function garage_helpNotifythread(marker)
    DrawHelpNotifythread("test")
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