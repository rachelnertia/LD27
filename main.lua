-- LD27 GAME --
-- THEME: 10 SECNDS --

-- 'includes'
love.filesystem.load('player.lua')()
love.filesystem.load('pickup.lua')()
--

soundOn = true
gamePaused = false


function love.load()
	--
	math.randomseed(os.time())
	--
	love.graphics.setDefaultImageFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(107, 118, 148)
	--
	scrWidth = love.graphics.getWidth()
	scrHeight = love.graphics.getHeight()
	--
	gBlockWidth = scrWidth/20
	gBlockHeight = scrHeight/20
	--
	blockImage = love.graphics.newImage('block.png')
	-- load audio files
	scorePickupSounds = {}
	scorePickupSounds[1] = love.audio.newSource('scorepickup1.ogg', 'static')
	scorePickupSounds[2] = love.audio.newSource('scorepickup2.ogg', 'static')
	scorePickupSounds[3] = love.audio.newSource('scorepickup3.ogg', 'static')
	scorePickupSounds[4] = love.audio.newSource('scorepickup4.ogg', 'static')
	scorePickupSounds[5] = love.audio.newSource('scorepickup5.ogg', 'static')
	--
	timePickupSounds = {}
	timePickupSounds[1] = love.audio.newSource('timepickup1.ogg', 'static')
	--
	bumpSounds = {}
	bumpSounds[1] = love.audio.newSource('bump1.ogg', 'static')
	--
	tickSound = love.audio.newSource('tick1.ogg', 'static')
	--
	gPreviousScores = {}
	--
	
	--
	reset()
end

function love.update(dt)
	if not gameOver then
		if not gamePaused then 
			gSecondCounter = gSecondCounter + dt
			if gSecondCounter >= 1 then
				gSecondCounter = 0
				if soundOn then love.audio.play(tickSound) end
			end
			--
			player:update(dt)
			--
			for i, v in ipairs(gPickups) do
				v:update(dt)
				-- remove it if it goes out of bounds
				if v.x > scrWidth + v.w then table.remove(gPickups,i) end
				if v.x < -v.w then table.remove(gPickups,i) end
				if v.y > scrHeight + v.w then table.remove(gPickups,i) end
				if v.y < -v.h then table.remove(gPickups,i) end		
			end
			--
			gSpawnTimer = gSpawnTimer + dt
			--
			if gSpawnTimer >= gPickupWait then
				spawnPickup()
				gSpawnTimer = 0
			end
			--
			gCounter = gCounter - dt
			if gCounter <= 0 then
				gameOver = true
				gamePaused = false -- although really how could it be paused
				table.insert(gPreviousScores,1,gScore)
			end
		end
	end
end

function love.draw()
	for i, v in ipairs(gBlocks) do
		love.graphics.setColor(127, 138, 178)
		--love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
		love.graphics.draw(blockImage,v.x,v.y)
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
	--
	if gameOver then drawPreviousScores() end
end

function love.keypressed(key, unicode)
	if key == 'r' then
		reset()
	end
	if key == 'm' then
		soundOn = not soundOn
	end
	if key == 'p' then
		if not gameOver then
			gamePaused = not gamePaused
		end
	end
end

function reset()
	gPickupWait = 0.25
	gSecondCounter = 0
	--
	gScore = 0
	--
	gCounter = 10 
	gameOver = false
	gamePaused = false
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
	setupBlocks()
end

function setupBlocks()
	gBlocks = {}
	for i = 1, 30, 1 do
		gBlocks[i] = {}
		gBlocks[i].x = math.abs(math.random(0, (scrWidth/gBlockWidth))*gBlockWidth)
		gBlocks[i].y = math.abs(math.random(0, (scrHeight/gBlockHeight))*gBlockWidth)
		gBlocks[i].w = gBlockWidth
		gBlocks[i].h = gBlockHeight
	end
end

function drawDebug()
	love.graphics.print("FPS: " .. love.timer.getFPS()
		.. " delta: " .. love.timer.getDelta(), scrWidth-150, 0)
end

function drawInfo()
	love.graphics.setColor(0xFF, 0xB3, 0xCA)
	love.graphics.print("ARROW KEYS MOVE R RESETS M TOGGLES SOUND P PAUSES", 0, 0)
	if gamePaused then
		love.graphics.print("GAME PAUSED", scrWidth/2, scrHeight/2 - 20, 0, 2, 2)
	end
	if gameOver then
		love.graphics.print("GAME OVER", scrWidth/2, scrHeight/2 - 20, 0, 2, 2)
	end
	love.graphics.setColor(0x23, 0x33, 0x60)
	love.graphics.print(math.ceil(gCounter), scrWidth/2, scrHeight/2, 0, 2,2)
	love.graphics.setColor(0xE6, 0xD6, 0x17)
	love.graphics.print(gScore, scrWidth/2, scrHeight/2 + 20, 0, 2,2)
end

function drawPreviousScores()
	love.graphics.setColor(0xE6, 0xD6, 0x17)
	love.graphics.print('PREVIOUS SCORES', 0, 20)
	for i, v in ipairs(gPreviousScores) do
		love.graphics.print("-"..i.."    "..v, 0, 20+(20*i))
	end
	
end

-- spawn a new pickup (the things wot slide across the screen)
function spawnPickup()
	local new = Pickup.create()
	-- first, determine which side of the screen it should come from
	local edge = math.random(1,4)
	if edge == 1 then
		-- spawn on left
		new.x = -new.w
		new.y = math.random(0,scrHeight - new.h)
		new.xvel = new.movespeed
	elseif edge == 2 then
		--spawn on right
		new.x = scrWidth + new.w
		new.y = math.random(0,scrHeight - new.h)
		new.xvel = new.movespeed * -1
	elseif edge == 3 then
		--spawn on top
		new.x = math.random(0, scrWidth - new.w)
		new.y = -new.h
		new.yvel = new.movespeed
	elseif edge == 4 then
		--spawn on bottom
		new.x = math.random(0, scrWidth - new.w)
		new.y = scrHeight + new.h
		new.yvel = new.movespeed * -1
	end
	-- next, decide what type it should be
	-- 3/4 chance it'll be a score-pickup
	if math.random(1,4) < 4 then 
		new.type = 'score'
		-- score pickups base their value on the current time
		new.value = 100 + 100*math.floor(gCounter)
		-- for maximum-value score pickups, the player should aim to keep the counter at around 10 seconds
		if math.floor(gCounter) > 10 then
			new.value = 1000 - 100*math.floor(gCounter-10)
			-- but disallow negative score pickups
			if new.value < 100 then 
				new.value = 100 
			end
		end
		-- maximum value 900 (1000 doesn't fit on the box)
		if new.value > 900 then 
			new.value = 900 
		end
	else
		-- 1/4 chance it'll be a time pickup
		-- with a value between 1 and 10
		new.value = math.random(1,10)
		new.type = 'moretime'
		-- if the counter is above 10 then there's a high chance (3/4) that the game will spawn penalty time pickups instead
		if gCounter > 10 then
			if math.random(1,4) < 4 then
				new.type = 'lesstime'
			end
		end
	end
	-- finally, add it to the list
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