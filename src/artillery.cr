require "zeromq"
require "json"

module Artillery
  PUBLIC_DIRECTORY = ENV["ARTILLERY_PUBLIC"] ||= "./public"
  MOUNTPOINT_INTERFACE = ENV["ARTILLERY_EXPOSED_INTERFACE"] ||= "0.0.0.0"
  MOUNTPOINT_PORT_ZEROMQ = ENV["ARTILLERY_PORT_ZEROMQ"] ||= "4000"
  MOUNTPOINT_LOCATION = ENV["ARTILLERY_ZEROMQ_URL"] ||= "tcp://#{MOUNTPOINT_INTERFACE}:#{MOUNTPOINT_PORT_ZEROMQ}"
  MOUNTPOINT_PORT_HTTP = ENV["ARTILLERY_PORT_HTTP"] ||= "3000"
  HTTP_METHODS = %w(get post put patch delete options)
  USE_SHELL_HEADERS = ENV["ARTILLERY_SHELL_HEADERS"] ||= nil
  USE_SHOTS = ENV["ARTILLERY_SHOTS"] ||= nil
end

#de Only load essentials.
#de Individual applications in src/processes/ require their own specialized object requirements.

require "./artillery/overrides/*"
require "./artillery/macros/*"

require "./artillery/logger"
require "./artillery/shell/request"
require "./artillery/shell/response"

require "./artillery/mountpoint"
require "./artillery/launcher"
require "./artillery/shot"

#de if Artillery::USE_SHOTS
#de   puts "SHOTS: #{Artillery::USE_SHOTS}"
#de end