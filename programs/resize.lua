local tArgs = {...}

if tArgs[1] == nil or tArgs[2] == nil then
    print("Usage: resize <x> <y>")
end

local x = tonumber(tArgs[1])
local y = tonumber(tArgs[2])

if x == nil or y == nil then
    print("x and y must be Numbers")
end

cclite.setScreenSize(x,y)
