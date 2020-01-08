module Artillery
  class Battery
    class Presence
      attr_accessor :requests
      attr_accessor :waiting
      attr_reader :name

      def initialize name
        @name = name
        @requests = []
        @waiting = []
      end
    end
  end
end
