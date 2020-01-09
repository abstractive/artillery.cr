module Artillery
  module Protocol
    module Cannonry
      HEADER          = "ABCD01" #de Artillery Battery Cannon Decentrality
      RETRIES         = 3
      module Timing
        HEARTBEAT_IN  = 5000.milliseconds
        HEARTBEAT_OUT = 9000.milliseconds
        EXPIRES       = HEARTBEAT_OUT
        LISTEN        = 100 #de Milliseconds
        RETRY         = 1000.milliseconds
        WAIT          = 5.milliseconds
        POLL          = 100 #de milliseconds
        REPLY         = 1.seconds
      end
      module Command
        READY         =   "\001"
        REQUEST       =   "\002"
        REPLY         =   "\003"
        HEARTBEAT     =   "\004"
        DISCONNECT    =   "\005"
      end
    end
  end
end
