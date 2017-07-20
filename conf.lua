function love.conf(t)
	t.identity = "ccemu"
	t.console = false -- Enable this to see why you get emulator messages.
	t.window = false
	t.modules.audio = true
	t.modules.joystick = false
	t.modules.physics = false
	t.modules.sound = true
	t.modules.math = false
    t.version = "0.10.2"
end
