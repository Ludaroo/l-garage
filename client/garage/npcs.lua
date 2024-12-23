NPCS = {}

function garage_npcs_createNPC(self)
    garagedata = self.data
    npcdata = garagedata.npc
    model = npcdata.model
    timeout = 10000
    lib.requestModel(model, timeout)

    if npcdata.onground then
        local foundGround, groundZ = GetGroundZFor_3dCoord(npcdata.coords.x, npcdata.coords.y, npcdata.coords.z, true)
        if foundGround then
            propercoordsz = groundZ
        end
    end
    npc = CreatePed(4, model, npcdata.coords.x, npcdata.coords.y, propercoordsz or npcdata.coords.z, npcdata.coords.w, false, false)

    SetEntityAsMissionEntity(npc, true, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedCombatAttributes(npc, 17, 1)
    SetPedCombatAttributes(npc, 46, 1)
    SetEntityInvincible(npc, true)
    Wait(500)
    FreezeEntityPosition(npc, true)


    NPCS[self] = npc
end


function garage_npcs_removeNPC(self)

    npc = NPCS[self]
    DeleteEntity(npc)
    model = self.data.npc.model
    SetModelAsNoLongerNeeded(model)
end


function garage_nocs_removeallNPCS()
    for k,v in pairs(NPCS) do
        DeleteEntity(v)
        SetModelAsNoLongerNeeded(v)
    end
end


AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        garage_nocs_removeallNPCS()
    end
end)