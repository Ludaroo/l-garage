-- uishown = false
-- RegisterCommand("showUI", function(source, args, rawCommand)

--     SendNUIMessage({
--         type = "toggle-triangle",
--         display = not uishown
--     })
--     uishown = not uishown
-- end)
-- DUI = {}
-- local thisResource           = GetCurrentResourceName()
-- local duiUrl                 = ("nui://%s/html/dist/index.html"):format(thisResource)
-- local width                  = 1000
-- local height                 = 1480
-- local txdName                = "keep_interaction" -- texture dictionary
-- local txnName                = "interaction_txn"  -- texture name

-- local function createTexture(duiHandle)
--     local txd = CreateRuntimeTxd(txdName)
--     local txn = CreateRuntimeTextureFromDuiHandle(txd, txnName, duiHandle)
--     return txdName, txnName, txd, txn
-- end


-- local function loadScaleform(scaleformName, timeout)
--     local scaleformHandle = RequestScaleformMovie(scaleformName)
--     timeout = timeout or 5000
--     local startTime = GetGameTimer()

--     while not HasScaleformMovieLoaded(scaleformHandle) and GetGameTimer() < startTime + timeout do
--         Wait(0)
--     end

--     local loaded = HasScaleformMovieLoaded(scaleformHandle)
--     if not loaded then warn('Scaleform failed to load: ' .. scaleformName) end

--     return scaleformHandle, loaded
-- end


-- local function enableScaleform(name)
--     local sfHandle, loaded = loadScaleform(name)
--     if not loaded then return end

--     BeginScaleformMovieMethod(sfHandle, "SET_TEXTURE")
--     -- 3d
--     ScaleformMovieMethodAddParamTextureNameString(txdName)
--     ScaleformMovieMethodAddParamTextureNameString(txnName)
--     ScaleformMovieMethodAddParamInt(0)
--     ScaleformMovieMethodAddParamInt(0)
--     ScaleformMovieMethodAddParamInt(width)
--     ScaleformMovieMethodAddParamInt(height)

--     EndScaleformMovieMethod()
--     return sfHandle
-- end


-- function DUI:Create()
--     if self.scaleform then return self.scaleform end

--     local scaleform = {
--         name = 'interaction_renderer',
--         occupied = false,
--         duiObject = nil,
--         duiHandle = nil,
--         txdName = nil,
--         txnName = nil,
--         txd = nil,
--         txn = nil,
--         sfHandle = nil,
--         position = vector3(784.2927, -3009.1035, -68.9998),
--         rotation = vector3(0, 0, 0),
--         attached = {
--             entity = false,
--             bone = false,
--             offset = vec3(0, 0, 0)
--         }
--     }

--     scaleform.duiObject = CreateDui(duiUrl, width, height)
--     scaleform.duiHandle = GetDuiHandle(scaleform.duiObject)

--     -- wait till dui is available or it's gonna show `!img`
--     while not IsDuiAvailable(scaleform.duiObject) do Wait(0) end

--     scaleform.txdName, scaleform.txnName, scaleform.txd, scaleform.txn = createTexture(scaleform.duiHandle)
--     scaleform.sfHandle = enableScaleform(scaleform.name)

--     scaleform.setPosition = setPosition
--     scaleform.setRotation = setRotation
--     scaleform.set3d = set3d
--     scaleform.setScale = setScale
--     scaleform.send = send
--     scaleform.setStatus = setStatus
--     scaleform.attach = attach
--     scaleform.dettach = dettach

--     DUI.scaleform = scaleform
-- end

-- local function getRotatedOffset(rotation, offset)
--     rotation = math_rad(rotation)
--     local sin_r = math_sin(rotation)
--     local cos_r = math_cos(rotation)

--     local x = offset.x * cos_r - offset.y * sin_r
--     local y = offset.x * sin_r + offset.y * cos_r
--     return x, y, offset.z
-- end

-- local function calculatePosition(entity, offset)
--     local eRotation = GetEntityHeading(entity)
--     local ro_x, ro_y, ro_z = getRotatedOffset(eRotation, offset)
--     local currentPosition = GetEntityCoords(entity)
--     local pos = vector3(currentPosition.x + ro_x, currentPosition.y + ro_y, currentPosition.z + ro_z)
--     setPosition(pos)
--     return pos
-- end

-- local function preCalculatePosition(ref, entity, offset)
--     local pos

--     if ref.bone then
--         pos = GetWorldPositionOfEntityBone(entity, ref.bone)
--         setPosition(pos)
--         return pos
--     else
--         pos = calculatePosition(entity, offset)
--         -- setPosition(pos)
--         return pos
--     end
-- end


-- calculateWorldPosition = function(ref)
--     if not DoesEntityExist(ref.entity) then
--         renderingIsActive = false
--         return
--     end

--     local entity = ref.entity
--     local offset = ref.offset

--     local currentPosition = GetEntityCoords(entity)

--     -- Detect if the entity is static and set dynamic interval
--     if previousPosition == vec3(0, 0, 0) then
--         previousPosition = currentPosition
--     elseif currentPosition == previousPosition then
--         ref.static = true
--         tracking_interval = 500
--     else
--         ref.static = false
--         previousPosition = currentPosition
--         tracking_interval = 0
--     end

--     -- If the entity is static and position not calculated yet -> update the position
--     if ref.static and not ref.positionCalculated then
--         ref.positionCalculated = preCalculatePosition(ref, entity, offset)
--     end

--     -- If the entity is not static -> update the position
--     if not ref.static then
--         ref.positionCalculated = preCalculatePosition(ref, entity, offset)
--     end
-- end

-- local function render_sprite(scaleform)
--     -- DrawInteractiveSprite(txdName, txnName, 0.5, 0.5, 0.21, 0.55, 0.0, 255, 255, 255, 255)
--     -- DrawSprite(txdName, txnName, 0.5, 0.5, 0.21, 0.55, 0.0, 255, 255, 255, 255) --draw in middle of screen
--     SetDrawOrigin(scaleform.position.x, scaleform.position.y, scaleform.position.z, 0)
--     DrawSprite(txdName, txnName, 0.0, 0.0, 0.21, 0.55, 0.0, 255, 255, 255, 255)
--     ClearDrawOrigin()
-- end

-- local function cache3dScale(scale)
--     cachedSx = scalex * (scale or 1)
--     cachedSy = scaley * (scale or 1)
--     cachedSz = scalez * (scale or 1)
-- end

-- local function render_3d(scaleform)
--     DrawScaleformMovie_3dSolid(scaleform.sfHandle, scaleform.position.x, scaleform.position.y,
--         scaleform.position.z + 1, scaleform.rotation.x, scaleform.rotation.y, scaleform.rotation.z, 2.0, 2.0, 1.0,
--         cachedSx, cachedSy, cachedSz, 2)
-- end



-- CreateThread(function()
--     DUI:Create()
-- end)




-- CreateThread(function() 
--     while true do
--         Wait(0)
--         render_sprite(DUI.scaleform)
--         coords = GetEntityCoords(PlayerPedId())
--         --setPosition(DUI.scaleform.duiObject, coords.x, coords.y, coords.z + 2)
--     end

-- end)




-- Define resource and Dui URL
local thisResource = GetCurrentResourceName()
local duiUrl = ("nui://%s/html/dist/index.html"):format(thisResource)
local width, height = GetActiveScreenResolution()

-- Test coordinates for drawing the sprite
local testcoords = vector3(787.3417, -3006.6621, -68.9998)



-- Create a new Dui instance
local dui = lib.dui:new({
    url = duiUrl,
    width = width,
    height = height,
    debug = true
})

-- Set the Dui URL
dui:setUrl(duiUrl)

-- Get texture dictionary and texture name from Dui instance
local txdName, txnName = dui.dictName, dui.txtName

-- Function to draw the Dui sprite at specified coordinates
local function DrawDUI()
    SetDrawOrigin(testcoords.x, testcoords.y, testcoords.z, 0)
    DrawSprite(txdName, txnName, 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
    ClearDrawOrigin()
end

-- Create a thread to continuously draw the Dui sprite
CreateThread(function()
    while true do
        Wait(0)
        nearestvehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if nearestvehicle ~= 0 then
            testcoords = vector3(GetEntityCoords(nearestvehicle).x, GetEntityCoords(nearestvehicle).y, GetEntityCoords(nearestvehicle).z + 2)
        end
        DrawDUI()
    end
end)


local uivisible = false

-- Register a command to toggle the UI 
RegisterCommand('testdui', function()
    dui:sendMessage({
        type = "toggle-triangle",
        display = not uivisible
    })
    uivisible = not uivisible
end)

