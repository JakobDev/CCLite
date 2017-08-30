--This File is started in the VM to load the Bios and print the error if failed
local nativeboot = boot
boot = nil

local function write( sText )
    local w,h = term.getSize()
    for i = 1, #sText do
        term.write(sText:sub(i,i))       
        local x,y = term.getCursorPos()
        if x == w+1 then
            term.setCursorPos(1,y+1)
        end
    end
end

local function noBios()
    term.setBackgroundColor(32768)
    term.clear()
    term.setTextColor(1)
    term.setCursorPos(1,1)
    write(nativeboot.biosPath().." was not found")
    nativeboot.log(nativeboot.biosPath().." was not found")
    coroutine.yield("key")
    os.shutdown()
end

local function displayError(sText)
    term.setBackgroundColor(32768)
    term.clear()
    term.setTextColor(1)
    term.setCursorPos(1,1)
    write("There is a error while running CraftOS")
    local x,y = term.getCursorPos()
    term.setCursorPos(1,y+1)
    term.setTextColor(16384)
    write(sText)
    nativeboot.log(sText)
    coroutine.yield("key")
    os.shutdown()
end

local bios = nativeboot.getBios()
getBios = nil
if bios == nil then
    noBios()
end
local fn, err = loadstring(bios,"@bios")
if not fn then
    displayError(err:sub(14))
end
local ok,err = pcall(fn)
if not ok then
    displayError(err)
end

