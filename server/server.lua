if (GetResourceState("es_extended") == "started") then
    if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
        ESX = exports["es_extended"]:getSharedObject()
    else
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
end

ESX.RegisterServerCallback('l-garage:getVehicles', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    oxmysql:execute('SELECT * FROM owend_vehicles WHERE owner = ?', {identifier}, function(vehicles)
        cb(vehicles)
    end)
end)

RegisterNetEvent('l-garage:storeVehicle')
AddEventHandler('l-garage:storeVehicle', function(vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local propJson = json.encode(vehicleProps)

    oxmysql:execute('UPDATE owend_vehicles SET stored = 1, vehicle = ? WHERE plate = ? AND owner = ?',
        {propJson, vehicleProps.plate, identifier})
end)
