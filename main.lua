-- LD27 GAME --
-- THEME: 10 SECNDS --

love.filesystem.load('player.lua')()
love.filesystem.load('pickup.lua')()

gPickupWait = 0.25

gBlockWidth = 30

function love.load()
	--math.randomseed(os.time())
	math.randomseed(8372568)
	love.graphics.setBackgroundColor(107, 118, 148)
	scrWidth = love.graphics.getWidth()
	scrHeight = love.graphics.getHeight()
	--
	reset()
end

function love.update(dt)
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
	checkCollisions()
	--
	if gCounter <= 0 then
		gameOver = true
	end
	-- count down!
	gCounter = gCounter - dt
	gSpawnTimer = gSpawnTimer + dt
	--
	if gSpawnTimer >= gPickupWait then
		spawnPickup()
		gSpawnTimer = 0
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
	love.graphics.setColor(0xFF, 0xB3, 0xCA)
	love.graphics.print("10 SCNDS IS A VRY LONG TIME", scrWidth/2, 0)
	love.graphics.print("TIME: " .. math.ceil(gCounter), scrWidth/2, 10)
	love.graphics.print("SCORE: " .. gScore, scrWidth/2, 20)
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
	player = Player.create()
	player.x = scrWidth/2
	player.y = scrHeight/2
	--
	gPickups = {}
	spawnPickup()
	--
	-- set obstacles
	gBlocks = {}
	for i = 1, 20, 1 do
		gBlocks[i] = {}
		gBlocks[i].x = math.abs(math.random(1, (scrWidth/gBlockWidth)-1)*gBlockWidth)
		gBlocks[i].y = math.abs(math.random(1, (scrHeight/gBlockWidth)-1)*gBlockWidth)
		gBlocks[i].w = gBlockWidth
		gBlocks[i].h = gBlockWidth
	end
end

function drawDebug()
	love.graphics.print("FPS: " .. love.timer.getFPS()
		.. " delta: " .. love.timer.getDelta(), 0, 0)
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
	if math.random(0,1) == 1 then new.type = 'score' end
	
	table.insert(gPickups, new)
end

function checkCollisions()
	for i, v in ipairs(gBlocks) do
		if AABB(player.x, player.y, player.w, player.h,
			v.x, v.y, v.w, v.h) then
			-- handle collision
			player:stopMoving()
		end
	end
	--
	for i, v in ipairs(gPickups) do
		if AABB(player.x, player.y, player.w, player.h,
			v.x, v.y, v.w, v.h) then
			-- handle collision
			if v.type == 'time' then
				gCounter = gCounter + 5
			elseif v.type == 'score' then
				gScore = gScore + 100
			end
			table.remove(gPickups, i)
			--
			player:stopMoving()
		end
	end
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