HttpRequest = {}
HttpRequest.threads = {}
HttpRequest.activeRequests = {}

local function newThread()

end

function HttpRequest.new()
	local self = {}

	local httpParams = {}
	httpParams.headers = {}

	self.onReadyStateChange = function() end
	self.responseText = ""

	-- Locate or create a free thread
	local foundThread = false
	for i = 1,#HttpRequest.threads do
		if HttpRequest.threads[i].status == 0 then
			self.threadObj = HttpRequest.threads[i]
			self.threadObj.status = 1
			foundThread = true
			break
		end
	end
	if foundThread == false then
		self.threadObj = {}
		self.threadObj.thread = love.thread.newThread("http/HttpRequest_thread.lua")
		self.threadObj.channel = love.thread.newChannel()
		self.threadObj.thread:start(self.threadObj.channel,_conf.useLuaSec)
		self.threadObj.status = 1
		table.insert(HttpRequest.threads,self.threadObj)
	end

	self.open = function(pMethod, pUrl)
		httpParams.method = pMethod or "GET"
		httpParams.url = pUrl
	end
	---------------------------------------------------------------------
	self.send = function(pString)
		httpParams.body = pString or ""
		
		self.threadObj.channel:supply(TSerial.pack(httpParams))
		self.threadObj.status = 2
	end
	---------------------------------------------------------------------
	self.setRequestHeader = function(pName, pValue)
		httpParams.headers[pName] = pValue
	end
	---------------------------------------------------------------------
	self.checkRequest = function()
		-- Look for async thread response message
		if self.threadObj.channel and self.threadObj.channel:getCount() > 0 then
			-- Unpack message
			result = TSerial.unpack(self.threadObj.channel:pop())

			self.threadObj.channel:clear()

			-- Set status
			self.status = result[2]
			-- Set responseText
			self.responseText = result[5]

			-- Remove request from activeRequests
			for i = 1, #HttpRequest.activeRequests do
				if HttpRequest.activeRequests[i] == self then
					table.remove(HttpRequest.activeRequests, i)
					break
				end
			end

			-- Mark thread as avaliable again
			self.threadObj.status = 0
			
			-- Finally call onReadyStateChange callback
			self.onReadyStateChange()
		end

		if self.threadObj.thread:isRunning() == false then
			print(self.threadObj.thread:getError())

			-- Remove request from activeRequests
			for i = 1, #HttpRequest.activeRequests do
				if HttpRequest.activeRequests[i] == self then
					table.remove(HttpRequest.activeRequests, i)
					break
				end
			end
			
			-- Remove dead thread from avaliable threads
			for i = 1, #HttpRequest.threads do
				if HttpRequest.threads[i] == self.threadObj then
					table.remove(HttpRequest.threads, i)
					break
				end
			end
			
			-- Finally call onReadyStateChange callback
			self.onReadyStateChange()
		end
	end
	---------------------------------------------------------------------

	table.insert(HttpRequest.activeRequests, self)
	return self
end


function HttpRequest.checkRequests()
	for k, v in ipairs(HttpRequest.activeRequests) do
		if HttpRequest.activeRequests[k] ~= nil then
			HttpRequest.activeRequests[k].checkRequest()
		end
	end
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- TSerial v1.23, a simple table serializer which turns tables into Lua script
-- by Taehl (SelfMadeSpirit@gmail.com)

-- Usage: table = TSerial.unpack( TSerial.pack(table) )
TSerial = {}
function TSerial.pack(t)
	assert(type(t) == "table", "Can only TSerial.pack tables.")
	local s = "{"
	for k, v in pairs(t) do
		local tk, tv = type(k), type(v)
		if tk == "boolean" then k = k and "[true]" or "[false]"
		elseif tk == "string" then if string.find(k, "[%c%p%s]") then k = '["'..k..'"]' end
		elseif tk == "number" then k = "["..k.."]"
		elseif tk == "table" then k = "["..TSerial.pack(k).."]"
		else error("Attempted to Tserialize a table with an invalid key: "..tostring(k))
		end
		if tv == "boolean" then v = v and "true" or "false"
		elseif tv == "string" then v = string.format("%q", v)
		elseif tv == "number" then  -- no change needed
		elseif tv == "table" then v = TSerial.pack(v)
		else error("Attempted to Tserialize a table with an invalid value: "..tostring(v))
		end
		s = s..k.."="..v..","
	end
	return s.."}"
end

function TSerial.unpack(s)
	assert(type(s) == "string", "TSerial.unpack: string expected, got " .. type(s))
	return assert(loadstring("return "..s))()
end
