module Artillery
  module Shell
    class Response

      property status : Int16
      property body : String

      def initialize(
          status : Int16 = 500,
          body : String = ""
        )
        @status = status
        @body = body
      end

      def add(
          key : String,
          value : String
        )
        headers[key] = value
      end

      def headers
        @headers ||= {} of String => String
      end

    end
  end
end