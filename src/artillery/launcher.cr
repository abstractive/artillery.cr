require "../artillery"
require "../artillery/shot"
require "../artillery/shot/error_404"
require "radix"

module Artillery
  class Launcher

    extend Logger

    @@context = uninitialized ZMQ::Context
    @@client = uninitialized ZMQ::Socket

    @@index = uninitialized Radix::Tree(String)
    @@attached = [] of String

    #de TODO: Infer uri by file-location unless specified
    @@vectors = Array(
      NamedTuple(
        path: String,
        method: Symbol,
        object: String
      )
    ).new

    def self.vectors
      @@vectors
    end

    def self.start
      @@context = ZMQ::Context.new
      @@client = @@context.socket(ZMQ::REP)
      @@client.connect("tcp://127.0.0.1:5555")
      @@client.set_socket_option(ZMQ::LINGER, 0)
      log "Starting Launcher", "Artillery"
    end

    def self.reset
      @@client.close
      log "Reset"
      start
    rescue
    end

    def self.attach(object)
      @@attached << object
    end

    def self.load(vector)
      @@vectors.push(vector)
    end

    def self.not_found
      {
        path: "/not-found",
        method: :get,
        object: "Error404"
      }
    end

    def self.get_vector(shell : Artillery::Shell::Request)
      vector = @@index.find("#{shell.index}")
      return not_found unless vector.found?
      {
        path: shell.path,
        method: shell.method,
        object: vector.payload
      }
    end

    def self.organize_vectors
      @@index = Radix::Tree(String).new
      @@vectors.each { |v|
        @@index.add "#{v[:method].to_s.upcase}#{v[:path]}", v[:object]
        #de log "Added #{v[:method].to_s.upcase}#{v[:path]} on #{v[:object]}"
      }
    end

    def self.run
      organize_vectors
      start
      loop do
        begin
          #de Get a request as JSON via ZeroMQ and make Artillery::Shell::Request from it.
          shell = Artillery::Shell::Request.from_json(@@client.receive_string)
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
          @@client.send_string({
            body: (shot.response.body || "").to_s,
            status: (shot.response.status || "").to_s,
            headers: (shot.response.headers || Hash).to_s,
          }.to_json)      
        rescue ex
          log "#{ex.class.name}: #{ex.message}\n#{ex.backtrace.join('\n')}"
          reset
        end
      end

    end
  end
end
