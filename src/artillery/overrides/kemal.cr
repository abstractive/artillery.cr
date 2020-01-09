require "kemal"

Kemal.config.host_binding = Artillery::MOUNTPOINT_INTERFACE
Kemal.config.port = Int32.new(Artillery::MOUNTPOINT_PORT_HTTP)
Kemal.config.shutdown_message = false
Kemal.config.logger = Artillery::Logger::Kemal.new

#de Can likely remove; provided by nginx
Kemal.config.public_folder = Artillery::PUBLIC_DIRECTORY

module Kemal
  def self.display_startup_message(config, server)
    #de Suppress startup message.
  end
end

class Artillery::Logger::Kemal < ::Kemal::BaseLogHandler
  # This is run for each request. You can access the request/response context with `context`.
  def call(context)
    elapsed = elapsed_text(Time.measure { call_next(context) })
    method = context.request.method.colorize(:blue)
    resource = context.request.resource
    status = context.response.status_code
    Artillery::Logger.log "#{status}/#{method}: #{resource} #{elapsed}", "Kemal"
    #de call_next context
  end

  def write(message)
  end

  private def elapsed_text(elapsed)
    millis = elapsed.total_milliseconds
    return "#{millis.round(2)}ms" if millis >= 1

    "#{(millis * 1000).round(2)}µs"
  end
end

