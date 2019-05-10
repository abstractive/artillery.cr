require "zeromq"
require "json"

module Artillery
  HTTP_METHODS   = %w(get post put patch delete options)
  USE_SHELL_HEADERS = ENV["ARTILLERY_SHELL_HEADERS"] ||= nil
end

#de Only load essentials.
#de Individual applications in src/processes/ require their own specialized object requirements.

require "./artillery/macros/*"

require "./artillery/logger"
require "./artillery/shell/request"
require "./artillery/shell/response"
