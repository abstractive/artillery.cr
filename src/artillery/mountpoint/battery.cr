require "../mountpoint"
require "../protocols/cannonry"

#de Based on the example implementation of MDP:7 from ZMQ, by Tom van Leeuwen
#de https://github.com/booksbyus/zguide/blob/master/examples/Ruby/mdbroker.rb

module Artillery
  class Battery < Mountpoint

    include Protocol

    @poller : ZMQ::Poller

    @presences = uninitialized Hash
    @workers = uninitialized Hash
    @waiting = uninitialized Array

    def initialize
      @context = ZMQ::Context.new(MOUNTPOINT_THREADS)
      @poller = ZMQ::Poller.new
      @poller.register_readable(@socket)
      @workers = {}
      @presences = {}
      @waiting = []
      debug "Initialized"
    end

    def connect
      debug "Connecting"
      @server = @context.socket(ZMQ::ROUTER)
      @server.set_socket_option(ZMQ::LINGER, 0)
      @server.bind(MOUNTPOINT_LOCATION)
    end

    def engage
      embattled do |env|
        debug "Request..."
        presence = env.request.headers['Presence']
        #de Pull presence from headers.
        #de Grab Cannon for presence.
        #de Send out request to Cannon.
        #de Return response from Cannon.
        #de @socket.send_string(prepared(env))
        #de JSON.parse(@socket.receive_string) #de Directly output to socket.
        JSON.parse("")
      end
    end

    def shutdown

    end

    def close

    end

    def worker_register()

    end

    def worker_unregister()

    end

    def on_ready()

    end

    def on_reply()

    end

    def on_heartbeat()
      #de Implement
    end

    def on_disconnect()

    end

    def worker_waiting()

    end

    def worker_disconnect_received()

    end

    def worker_disconnect_send()

    end

  end
end
