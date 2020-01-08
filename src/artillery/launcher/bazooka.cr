require "../launcher"

module Artillery
  class Bazooka < Launcher

    def log(message)
      super(message, "Artillery::Bazooka")
    end

    def self.run
      new.start
    end

    @context = uninitialized ZMQ::Context
    @worker = uninitialized ZMQ::Socket

    def initialize
      @context = ZMQ::Context.new
    end

    def connect
      shutdown if @worker
      @worker = @context.socket(ZMQ::REP)
      @worker.set_socket_option(ZMQ::LINGER, 0)
      @worker.connect(MOUNTPOINT_LOCATION)
    end

    def engage
      embattled do
        shell = chamber(@worker.receive_string)
        send(armed(shell))
      end
    end

    def send(message)
      @worker.send_string(message)
    end

    def shutdown
      @worker.close
    rescue
    end

  end
end
