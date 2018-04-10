local tPlugins = cclite.listPlugins()

if #tPlugins == 0 then
    print("No Plugins loaded")
    return
elseif #tPlugins == 1 then
    print("1 Plugin loaded:")
else
    print(#tPlugins.." Plugins loaded:")
end

textutils.pagedTabulate(tPlugins)
