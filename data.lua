Data = {}
    Data.Garages = {   
        ["Mission Row"] = {
            control = 38,
            coords = vector4(214.0199, -808.6150, 31.0149, 69.4439),
            npc = {model = "s_m_y_cop_01", coords = vector4(213.6358, -809.9702, 31.0149, 354.2460), onground = true},
            marker = {coords = vector4(214.0199, -808.6150, 31.0149, 69.4439), color = {r = 0, g = 0, b = 255, a = 100}, scale = vector3(1.0, 1.0, 1.0), type = 1},
            blip = {coords = vector4(223.0, -810.0, 30.0, 180.0), color = 38, scale = 0.8, name = "Mission Row Garage"},
            helpnotification = {text = "Press ~INPUT_CONTEXT~ to open the garage", distance = 1.5},
            type = "public",
            vehtype = "car",
            distance = 10.0,
            ipl = "",
        }
    } -- this will later be in a config.json that can be edited ingame, no config.lua required yk? but for now its debugdata

    Data.IPLS = {
        [""]
    }

return Data