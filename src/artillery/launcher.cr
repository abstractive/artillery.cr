require "../artillery"

module Artillery
  class Launcher

    extend Logger

    def self.run

      log "Starting Launcher", "Artillery"
      
      context = ZMQ::Context.new
      client = context.socket(ZMQ::REP)
      client.connect("tcp://127.0.0.1:5555")
      client.set_socket_option(ZMQ::LINGER, 0)

      loop do
        begin
          request = Artillery::Shell::Request.from_json(client.receive_string)
          puts request.path
          client.send_string("#{timestamp}/l: RESPONSE")
          puts "#{timestamp}/l: #{request}"
        rescue ex
          puts "#{ex.class.name}: #{ex.message}\n#{ex.backtrace.join('\n')}"
        end
      end

    end
  end
end
