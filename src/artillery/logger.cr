require "colorize"

module Artillery
  module Logger

    extend self

    def log(message, tag=self.class.name)
      arrow = ">".colorize(:dark_gray).mode(:bold).to_s
      puts output = "#{timestamp} #{arrow} #{((tag) ? "#{tag.colorize(:yellow).to_s} #{arrow} " : "") + message}"
      output
    end

    def debug(message, tag=self.class.name, level : Int32? = nil)
      #de TODO: Implement levels.
      word = "DEBUG".colorize(:magenta)
      log "#{word}: #{message.colorize(:dark_gray).to_s}"
    end

    def exception(ex)
      log "#{ex.class.name.colorize(:bold).to_s}: #{ex.message.colorize(:red).to_s}\n#{ex.backtrace.join('\n')}"
    end

    def timestamp
      Time.local.to_s("%Y-%m-%d %H:%M:%S.%L").colorize(:cyan).to_s
    end

  end
end