module Artillery
  module Shell
    class Request

      property path : JSON::Any
      property body : String
      property query : String
      #de property headers : JSON::Any?
      #de property params

      def initialize(env)
        @path = env["path"]
        @body = (env["body"] || IO::Memory.new).to_s
        @query = (env["query"] || "").to_s
        #de {% if Artillery::ARTILLERY_SHELL_HEADERS %}
        #de   @headers = env["headers"]
        #de {% end %}
        #de @params = env.request.params
      end

      def self.from_json(payload)
        new JSON.parse(payload)
      end

      def self.as_json_from_context(env)
        payload = {
          path: env.request.path,
          body: (env.request.body || IO::Memory.new).to_s,
          query: env.request.query || ""
        }        
        #de {% if Artillery::ARTILLERY_SHELL_HEADERS %}
        #de   payload[:headers] = env.request.headers
        #de {% end %}
        payload.to_json
      end

    end
  end
end