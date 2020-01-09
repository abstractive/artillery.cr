require "../launcher"

module Artillery
  class Bazooka < Launcher

    def initialize
      @context = ZMQ::Context.new
      debug "Initialized"
    end

    def connect
      debug "Connecting"
      @socket = @context.socket(ZMQ::REP)
      @socket.set_socket_option(ZMQ::LINGER, 0)
      @socket.connect(MOUNTPOINT_LOCATION)
    end

    def engage
      embattled do
        shell = chamber(@socket.receive_string)
        debug "Request..."
        send(armed(shell))
      end
    end

    def send(message)
      debug "Responding..."
      @socket.send_string(message)
    end

    def shutdown
      @socket.close
    rescue
    end

  end
end
