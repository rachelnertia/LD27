--playerImage = love.graphics.newImage('player.png')
starImage = love.graphics.newImage('star.png')

Player = {}
Player.__index = Player

gPlayerColor = {r = 171, g = 179, b = 202}

function Player.create()
	local player = {}
	setmetatable(player, Player)
	--
	player.x = 0 
	player.y = 0
	player.w = scrWidth/25
	player.h = scrHeight/25
	player.xvel = 0
	player.yvel = 0
	player.movespeed = 1500
	player.canMove = true
	--player.trail = love.graphics.newParticleSystem(bubbleImage, 100)
	player:trailSetup()
	--player.trail:start()
	
	return player
end

function Player:update(dt)
	
	self:input()
	self:checkCollisions(dt)
	self:boundsCheck(dt)
	self.x = self.x + (self.xvel * dt)
	self.y = self.y + (self.yvel * dt)
	
	self.trail:setPosition(self.x + self.w/2, self.y + self.h/2)
	self.trail:start()
	self.trail:update(dt)
	
	
end

function Player:checkCollisions(dt)
	for i, v in ipairs(gBlocks) do
		if AABB((self.x+self.xvel*dt), (self.y+self.yvel*dt), self.w, self.h, v.x, v.y, v.w, v.h) then
			--handle collision
			if self.xvel > 0 then self.x = v.x - self.w
			elseif self.xvel < 0 then self.x = v.x + v.w
			elseif self.yvel > 0 then self.y = v.y - self.h
			elseif self.yvel < 0 then self.y = v.y + v.w
			end			
			
			self:stopMoving()
			love.audio.play(bumpSounds[math.random(1,#bumpSounds)])
		end
	end
	--
	for i, v in ipairs(gPickups) do
		if AABB(self.x, self.y, self.w, self.h,
			v.x, v.y, v.w, v.h) then
			-- handle collision
			if v.type == 'moretime' then
				gCounter = gCounter + v.value
				love.audio.play(timePickupSounds[math.random(1,#timePickupSounds)])
			elseif v.type == 'lesstime' then
				gCounter = gCounter - v.value
				love.audio.play(timePickupSounds[math.random(1,#timePickupSounds)])
			elseif v.type == 'score' then
				gScore = gScore + v.value
				love.audio.play(scorePickupSounds[math.random(1,#scorePickupSounds)])
			end
			table.remove(gPickups, i)
			--
			self:stopMoving()
		end
	end

end

function Player:boundsCheck(dt)
	if self.x + self.xvel*dt > scrWidth then 
		self.x = scrWidth - self.w 
		self:stopMoving()
	end
	if self.x + self.xvel*dt < 0 then 
		self.x = 0
		self:stopMoving()	
	end
	if self.y + self.yvel*dt > scrHeight then 
		self.y = scrHeight - self.h 
		self:stopMoving()
	end
	if self.y + self.yvel*dt < 0 then 
		self.y = 0 
		self:stopMoving()
	end
end

function Player:startMoving(dir)
	self.canMove = false
	--
	if dir == 'right' then
		self.xvel = self.movespeed
	elseif dir == 'left' then
		self.xvel = -self.movespeed
	elseif dir == 'down' then
		self.yvel = self.movespeed
	elseif dir == 'up' then
		self.yvel = -self.movespeed
	end
end

function Player:stopMoving()
	self.xvel = 0
	self.yvel = 0
	self.canMove = true
end

function Player:input()
	if self.canMove then
		if love.keyboard.isDown('right') then 
			self:startMoving('right')
		elseif love.keyboard.isDown('left') then 
			self:startMoving('left')
		elseif love.keyboard.isDown('down') then 
			self:startMoving('down')
		elseif love.keyboard.isDown('up') then 
			self:startMoving('up')
		end
	end
end

--function Player:checkCollisions

function Player:draw()
	--love.graphics.draw(playerImage, self.x, self.y)
	love.graphics.setColor(gPlayerColor.r, gPlayerColor.g, gPlayerColor.b)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	--
	love.graphics.draw(self.trail)
end

function Player:trailSetup()
	
	self.trail = love.graphics.newParticleSystem(starImage, 200)
	self.trail:setEmissionRate(20)
	self.trail:setLifetime(1)
	self.trail:setParticleLife(2)
	self.trail:setPosition(self.x, self.y)
	--self.trail:setDirection()
	self.trail:setSpread(5)
	self.trail:setSpeed(10, 30)
	self.trail:setRadialAcceleration(10)
	self.trail:setSizes(1)
	self.trail:setSizeVariation(0.5)
	self.trail:setColors(gPlayerColor.r,gPlayerColor.g,gPlayerColor.b, 128, gPlayerColor.r,gPlayerColor.g,gPlayerColor.b, 0)
	self.trail:stop()

end