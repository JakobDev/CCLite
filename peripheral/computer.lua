local ID = 1
local function baseobj(sType)
	local obj = {}
	local myID = ID
	ID = ID + 1
	obj.type = sType
	function obj.getMethods() return {"turnOn", "shutdown", "reboot", "getID", "isOn"} end
	function obj.ccliteGetMethods() return {} end
	function obj.call(sMethod)
		if sMethod == "turnOn" then
		elseif sMethod == "shutdown" then
		elseif sMethod == "reboot" then
		elseif sMethod == "getID" then
			return myID
        elseif sMethod == "isOn" then
            return false
		end
	end
	return obj
end

function peripheral.base.computer() return baseobj("computer") end
function peripheral.base.turtle() return baseobj("turtle") end
peripheral.types.computer = "computer"
peripheral.types.turtle = "turtle"
