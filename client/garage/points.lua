-- Load Garage data from the 'data.lua' file
Data = require 'data'
Garages = Data.Garages
WaitForGarageData()

-- Handles NPC creation when a player enters a garage
function onEnter(self)
    if self.data.npc then
        garage_npcs_createNPC(self) -- Create NPC if data contains NPC info
    end
end

-- Handles NPC removal when a player exits a garage
function onExit(self)
    if self.data.npc then
        garage_npcs_removeNPC(self) -- Remove NPC if data contains NPC info
    end
end

-- Called when a player is nearby a garage, triggers relevant actions
function nearby(self)
    garage_helpNotifyThread(self) -- Display help notifications if applicable
    if self.data.marker then
        garage_markers_drawMarker(self) -- Draw a marker if data contains marker information
    end
    garage_control_handleControl(self) -- Handle player controls related to garage
end

-- Creates points (markers) for each garage and registers actions like entering/exiting
function createPoints(Garages)
    for k, v in pairs(Garages) do
        -- Create a marker for the garage using the provided coordinates, type, and color
        local marker = lib.marker.new({
            coords = v.coords,
            type = v.marker.type,
            color = v.marker.color,
        })

        -- Register a new point (garage) with various actions (enter, exit, nearby)
        lib.points.new({
            name = k,               -- Name of the point (e.g., garage name)
            data = v,               -- Data containing garage-specific information
            coords = v.coords,      -- Coordinates of the garage
            distance = v.distance,  -- Distance within which actions are triggered
            nearby = nearby,        -- Function to call when a player is nearby
            onEnter = onEnter,      -- Function to call when a player enters the area
            onExit = onExit,        -- Function to call when a player exits the area
            marker = marker,        -- The marker to display at the garage's location
            helpnotification = v.helpnotification, -- Help notification info
        })
    end
end
