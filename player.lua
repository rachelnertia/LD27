playerImage = love.graphics.newImage('player.png')

Player = {}
Player.__index = Player

function Player.create()
	local player = {}
	setmetatable(player, Player)
	--
	player.x = 0 
	player.y = 0
	player.w = 25
	player.h = 25
	player.xvel = 0
	player.yvel = 0
	player.movespeed = 1000
	player.canMove = true
	return player
end

function Player:update(dt)
	
	self:input()

	self.x = self.x + (self.xvel * dt)
	self.y = self.y + (self.yvel * dt)
	
	self:boundsCheck()
	
end

function Player:boundsCheck()
	if self.x > scrWidth then 
		self.x = scrWidth - self.w 
		self:stopMoving()
	end
	if self.x < 0 then 
		self.x = 0
		self:stopMoving()	
	end
	if self.y > scrHeight then 
		self.y = scrHeight - self.h 
		self:stopMoving()
	end
	if self.y < 0 then 
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
	love.graphics.setColor(171, 179, 202)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end