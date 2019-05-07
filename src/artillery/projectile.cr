require "../artillery"
require "radix"

module Artillery
  class Projectile

    include Logger

    #de TODO: Infer uri by file-location unless specified
    @@vectors = Array(NamedTuple(uri: String, method: Symbol, action: Symbol)).new

    @response = uninitialized Shell::Response
    @request = uninitialized Shell::Request

    property request : Shell::Request?

    def initialize(request)
      log "Initialize"
      @request = request
    end

    def self.vector(uri : String)
      @@vectors.push({
        uri: uri,
        method: :get,
        action: :initialize
      })
    end

    def self.vector(method : Symbol, uri : String)
      @@vectors.push({
        method: method,
        uri: uri
      })
    end

    def self.vector(method : Symbol, uri : String, action : Symbol)
      @@vectors.push({
        method: method,
        uri: uri,
        action: action
      })
    end

    def self.vectors
      @@vectors
    end

  end
end
