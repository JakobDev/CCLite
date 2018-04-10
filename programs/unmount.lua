local tArgs = {...}

if tArgs[1] == nil then
    print("Usage: unmount <path>")
    return
end

if not cclite.unmountDisk(tArgs[1]) then
    print("No Filesystem is mounted at "..tArgs[1])
end
