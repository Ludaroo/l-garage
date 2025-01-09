Data = require 'data' -- loads Garages from data.lua for now
Garages = Data.Garages
WaitForGarageData()

function onEnter(self)
    if self.data.npc then
        garage_npcs_createNPC(self)
    end
end

function onExit(self)
    if self.data.npc then
        garage_npcs_removeNPC(self)
    end
end

function nearby(self)
    garage_helpNotifyThread(self)
    if self.data.marker then
        garage_markers_drawMarker(self)
    end
    garage_control_handleControl(self)
end

function createPoints(Garages)
    for k, v in pairs(Garages) do
        local marker = lib.marker.new({
            coords = v.coords,
            type = v.marker.type,
            color = v.marker.color,
          })
        lib.points.new({
            name = k,
            data = v,
            coords = v.coords,
            distance = v.distance,
            nearby = nearby,
            onEnter = onEnter,
            onExit = onExit,
            marker = marker,
            helpnotification = v.helpnotification,
        })
    end
end
