module Artillery

  alias PayloadType = JSON::Any |
                      Hash(String, String |
                                   JSON::Any |
                                   Hash(String, Hash) |
                                   Hash(String, String))

  module Shell
    class Request

      #de property headers : JSON::Any?
      property method : String
      property path : String
      property index : String
      property query : String
      property body : String
      property format : String

      def initialize(env)
        @method = (env["method"] || "").to_s
        @path = (env["path"] || "").to_s
        @index = "#{@method}#{@path}"
        @query = (env["query"] || "").to_s
        @body = (env["body"] || IO::Memory.new).to_s
        @format = (env["format"] || "").to_s
      end

      def json?
        @format.starts_with?("application/json")
      end

      def data
        JSON.parse(@body).as_h
      rescue
        JSON.parse("").as_h
      end

      def self.from_json(payload)
        new JSON.parse(payload)
      end

      def self.as_json_from_context(env)
        {
          method: (env.request.method || "").to_s,
          path: (env.request.path || "").to_s,
          query: (env.request.query || "").to_s,
          body: (( (b = env.request.body) && b.gets_to_end ) || IO::Memory.new).to_s,
          format: (env.request.headers["Content-Type"] || "").to_s
        }.to_json
      end

    end
  end
end