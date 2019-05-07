require "kemal"
require "../artillery"

module Artillery
  class Mount

    extend Logger

    HTTP_METHODS   = %w(get post put patch delete options)

    def self.run

      log "Starting Mount Point", "Artillery"

      context = ZMQ::Context.new
      server = context.socket(ZMQ::REQ)
      server.set_socket_option(ZMQ::LINGER, 0)
      server.bind("tcp://127.0.0.1:5555")

      {% for method in HTTP_METHODS %}
        Kemal::RouteHandler::INSTANCE.add_route({{method.upcase}}, "/*") do |env|
          log env.inspect
          log "#{timestamp}/m1: #{env.request.path} "
          server.send_string(Artillery::Shell::Request.as_json_from_context(env))
          server.receive_string
        end
      {% end %}

      Kemal.run

    end
  end
end