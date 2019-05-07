module Artillery
  module Logger

    def self.log(message, tag=nil)
      puts output = ((tag) ? "#{tag}: " : "") + message
      output
    end

    def log(message, tag=self.class.name)
      Artillery::Logger.log(message, tag)
    end

    def self.timestamp
      Time.now.to_s("%Y-%m-%d %H:%M:%S.%L")
    end

    def timestamp
      Artillery::Logger.timestamp
    end

  end
end