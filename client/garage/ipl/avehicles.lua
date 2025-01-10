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
            local polyzonePoints = iplData.vehicles.poly.points
            local maxVehicles = iplData.vehicles.max
            local direction = normalizeVector(vector3(polyzonePoints[#polyzonePoints].x - polyzonePoints[1].x,
                                                      polyzonePoints[#polyzonePoints].y - polyzonePoints[1].y,
                                                      polyzonePoints[#polyzonePoints].z - polyzonePoints[1].z))

            -- Calculate the total distance and spacing between vehicles
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
                -- Ensure slot 1 is empty
                local isSlotFilled = (i == 1) and false or true
                table.insert(SlotsInIPL[name], { position = position, isSlotFilled = isSlotFilled })
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
            local polyzonePoints = iplData.vehicles.poly.points
            local margin = iplData.vehicles.margin or 0
            local distanceBetweenVehicles = iplData.vehicles.DistanceBetweenVehicles or 5

            if #polyzonePoints < 2 then
                print("PolyZone must have at least two points to calculate vehicle positions.")
                return
            end

            -- Create the PolyZone
            local polyZone = lib.zones.poly({
                points = polyzonePoints,
                thickness = 2,
                debug = true,
            })

            local startPoint = vector3(polyzonePoints[1].x, polyzonePoints[1].y, polyzonePoints[1].z)
            local endPoint = vector3(polyzonePoints[#polyzonePoints].x, polyzonePoints[#polyzonePoints].y, polyzonePoints[#polyzonePoints].z)

            local direction = normalizeVector(endPoint - startPoint)
            local totalDistance = vectorLength(endPoint - startPoint)
            local spacing = totalDistance / (maxVehicles - 1)

            if distanceBetweenVehicles > 0 then
                spacing = distanceBetweenVehicles
            end

            local marginOffset = vector3(direction.x * margin, direction.y * margin, direction.z * margin)
            local marginStart = vector3(startPoint.x + marginOffset.x, startPoint.y + marginOffset.y, startPoint.z + marginOffset.z)
            local marginEnd = vector3(endPoint.x - marginOffset.x, endPoint.y - marginOffset.y, endPoint.z - marginOffset.z)

            -- Initialize SlotsInIPL[name] if it doesn't exist
            if not SlotsInIPL[name] then
                SlotsInIPL[name] = {}
            end
            for i = 1, maxVehicles do  -- Loop to maxVehicles, now including the dynamic last slot

                local position = vector3(
                    marginStart.x + direction.x * ((i - 1) * spacing),
                    marginStart.y + direction.y * ((i - 1) * spacing),
                    marginStart.z + direction.z * ((i - 1) * spacing)
                )

                local zOffset = 0.0
                local groundFound, groundZ = GetGroundZFor_3dCoord(position.x, position.y, position.z + 10, false)
                if groundFound then
                    zOffset = groundZ - position.z
                end
                position = vector3(position.x, position.y, position.z + zOffset)
                lib.requestModel(data.DebugCar, 2000)
                
                -- Skip spawning vehicle in the last slot for debugging purposes
                if i == maxVehicles then
                    if not SlotsInIPL[name][i] then
                        SlotsInIPL[name][i] = { position = position, isSlotFilled = false }
                    end
                    -- Do not spawn vehicle, set slot as empty
                    SlotsInIPL[name][i].isSlotFilled = false
                else
                    local vehicle = CreateVehicle(data.DebugCar, position.x, position.y, position.z, heading, true, false)

                    if vehicle then
                        -- Insert the vehicle into the VehiclesInIPL global table
                        local vehicleTable = getVehiclesGlobalTable(name)
                        table.insert(vehicleTable, { vehicle = vehicle, position = position })

                        -- Ensure slot exists before marking as filled
                        if not SlotsInIPL[name][i] then
                            SlotsInIPL[name][i] = { position = position, isSlotFilled = false }
                        end
                        SlotsInIPL[name][i].isSlotFilled = true -- Mark slot as filled
                    else
                        if not SlotsInIPL[name][i] then
                            SlotsInIPL[name][i] = { position = position, isSlotFilled = false }
                        end
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

-- Function to draw markers for empty slots
-- Function to draw markers for empty slots
function drawEmptySlotsMarkers(name)
    Citizen.CreateThread(function()
        while not waitForVehiclesCreation(name, 5000) do -- Wait for vehicles to be created with a 5-second timeout
            Citizen.Wait(100)
        end

        local slots = getEmptySlotsInIPL(name)

        if slots then
            for _, slot in ipairs(slots) do
                -- Ensure the marker is drawn at the center of the slot
                local markerPosition = vector3(slot.position.x - 2, slot.position.y, slot.position.z)

                -- Adjust Z position to ensure the marker is on the ground (centered)
                local groundFound, groundZ = GetGroundZFor_3dCoord(markerPosition.x, markerPosition.y, markerPosition.z + 10, false)
                if groundFound then
                    markerPosition = vector3(markerPosition.x, markerPosition.y, groundZ)
                end

                -- Draw the marker only for empty slots
                local marker = lib.marker.new({
                    type = 1,
                    coords = markerPosition,  -- Adjusted marker position
                    color = { r = 255, g = 0, b = 0, a = 20 },
                })

                while true do
                    marker:draw()
                    Citizen.Wait(1)
                end
            end
        end
    end)
end


-- Function to get vehicles in an IPL
function getVehiclesInIPL(name)
    while not waitForVehiclesCreation(name, 5000) do
        Citizen.Wait(100) -- wait for the data to be available
    end
    local vehicles = VehiclesInIPL[name] or {}
    local sequentialVehicles = {}
    for _, v in ipairs(vehicles) do
        table.insert(sequentialVehicles, v)
    end
    return sequentialVehicles
end

-- Function to get slots in an IPL
function getSlotsInIPL(name)
    while not SlotsInIPL[name] do
        Citizen.Wait(100) -- wait for the data to be available
    end

    local slots = SlotsInIPL[name] or {}
    local sequentialSlots = {}
    for i = 1, #slots do
        if slots[i] then
            table.insert(sequentialSlots, slots[i])
        end
    end
    return sequentialSlots
end

-- Function to get empty slots in an IPL
function getEmptySlotsInIPL(name)
    repeat Wait(0) until SlotsInIPL[name]
    local slots = getSlotsInIPL(name)
    local emptySlots = {}


    for _, slot in ipairs(slots) do
        if not slot.isSlotFilled then
            table.insert(emptySlots, slot)
        end
    end

    return emptySlots
end

-- Function to find an empty slot in an IPL
function findEmptySlotInIPL(name)
    local slots = getSlotsInIPL(name)

    for i, slot in ipairs(slots) do
        if not slot.isSlotFilled then
            return i, slot
        end
    end
    return nil, nil
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
            if vectorDistance(slot.position, v.position) < 1.0 then  -- Check within tolerance
                isSlotFilled = true
                break
            end
        end
        slot.isSlotFilled = isSlotFilled  -- Mark the slot as filled or available
    end
end

-- Monitor and update slot occupation
Citizen.CreateThread(function()
    while true do
        for name, _ in pairs(SlotsInIPL) do
            updateSlotOccupation(name) -- Update slot status
            drawEmptySlotsMarkers(name) -- Draw empty slots
        end
        Citizen.Wait(1000) -- Check every second
    end
end)
