-- LD27 GAME --
-- THEME: 10 SECNDS --

love.filesystem.load('player.lua')()
love.filesystem.load('pickup.lua')()

gPickupWait = 0.1
gPickupTimeValue = 2
gPickupScoreValue = 100

gBlockWidth = 30

function love.load()
	--math.randomseed(os.time())
	math.randomseed(os.time())
	--love.graphics.setColorMode('replace')
	love.graphics.setDefaultImageFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(107, 118, 148)
	scrWidth = love.graphics.getWidth()
	scrHeight = love.graphics.getHeight()
	
	--
	reset()
end

function love.update(dt)
	if not gameOver then
		player:update(dt)
		--
		for i, v in ipairs(gPickups) do
			v:update(dt)
			-- remove it if it goes out of bounds
			if v.x > scrWidth then table.remove(gPickups,i) end
			if v.x < -v.w then table.remove(gPickups,i) end
			if v.y > scrHeight then table.remove(gPickups,i) end
			if v.y < -v.h then table.remove(gPickups,i) end		
		end
		--
		--player:checkCollisions(dt)
		--
		if gCounter <= 0 then
			gameOver = true
		end
		-- count down!
		gCounter = gCounter - dt
		if gCounter < 0 then gameOver = true end
		gSpawnTimer = gSpawnTimer + dt
		--
		if gSpawnTimer >= gPickupWait then
			spawnPickup()
			gSpawnTimer = 0
		end
	end
end

function love.draw()
	for i, v in ipairs(gBlocks) do
		love.graphics.setColor(0xFF, 0xFF, 0xFF)
		love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
	end
	--
	for i, v in ipairs(gPickups) do
		v:draw()
	end
	--
	player:draw()
	--
	drawInfo()
	--
	drawDebug()
end

function love.keypressed(key, unicode)
	if key == 'r' then
		reset()
	end
end

function reset()
	--
	gScore = 0
	--
	gCounter = 10 
	gameOver = false
	--
	gSpawnTimer = 0
	--
	--
	player = Player.create()
	player.x = scrWidth/2
	player.y = scrHeight/2
	--
	gPickups = {}
	spawnPickup()
	--
	-- set obstacles
	gBlocks = {}
	for i = 1, 30, 1 do
		gBlocks[i] = {}
		gBlocks[i].x = math.abs(math.random(0, (scrWidth/gBlockWidth))*gBlockWidth)
		gBlocks[i].y = math.abs(math.random(0, (scrHeight/gBlockWidth))*gBlockWidth)
		gBlocks[i].w = gBlockWidth
		gBlocks[i].h = gBlockWidth
	end
end

function drawDebug()
	love.graphics.print("FPS: " .. love.timer.getFPS()
		.. " delta: " .. love.timer.getDelta(), scrWidth-150, 0)
end

function drawInfo()
	love.graphics.setColor(0xFF, 0xB3, 0xCA)
	love.graphics.print("ARROW KEYS MOVE R RESETS", 0, 0)
	love.graphics.setColor(0x23, 0x33, 0x60)
	love.graphics.print(math.ceil(gCounter), scrWidth/2, scrHeight/2, 0, 2,2)
	love.graphics.setColor(0xE6, 0xD6, 0x17)
	love.graphics.print(gScore, scrWidth/2, scrHeight/2 + 20, 0, 2,2)
end

function spawnPickup()
	local new = Pickup.create()
	local edge = math.random(0,3)
	if edge == 0 then
		-- spawn on left
		new.x = -new.w
		new.y = math.random(0,scrHeight - new.h)
		new.xvel = new.movespeed
	elseif edge == 1 then
		--spawn on right
		new.x = scrWidth + new.w
		new.y = math.random(0,scrHeight - new.h)
		new.xvel = -new.movespeed
	elseif edge == 2 then
		--spawn on top
		new.x = math.random(0, scrWidth - new.w)
		new.y = -new.h
		new.yvel = new.movespeed
	elseif edge == 3 then
		--spawn on bottom
		new.x = math.random(0, scrWidth - new.w)
		new.y = scrHeight + new.h
		new.yvel = -new.movespeed
	end
	if math.random(0,1) == 0 then 
		new.type = 'score'
		new.value = 100
	else
		new.type = 'time'
		new.value = math.random(1,2)
		
	end
	
	table.insert(gPickups, new)
end

-- check for collision of two rectangles
function AABB(x1, y1, w1, h1, x2, y2, w2, h2)
	if math.abs(x2 - x1) < (w1) then
		if math.abs(y2 - y1) < (h1) then
			return true
		end
	end
	return false
end