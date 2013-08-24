-- LD27 GAME --
-- THEME: 10 SECNDS --

love.filesystem.load('player.lua')()

function love.load()
	-- counter for game time
	gCounter = 10 
	gameOver = false
	--
	player = Player.create()
	--
	love.graphics.setBackgroundColor(107, 118, 148)
	scrWidth = love.graphics.getWidth()
	scrHeight = love.graphics.getHeight()
end

function love.update(dt)
	player:update(dt)
	--
	if gCounter <= 0 then
		gameOver = true
	end
	-- count down!
	gCounter = gCounter - dt
end

function love.draw()
	player:draw()
	love.graphics.setColor(0xAB, 0xB3, 0xCA)
	love.graphics.print("10 SCNDS IS A VRY LONG TIME", scrWidth/2, 0)
	love.graphics.print("TIME: " .. math.ceil(gCounter), scrWidth/2, 10)
end