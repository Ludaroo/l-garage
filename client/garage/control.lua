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



-- TTODO: maybe add ox-lib addkeybinds here later? https://overextended.dev/ox_lib/Modules/AddKeybind/Client#ckeybind-class