data = require "data"

local ipls = data.IPLS

--[[
    Loads all the IPLs by executing their respective code.
]]
function loadIPLS()
    for k, v in pairs(ipls) do
        if v.code then
            v.code()
        end
    end
end

--[[
    Retrieves the coordinates for a specified IPL by name.
    @param name: The name of the IPL to retrieve coordinates for.
    @return: The coordinates associated with the specified IPL.
]]
function getIPLCoords(name)
    return ipls[name].coords
end

--[[
    Teleports the player to a specified IPL location.
    @param name: The name of the IPL to teleport to.
]]
function teleportToIPL(name)
    -- Ensure IPL code is executed before teleporting
    if ipls[name] and ipls[name].code then
        ipls[name].code()
    end
    
    -- Create the vehicles for the IPL (custom function, adjust as needed)
    local vehicles = createVehiclesInIPL(name, name)
    
    -- Fade out before teleporting
    DoScreenFadeOut(1000)
    Wait(1000)

    -- Set player's position to the entrance of the IPL
    SetEntityCoords(PlayerPedId(), getIPLCoords(name).entrance)

    -- Fade in after teleporting
    DoScreenFadeIn(1000)

    -- Optionally, start the camera for the IPL (uncomment if necessary)
    -- startIPLCamera(name, vehicles)
end

if data.debug then
-- Test teleport to "eclipseboulevard" IPL for debug purposes
teleportToIPL("eclipseboulevard")
end
