module Artillery
  abstract class Armament
    
    include Logger

    @context = uninitialized ZMQ::Context
    @socket = uninitialized ZMQ::Socket

    @running = uninitialized Bool

    def self.run
      new.start
    end

    def start
      connect
      engage
    end

    def embattled
      @running = true
      word = "Engaging".colorize(:green).mode(:bold).to_s
      log "#{word} // 0MQ: #{MOUNTPOINT_LOCATION}"
      while(@running)
        begin
          debug "Going into embattled yield:"
          yield
          debug "Out of embattled yield."
        rescue ex
          exception(ex)
          reset
        end
      end
      log "Disengaging // 0MQ: #{MOUNTPOINT_LOCATION}"
      shutdown
    end
    
    def reset
      shutdown
      log "Reset 0MQ connection."
      connect
    end

  end
end
