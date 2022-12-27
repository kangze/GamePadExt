local _,Addon=...;

local split = function(str, sep)
    if str == nil or str == "" or sep == nil or sep == "" then
        return nil, "string and delimiter should NOT be empty"
    end

    local pattern = sep:gsub("[().%+-*?[^$]", "%%%1")
    local result = {}
    while str:len() > 0 do
        local pstart, pend = string.find(str, pattern)
        if pstart and pend then
            if pstart > 1 then
                local subcnt = str:sub(1, pstart - 1)
                table.insert(result, subcnt)
            end
            str = str:sub(pend + 1, -1)
        else
            table.insert(result, str)
            break
        end
    end
    return result
end

string.split=split;