local data = require "data"

-- Camera and state variables
local IPLCamera = nil
local currentVehicleIndex = 1
local vehiclesInIPL = {}
local isCameraActive = true -- Tracks if the camera is currently active
local controlsDisabled = false -- Tracks if controls are disabled

function loadIPL(ipl)
    RequestIpl(ipl)
    data.IPLS[ipl].code()
end

function startIPLCamera(ipl, vehicles)
    -- Load the IPL before starting the camera
    loadIPL(ipl)

    local coords = data.IPLS[ipl].coords.entrance

    -- Get a free camera space
    local cameracoords = getCameraSpace(coords)

    -- Create and set up the camera
    IPLCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(IPLCamera, cameracoords.x, cameracoords.y, cameracoords.z)
    PointCamAtCoord(IPLCamera, coords.x, coords.y, coords.z)
    SetCamActive(IPLCamera, true)
    RenderScriptCams(true, false, 1000, true, false)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)

    -- Get vehicles in the IPL
    vehiclesInIPL = vehicles

    -- Show the ped at the first position
    if #vehiclesInIPL > 0 then
        currentVehicleIndex = 1
        focusOnVehicle(vehiclesInIPL[currentVehicleIndex].vehicle)
    else
        print("No vehicles found in IPL: " .. ipl)
    end

    -- Disable all controls
    disableControls(true)

    -- Draw instructions above the vehicles
    drawInstructions()

    -- Handle keypresses
    CreateThread(function()
        while IPLCamera do
            Wait(0)

            -- Toggle camera with H key
            if IsControlJustPressed(0, 74) then -- H key
                toggleCamera()
            end

            if isCameraActive then
                -- Navigate vehicles only if the camera is active
                if IsControlJustPressed(0, 174) then -- Left Arrow
                    navigateVehicles(-1)
                elseif IsControlJustPressed(0, 175) then -- Right Arrow
                    navigateVehicles(1)
                end
            end

            -- Handle Enter to select vehicle
            if IsControlJustPressed(0, 176) then -- Enter
                selectVehicle(vehiclesInIPL[currentVehicleIndex])
            end
        end
    end)
end

function endIPLCamera()
    if IPLCamera then
        SetCamActive(IPLCamera, false)
        RenderScriptCams(false, false, 1000, true, false)
        DestroyCam(IPLCamera, true)
        IPLCamera = nil
        vehiclesInIPL = {}
        currentVehicleIndex = 1
        isCameraActive = true -- Reset camera state

        -- Re-enable controls when camera ends
        disableControls(false)
    end
end

function toggleCamera()
    if IPLCamera then
        isCameraActive = not isCameraActive
        if isCameraActive then
            SetCamActive(IPLCamera, true)
            RenderScriptCams(true, false, 1000, true, false)
        else
            SetCamActive(IPLCamera, false)
            RenderScriptCams(false, false, 1000, true, false)
        end
    end
end

function navigateVehicles(direction)
    currentVehicleIndex = currentVehicleIndex + direction
    if currentVehicleIndex < 1 then
        currentVehicleIndex = #vehiclesInIPL
    elseif currentVehicleIndex > #vehiclesInIPL then
        currentVehicleIndex = 1
    end
    focusOnVehicle(vehiclesInIPL[currentVehicleIndex])
end

function focusOnVehicle(vehicle)
    local vehicleCoords = GetEntityCoords(vehicle)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(vehicle))
    local vehicleHeight = maxDim.z - minDim.z

    -- Camera offset dynamically adjusts based on vehicle size
    local cameraOffset = vector3(0, -5.0, vehicleHeight + 1.5)
    local cameraPosition = vehicleCoords + cameraOffset

    -- Smooth transition for camera
    local duration = 1000 -- in ms
    smoothTransition(IPLCamera, cameraPosition, vehicleCoords)

    -- Highlight the vehicle (optional)
    SetVehicleLights(vehicle, 2) -- Turn on full lights for visibility
    CreateThread(function()
        Wait(1000)
        SetVehicleLights(vehicle, 0)
    end)
end

function smoothTransition(cam, toPosition, lookAtPosition)
    local startTime = GetGameTimer()
    local fromPosition = GetCamCoord(cam)
    local duration = 1000

    while GetGameTimer() - startTime < duration do
        Wait(0)
        local progress = (GetGameTimer() - startTime) / duration
        local interpolated = fromPosition + (toPosition - fromPosition) * progress
        SetCamCoord(cam, interpolated.x, interpolated.y, interpolated.z)
        PointCamAtCoord(cam, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z)
    end
end

function getCameraSpace(coords)
    -- Raycast to find a suitable camera space
    local raycast = StartShapeTestRay(coords.x, coords.y, coords.z + 1, coords.x, coords.y, coords.z + 100, 1, PlayerPedId(), 0)
    local _, hit, endCoords = GetShapeTestResult(raycast)
    if hit then
        return endCoords
    end
    return coords + vector3(0, 0, 5.0)
end

-- Disable/Enable all controls
function disableControls(disable)
    controlsDisabled = disable
    DisplayRadar(not disable)
    if disable then
        DisableAllControlActions(0)
        EnableControlAction(0, 174, true) -- Left Arrow
        EnableControlAction(0, 175, true) -- Right Arrow
        EnableControlAction(0, 176, true) -- Enter
        EnableControlAction(0, 74, true)  -- H key
    end
end

-- Draw instructions above the vehicles (placeholder for now)
function drawInstructions()
    -- Add logic to draw above vehicles dynamically if needed.
end

function selectVehicle(vehicle)
    -- Logic when a vehicle is selected
    print("Vehicle selected: " .. tostring(vehicle))
end
