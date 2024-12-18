function debug(msg)
    if not msg then
        return
    end
    if type(msg) == "table" then
        for k, v in pairs(msg) do
            print(("^0[^3l-garage^0]^0 >> %s: %s"):format(k, v))
        end
    else
        print(("^0[^3l-garage^0]^0 >> %s"):format(msg))
    end
end

function debugWithColor(msg, color)
    if not msg then
        return
    end
    local colorCode = color or 0
    SetConsoleColor(colorCode)
    debug(msg)
    ResetConsoleColor()
end

debugWithColor(test, 3)
