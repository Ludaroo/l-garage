RegisterCommand("testdui", function(source, args, rawCommand)
    local dui = lib.dui:new({
        url = ("nui://%s/web/index.html"):format(cache.resource), 
        width = 1920, 
        height = 1080,
        debug = true
    })
    dui:setUrl("https://google.com")
 
end)

uishown = false 

RegisterCommand("testdui2", function(source, args, rawCommand)
    SetNuiFocus(not uishown, uishown)
    SetNuiFocusKeepInput(not uishown)
    SendNUIMessage({
        type = "publicgarage",
    })
end)