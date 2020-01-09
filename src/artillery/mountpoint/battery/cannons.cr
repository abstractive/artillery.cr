module Artillery  
  class Battery < Mountpoint
    class Cannon
      include Logger
      property presence : Presence
      property expiry : Time::Span
      getter address

      def initialize(@address : String, @presence : Presence)
        @expiry = reset_expiration
      end

      def expired?
        @expiry <= Time.monotonic
      end

      def pretty
        "[#{@presence.name.colorize(:green)}:#{@address.inspect}]"
      end

      def reset_expiration
        #de debug("Resetting expiration: #{pretty}")
        @expiry = Time.monotonic + Cannonry::Timing::EXPIRES
      end

      module Methods

        private def cannon_fetch(address : String)
          @cannons[address]
        end

        private def cannon_attach(address : String, presence : Presence | String)
          presence = presence_require(presence)
          @cannons[address] ||= Cannon.new(address, presence)
          cannon_idle(address)
        end

        private def cannon_delete(cannon : Cannon | String)
          cannon = @cannons[cannon] if cannon.is_a?(String)
          cannon_disconnect(cannon)
          cannon.presence.idle.delete(cannon) if cannon.presence
          @waiting.delete(cannon)
          @cannons.delete(cannon.address)
        end

        def cannon_idle(cannon : Cannon | String)
          cannon = @cannons[cannon] if cannon.is_a?(String)
          @waiting << cannon
          cannon.presence.idle.push cannon
          cannon.reset_expiration
          dispatch(cannon.presence)
        end

        def cannon_disconnect(cannon : Cannon | String)
          send(cannon, Cannonry::Command::DISCONNECT)
        end

      end
    end
  end
end
