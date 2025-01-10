Data = {}
Data.debug = true
Data.Garages = {
    ["Mission Row"] = {
        control = 38,
        coords = vector4(214.0199, -808.6150, 31.0149, 69.4439),
        npc = {
            model = "s_m_y_cop_01",
            coords = vector4(213.6358, -809.9702, 31.0149, 354.2460),
            onground = true
        },
        marker = {
            coords = vector4(214.0199, -808.6150, 31.0149, 69.4439),
            color = {
                r = 0,
                g = 0,
                b = 255,
                a = 100
            },
            scale = vector3(1.0, 1.0, 1.0),
            type = 1
        },
        blip = {
            coords = vector4(223.0, -810.0, 30.0, 180.0),
            color = 38,
            scale = 0.8,
            name = "Mission Row Garage"
        },
        helpnotification = {
            text = "Press ~INPUT_CONTEXT~ to open the garage",
            distance = 1.5
        },
        type = "public",
        vehtype = "car",
        distance = 10.0,
        ipl = "import1"
    }
} -- this will later be in a config.json that can be edited ingame, no config.lua required yk? but for now its debugdata

Data.IPLS = {
    ["import1"] = {
        code = function()
            CreateThread(function()
                print("huh")
                -- Getting the object to interact with
                ImportCEOGarage1 = exports['bob74_ipl']:GetImportCEOGarage1Object()

                -- Loading Garage 2
                ImportCEOGarage1.Part.Clear() -- Removing all garages
                ImportCEOGarage1.Part.Load(ImportCEOGarage1.Part.Garage2) -- Loading only Garage 2

                -- Setting the garage's style
                ImportCEOGarage1.Style.Set(ImportCEOGarage1.Part.Garage2, ImportCEOGarage1.Style.plain)

                -- Numbering style
                ImportCEOGarage1.Numbering.Set(ImportCEOGarage1.Part.Garage2, ImportCEOGarage1.Numbering.Level1.style5)

                -- Lighting style + Refresh
                ImportCEOGarage1.Lighting.Set(ImportCEOGarage1.Part.Garage2, ImportCEOGarage1.Lighting.style3, true)

                -- Enabling ModShop
                ImportCEOGarage1.Part.Load(ImportCEOGarage1.Part.ModShop)
                -- with a custom floor + Refresh
                ImportCEOGarage1.ModShop.Floor.Set(ImportCEOGarage1.ModShop.Floor.seabed, true)
            end)
        end,

        coords = {
            exit = vector3(-191.0133, -579.1428, 135.0000),
            entrance = vector3(-191, -579, 135)
        },
        vehicles = {
            [1] = {
                coords = vector4(-179.7688, -571.4345, 135.5887, 159.0597),
                type = "car"
            },
            [2] = {
                coords = vector4(-185.2332, -572.1675, 136.0005, 190.4247),
                type = "car"
            },
            [3] = {
                coords = vector4(-172.5018, -575.9543, 136.0005, 132.9360),
                type = "car"
            }
        }
    },
    ["eclipseboulevard"] = {
        code = function()
            Citizen.CreateThread(function()
                -- Getting the object to interact with
                DrugWarsGarage = exports['bob74_ipl']:GetDrugWarsGarageObject()

                -- Disable the exterior
                DrugWarsGarage.Ipl.Exterior.Remove()

                -- Set the interior style
                DrugWarsGarage.Style.Set(DrugWarsGarage.Style.industrial, false)

                -- Set the color
                DrugWarsGarage.Tint.SetColor(DrugWarsGarage.Tint.purple, false)

                RefreshInterior(DrugWarsGarage.interiorId)
            end)
        end,
        vehicles = {
            max = 4,
            heading = 103.7544,
            margin = 2.0,
            DistanceBetweenVehicles = 5.0,
            poly = {
                points = {vec3(526.96997070312, -2636.1101074218, -49.0),
                          vec3(523.29998779296, -2636.1799316406, -49.0),
                          vec3(521.38000488282, -2608.4699707032, -49.0), vec3(528.0599975586, -2613.3400878906, -49.0)}
            },
            thickness = 4.0
        },
        coords = {
            exit = vector3(130.0, -707.0, 242.0),
            entrance = vector3(519.2477, -2618.788, -50.000)
        }
    }
}

Data.DebugCar = 'adder'
return Data
