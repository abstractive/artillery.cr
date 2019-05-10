module Artillery
  module Shell
    class Request

      property method : String
      property path : String
      property body : String
      property query : String
      property index : String
      #de property headers : JSON::Any?
      #de property params

      def initialize(env)
        @method = (env["method"] || "").to_s
        @path = (env["path"] || "").to_s
        @body = (env["body"] || IO::Memory.new).to_s
        @query = (env["query"] || "").to_s
        @index = "#{@method}#{@path}"
        #de {% if Artillery::ARTILLERY_SHELL_HEADERS %}
        #de   @headers = env["headers"]
        #de {% end %}
        #de @params = env.request.params
      end

      def self.from_json(payload)
        new JSON.parse(payload)
      end

      def self.as_json_from_context(env)
        {
          method: (env.request.method || "").to_s,
          path: (env.request.path || "").to_s,
          body: (env.request.body || IO::Memory.new).to_s,
          query: (env.request.query || "").to_s
        }.to_json
        #de {% if Artillery::ARTILLERY_SHELL_HEADERS %}
        #de   payload[:headers] = env.request.headers
        #de {% end %}
      end

    end
  end
end