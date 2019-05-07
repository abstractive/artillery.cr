module Artillery
  module Logger

    extend self

    def log(message, tag=nil)
      puts output = ((tag) ? "#{tag}: " : "") + message
      output
    end

    def timestamp
      Time.now.to_s("%Y-%m-%d %H:%M:%S.%L")
    end

  end
end