require "../artillery"
require "../artillery/shot"
require "../artillery/shot/error_404"
require "radix"

module Artillery
  class Launcher

    extend self
    extend Logger

    @@context = uninitialized ZMQ::Context
    @@worker = uninitialized ZMQ::Socket

    @@index = uninitialized Radix::Tree(String)
    #de @@attached = [] of String

    #de TODO: Infer uri by file-location unless specified
    @@vectors = Array(
      NamedTuple(
        redirect: String?,
        path: String,
        method: Symbol,
        object: String
      )
    ).new

    def vectors
      @@vectors
    end

    def start
      @@context = ZMQ::Context.new
      @@worker = @@context.socket(ZMQ::REP)
      @@worker.connect(MOUNTPOINT_LOCATION)
      @@worker.set_socket_option(ZMQ::LINGER, 0)
      log "Started // 0MQ: #{MOUNTPOINT_LOCATION}", "Artillery::Launcher"
    end

    def reset
      @@worker.close
      log "Reset"
      start
    rescue
    end

    #de def attach(object)
    #de   @@attached << object
    #de end

    def load(vector)
      @@vectors.push(vector)
    end

    def not_found
      {
        path: "/not-found",
        method: :get,
        object: "Error404"
      }
    end

    def get_vector(shell : Artillery::Shell::Request)
      vector = @@index.find("#{shell.index}")
      return not_found unless vector.found?
      {
        path: shell.path,
        method: shell.method,
        object: vector.payload
      }
    end

    def organize_vectors
      @@index = Radix::Tree(String).new
      @@vectors.each { |v|
        @@index.add "#{v[:method].to_s.upcase}#{v[:path]}", v[:object]
        #de log "Added #{v[:method].to_s.upcase}#{v[:path]} on #{v[:object]}"
      }
    end

    def prepare_launcher
      organize_vectors
      start
    end

    def run
      loop do
        begin
          #de Get a request as JSON via ZeroMQ and make Artillery::Shell::Request from it.
          shell = Artillery::Shell::Request.from_json(@@worker.receive_string)
          respond = prepare_payload(shell)
          @@worker.send_string(respond.to_json)
        rescue ex
          log "#{ex.class.name}: #{ex.message}\n#{ex.backtrace.join('\n')}"
          reset
        end
      end

      def prepare_payload(shell)
        vector = get_vector(shell)
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
        return respond
      end

    end
  end
end
