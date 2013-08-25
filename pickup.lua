timePickupImage = love.graphics.newImage('timepickup.png')
timePickupQuads = {
	love.graphics.newQuad(0,0,25,25,250,25),
	love.graphics.newQuad(25,0,25,25,250,25),
	love.graphics.newQuad(50,0,25,25,250,25),
	love.graphics.newQuad(75,0,25,25,250,25),
	love.graphics.newQuad(100,0,25,25,250,25),
	love.graphics.newQuad(125,0,25,25,250,25),
	love.graphics.newQuad(150,0,25,25,250,25),
	love.graphics.newQuad(175,0,25,25,250,25),
	love.graphics.newQuad(200,0,25,25,250,25),
	love.graphics.newQuad(225,0,25,25,250,25)
}

Pickup = {}
Pickup.__index = Pickup

function Pickup.create()
	local pickup = {}
	setmetatable(pickup, Pickup)
	--
	pickup.type = 'time'
	pickup.value = 1
	pickup.x = 0 
	pickup.y = 0
	pickup.w = 25
	pickup.h = 25
	pickup.xvel = 0
	pickup.yvel = 0
	pickup.movespeed = 250
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
		--love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
		love.graphics.drawq(timePickupImage, timePickupQuads[self.value], self.x, self.y)
	elseif self.type == 'score' then
		love.graphics.setColor(0xE6, 0xD6, 0x17)
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	end
	
end