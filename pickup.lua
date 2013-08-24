Pickup = {}
Pickup.__index = Pickup

function Pickup.create()
	local pickup = {}
	setmetatable(pickup, Pickup)
	--
	pickup.type = 'time'
	pickup.x = 0 
	pickup.y = 0
	pickup.w = 25
	pickup.h = 25
	pickup.xvel = 0
	pickup.yvel = 0
	pickup.movespeed = 500
	--
	return pickup
end

function Pickup:update(dt)
	-- move
	self.x = self.x + (self.xvel * dt)
	self.y = self.y + (self.yvel * dt)
end

function Pickup:draw()
	if self.type == 'time' then
		love.graphics.setColor(0x23, 0x33, 0x60)
	elseif self.type == 'score' then
		love.graphics.setColor(0xE6, 0xD6, 0x17)
	end
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end