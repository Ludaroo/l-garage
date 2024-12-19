function WaitForGarageData()
    while not Garages do
        Wait(100)
        -- function to check if the garage data is loaded from the server     
    end
end

function RefreshGarageData()
    -- ESX.TriggerServerCallback('l-garage:getGarages', function(garages)
    --     Garage = garages
    -- end)
    -- example for later
end

function GetGarageData()
    return Garage
end

function GetGarageDataByName(name)
    return Garage[name]
end


