-- LD27 GAME --
-- THEME: 10 SECNDS --

love.filesystem.load('player.lua')()
love.filesystem.load('pickup.lua')()

function love.load()
	love.graphics.setBackgroundColor(107, 118, 148)
	scrWidth = love.graphics.getWidth()
	scrHeight = love.graphics.getHeight()
	-- counter for game time
	gCounter = 10 
	gameOver = false
	--
	player = Player.create()
	player.x = scrWidth/2
	player.y = scrHeight/2
	--
	gPickups = {}
	spawnPickup()
	--
end

function love.update(dt)
	player:update(dt)
	--
	for i, v in ipairs(gPickups) do
		v:update(dt)
	end
	--
	checkCollisions()
	--
	if gCounter <= 0 then
		gameOver = true
	end
	-- count down!
	gCounter = gCounter - dt
end

function love.draw()
	player:draw()
	--
	for i, v in ipairs(gPickups) do
		v:draw()
	end
	--
	love.graphics.setColor(0xAB, 0xB3, 0xCA)
	love.graphics.print("10 SCNDS IS A VRY LONG TIME", scrWidth/2, 0)
	love.graphics.print("TIME: " .. math.ceil(gCounter), scrWidth/2, 10)
	--
	drawDebug()
end

function drawDebug()
	love.graphics.print("FPS: " .. love.timer.getFPS()
		.. " delta: " .. love.timer.getDelta(), 0, 0)
end

function spawnPickup()
	local new = Pickup.create()
	table.insert(gPickups, new)
end

function checkCollisions()
	for i, v in ipairs(gPickups) do
		if AABB(player.x, player.y, player.w, player.h,
			v.x, v.y, v.w, v.h) then
			-- handle collision
			gCounter = gCounter + 5
		end
	end
end

-- check for collision of two rectangles
function AABB(x1, y1, w1, h1, x2, y2, w2, h2)
	if math.abs(x2 - x1) < (w1 + w2) then
		if math.abs(y2 - y1) < (h1 + h2) then
			return true
		end
	end
	return false
end