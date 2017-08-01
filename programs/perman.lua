local tPerList = cclite.listPeripheral()
local tNameList = {}
local tPosList = {}
local tScroolList = {}
tScroolList[1] = "None"
local nCount = 2
for k,v in pairs(tPerList) do
    table.insert(tScroolList,k)
    tNameList[v] = k
    tPosList[k] = nCount
    nCount = nCount + 1
end
local tSide = {}
table.insert(tSide,{"back",1})
table.insert(tSide,{"left",1})
table.insert(tSide,{"right",1})
table.insert(tSide,{"up",1})
table.insert(tSide,{"front",1})
table.insert(tSide,{"bottom",1})

term.clear()
for k,v in ipairs(tSide) do
   if peripheral.getType(v[1]) ~= nil then
        v[2] = tPosList[cclite.getPeripheralType(v[1])]
   end
   term.setCursorPos(1,k)
   term.write(v[1])
   term.setCursorPos(8,k)
   term.write(tScroolList[v[2]])
end


local nPos = 1
while true do
    term.setCursorPos(1,nPos)
    term.clearLine()
    term.write(tSide[nPos][1])
    term.setCursorPos(8,nPos)
    term.write("["..tScroolList[tSide[nPos][2]].."]")
    local ev,me = os.pullEvent("key")
    if me == keys.right then
        if tSide[nPos][2] == #tScroolList then
            tSide[nPos][2] = 1
        else
            tSide[nPos][2] = tSide[nPos][2] + 1
        end
    elseif me == keys.left then
        if tSide[nPos][2] == 1 then
            tSide[nPos][2] = #tScroolList
        else
            tSide[nPos][2] = tSide[nPos][2] - 1
        end
    elseif me == keys.down then
        term.setCursorPos(1,nPos)
        term.clearLine()
        term.write(tSide[nPos][1])
        term.setCursorPos(8,nPos)
        term.write(tScroolList[tSide[nPos][2]])
        if nPos == #tSide then
            nPos = 1
        else
            nPos = nPos + 1
        end
    elseif me == keys.up then
        term.setCursorPos(1,nPos)
        term.clearLine()
        term.write(tSide[nPos][1])
        term.setCursorPos(8,nPos)
        term.write(tScroolList[tSide[nPos][2]])
        if nPos == 1 then
            nPos = #tSide
        else
            nPos = nPos - 1
        end
    elseif me == keys.c then
        break
    elseif me == keys.enter then
        for k,v in ipairs(tSide) do
            if v[2] == 1 then
                pcall(function() cclite.peripheralDetach(v[1]) end)
            else
                pcall(function() cclite.peripheralDetach(v[1]) end)
                pcall(function() cclite.peripheralAttach(v[1],tScroolList[v[2]]) end)
            end
        end
        break
    end
end

term.clear()
term.setCursorPos(1,1)
