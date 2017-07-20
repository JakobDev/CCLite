function peripheral.base.speaker()
	local obj = {}
	obj.type = "speaker"
	function obj.getMethods() return {"playNote","playSound"} end
	function obj.ccliteGetMethods() return {} end
	function obj.call(sMethod, ...)
		local tArgs = {...}
		if sMethod == "playNote" then
			local sFile,nVolume,nPitch = unpack(tArgs)
            if type( sFile ) ~= "string" then
                error( "bad argument #1 (expected string, got " .. type( sFile ) .. ")", 2 ) 
            end
            if nVolume ~= nil and type( nVolume ) ~= "number" then
                error( "bad argument #2 (expected number, got " .. type( nVolume ) .. ")", 2 ) 
            end
            if nPitch ~= nil and type( nPitch ) ~= "number" then
                error( "bad argument #3 (expected number, got " .. type( nPitch ) .. ")", 2 ) 
            end
            if not love.filesystem.isFile( "/sound/note/"..sFile..".ogg" ) then
                error( 'Invalid instrument, "'..sFile..'"!', 2)
            end
            local note = love.audio.newSource("/sound/note/"..sFile..".ogg","static")
            if nVolume then
                note:setVolume(nVolume)
            end
            if nPitch then
                note:setPitch(nPitch)
            end
            note:play()
		end
        if sMethod == "playSound" then
			local sFile,nVolume,nPitch = unpack(tArgs)
            if type( sFile ) ~= "string" then
                error( "bad argument #1 (expected string, got " .. type( sFile ) .. ")", 2 ) 
            end
            if nVolume ~= nil and type( nVolume ) ~= "number" then
                error( "bad argument #2 (expected number, got " .. type( nVolume ) .. ")", 2 ) 
            end
            if nPitch ~= nil and type( nPitch ) ~= "number" then
                error( "bad argument #3 (expected number, got " .. type( nPitch ) .. ")", 2 ) 
            end
            if not love.filesystem.isFile( "/sound/other/"..sFile..".ogg" ) then
                error( 'Invalid instrument, "'..sFile..'"!', 2)
            end
            local note = love.audio.newSource("/sound/other/"..sFile..".ogg","static")
            if nVolume then
                note:setVolume(nVolume)
            end
            if nPitch then
                note:setPitch(nPitch)
            end
            note:play()
		end
	end
	function obj.ccliteCall(sMethod, ...)
	end
	return obj
end
peripheral.types.speaker = "speaker"
