--Show a Error, if CraftOS crash
function errorscreen(msg)
   api.term.setBackgroundColor(32768)
   api.term.clear()
   api.term.setTextColor(1)
   api.term.write("There is a error while running CraftOS")
   api.term.setCursorPos(1,2)
   api.term.setTextColor(16384)
   api.term.write(msg)
end
