require "../artillery"
require "radix"

module Artillery
  class Launcher

    extend Logger

    @@context = uninitialized ZMQ::Context
    @@client = uninitialized ZMQ::Socket

    def self.start
      @@context = ZMQ::Context.new
      @@client = @@context.socket(ZMQ::REP)
      @@client.connect("tcp://127.0.0.1:5555")
      @@client.set_socket_option(ZMQ::LINGER, 0)
      log "Starting Launcher", "Artillery"
    end

    def self.reset
      @@client.close
      log "Reset"
      start
    rescue
    end

    def self.run
      start
      loop do
        begin
          request = Artillery::Shell::Request.from_json(@@client.receive_string)
          @@client.send_string("#{timestamp}/l: RESPONSE")
          log "#{timestamp}/l: #{request.path}"
        rescue ex
          log "#{ex.class.name}: #{ex.message}\n#{ex.backtrace.join('\n')}"
          reset
        end
      end

    end
  end
end
