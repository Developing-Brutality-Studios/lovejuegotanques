function newAnalog(Ax, Ay, Ar, Br, Bd)
	local self = {}
	self.cx = Ax or 200
	self.cy = Ay or love.graphics.getHeight() - 200
	--self.cy = Ay or 150 
	self.deadzone = Bd or 20/100 --Range from 0 to 1
	self.button = Br or 30
	self.size = Ar or 100
	self.angle = 0
	self.d = 0 --Range from 0 to 1
	
	self.dx = 0 --Range from 0 to 1
	self.dy = 0 --Range from 0 to 1
	
	self.held = false
	self.releasePos = 0
	self.releaseTimer = 0
	self.releaseSpeed = .2
	
	self.getAngle = function(cx, cy, x, y)
		local a = math.atan2(y-cy, x-cx)
		a = -a
		while a < 0 do
			a = a + math.pi*2
		end
		while a >= math.pi*2 do
			a = a - math.pi*2
		end
		
		return a
	end

	self.fade = function(currenttime, maxtime, c1, c2)
		local tp = currenttime/maxtime
		local ret = {} --return color

		for i = 1, #c1 do
			ret[i] = c1[i]+(c2[i]-c1[i])*tp
			ret[i] = math.max(ret[i], 0)
			ret[i] = math.min(ret[i], 255)
		end

		return unpack(ret)
	end
	
	self.distance = function(cx, cy, x, y)
		return math.sqrt( math.abs(x-cx)^2 + math.abs(y-cy)^2 )
	end
	
	self.renderGradient = function(size, c1, c2)
		local i = love.image.newImageData(size*2, size*2)
		for x = 0, size*2-1 do
			for y = 0, size*2-1 do
				local d = self.distance(size, size, x+1, y+1)
				local f = d/size
				f = math.max(0, f)
				i:setPixel(x, y, self.fade(f, 1, c1, c2))
			end
		end
		return love.graphics.newImage(i)
	end

	self.pokedStencil = function(cx, cy, d1, d2, s)
		for a = 0, s-1 do
			local p1x = math.cos(a/s*(math.pi*2))*d2
			local p1y = -math.sin(a/s*(math.pi*2))*d2
			
			local p2x = math.cos(a/s*(math.pi*2))*d1
			local p2y = -math.sin(a/s*(math.pi*2))*d1
			
			local p3x = math.cos((a+1)/s*(math.pi*2))*d1
			local p3y = -math.sin((a+1)/s*(math.pi*2))*d1
			
			local p4x = math.cos((a+1)/s*(math.pi*2))*d2
			local p4y = -math.sin((a+1)/s*(math.pi*2))*d2
			
			love.graphics.polygon("fill", cx+p1x, cy+p1y, cx+p2x, cy+p2y, cx+p3x, cy+p3y, cx+p4x, cy+p4y)
		end
	end
	
	self.gradientImage = self.renderGradient(self.size, {0, 205, 255, 155}, {255, 255, 255, 55})
	
	self.draw = function()
		--self screen
		local t = self
		love.graphics.setColor(255, 255, 255, 0.3)
		love.graphics.circle("line", t.cx, t.cy, t.size, 32)
		love.graphics.circle("line", t.cx, t.cy, t.deadzone*t.size, 32)
		
		love.graphics.stencil( function() self.pokedStencil(t.cx, t.cy, t.deadzone*t.size, t.size, 32) end)
		love.graphics.setColor(255, 255, 255, 0.3)
		love.graphics.draw(self.gradientImage, t.cx-t.size, t.cy-t.size)
		--love.graphics.stencil()
		
		local ax, ay = t.cx + math.cos(t.angle)*t.d*t.size, t.cy - math.sin(t.angle)*t.d*t.size
		love.graphics.stencil( function() love.graphics.circle("fill", ax, ay, t.button, 32) end )
		local l = love.graphics.getLineWidth()
		love.graphics.setLineWidth(12)
		love.graphics.setColor(0, 105, 155, 0.3)
		love.graphics.line(ax, ay, t.cx, t.cy)
		love.graphics.circle("fill", t.cx, t.cy, 12/2, 32)
		love.graphics.setLineWidth(l)
		--love.graphics.setInvertedStencil()
		
		love.graphics.setColor(0, 205, 255, 0.3)
		love.graphics.circle("fill", ax, ay, t.button, 32)
		love.graphics.setColor(0, 205, 255, 255)
		love.graphics.circle("line", ax, ay, t.button, 32)
	end

	self.update = function(dt)
		--Actual code
		
		--Restore self to center if not being held
		if self.releaseTimer > 0 then
			self.releaseTimer = math.max(0, self.releaseTimer-dt)
		end
		if self.held == false then
			self.d = math.max(0, self.releasePos*(self.releaseTimer/self.releaseSpeed) )
		end
	end

	self.touchPressed = function(id, x, y, pressure)
		local x, y = x*love.graphics.getWidth(), y*love.graphics.getHeight()
		if pressure > .5 then
			local d = self.distance(x, y, self.cx + math.cos(self.angle)*self.d*self.size, self.cy - math.sin(self.angle)*self.d*self.size)
			if d <= self.button then
				self.held = id
				self.touchMoved(id, x, y, pressure)
			end
		end
	end

	self.touchReleased = function(id, x, y, pressure)
		--local x, y = x*love.graphics.getWidth(), y*love.graphics.getHeight()
		--if pressure > .5 then
			if self.held == id then
				self.held = false
				self.releaseTimer = self.releaseSpeed
				self.releasePos = self.d
				self.dx = 0
				self.dy = 0
			end
		--end
	end

	self.touchMoved = function(id, x, y, pressure)
		local x, y = x*love.graphics.getWidth(), y*love.graphics.getHeight()
		if pressure > .5 then
			if self.held == id then
				local d = self.distance(x, y, self.cx, self.cy)
				self.d = math.min(1, d/self.size)
				self.angle = self.getAngle(self.cx, self.cy, x, y)
				if self.d >= self.deadzone then
					self.dx = math.cos(self.angle) * (self.d-self.deadzone)/(1-self.deadzone)
					self.dy = -math.sin(self.angle) * (self.d-self.deadzone)/(1-self.deadzone)
				else
					self.dx = 0
					self.dy = 0
				end
			end
		end
	end
	
	self.getX = function()
		return self.dx
	end
	
	self.getY = function()
		return self.dy
	end
	
	self.isHeld = function()
		return self.held
	end
	
	return self
end