Player = {}
Player.__index = Player

function Player.create()
	local player = {}
	setmetatable(player, Player)
	--
	player.x, player.y = 0, 0
	player.movespeed = 100
	return player
end

function Player:update(dt)
	if love.keyboard.isDown('right') then 
		self.x = self.x + (self.movespeed * dt) 
	end
	if love.keyboard.isDown('left') then 
		self.x = self.x - (self.movespeed * dt) 
	end
	if love.keyboard.isDown('down') then 
		self.y = self.y + (self.movespeed * dt) 
	end
	if love.keyboard.isDown('up') then 
		self.y = self.y - (self.movespeed * dt) 
	end
end

function Player:draw()
	love.graphics.setColor(171, 179, 202)
	love.graphics.rectangle('fill', self.x, self.y, 25, 25)
end