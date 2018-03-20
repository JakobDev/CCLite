if type(cclite) == "table" then
    if type(cclite.getConfig().debugrun) == "string" then
        term.clear()
        term.setCursorPos(1,1)
        local prog = cclite.getConfig().debugrun
        cclite.log("Running "..prog)
        cclite.setTitle(prog)
        if not shell.resolveProgram(prog) then
            printError('Program "'..prog..'" was not found')
            print("Press any key to continue")
            os.pullEvent("key")
        else
            shell.run(prog)
            print("Press any key to continue")
            os.pullEvent("key")
        end
        os.shutdown()
    elseif type(cclite.getConfig().run) == "string" then
        cclite.log("Running "..cclite.getConfig().run)
        shell.run(cclite.getConfig().run)
    end
    if fs.isDir("/rom/programs/cclite") == true then
        shell.setPath(shell.path()..":/rom/programs/cclite")
        if cclite.isFirstRun() == true then
            shell.run("/rom/programs/cclite/welcome.lua")
        end
    end
    if fs.isDir("/rom/programs/extra") == true then
        shell.setPath(shell.path()..":/rom/programs/extra")
    end
end
