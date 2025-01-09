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
    RenderScriptCams(true, false, 0, true, true)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)

    -- Get vehicles in the IPL
    vehiclesInIPL = vehicles

    -- Show the ped at the first position
    if #vehiclesInIPL > 0 then
        currentVehicleIndex = 1
        focusOnVehicle(vehiclesInIPL[currentVehicleIndex])
    else
        print("No vehicles found in IPL: " .. ipl)
    end

    -- Disable all controls
    disableControls(true)

    -- Draw instructions above the vehicles
    drawInstructions()

    -- Show the instructional button and handle keypresses
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
                    currentVehicleIndex = currentVehicleIndex - 1
                    if currentVehicleIndex < 1 then
                        currentVehicleIndex = #vehiclesInIPL
                    end
                    focusOnVehicle(vehiclesInIPL[currentVehicleIndex])
                elseif IsControlJustPressed(0, 175) then -- Right Arrow
                    currentVehicleIndex = currentVehicleIndex + 1
                    if currentVehicleIndex > #vehiclesInIPL then
                        currentVehicleIndex = 1
                    end
                    focusOnVehicle(vehiclesInIPL[currentVehicleIndex])
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
        RenderScriptCams(false, false, 0, true, true)
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
            RenderScriptCams(true, false, 0, true, true)
        else
            SetCamActive(IPLCamera, false)
            RenderScriptCams(false, false, 0, true, true)
        end
    end
end

function focusOnVehicle(vehicle)
    local vehicleCoords = GetEntityCoords(vehicle)
    local cameraOffset = vector3(0, -5, 2) -- Adjust camera offset as needed
    local cameraPosition = vehicleCoords + cameraOffset

    -- Adjust camera position and point at the vehicle
    SetCamCoord(IPLCamera, cameraPosition.x, cameraPosition.y, cameraPosition.z)
    PointCamAtEntity(IPLCamera, vehicle)
end

function getCameraSpace(coords)
    -- Raycast to find a suitable camera space
    local raycast = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z + 100, 1, PlayerPedId(), 0)
    local _, hit, endCoords = GetShapeTestResult(raycast)
    if hit then
        return endCoords
    end
    return coords
end

-- Disable/Enable all controls
function disableControls(disable)
    if disable then
        DisplayRadar(false)
        DisableAllControlActions(0)
        EnableControlAction(0, 174, true) -- Left Arrow
        EnableControlAction(0, 175, true) -- Right Arrow
        EnableControlAction(0, 176, true) -- Enter
        EnableControlAction(0, 74, true)  -- H key
     
    else
        
    end
end

-- Draw instructions above the vehicles (empty for now)
function drawInstructions()
    -- This function can be used to draw something above vehicles in future.
end

-- Show instructional button
function showInstructionalButton()
    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamPlayerNameString("Left/Right to move cars")
    ScaleformMovieMethodAddParamPlayerNameString("Enter to select a car")
    ScaleformMovieMethodAddParamPlayerNameString("H to disable camera")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

-- Call this function to show the instructional button
showInstructionalButton()

function selectVehicle(vehicle)
    -- You can add logic here for what happens when a vehicle is selected.
    print("Vehicle selected: " .. vehicle)
end
