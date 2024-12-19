function DebugPrint(...)
    local args = {...}
    local str = ""
    local line = debug.getinfo(2).currentline
    local currentfunction = debug.getinfo(2).name
    for k,v in pairs(args) do
        if type(v) == "table" then
            str = DumpTable(v) .. "|"
        else
            str = tostring(v) .. "|"
        end
    end
    lib.print.debug(str, line, currentfunction)
end

function InfoPrint(...)
    local args = {...}
    local str = ""
    local line = debug.getinfo(2).currentline
    local currentfunction = debug.getinfo(2).name
    for k,v in pairs(args) do
        if type(v) == "table" then
            str = DumpTable(v) .. "|"
        else
            str = tostring(v) .. "|"
        end
    end
    lib.print.info(str, line, currentfunction)
end

function WarnPrint(...)
    local args = {...}
    local str = ""
    local line = debug.getinfo(2).currentline
    local currentfunction = debug.getinfo(2).name
    for k,v in pairs(args) do
        if type(v) == "table" then
            str = DumpTable(v) .. "|"
        else
            str = tostring(v) .. "|"
        end
    end
    lib.print.warn(str, line, currentfunction)
end


function VerbosePrint(...)
    local args = {...}
    local str = ""
    local line = debug.getinfo(2).currentline
    local currentfunction = debug.getinfo(2).name
    for k,v in pairs(args) do
        if type(v) == "table" then
            str = DumpTable(v) .. "|"
        else
            str = tostring(v) .. "|"
        end
    end
    lib.print.verbose(str, line, currentfunction)
end



function DumpTable(table, indent, printDump)
    indent = indent or 0
    local indentStr = string.rep("  ", indent)
    local result = ""

    for k, v in pairs(table) do
        if type(v) == "table" then
            result = result .. indentStr .. tostring(k) .. ":\n"
            result = result .. DumpTable(v, indent + 1)
        else
            result = result .. indentStr .. tostring(k) .. ": " .. tostring(v) .. "\n"
        end
    end

    if printDump == nil then
        return result
    else
        print(result)
    end
end
