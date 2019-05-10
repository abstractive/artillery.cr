require "kemal"
require "../artillery"

if ENV["ARTILLERY_PUBLIC"]
  Kemal.config.public_folder = ENV["ARTILLERY_PUBLIC"]
end

module Artillery
  class Mountpoint

    extend Logger

    @@context = uninitialized ZMQ::Context
    @@server = uninitialized ZMQ::Socket

    def self.start
      @@context = ZMQ::Context.new
      @@server = @@context.socket(ZMQ::REQ)
      @@server.set_socket_option(ZMQ::LINGER, 0)
      @@server.bind(MOUNTPOINT_LOCATION)
      log "Starting Mountpoint", "Artillery"
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
            @@server.send_string(Artillery::Shell::Request.as_json_from_context(env))
            response = JSON.parse(@@server.receive_string) #de Directly output to socket.
            env.response.status_code = Int32.new("#{response["status"]}")
            "#{response["body"]}"
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