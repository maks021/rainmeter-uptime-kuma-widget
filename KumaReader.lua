function Initialize()
    path = SKIN:GetVariable('CURRENTPATH')
    txtFile = path .. 'kuma.txt'
    cache = 'Uptime Kuma...'
end

local function readFile()
    local f = io.open(txtFile, "r")
    if not f then
        return "Nema kuma.txt"
    end

    local content = f:read("*all")
    f:close()

    if not content or content == "" then
        return "Nema podataka"
    end

    return content
end

function Update()
    cache = readFile()
    return cache
end

function GetStringValue()
    return cache
end