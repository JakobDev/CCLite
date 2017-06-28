if type(cclite) == "table" then
    if type(cclite.getConfig().debugrun) == "string" then
        term.clear()
        term.setCursorPos(1,1)
        cclite.log("Running "..cclite.getConfig().debugrun)
        cclite.setTitle(cclite.getConfig().debugrun)
        shell.run(cclite.getConfig().debugrun)
        os.shutdown()
    elseif type(cclite.getConfig().run) == "string" then
        cclite.log("Running "..cclite.getConfig().run)
        shell.run(cclite.getConfig().run)
    end
end
shell.setPath(shell.path()..":/rom/programs/cclite")
