module Artillery
  module Protocols
    module Munitions

      #de TODO: Reassess; this could just be redundant
      #de       and Cannonry protocol could suffice.

      #de This ought to never exist most likely:
      #de VERSION_CLIENT = "MDPC01"

      VERSION_WORKER = "AAOP01" #de Artillery Arsenal Ordnance Protocol

      READY         =   "\001"
      REQUEST       =   "\002"
      REPLY         =   "\003"
      HEARTBEAT     =   "\004"
      DISCONNECT    =   "\005"
    end
  end
end
