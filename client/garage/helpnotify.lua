function garage_helpNotifythread(data)
    coords = data.coords

    distance = #(coords - GetEntityCoords(PlayerPedId()))
    data.helpnotification.distance = data.helpnotification.distance or 1.5
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