require "../artillery"

module Artillery
  abstract class Shot

    property request : Artillery::Shell::Request
    property response : Artillery::Shell::Response

    @@attached = [] of String

    macro inherited
      #de puts "INHERETED: #{self}"
      #de Must have vectors
      Artillery::Launcher.attach "#{self}"
    end

    def self.attached
      @@attached
    end

    include Logger

    def initialize(request : Shell::Request)
      log "REQUEST: #{request.path}"
      @request = request
      @response = Shell::Response.new
    end

    {% for method in Artillery::HTTP_METHODS %}
      def {{method.downcase.id}}
        error 404, "Not Found"
      end
    {% end %}


    def header(
        key : String,
        value : String
      )
      @response.add(key, value)
    end

    def success(body : String?)
      @response.status = 200
      @response.body = body unless body.nil?
    end
  
    def error(
        code : Int16,
        body : String?
      )
      @response.status = code
      @response.body = body unless body.nil?
    end

    def self.vector(path : String)
      Artillery::Launcher.load({
        method: :get,
        path: path,
        object: "#{self}"
      })
    end

    def self.vector(method : Symbol, path : String)
      Artillery::Launcher.load({
        method: method,
        path: path,
        object: "#{self}"
      })
    end

    def self.vector(method : Symbol, path : String, execute : Symbol)
      Artillery::Launcher.load({
        method: method,
        path: path,
        object: "#{self}"
      })
    end

  end
end
