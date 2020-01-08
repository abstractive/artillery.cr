require "../launcher"
require "../../protocols/cannonry"

#de Based on the example implementation of MDP:7 from ZMQ, by Tom van Leeuwen
#de https://github.com/booksbyus/zguide/blob/master/examples/Ruby/mdwrkapi.rb

module Artillery
  class Cannon

    extend self
    extend Launcher
    include Protocol

    @@poller = uninitialized ZMQ::Poller
    @@worker = uninitialized ZMQ::Socket
    @@retries = uninitialized Int32
    @@heartbeat = uninitialized Time::Span
    @@handling = uninitialized String?
    @@messages = uninitialized Array(String)
    @@responding = uninitialized String

    def log(message)
      super(message, "Artillery::Cannon")
    end

    def start
      unless PRESENCE
        raise Error::PresenceUndefined
      end
      @@context = ZMQ::Context.new(1)
      @@poller = ZMQ::Poller.new
      @@reply_to = nil
      reconnect
      log "Started // 0MQ: #{MOUNTPOINT_LOCATION} // Presence: #{PRESENCE}"
    end

    #de Connect to the Battery
    def reconnect
      shutdown if @@worker
      @@worker = @@context.socket(ZMQ::DEALER)
      @@worker.set_socket_option(ZMQ::LINGER, 0)
      @@worker.connect(MOUNTPOINT_LOCATION)
      @@poller.register(@@worker, ZMQ::POLLIN)
      send_ready
      reset_retries
      reset_heartbeat
    end

    def run
      prepare_launcher
      start && engage
    end

    def handle_request(message)

    end

    def engage
      log "Waiting for requests."
      loop do
        contact = @poller.poll(Cannonry::Timing::WAIT_LISTEN)
        if contact
          command = parse_messages
          reset_retries
          case command
          when Cannonry::Worker::REQUEST
            #de TODO: Possibility of multiple messages per request.
            #de       Right now just pull one:
            mark_responding
            discard_frame
            handle_request(get_message)
          when Cannonry::Worker::HEARTBEAT
            #de TODO: Have Cannons monitor Battery in future?
          when Cannonry::Worker::DISCONNECT
            reconnect
          else
            raise Error::Invalid::CommandReceived
          end
        else
          if !retry?
            sleep Cannonry::Timing::WAIT_RETRY
            reconnect
          end
        end
        if next_heartbeat?
          send_heartbeat
          reset_heartbeat
        end
      end
    end

    def discard_frame
      get_message
      return nil
    end

    def get_message
      @@messages.shift
    end

    def parse_messages
      @@messages = []
      @@worker.recv_strings @@messages
      discard_frame
      unless get_message == Cannonry::Worker::VERSION
        raise Error::Invalid::ProtocolVersion
      end
      return get_message
    end

    def mark_responding
      @@responding = get_message
      discard_frame
    end

    def send_reply(message)
      send(Worker::REPLY, [@@responding, '', message])
    end

    def send_ready
      send(Worker::READY)
    end

    def next_heartbeat?
      ( Time.monotonic - @@heartbeat ) > Cannonry::Timing::HEARTBEAT
    end

    def send_heartbeat
      send(Worker::HEARTBEAT)
    end

    def reset_heartbeat
      @@heartbeat = Time.monotonic
    end

    def retry?
      @@retries -= 1
      return @@retries !== 0
      else
        return true
      end
    end

    def reset_retries
      @@retries = Cannonry::RETRIES
    end

    def send(command : String?, option : String?, message : String? | Array?)
      if message.nil?
        message = []
      elsif message.is_a?(String)
        message = [message]
      elsif !message.is_a?(Array)
        raise Error::Invalid::MessageFormat
      end
      message = [option].concat(message) if option
      message = ['', Cannonry::Worker::VERSION, command].concat(message)
      @worker.send_strings(message)
    end

    def shutdown
      @@poller.deregister(@@worker, ZMQ::DEALER)
      @@worker.close
    end

  end
end
