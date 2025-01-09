if GetResourceState("oxmysql") == "started" then
    print("oxmysql is started!")
    if (GetResourceState("es_extended") == "started") then
        if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
            ESX = exports["es_extended"]:getSharedObject()
        else
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        end
    end
else
    print("oxmysql is not started!")
end

ESX.RegisterServerCallback('l-garage:getVehicles', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    exports.oxmysql:query('SELECT * FROM owned_vehicles WHERE owner = ?', {identifier}, function(result)
        cb(result)
        debug(result, 2)
    end)
end)

RegisterNetEvent('l-garage:storeVehicle')
AddEventHandler('l-garage:storeVehicle', function(vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local propJson = json.encode(vehicleProps)
    exports.oxmysql:query('UPDATE owned_vehicles SET stored = 1, vehicle = ? WHERE plate = ? AND owner = ?',
        {propJson, vehicleProps.plate, identifier})
end)
