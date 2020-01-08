require "../artillery"

module Artillery
  abstract class Shot

    property request : Artillery::Shell::Request
    property response : Artillery::Shell::Response
    property redirect : String?

    @@attached = [] of String

    macro inherited
      #de puts "INHERETED: #{self}"
      #de Must have vectors
      #de Armory.attach "#{self}"
    end

    def self.attached
      @@attached
    end

    include Logger

    def initialize(request : Shell::Request)
      #de log "REQUEST: #{request.path}"
      @request = request
      @response = Shell::Response.new
      @redirect = nil
    end

    def redirect?
      !@redirect.nil?
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

    alias ResponseHash = Hash(String, Char |
                                      String |
                                      Bool |
                                      Float64 |
                                      Int64 |
                                      Int32 |
                                      Int16 |
                                      Array(ResponseHash) |
                                      Hash(String, ResponseHash))

    def success(body : ResponseHash)
      @response.status = 200
      @response.body = body.to_json
    end

    def success(body : String?)
      @response.status = 200
      @response.body = body unless body.nil?
    end

    def redirect(@redirect)
    end
  
    def error(
        code : Int16,
        body : String?
      )
      @response.status = code
      @response.body = body unless body.nil?
    end

    def self.vector(path : String)
      Armory.load({
        redirect: nil,
        method: :get,
        path: path,
        object: "#{self}"
      })
    end

    def self.vector(method : Symbol, path : String)
      Armory.load({
        redirect: nil,
        method: method,
        path: path,
        object: "#{self}"
      })
    end

    def self.vector(method : Symbol, path : String, execute : Symbol)
      Armory.load({
        redirect: nil,
        method: method,
        path: path,
        object: "#{self}"
      })
    end

  end
end
