require "../mountpoint"

module Artillery
  class Battery < Mountpoint

    VERSION = 'BTRY01'

    @@presences = uninitialized Hash
    @@workers = uninitialized Hash
    @@waiting = uninitialized Hash

    def self.start
      @@context = ZMQ::Context.new
      @@server = @@context.socket(ZMQ::ROUTER)
      @@server.set_socket_option(ZMQ::LINGER, 0)
      @@server.set_socket_option(ZMQ::RCVTIMEO, SOCKET_TIMEOUT)
      @@server.bind(MOUNTPOINT_LOCATION)
    end

    #de TODO: Convert to block form, and absorb into Mountpoint, then customize here.
    def self.run
      start
      {% for method in HTTP_METHODS %}
        Kemal::RouteHandler::INSTANCE.add_route({{method.upcase}}, "/*") do |env|
          begin
            #de @@server.send_string(Artillery::Shell::Request.as_json_from_context(env))
            #de response = JSON.parse(@@server.receive_string) #de Directly output to socket.
            if response["redirect"]?
              env.redirect "#{response["redirect"]}"
            else
              env.response.status_code = Int32.new("#{response["status"]}")
              "#{response["body"]}"
            end
          rescue ex
            log "#{ex.class.name}: #{ex.message}\n#{ex.backtrace.join('\n')}"
            reset
          end
        end
      {% end %}
      log "Started // 0MQ: #{MOUNTPOINT_LOCATION} HTTP@#{MOUNTPOINT_PORT_HTTP}", "Artillery::Battery"
      Kemal.run
    end

    def self.shutdown

    end

    def self.reset

    end

    def self.close

    end

    def self.worker_register()

    end

    def self.worker_unregister()

    end

    def self.on_ready()

    end

    def self.on_reply()

    end

    def self.on_heartbeat()
      #de Implement
    end

    def self.on_disconnect()

    end

    def self.worker_waiting()

    end

    def self.worker_disconnect_received()

    end

    def self.worker_disconnect_send()

    end

  end
end
