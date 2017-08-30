term.clear()
term.setCursorPos(1,1)
write([[
Welcome to CCLite!
This is a ComputerCraft Emulator. For more Information about ComputerCraft visit http://www.computercraft.info/wiki.

The Save Directory of CCLite is ]]..cclite.getSaveDirectory():gsub("\n","")..[[ You can find the Config file there.

On Android you can press the Menu Key to show the Keyboard.

You can  make a Screenshot with the ESC Key.

You can manage Peripherals with the Built-In Program "perman"

Press any Key to continue
]])
os.pullEvent("key")
os.pullEvent("key_up")
term.clear()
term.setCursorPos(1,1)
term.setTextColour(colors.yellow)
print(os.version())
