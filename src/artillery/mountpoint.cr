require "../artillery"
require "../artillery/overrides/kemal"

module Artillery
  abstract class Mountpoint < Armament

    def prepared(env)
      Artillery::Shell::Request.as_json_from_context(env)
    end

    def embattled(&block : HTTP::Server::Context -> JSON::Any)
      handler = block
      {% for method in HTTP_METHODS %}
        ::Kemal::RouteHandler::INSTANCE.add_route({{method.upcase}}, "/*") do |env|
          begin
            response = handler.call(env)
            if response["redirect"]?
              env.redirect "#{response["redirect"]}"
            else
              env.response.status_code = Int32.new("#{response["status"]}")
              "#{response["body"]}"
            end
          rescue ex
            exception(ex)
            reset
          end
        end
      {% end %}
      word = "Engaging".colorize(:green).mode(:bold).to_s
      log "#{word} // 0MQ: #{MOUNTPOINT_LOCATION} HTTP@#{MOUNTPOINT_PORT_HTTP}"
      ::Kemal.run
    end

  end
end