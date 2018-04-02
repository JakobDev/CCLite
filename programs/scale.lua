local tArgs = {...}

if tArgs[1] == nil then
    print("Usage: scale <scale>")
    return
end

local nScale = tonumber(tArgs[1])

if nScale == nil then
    print("Scale must be a number")
    return
end

cclite.setScale(nScale)
