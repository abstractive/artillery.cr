module Artillery
  abstract class Armament
    
    include Logger
    include Protocol

    @context = uninitialized ZMQ::Context
    @socket = uninitialized ZMQ::Socket

    @heartbeat = uninitialized Time::Span
    @running = uninitialized Bool
    @retries = uninitialized Int32

    def self.run
      new.start
    end

    def start
      connect
      @running = true
      word = "Starting".colorize(:green).mode(:bold).to_s
      log "#{word} // 0MQ: #{MOUNTPOINT_LOCATION}"
      engage
      word = "Stopping".colorize(:red).mode(:bold).to_s
      log "#{word} // 0MQ: #{MOUNTPOINT_LOCATION}"
    end

    def embattled
      while(@running)
        begin
          yield
        rescue ex
          exception(ex)
          reset
        end
      end
      shutdown
    end
    
    def reset
      shutdown
      log "Reset connection.", "OMQ"
      connect
    end

    def next_heartbeat?
      ( Time.monotonic - @heartbeat ) > Cannonry::Timing::HEARTBEAT_IN
    end

    def reset_heartbeat
      @heartbeat = Time.monotonic
    end

  end
end
