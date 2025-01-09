function garage_helpNotifythread(data)
    coords = data.coords

    distance = #(coords - GetEntityCoords(PlayerPedId()))

    if not data.helpnotification then
        data.helpnotification = {text = "Press ~INPUT_CONTEXT~ to open the garage", distance = 1.5}
    end
    
    if distance < data.helpnotification.distance then 
        DrawHelpNotifythread("test")
    end
    
  
end

function DrawHelpNotifythread(msg)
    ESX.ShowHelpNotification('Hit ~INPUT_CONTEXT~ to do shit!')
end


function EnableHelpNotify(msg)
    lib.showTextUI(msg)
end

function DisableHelpNotify()
    lib.hideTextUI()
end