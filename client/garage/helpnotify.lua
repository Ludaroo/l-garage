--[[
    garage_helpNotifyThread: Handles the display of help notifications based on player proximity to a point.
    @param data: Table containing coordinates and help notification details.
    
    drawHelpNotificationThread: Displays a help notification in a thread.
    @param msg: The message to display.
    
    enableHelpNotification: Enables the help notification.
    @param msg: The message to display.
    
    disableHelpNotification: Disables the help notification.
]]

local useThreadHelpNotification = false -- Change this if you use a help notification that is not a thread
local helpnotificationvisible = false

--[[
    Handles the display of help notifications based on player proximity to a point.
    @param data: Table containing coordinates and help notification details.
]]
function garage_helpNotifyThread(data)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(data.coords - playerCoords)

    if not data.helpnotification then
        data.helpnotification = {text = "Press ~INPUT_CONTEXT~ to open the garage", distance = 1.5}
    end

    if distance < data.helpnotification.distance then
        if useThreadHelpNotification then  
            drawHelpNotificationThread(data.helpnotification.text)
        else
            if not helpnotificationvisible then
                enableHelpNotification(data.helpnotification.text)
                helpnotificationvisible = true
            end
        end
    else
        if not useThreadHelpNotification and helpnotificationvisible then
            disableHelpNotification()
            helpnotificationvisible = false
        end
    end
end

--[[
    Displays a help notification in a thread.
    @param msg: The message to display.
]]
function drawHelpNotificationThread(msg)
    ESX.ShowHelpNotification(msg)
end

--[[
    Enables the help notification.
    @param msg: The message to display.
]]
function enableHelpNotification(msg)
    lib.showTextUI(msg)
end

--[[
    Disables the help notification.
]]
function disableHelpNotification()
    lib.hideTextUI()
end

-- Disabling help notification when script stops to prevent it from staying on screen.
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if not useThreadHelpNotification and helpnotificationvisible then
            disableHelpNotification()
        end
    end
end)