require "../mountpoint"

module Artillery
  class Shoulder < Mountpoint

    def initialize
      @context = ZMQ::Context.new(MOUNTPOINT_THREADS)
    end

    def connect
      @socket = @context.socket(ZMQ::REQ)
      @socket.set_socket_option(ZMQ::LINGER, 0)
      @socket.set_socket_option(ZMQ::RCVTIMEO, SOCKET_TIMEOUT)
      @socket.bind(MOUNTPOINT_LOCATION)
    end

    def shutdown
      if @socket && !@socket.closed?
        @socket.close
      end
    rescue
    end

    def engage
      embattled do |env|
        debug "Request on presence: #{env.request.headers.get?("Presence") || "UNKNOWN"}"
        @socket.send_string(prepared(env))
        JSON.parse(@socket.receive_string) #de Directly output to socket.
      end
    end

  end
end