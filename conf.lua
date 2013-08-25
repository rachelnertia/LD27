function love.conf(t)
	t.title = ""
	t.author = "Inertia"
	t.version = "0.8.0"
	t.console = false
	t.release = false
	--
	-- these should be the same
	t.screen.width = 600
	t.screen.height = 600
	
	t.fullscreen = false
	t.screen.vsync = false
	--
	t.modules.joystick = false
	t.modules.physics = false
	--
	
end