require "../launcher"
require "../protocols/cannonry"

#de Based on the example implementation of MDP:7 from ZMQ, by Tom van Leeuwen
#de https://github.com/booksbyus/zguide/blob/master/examples/Ruby/mdwrkapi.rb

module Artillery
  class Cannon < Launcher

    include Protocol

    @poller : ZMQ::Poller

    @messages = uninitialized Array(String)

    @handling : String?

    def initialize
      unless PRESENCE_CODE
        raise Error::PresenceUndefined.new
      end
      @context = ZMQ::Context.new(LAUNCHER_THREADS)
      @poller = ZMQ::Poller.new
      @poller.register_readable(@socket)
      debug "Initialized"
    end

    def connect
      debug "Connecting"
      @socket = @context.socket(ZMQ::DEALER)
      @socket.set_socket_option(ZMQ::LINGER, 0)
      @socket.connect(MOUNTPOINT_LOCATION)
      send_ready
      reset_retries
      reset_heartbeat
    end

    def engage
      embattled do
        debug "About to poll Battery for #{Cannonry::Timing::WAIT_LISTEN} milliseconds:"
        if @poller.poll(Cannonry::Timing::WAIT_LISTEN) != 0
          command = parse_messages
          reset_retries
          case command
          when Cannonry::Worker::REQUEST
            #de TODO: Possibility of multiple messages per request.
            #de       Right now just pull one:
            responding!
            discard_frame
            handle(get_message)
            finished!
          when Cannonry::Worker::HEARTBEAT
            #de TODO: Have Cannons monitor Battery in future?
            debug "Received HEARTBEAT from Battery"
          when Cannonry::Worker::DISCONNECT
            debug "Received DISCONNECT from Battery"
            reset
          else
            raise Error::Invalid::CommandReceived.new
          end
        else
          if !retry?
            debug "Retrying in #{Cannonry::Timing::WAIT_RETRY}"
            sleep Cannonry::Timing::WAIT_RETRY
            reset
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
        debug "Shutting down sockets."
        send_disconnect
        @socket.close
        @poller.deregister_readable(@socket)
      end
    rescue ex
      exception(ex)
      #de raise(ex)
    end

    private

    def handle(message)
      debug "Received request."
      shell = chamber(@socket.receive_string)
      send_reply(armed(shell))
      debug "Responded to request."
    end

    def discard_frame
      get_message
      return nil
    end

    def get_message
      @messages.shift
    end

    def parse_messages
      debug("Parsing messages.")
      @messages = @socket.receive_strings
      discard_frame
      unless get_message == Cannonry::Worker::VERSION
        raise Error::Invalid::ProtocolVersion.new
      end
      return get_message
    end

    def send(command : String?, option : String? = nil, message : String? | Array? = nil)
      if message.nil?
        message = [] of String
      elsif message.is_a?(String)
        message = [message]
      elsif !message.is_a?(Array)
        raise Error::Invalid::MessageFormat.new
      end
      message = [option].concat(message) if option
      message = ["", Cannonry::Worker::VERSION, command].concat(message)
      @socket.send_strings(message)
    end

    def finished!
      @handling = nil
      @messages = uninitialized Array(String)
    end

    def responding!
      @handling = get_message
      discard_frame
    end

    def send_reply(message)
      send(Cannonry::Worker::REPLY, @handling, message)
    end

    def send_ready
      send(Cannonry::Worker::READY, PRESENCE_CODE)
      debug "Sent READY to Battery"
    end

    def send_heartbeat
      send(Cannonry::Worker::HEARTBEAT)
      debug "Sent HEARTBEAT to Battery"
    end

    def send_disconnect
      send(Cannonry::Worker::DISCONNECT)
      debug "Sent DISCONNECT to Battery"
    end

    def reset_retries
      @retries = Cannonry::RETRIES
    end

  end
end
