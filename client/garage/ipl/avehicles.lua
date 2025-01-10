local data = require "data"

-- Global tables to store vehicles and slot information
VehiclesInIPL = {}
SlotsInIPL = {}
SlotsCount = {}

-- Initialize global table for vehicles
function getVehiclesGlobalTable(name)
    -- Check if global table exists, if not create it
    if not VehiclesInIPL[name] then
        VehiclesInIPL[name] = {}
    end
    return VehiclesInIPL[name]
end

-- Function to wait for vehicles to be created with a timeout
function waitForVehiclesCreation(name, timeout)
    local startTime = GetGameTimer()
    while not VehiclesInIPL[name] and GetGameTimer() - startTime < timeout do
        Citizen.Wait(100)
    end
    return VehiclesInIPL[name] and true or false
end

function vectorDistance(vec1, vec2)
    return #(vec1 - vec2)
end

-- Helper function to normalize a vector
function normalizeVector(vec)
    local length = math.sqrt(vec.x^2 + vec.y^2 + vec.z^2)
    if length == 0 then
        return vector3(0, 0, 0)
    end
    return vector3(vec.x / length, vec.y / length, vec.z / length)
end

function vectorLength(vec)
    return math.sqrt(vec.x^2 + vec.y^2 + vec.z^2)
end

-- Function to calculate the number of slots in an IPL
function calculateSlotsInIPL(name, ipl)
    if not SlotsCount[name] then
        local iplData = data.IPLS[ipl]
        if iplData and iplData.vehicles then
            local polyzonePoints = iplData.vehicles.poly and iplData.vehicles.poly.points
            local maxVehicles = iplData.vehicles.max
            if polyzonePoints then
                -- Handle PolyZone calculations
                local direction = normalizeVector(vector3(polyzonePoints[#polyzonePoints].x - polyzonePoints[1].x,
                                                          polyzonePoints[#polyzonePoints].y - polyzonePoints[1].y,
                                                          polyzonePoints[#polyzonePoints].z - polyzonePoints[1].z))
                local totalDistance = vectorLength(polyzonePoints[#polyzonePoints] - polyzonePoints[1])
                local spacing = totalDistance / (maxVehicles - 1)

                -- Store the number of slots in SlotsCount
                SlotsCount[name] = maxVehicles
                print("Calculated slots for IPL " .. name .. ": " .. SlotsCount[name])

                -- Initialize SlotsInIPL[name] if it doesn't exist
                if not SlotsInIPL[name] then
                    SlotsInIPL[name] = {}
                end

                -- Populate SlotsInIPL table with empty slot data
                for i = 1, maxVehicles do
                    local position = vector3(polyzonePoints[1].x + (direction.x * spacing * (i - 1)),
                                             polyzonePoints[1].y + (direction.y * spacing * (i - 1)),
                                             polyzonePoints[1].z + (direction.z * spacing * (i - 1)))
                    local isSlotFilled = (i == 1) and false or true
                    table.insert(SlotsInIPL[name], { position = position, isSlotFilled = isSlotFilled })
                end
            else
                -- Handle single vehicle slot
                local vehicles = iplData.vehicles
                if vehicles then
                    SlotsCount[name] = #vehicles
                    if not SlotsInIPL[name] then
                        SlotsInIPL[name] = {}
                    end
                    for i, vehicle in ipairs(vehicles) do
                        table.insert(SlotsInIPL[name], { position = vehicle.coords, isSlotFilled = false })
                    end
                end
            end
        else
            print("No vehicles data found for IPL: " .. name)
        end
    end
    return SlotsCount[name]
end

-- Function to create vehicles in an IPL with margin distance
function createVehiclesInIPL(name, ipl)
    if data.debug then
        local iplData = data.IPLS[ipl]
        if iplData and iplData.vehicles then
            local maxVehicles = iplData.vehicles.max
            local heading = iplData.vehicles.heading
            local polyzonePoints = iplData.vehicles.poly and iplData.vehicles.poly.points
            local margin = iplData.vehicles.margin or 0
            local distanceBetweenVehicles = iplData.vehicles.DistanceBetweenVehicles or 5

            if polyzonePoints then
                -- Create the PolyZone and handle vehicle creation inside the PolyZone
                local startPoint = vector3(polyzonePoints[1].x, polyzonePoints[1].y, polyzonePoints[1].z)
                local endPoint = vector3(polyzonePoints[#polyzonePoints].x, polyzonePoints[#polyzonePoints].y, polyzonePoints[#polyzonePoints].z)

                local direction = normalizeVector(endPoint - startPoint)
                local totalDistance = vectorLength(endPoint - startPoint)
                local spacing = totalDistance / (maxVehicles - 1)

                if distanceBetweenVehicles > 0 then
                    spacing = distanceBetweenVehicles
                end

                -- Create vehicles in the PolyZone
                for i = 1, maxVehicles do
                    local position = vector3(startPoint.x + direction.x * ((i - 1) * spacing),
                                             startPoint.y + direction.y * ((i - 1) * spacing),
                                             startPoint.z + direction.z * ((i - 1) * spacing))

                    lib.requestModel(data.DebugCar, 2000)
                    if i == maxVehicles then
                        -- Skip spawning vehicle in the last slot for debugging purposes
                        SlotsInIPL[name][i].isSlotFilled = false
                    else
                        local vehicle = CreateVehicle(data.DebugCar, position.x, position.y, position.z, heading, true, false)
                        local vehicleTable = getVehiclesGlobalTable(name)
                        table.insert(vehicleTable, { vehicle = vehicle, position = position })
                        SlotsInIPL[name][i].isSlotFilled = true
                    end
                end
            else
                -- Handle single vehicle slot creation
                local vehicles = iplData.vehicles
                if vehicles then
                    for i, vehicle in ipairs(vehicles) do
                        local position = vehicle.coords
                        lib.requestModel(data.DebugCar, 2000)
                        local createdVehicle = CreateVehicle(data.DebugCar, position.x, position.y, position.z, vehicle.heading, true, false)
                        local vehicleTable = getVehiclesGlobalTable(name)
                        table.insert(vehicleTable, { vehicle = createdVehicle, position = position })
                        SlotsInIPL[name][i].isSlotFilled = true
                    end
                end
            end
        else
            print("No vehicle data found for IPL: " .. name)
        end
    else
        print("Debug mode is disabled; no vehicles created.")
    end
end

-- Function to delete all vehicles in an IPL
function deleteVehiclesInIPL(name)
    if VehiclesInIPL[name] then
        for _, v in ipairs(VehiclesInIPL[name]) do
            if DoesEntityExist(v.vehicle) then
                DeleteEntity(v.vehicle)
            end
        end
        VehiclesInIPL[name] = {}
    else
        print("No vehicles found for IPL: " .. name)
    end

    if SlotsInIPL[name] then
        for _, slot in pairs(SlotsInIPL[name]) do
            slot.isSlotFilled = false
        end
    end
end

-- Function to update slot occupation status
function updateSlotOccupation(name)
    local slots = getSlotsInIPL(name)

    if not slots then
        print("No slots found for IPL: " .. name)
        return
    end

    local vehicles = getVehiclesInIPL(name)
    for i, slot in ipairs(slots) do
        local isSlotFilled = false
        for _, v in ipairs(vehicles) do
            if vectorDistance(slot.position, v.position) < 1.0 then
                isSlotFilled = true
                break
            end
        end
        slot.isSlotFilled = isSlotFilled
    end
end

-- Monitor and update slot occupation
Citizen.CreateThread(function()
    while true do
        for name, _ in pairs(SlotsInIPL) do
            updateSlotOccupation(name) -- Update slot status
        end
        Citizen.Wait(1000)
    end
end)
