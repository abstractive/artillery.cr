require "kemal"
require "../artillery"
require "../artillery/overrides/kemal"

Kemal.config.host_binding = Artillery::MOUNTPOINT_INTERFACE
Kemal.config.port = Int32.new(Artillery::MOUNTPOINT_PORT_HTTP)
Kemal.config.shutdown_message = false

#de Can likely remove; provided by nginx
Kemal.config.public_folder = Artillery::PUBLIC_DIRECTORY

module Artillery
  abstract class Mountpoint

    extend Logger

    def self.run
      new.engage
    end

    @context = uninitialized ZMQ::Context
    @server = uninitialized ZMQ::Socket

    def start
      @context = ZMQ::Context.new
      @server = @context.socket(ZMQ::REQ)
      @server.set_socket_option(ZMQ::LINGER, 0)
      @server.set_socket_option(ZMQ::RCVTIMEO, SOCKET_TIMEOUT)
      @server.bind(MOUNTPOINT_LOCATION)
    end

    def reset
      @server.close
      log "Reset"
      start
    rescue
    end

    def engage
      start
      {% for method in HTTP_METHODS %}
        Kemal::RouteHandler::INSTANCE.add_route({{method.upcase}}, "/*") do |env|
          begin
            @server.send_string(Artillery::Shell::Request.as_json_from_context(env))
            response = JSON.parse(@server.receive_string) #de Directly output to socket.
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
      log "Started // 0MQ: #{MOUNTPOINT_LOCATION} HTTP@#{MOUNTPOINT_PORT_HTTP}", "Artillery::Mountpoint"
      Kemal.run
    end

  end
end