local tContent = {}

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "What is CCLite"
tContent[count]["text"] = "CCLite is a ComputerCraft Emulator made with Love2d. ComputerCraft is a Mod for Minecraft, which brings programble Computers to your World. For more Information about Computercraft visit http://www.computercraft.info/."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Where are the Files saved"
tContent[count]["text"] = "CCLite saves his files at "..cclite.getSaveDirectory():gsub("\n","")..". The Config File is there. You can find the Files of this Computer in the data folder"

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Drop Files into the Computer"
tContent[count]["text"] = "You can drag and drop a file into the Computer. It will appear in the root Directory of the Computer.\n\nNote: This is not possible, if you installed CCLite with Snap, because Snaps are Sandboxed and don't have acces to the Filesystem."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Take Screenshots"
tContent[count]["text"] = "You can take a Screenshot with the ESC Key."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Use HTTPS"
tContent[count]["text"] = "You need to install LuaSec to use HTTPS. If you are using the Snap Version of CCLite, LuaSec is included."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Note for Android Users"
tContent[count]["text"] = "You can press the Undo Key to show the Keyboard.\n\nIt's not possible to use HTTPS on Android."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Set Config from the Commandline"
tContent[count]["text"] = "You can run CCLite with a special Config from the Commandline. The Syntax of the Args are \"--option=value\". e.g. \"cclite --id=1 --terminal_height=25\" will run CCLite with the changed Config. You can find alls Options in the Config File. Options who are no set from the Commandline will be taken from the Config File."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Use CCLite as Pocket Computer"
tContent[count]["text"] = "You can use CCLite as a Pcoket Computer by running it with the --pocket Argument."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Debugging with CCLIte"
tContent[count]["text"] = "CCLite offers 2 Arguments for helping debugging your Programs:\n--run=Program: Just run a Program with shell.run().\n--debugrun=Program: Run a Program and exit the Emulator after running it.\nYou can use this Arguments for adding a Run Button to your IDE."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Manage Peripherals"
tContent[count]["text"] = "You can use the built-in program \"perman\" to attach and detach Peripherals"

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Edit Files of other Computers"
tContent[count]["text"] = "You can mount the Filesystem of another Computer by running mount <id>. If you want to unmount the Filesystem run unmount <mountpath>"

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Use Plugins"
tContent[count]["text"] = "You can install Plugins by putting them into the Plugins Folder.\n\nIf you want to develop Plugins, take a look at the Wiki of the GitHub Page of CCLIte."

local count = #tContent+1
tContent[count] = {}
tContent[count]["titel"] = "Report Bugs/Left Feedback"
tContent[count]["text"] = "You can report Bugs or left Feedback on the GitHub Issues Page (https://github.com/Wilma456/CCLite/issues), in the Computercraft Forum Thread (http://www.computercraft.info/forums2/index.php?/topic/28773-wipcclite-for-craftos-18/) or you can write a Mail to wilma456@gmx.de."

local function showTextWindow(sText)
    term.clear()
    term.setCursorPos(1,1)
    print(sText)
    local w,h = term.getSize()
    term.setCursorPos(1,h)
    term.setBackgroundColor(colors.blue)
    term.clearLine()
    term.write("OK")
    while true do
        local ev,me,x,y = os.pullEvent()
        if ev == "mouse_click" and y == h then
            break
        end
    end
end

local function drawMenu()
    term.setBackgroundColor(colors.white)
    term.clear()
    term.setCursorPos(1,1)
    term.setBackgroundColor(colors.blue)
    term.clearLine()
    term.setTextColor(colors.black)
    term.write("Welcome to CCLite "..cclite.getVersion().."!")
    local w,h = term.getSize()
    term.setCursorPos(w,1)
    term.blit("X","f","e")
    term.setBackgroundColor(colors.white)
    for i=1,h-1 do
        if tContent[i] ~= nil then
            term.setCursorPos(1,i+1)
            term.write(tContent[i]["titel"])
        end
    end
end

drawMenu()

while true do
    local ev,me,x,y = os.pullEvent()
    local w,h = term.getSize()
    if ev == "mouse_click" then
        if y == 1 and x == w then
            break
        elseif tContent[y-1] ~= nil then
            showTextWindow(tContent[y-1]["text"])
            drawMenu()
        end
    end
end

term.setBackgroundColor(colors.black)
term.clear()
term.setTextColor(colors.yellow)
term.setCursorPos(1,1)
print(os.version())
term.setTextColor(colors.white)
