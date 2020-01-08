module Artillery
  module Protocol
    module Cannonry
      RETRIES         = 3
      module Timing
        HEARTBEAT     = 3.seconds
        WAIT_LISTEN   = 2600 #de Milliseconds
        WAIT_RETRY    = 1.second
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
