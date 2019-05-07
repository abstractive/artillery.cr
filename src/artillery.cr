require "zeromq"
require "json"

module Artillery
  ARTILLERY_SHELL_HEADERS = ENV["ARTILLERY_SHELL_HEADERS"] ||= nil
end

require "./artillery/logger"
require "./artillery/shell/request"
require "./artillery/shell/response"

#de require "./artillery/mount"
#de require "./artillery/launcher"
#de require "./artillery/projectile"
