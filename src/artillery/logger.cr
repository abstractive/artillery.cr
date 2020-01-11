require "colorize"

module Artillery
  module Logger

    extend self

    def mark(*symbols)
      printf("#{symbols.join}")
    end

    def log(message, tag=self.class.name)
      arrow = ">".colorize(:dark_gray).mode(:bold).to_s
      printf output = "\n#{timestamp} #{arrow} #{((tag) ? "#{tag.colorize(:light_yellow).to_s} #{arrow} " : "") + message} "
      output
    end

    def debug(message, tag=self.class.name, level : Int32? = nil)
      #de TODO: Implement levels.
      word = "D".colorize(:cyan)
      log "#{word}: #{message.colorize(:dark_gray).to_s}", tag
    end

    def exception(ex)
      log "#{ex.class.name.colorize(:red).mode(:bold).to_s}: #{ex.message.colorize(:white).to_s}\n#{ex.backtrace.join('\n')}"
    end

    def timestamp
      Time.local.to_s("%Y-%m-%d %H:%M:%S.%6N").colorize(:dark_gray).to_s
    end

  end
  extend Logger
  include Logger
end