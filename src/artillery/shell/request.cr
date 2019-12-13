module Artillery
  module Shell
    class Request

      #de property headers : JSON::Any?
      property method : String
      property path : String
      property index : String
      #de property query : String
      property body : String
      property format : String
      property json : Bool?
      property data : Hash(String, JSON::Any)?

      def initialize(env)
        @method = (env["method"] || "").to_s
        @path = (env["path"] || "").to_s
        @body = (env["body"] || IO::Memory.new).to_s
        @format = (env["format"] || "").to_s
        #de @query = (env["query"] || "").to_s
        @index = "#{@method}#{@path}"
        #de {% if Artillery::ARTILLERY_SHELL_HEADERS %}
        #de   @headers = env["headers"]
        #de {% end %}
      end

      def json?
        return @json if @json
        @json = @format.starts_with?("application/json")
      end

      def data
        return nil unless json?
        return @data if @data
        @data = JSON.parse(@body).as_h
      rescue
        nil
      end

      def self.from_json(payload)
        new JSON.parse(payload)
      end

      def self.as_json_from_context(env)
        {
          method: (env.request.method || "").to_s,
          path: (env.request.path || "").to_s,
          body: (( (b = env.request.body) && b.gets_to_end ) || IO::Memory.new).to_s,
          format: (env.request.headers["Content-Type"] || "").to_s,
          #de query: (env.request.query || "").to_s
        }.to_json
        #de {% if Artillery::ARTILLERY_SHELL_HEADERS %}
        #de   payload[:headers] = env.request.headers
        #de {% end %}
      end

    end
  end
end