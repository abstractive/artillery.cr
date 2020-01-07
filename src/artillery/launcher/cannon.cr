require "../launcher"

module Artillery
  class Cannon < Launcher

    extend self

    VERSION = 'CNON01'

    @@presence = uninitialized String

    def start
      @@context = ZMQ::Context.new
      @@client = @@context.socket(ZMQ::DEALER)
      @@client.connect(MOUNTPOINT_LOCATION)
      @@client.set_socket_option(ZMQ::LINGER, 0)
      log "Started // 0MQ: #{MOUNTPOINT_LOCATION} // Presence: #{@@presence}", "Artillery::Cannon"
    end

    def run
      prepare_launcher

    def ready

    end

    def on_message()

    end

    def on_request()

    end

    def reply()

    end

    def send_heartbeat
      #de Implement
    end

    def shutdown

    end

  end
end
