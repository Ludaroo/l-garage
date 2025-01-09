
function garage_control_handleControl(self)

    if IsControlJustPressed(0, self.data.control) then
        if self.data.type == "public" then
            garage_public_openGarage(self)
        end
    end

end

function garage_public_openGarage(self)

   if self.data.ipl ~= nil or self.data.ipl ~= "" then
    teleportToIPL(self.data.ipl)
    end
  
end



-- TTODO: maybe add ox-lib addkeybinds here later? https://overextended.dev/ox_lib/Modules/AddKeybind/Client#ckeybind-class