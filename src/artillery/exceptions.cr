module Artillery
  module Error
    module Presence
      class Undefined < Exception; end
      class Unavailable < Exception; end
    end
    module Invalid
      class MessageFormat < Exception; end
      class ProtocolVersion < Exception; end
      class CommandReceived < Exception; end
    end
  end
end
