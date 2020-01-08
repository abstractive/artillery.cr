require "../artillery"
require "../artillery/shot"
require "../artillery/shot/error_404"
require "radix"

module Artillery
  abstract class Launcher < Armament

    @context = uninitialized ZMQ::Context
    @socket = uninitialized ZMQ::Socket
    @retries = uninitialized Int32

    def start
      Armory.organize
      super
    end

    def chamber(message)
      #de Take a request as JSON and make a Artillery::Shell::Request from it.
      Artillery::Shell::Request.from_json(message)
    end

    def armed(shell)
      vector = Armory.equip(shell)
      shot = get_class(vector[:object]).new(shell)
      case shell.method
      when "GET"
        shot.get
      when "PUT"
        shot.put
      when "POST"
        shot.post
      when "DELETE"
        shot.delete
      else
        log "Method not found: #{shell.method}"
      end

      respond = if shot.redirect?
        {
          redirect: shot.redirect,
          body: "",
          status: 302
        }
      else
        {
          body: (shot.response.body || "").to_s,
          status: (shot.response.status || "").to_s,
          headers: (shot.response.headers || Hash).to_s,
        }
      end
      return respond.to_json
    end

    def retry?
      @retries -= 1
      return @retries != 0
    end

  end
end
