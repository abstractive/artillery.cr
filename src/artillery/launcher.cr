require "../artillery"
require "../artillery/shot"
require "../artillery/shot/error_404"
require "radix"

module Artillery
  abstract class Launcher

    include Logger
    @context = uninitialized ZMQ::Context
    @socket = uninitialized ZMQ::Socket

    @retries = uninitialized Int32
    @running = uninitialized Bool

    def start
      Armory.organize
      connect
      engage
    end

    def reset
      shutdown
      log "Reset 0MQ connection."
      connect
    end

    def embattled
      @running = true
      word = "Engaging".colorize(:green).mode(:bold).to_s
      log "#{word} // 0MQ: #{MOUNTPOINT_LOCATION}"
      while(@running)
        begin
          debug "Going into embattled yield:"
          yield
          debug "Out of embattled yield."
        rescue ex
          exception(ex)
          reset
        end
      end
      log "Disengaging // 0MQ: #{MOUNTPOINT_LOCATION}"
      shutdown
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
