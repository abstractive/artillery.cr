require "../launcher"

module Artillery
  class Cannon < Launcher

    @poller : ZMQ::Poller

    def initialize
      unless PRESENCE_CODE
        raise Error::Presence::Undefined.new
      end
      @context = ZMQ::Context.new(LAUNCHER_THREADS)
      @poller = ZMQ::Poller.new
    end

    def connect
      @socket = @context.socket(ZMQ::DEALER)
      @socket.set_socket_option(ZMQ::LINGER, 0)
      @socket.connect(MOUNTPOINT_LOCATION)
      @poller.register_readable(@socket)
      send_ready
      #de reset_retries
      reset_heartbeat
    end

    def inbound
      "==>".colorize(:light_gray)
    end

    def engage
      embattled do
        if @poller.poll(Cannonry::Timing::POLL) != 0
          data = parse_messages!
          command = data.shift
          #de reset_retries
          case command
          when Cannonry::Command::REQUEST
            mark(" >", "R".colorize(:light_cyan))
            handle(data)
          when Cannonry::Command::HEARTBEAT
            #de TODO: Have Cannons monitor Battery in future?
            mark(" >", "H".colorize(:light_magenta))
          when Cannonry::Command::DISCONNECT
            mark(" >", "D".colorize(:light_red))
            reset
          else
            raise Error::Invalid::CommandReceived.new
          end
        end
        if next_heartbeat?
          send_heartbeat
          reset_heartbeat
        end
      end
    end

    def shutdown
      if @socket && !@socket.closed?
        send_disconnect
        @socket.close
        @poller.deregister_readable(@socket)
      end
    rescue
    end

    private def handle(data)
      mark(" >", "H".colorize(:blue))
      handling = data.shift
      shell = chamber(data.shift)
      send_reply(armed(shell), handling)
    end

    private def parse_messages!
      data = @socket.receive_strings
      data.shift
      unless data.shift == Cannonry::HEADER
        raise Error::Invalid::ProtocolVersion.new
      end
      return data
    end

    private def send(command : String?, option : String? = nil, message : String? | Array? = nil)
      if message.nil?
        message = [] of String
      elsif message.is_a?(String)
        message = [message]
      elsif !message.is_a?(Array)
        raise Error::Invalid::MessageFormat.new
      end
      message = [option].concat(message) if option
      message = ["", Cannonry::HEADER, command].concat(message)
      @socket.send_strings(message)
      return message
    end

    private def send_reply(message : String, handling : String)
      sent = send(Cannonry::Command::REPLY, PRESENCE_CODE, [handling, message])
      mark(" <", "R".colorize(:cyan))
    end

    private def send_ready
      sent = send(Cannonry::Command::READY, PRESENCE_CODE)
      mark(" <", "R".colorize(:green))
    end

    private def send_heartbeat
      sent = send(Cannonry::Command::HEARTBEAT)
      mark(" <", "H".colorize(:magenta))
    end

    private def send_disconnect
      sent = send(Cannonry::Command::DISCONNECT)
      mark(" <", "D".colorize(:red))
    rescue
    end

  end
end
