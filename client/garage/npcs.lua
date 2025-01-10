NPCS = {}

--[[
    Creates an NPC for the garage.
    @param self: The object containing data for the NPC.
]]
function garage_npcs_createNPC(self)
    local garagedata = self.data
    local npcdata = garagedata.npc
    local model = npcdata.model
    local timeout = 10000
    lib.requestModel(model, timeout)

    local propercoordsz = npcdata.coords.z -- Default Z coordinate
    if npcdata.onground then
        local foundGround, groundZ = GetGroundZFor_3dCoord(npcdata.coords.x, npcdata.coords.y, npcdata.coords.z, true)
        if foundGround then
            propercoordsz = groundZ -- Adjust Z if ground is found
        end
    end

    -- Create the NPC ped
    local npc = CreatePed(4, model, npcdata.coords.x, npcdata.coords.y, propercoordsz, npcdata.coords.w, false, false)

    -- Set up NPC attributes
    SetEntityAsMissionEntity(npc, true, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedCombatAttributes(npc, 17, 1)
    SetPedCombatAttributes(npc, 46, 1)
    SetEntityInvincible(npc, true)
    
    -- Give the NPC some time to spawn
    Wait(500)
    FreezeEntityPosition(npc, true)

    -- Store the NPC in the global NPCS table
    NPCS[self] = npc
end

--[[
    Removes an NPC from the garage.
    @param self: The object containing data for the NPC.
]]
function garage_npcs_removeNPC(self)
    local npc = NPCS[self]
    if npc then
        DeleteEntity(npc)
        local model = self.data.npc.model
        SetModelAsNoLongerNeeded(model)
    end
end

--[[
    Removes all NPCs.
]]
function garage_npcs_removeAllNPCs()
    for _, npc in pairs(NPCS) do
        DeleteEntity(npc)
        SetModelAsNoLongerNeeded(GetEntityModel(npc))
    end
    NPCS = {} -- Clear the NPCs table after removal
end

-- Event handler for cleaning up when the resource stops
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        garage_npcs_removeAllNPCs()
    end
end)
