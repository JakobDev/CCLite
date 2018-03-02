_conf = {
	-- Enable the "http" API on Computers
	enableAPI_http = true,
	
	-- Enable the "cclite" API on Computers
	enableAPI_cclite = true,
	
    -- Enable the "pocket" API on Computers
    enableAPI_pocket = false,
    
    -- Give the Computer Access to the full API of Löve2d (only for debuging)
    enableAPI_love = true,

	-- The height of Computer screens, in characters
	terminal_height = 19,
	
	-- The width of Computer screens, in characters
	terminal_width = 51,
	
	-- The GUI scale of Computer screens
	terminal_guiScale = 2,
	
	-- Enable display of emulator FPS
	cclite_showFPS = false,
	
	-- The FPS to lock CCLite to
	lockfps = 20,
	
	-- Enable usage of Carrage Return for fs.writeLine
	useCRLF = false,
	
	-- Enable onscreen controls
	mobileMode = false,
	
    --The ID of the Computer
    id = 0,
    
    --Choose if the Computer is a Advanced Computer
    advanced = true,
    
    --Choose if the label shoulb be saved
    save_label = true,
    
    --Unrandomize
    unrandomize = false,
    
    --Choose, if /rom/programs/cclite should be mounted
    mount_programs = true,

    --Set the default settings of CraftOS
    CC_DEFAULT_SETTINGS="",
    
    --Change the Path of bios.lua
    biosPath="/lua/bios.lua",
    
    --Change the Mount Path of /rom
    romPath="/lua/rom",

	--Mappings for controlpad
	ctrlPad = {
		top = "w",
		bottom = "s",
		left = "a",
		right = "d",
		center = "return"
	}
}
