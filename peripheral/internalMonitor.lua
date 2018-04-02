function peripheral.base.internalMonitor()
	local obj = {}
	obj.type = "internalMonitor"
    local tMethods = {}
    local tMethodList = {}
    for k,v in pairs(api.term) do
        tMethods[k] = v
        table.insert(tMethodList,k)
    end
	function obj.getMethods() return tMethodList end
	function obj.ccliteGetMethods() return {} end
	function obj.call(sMethod, ...)
		return tMethods[sMethod](...)
	end
	function obj.ccliteCall(sMethod, ...)
	end
	return obj
end
peripheral.types.internalMonitor = "monitor"
