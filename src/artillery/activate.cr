require "../artillery"

require "./mountpoint/battery"
require "./launcher/bazooka"
require "./mountpoint/shoulder"

case Artillery::DISPOSITION
when "battery"
  Artillery::Battery.run
when "bazooka"
  Artillery::Bazooka.run
when "shoulder"
  Artillery::Shoulder.run
else
  Artillery.log "Cannot guess disposition.", "Artillery"
  abort
end
