function garage_control_handleControl(self)

    if IsControlJustPressed(0, self.data.control) then
        if self.data.type == "public" then
            garage_public_openGarage(self)
        end
    end

end