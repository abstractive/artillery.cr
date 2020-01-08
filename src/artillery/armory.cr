require "../artillery"
require "../artillery/shot"
require "../artillery/shot/error_404"

require "radix"

module Artillery
  class Armory

    extend Logger
    
    @@index = uninitialized Radix::Tree(String)

    #de TODO: Infer uri by file-location unless specified
    @@vectors = Array(
      NamedTuple(
        redirect: String?,
        path: String,
        method: Symbol,
        object: String
      )
    ).new

    def self.vectors
      @@vectors
    end

    def self.load(vector)
      @@vectors.push(vector)
    end

    def self.not_found
      {
        path: "/not-found",
        method: :get,
        object: "Error404"
      }
    end

    def self.equip(shell : Artillery::Shell::Request)
      vector = @@index.find("#{shell.index}")
      return not_found unless vector.found?
      {
        path: shell.path,
        method: shell.method,
        object: vector.payload
      }
    end

    def self.organize
      @@index = Radix::Tree(String).new
      @@vectors.each { |v|
        @@index.add "#{v[:method].to_s.upcase}#{v[:path]}", v[:object]
        #de log "Added #{v[:method].to_s.upcase}#{v[:path]} on #{v[:object]}"
      }
    end

  end
end
