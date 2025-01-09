function garage_control_handleControl(self)

    if IsControlJustPressed(0, self.data.control) then
        if self.data.type == "public" then
            garage_public_openGarage(self)
        end
    end

end

function garage_public_openGarage(self)
    InfoPrint("Opening Garage")
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open'})
end


RegisterNUICallback("close", function(data, cb)
    InfoPrint("Closing Garage")
    SetNuiFocus(false, false)
    cb("ok")
end)
