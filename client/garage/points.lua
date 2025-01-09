Garages = require 'data'
WaitForGarageData()

function onEnter(self)
    if self.data.npc then
        garage_npcs_createNPC(self)
    end
    EnableHelpNotify("test")
end

function onExit(self)
    if self.data.npc then
        garage_npcs_removeNPC(self)
    end
    DisableHelpNotify()
end

function nearby(self)
    garage_helpNotifythread(self)
    if self.data.marker then
        garage_markers_drawMarker(self)
    end
    -- handleControl()
    garage_control_handleControl(self)
end

function createPoints(Garages)
    for k, v in pairs(Garages) do
        lib.points.new({
            name = k,
            data = v,
            coords = v.coords,
            distance = v.distance,
            nearby = nearby,
            onEnter = onEnter,
            onExit = onExit,
        })
    end
end
