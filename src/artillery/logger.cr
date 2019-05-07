module Artillery
  module Logger

    def log(message)
      puts "#{self.class.name} #{message}"
    end

  end
end