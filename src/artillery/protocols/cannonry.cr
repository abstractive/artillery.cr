module Artillery
  module Protocols
    module Cannonry
      RETRIES         = 3
      module Timing
        HEARTBEAT     = 3.seconds
        RECONNECT     = 3.seconds
        WAIT_LISTEN   = 2 #de Seconds
        WAIT_RETRY    = 1 #de Seconds
      end
      module Worker
        VERSION       = "ABCP01" #de Artillery Battery Cannon Presence
        READY         =   "\001"
        REQUEST       =   "\002"
        REPLY         =   "\003"
        HEARTBEAT     =   "\004"
        DISCONNECT    =   "\005"
      end
    end
  end
end
