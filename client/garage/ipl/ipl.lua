data = require "data"

local ipls = data.IPLS
function loadIPLS()
    for k,v in pairs(IPLS) do
        if v.code then
            v.code()
        end
    end
end

function getIPLCoords(name)
    return ipls[name].coords
end

function teleportToIPL(name)
    
    ipls[name].code()
    
vehicles = createVehiclesInIPL("eclipseboulevard", "eclipseboulevard")
    -- Fade out before teleporting
    DoScreenFadeOut(1000)
    Wait(1000)


    SetEntityCoords(PlayerPedId(), getIPLCoords(name).entrance)


    DoScreenFadeIn(1000)
    --startIPLCamera("eclipseboulevard", vehicles)

end


teleportToIPL("eclipseboulevard")


