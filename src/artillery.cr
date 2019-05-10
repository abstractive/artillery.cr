require "zeromq"
require "json"

module Artillery
  MOUNTPOINT_LOCATION = ENV["ARTILLERY_MOUNTPOINT"] ||= "tcp://127.0.0.1:5555"
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