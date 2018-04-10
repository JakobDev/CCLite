local tArgs = {...}

if tArgs[1] == nil then
    print("Usage: mount <id>")
    return
end

local nID = math.floor(tonumber(tArgs[1]))

if nID == nil then
    print("ID must be a number")
    return
end

print("Mounted Filesystem of Computer "..nID.." at /"..cclite.mountDisk(nID))
