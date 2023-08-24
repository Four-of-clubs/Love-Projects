--Falling 1/24/2022
--Difficulty to understand this program: I dunno like a 6/10? Its weird I guess.
function love.load()
	love.window.setTitle("Falling 1/24/2022")
	--love.window.setFullscreen(true)
	love.window.setMode( 500, 800)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	love.math.setRandomSeed(os.time())
	time = 0
	
	wallInstances = {}
	
	function wallUpdateDriver(dt)
		for i,k in ipairs(wallInstances) do
			k:update(dt)
		end
	end
	
	function wallDisplayDriver()
		for i,k in ipairs(wallInstances) do
			k:display()
		end
	end
	
	Wall = {
		xBase,
		left = true,
		size = 10,
		color = {1,1,1},
		speed = 10,		--how far the shapes move downwards, in pixels per second.
		coords = {}
	}
	
	
	function Wall:new(x,color,size, speed, left) 
		local o = {}
		setmetatable(o, {__index = self})
		o.xBase = x
		o.left = left
		o.size = size
		o.color = color
		o.speed = speed
		o.coords = {{y = 0, w = size, h = size}, }
		table.insert(wallInstances, o)
		return o
	end
	
	function Wall:update(dt)
		for i=#self.coords,1,-1 do
			local k = self.coords[i]
			k.y = k.y + self.speed * dt
			if k.y - k.h > height then
				table.remove(self.coords,i)
			end
		end
		if #self.coords== 0 then
			self:makeBlock(0)
		else
			local lastElement = self.coords[#self.coords]		--retrieves the last shape created
			if lastElement.y - lastElement.h > 0 then
				self:makeBlock(lastElement.y - lastElement.h)
			end
		end
	end
	
	function Wall:makeBlock(y)
		table.insert(self.coords, {
			y = y,
			w = math.random(self.size) +30,
			h = math.random(self.size) + 30
		})
	end
	
	function Wall:display()
		love.graphics.setColor(self.color)
		if self.left then
			for i,k in ipairs(self.coords) do
				love.graphics.rectangle("fill", 0, height - k.y, self.xBase + k.w, k.h)
			end
		else
			for i,k in ipairs(self.coords) do
				love.graphics.rectangle("fill", self.xBase - k.w, height - k.y, width - self.xBase + k.w, k.h)
			end
		end
	end
		
		--this can be called once at the creation of a wall instance to populate the coords array without waiting
		function Wall:fill()
			local firstElement = self.coords[1]
			local lastElement = self.coords[#self.coords]		--retrieves the last shape created
			while firstElement.y < height do
				for i,k in ipairs(self.coords) do
					k.y = k.y + lastElement.h
				end
				self:makeBlock(0)
				lastElement = self.coords[#self.coords]
			end
		end
		
	--Wall:new(x , color, size, speed, left)
	Wall:new(150, {.7,.7,.7}, 70, 150, true):fill()
	Wall:new(width-150, {.7,.7,.7}, 70, 150, false):fill()
	Wall:new(100, {.4,.4,.4}, 70, 300, true):fill()
	Wall:new(width-100, {.4,.4,.4}, 70, 300, false):fill()
	Wall:new(60, {.2,.2,.2}, 50, 500, true):fill()
	Wall:new(width-60, {.2,.2,.2}, 50, 500, false):fill()
	Wall:new(20, {0,0,0}, 20, 700, true):fill()
	Wall:new(width-20, {0,0,0}, 20, 700, false):fill()
	
end

speed = 1/4
function love.update(dt)
	time = (time + dt)
	wallUpdateDriver(dt)
end

function love.draw()
	love.graphics.setBackgroundColor( 1, 1, 1)
	wallDisplayDriver()
end