require "../mountpoint"
require "./battery/cannons"
require "./battery/presences"
require "uuid"

module Artillery
  class Battery < Mountpoint

    CHANNEL = Channel(Nil).new

    include Cannon::Methods
    include Presence::Methods

    @poller : ZMQ::Poller
    @presences : Hash(String, Presence)
    @cannons : Hash(String, Cannon)
    @waiting : Array(Cannon)

    def initialize
      @context = ZMQ::Context.new(MOUNTPOINT_THREADS)
      @poller = ZMQ::Poller.new
      @cannons = Hash(String, Cannon).new
      @presences = Hash(String, Presence).new
      @waiting = Array(Cannon).new
      debug "Initialized"
    end

    def connect
      debug "Connecting"
      @socket = @context.socket(ZMQ::ROUTER)
      @socket.set_socket_option(ZMQ::LINGER, 0)
      @socket.bind(MOUNTPOINT_LOCATION)
      @poller.register_readable(@socket)
    end

    def online?(name : String)
      return unless @presences.has_key?(name)
      presence = @presences[name]
      return unless @cannons.find { |address,cannon|
        cannon.presence.name == name && !cannon.expired?
      }
      return presence
    end

    def start
      connect
      @running = true
      spawn do
        engage
      end
      spawn do
        word = "Starting".colorize(:green).mode(:bold).to_s
        log "#{word} // #{MOUNTPOINT_LOCATION}", "0MQ"
        marshal
      end
      while @running
        sleep Cannonry::Timing::WAIT
        CHANNEL.receive
      end
      word = "Stopping".colorize(:red).mode(:bold).to_s
      log "#{word} // #{MOUNTPOINT_LOCATION}", "0MQ"
    end

    def engage
      embattled do |env|
        unless code = env.request.headers["Presence"]?
          next ({
            "body" => "Presence Not Yet Defined",
            "status" => 501
          })
        end
        unless presence = online?(code)
          next ({
            "body" => "Service Unavailable",
            "status" => 503
          })
        end
        uuid = target(presence, prepared(env))
        unless response = presence.await?(uuid)
          next ({
            "body" => "Request Timeout",
            "status" => 408
          })
        end
        JSON.parse(response)
      end
    end

    def marshal
      crenulated do
        if @poller.poll(Cannonry::Timing::POLL) != 0
          data = parse_messages!
          address = data.shift
          exists = @cannons.has_key?(address)
          case command = data.shift
          when Cannonry::Command::READY
            code = data.shift
            mark(" >", "R".colorize(:light_green))
            if exists
              cannon_delete(address)
            else
              cannon_attach(address, code)
            end
          when Cannonry::Command::REPLY
            mark(" >", "R".colorize(:light_cyan))
            code = data.shift
            uuid = data.shift
            unless presence = @presences[code]?
              raise Error::Presence::Unavailable.new(code)
            end
            cannon_idle(address)
            presence.response!(uuid, data.shift)
            mark(" >", "R".colorize(:light_cyan))
          when Cannonry::Command::HEARTBEAT
            mark(" >", "H".colorize(:light_magenta))
            if exists
              cannon_fetch(address).reset_expiration
            else
              cannon_disconnect(address)
            end
          when Cannonry::Command::DISCONNECT
            mark(" >", "D".colorize(:light_red))
            cannon_delete(address) if exists
          else
            raise Error::Invalid::CommandReceived.new(command)
          end
        else
          CHANNEL.send(nil)
        end
        if next_heartbeat?
          @waiting.each do |cannon|
            if cannon.expired?
              debug("Cannon expired: #{cannon.pretty}")
              mark(" x", "C".colorize(:red))
              cannon_delete(cannon)
            else
              send(cannon, Cannonry::Command::HEARTBEAT)
              mark(" <", "H".colorize(:magenta))
            end
          end
          reset_heartbeat
        end
        if @presences.any?
          @presences.each { |code, presence|
            dispatch(presence)
          }
        end
        CHANNEL.send(nil)
      end
    end

    def crenulated
      while(@running)
        begin
          yield
        rescue ex
          exception(ex)
          reset
        end
      end
      shutdown
    end
    
    def target(presence : Presence, json : String)
      uuid = UUID.random.to_s
      presence.requests.push({uuid: uuid, json: json})
        mark(" *", "T".colorize(:light_yellow))
      return uuid
    end

    private def dispatch(presence : Presence)
      while presence.idle.any? && presence.requests.any?
        message = presence.requests.shift
        cannon = presence.idle.shift
        @waiting.delete(cannon)
        mark(" *", "D".colorize(:yellow))
        send(cannon, Cannonry::Command::REQUEST, message[:uuid], message[:json])
      end
    end

    private def send(
                      cannon : Cannon | String,
                      command : String,
                      option : String? = nil,
                      message : String | Array(String) | Nil = Array(String).new
                    )
      cannon = cannon.address if cannon.is_a?(Cannon)
      message = [message] if message.is_a?(String)
      message.unshift(option) if option
      message.unshift(command)
      message.unshift(Cannonry::HEADER)
      message.unshift("")
      message.unshift(cannon)
      @socket.send_strings(message)
    end

    private def parse_messages!
      data = @socket.receive_strings
      #de Leave the address in index 0.
      data.delete_at(1)
      header = data.delete_at(1)
      unless header == Cannonry::HEADER
        raise Error::Invalid::ProtocolVersion.new(header)
      end
      #de debug("Remaining message: #{data.inspect.colorize(:yellow)}")
      return data
    end

    def shutdown
      if @socket && !@socket.closed?
        @socket.close
        @poller.deregister_readable(@socket)
      end
    rescue
    end

  end
end
