function framework_initFramework()
    if (GetResourceState("es_extended") == "started") then
        if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
            ESX = exports["es_extended"]:getSharedObject()
        else
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        end
    end

    if (GetResourceState("qb-core") == "started") then
        if (exports["qb-core"] and exports["qb-core"].GetCoreObject) then
            QBCore = exports["qb-core"]:GetCoreObject()
        end
    end
end

framework_initFramework()
