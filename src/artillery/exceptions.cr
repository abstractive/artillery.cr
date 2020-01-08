module Artillery
  module Error
    class PresenceUndefined < Exception; end
    module Invalid
      class MessageFormat < Exception; end
      class ProtocolVersion < Exception; end
      class CommandRecieved < Exception; end
    end
  end
end
