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
end