local data = require "data"

-- Initialize a table to hold vehicles for each IPL
VehiclesInIPL = {}
for k, v in pairs(data.IPLS) do
    VehiclesInIPL[k] = {}
end

-- Function to create vehicles in an IPL
function createVehiclesInIPL(name, ipl)
    if data.debug then
        -- Ensure the IPL data exists
        if data.IPLS[ipl] and data.IPLS[ipl].vehicles then
            for _, v in pairs(data.IPLS[ipl].vehicles) do
                lib.requestModel(data.DebugCar, 2000) -- Load the vehicle model
                local vehicle = CreateVehicle(data.DebugCar, v.coords.x, v.coords.y, v.coords.z, v.coords.w, true, false)
                if vehicle then
                    table.insert(VehiclesInIPL[name], vehicle) -- Add vehicle to the table
                else
                    print("Failed to create vehicle at coords: ", v.coords)
                end
            end
        else
            print("Invalid IPL data for: " .. ipl)
        end
    else
        print("Debug mode is disabled; no vehicles created.")
    end
    return VehiclesInIPL[name]
end

-- Function to delete all vehicles in an IPL
function deleteVehiclesInIPL(name)
    if VehiclesInIPL[name] then
        for _, v in pairs(VehiclesInIPL[name]) do
            if DoesEntityExist(v) then
                DeleteEntity(v) -- Safely delete the vehicle
            end
        end
        VehiclesInIPL[name] = {} -- Clear the table
    else
        print("No vehicles found for IPL: " .. name)
    end
end

-- Function to get vehicles in an IPL
function getVehiclesInIPL(name)
    return VehiclesInIPL[name] or {} -- Return the list or an empty table
end
