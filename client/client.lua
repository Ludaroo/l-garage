if (GetResourceState("es_extended") == "started") then
    if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
        ESX = exports["es_extended"]:getSharedObject()
    else
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
end

local garageLocations = {
    {x = -460.5656, y = -813.7045, z = 30.5663}
}
local markerdist = 10.0
local markertype = 1
local markercolor = {r = 0, g = 255, b = 0}

local inzone = false

Citizen.CreateThreadNow(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        inzone = false

        for _, garage in pairs(garageLocations) do
            local distance = #(playerCoords - vector3(garage.x, garage.y, garage.z))
            if distance < markerdist then
                DrawMarker(markertype, garage.x, garage.y, garage.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, markercolor.r, markercolor.g, markercolor.b, 100, false, true, 2, false, nil, nil, false)
                if distance < 2.0 then
                    inzone = true
                    if IsControlJustReleased(0, 38) then
                        OpenMenu()
                    end
                end
            end
        end

        -- if inzone then
        --     SetNuiFocus(true, true)
        -- else
        --     SetNuiFocus(true, false)
        -- end

        Wait(0)
    end
end)



function OpenMenu()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open'})
    debug("opening menu", 3)

    ESX.TriggerServerCallback('l-garage:getVehicles', function(vehicles)
        SendNUIMessage({action = 'loadVehicles', vehicles = vehicles})
    end)
end



RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('spawnVehicle', function(data)
    local vehicleProps = data.vehicleProps
    local playerCoords = GetEntityCoords(PlayerPedId())

    ESX.Game.SpawnVehicle(vehicleProps.model, playerCoords, 0.0, function(vehicle)
        ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end)
end)


RegisterCommand("close", function()
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'close'})
end)