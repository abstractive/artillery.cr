module Artillery
  class Battery
    class Worker
      #attr_reader :service
      #attr_reader :identity
      attr_accessor :service
      attr_accessor :expiry
      attr_accessor :address

      #def initialize identity, address, lifetime
      def initialize address, lifetime
        #@identity = identity
        @address = address
        #@service = nil
        @expiry = Time.now + 0.001 * lifetime
      end

    end
  end
end
