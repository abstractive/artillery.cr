require "kemal"
require "../artillery"

module Artillery
  class Mount

    extend Logger

    @@context = uninitialized ZMQ::Context
    @@server = uninitialized ZMQ::Socket

    HTTP_METHODS   = %w(get post put patch delete options)

    def self.start
      @@context = ZMQ::Context.new
      @@server = @@context.socket(ZMQ::REQ)
      @@server.set_socket_option(ZMQ::LINGER, 0)
      @@server.bind("tcp://127.0.0.1:5555")
      log "Starting Mount Point", "Artillery"
    end

    def self.reset
      @@server.close
      log "Reset"
      start
    rescue
    end

    def self.run
      start
      {% for method in HTTP_METHODS %}
        Kemal::RouteHandler::INSTANCE.add_route({{method.upcase}}, "/*") do |env|
          begin
            log env.inspect
            log "#{timestamp}/m1: #{env.request.path} "
            @@server.send_string(Artillery::Shell::Request.as_json_from_context(env))
            @@server.receive_string
          rescue ex
            log "#{ex.class.name}: #{ex.message}\n#{ex.backtrace.join('\n')}"
            reset
          end
        end
      {% end %}

      Kemal.run

    end
  end
end