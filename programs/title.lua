local function printUsage()
    print( "Usages:" )
    print( "title get" )
    print( "title set <text>" )
end

local tArgs = { ... }
local sCommand = tArgs[1]
if sCommand == "get" then
    print( cclite.getTitle() )
elseif sCommand == "set" then
    if #tArgs == 1 then
        printUsage()
    elseif #tArgs == 2 then
        cclite.setTitle( tArgs[2] )
    end
else
    printUsage()
end
