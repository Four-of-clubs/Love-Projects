--PFire 1/21/2023
function love.load()
	love.window.setTitle("PFire 1/21/2023")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	love.math.setRandomSeed(os.time())
	time = 0
	fireInstances = {}
	
	--I'm not sure if these next two funcions should be part of the Fire 'class', so right now they aren't. 
	function FireUpdateDriver(dt)	--this argument it's passing should be time in seconds since last love.update(dt) loop
		for i,k in ipairs(fireInstances) do
			k:createBase(k.x, k.y)
			--k:createSmoke(k.x, k.y)
			k:update(dt)
		end
	end
	
	function FireDisplayDriver()
		for i,k in ipairs(fireInstances) do
			k:display()
		end
	end
	
	--this is lua's idea of a class. You may notice it is an array. Yup. Think of it more like a template that we tie functions to.
	Fire = {
		x = 0,
		y = 0,
		base = {}, 
		smoke = {}, 
		color = {1,1,1}, 
		size = 20
	 }
	
	--I have barely any idea what this function does, but its a way to create instances of a "class" in lua
	--I shouldn't have to specify every value in the object like I have, but if I don't then it just references the origional class values
	-- not sure how to fix that..
	function Fire:new (x,y, color, size)
		local o = {}
		setmetatable(o, {__index = self}) 
		o.x = x
		o.y = y
		o.base = {}
		o.smoke = {}
		o.color = color or {1,1,1}
		o.size = size or 20
		
		table.insert(fireInstances, o)
		return o
	end
	
	colorList = {{1,.3,.2}, {1,.6,.2}, {.9,.9,.2}, {.3,1,.2}, {.3,.1,.7}, {.6,.1,.7}, {.8,.2,.6}}
	
	local offset = 2*math.pi/#colorList
	for i=1,#colorList do
		Fire:new(math.cos(offset*i)*300 + width/2,math.sin(offset*i)*300 + height/2,colorList[i], (5 * i)+10 )
	end
	
	--[[
	--creating a global instance of the class here. This might be bad practice, I'm not sure.
	fire1 = Fire:new(width/2, height/2, {.8,.2,.6}, 20)		--you can call this object by its name, but giving it a name is not necessary

	--creating a global instance of the class here. This might be bad practice, I'm not sure.
	Fire:new(300, 600, {1,.6,.7}, 50)
	]]
	
	--Creates a base particle (bright bit) of the fire -- stores it in the self.base array
	function Fire:createBase(x,y)
		factor = self.size
		table.insert(self.base, {
			x = x + (love.math.random(10)-5) * 3 * (factor/20),
			y = y + (love.math.random(10)-5) * 3 * (factor/20),
			vx = (love.math.random(10)-5) / 10 * (factor/20),
			vy = ((love.math.random(10)-5) / 10 - 1) * (factor/20),
			life = .8, --I am using actuall seconds here, rather than frames. Way to go me.
		})
	end
	
	--currently unused, I'll get to it
	function Fire:updateCoords(x,y)
		self.x = x
		self.y = y
	end
	
	function Fire:updateSize(size)
		self.size = size
	end
	
	--Creates a smoke particle (smoke bit) of the fire -- stores it in the self.smoke array
	function Fire:createSmoke(x,y)
		table.insert(self.smoke, {
			x = x + (love.math.random(10)-5) * 5 * (factor/20),
			y = y + (love.math.random(10)-5) * 2 * (factor/20),
			vx = (love.math.random(10)-5) / 10 * (factor/20),
			vy = ((love.math.random(10)-5) / 10 - 2) * (factor/20),
			life = .8, --I am using actuall seconds here, rather than frames. Way to go me.
		})
	end
	
	
	function Fire:update(dt)
		for i=#self.base,1,-1 do	--were deleting elements from this array sometimes, so iterating backwards avoids skipping issues
			k = self.base[i]
			
			k.x = k.x + k.vx
			k.y = k.y + k.vy
			k.life = k.life - dt
			if k.life<=0 then 
				table.remove(self.base, i)
			end
			if k.life<=.5 and k.life + dt > .5 then 
				self:createSmoke(k.x, k.y)
			end
		end
			
			for i=#self.smoke,1,-1 do --were deleting elements from this array sometimes, so iterating backwards avoids skipping issues
				k = self.smoke[i]
				
				k.x = k.x + k.vx
				k.y = k.y + k.vy
				k.life = k.life - dt
				if k.life<=0 then 
					table.remove(self.smoke, i)
				end
			end
	end
	
	function Fire:display()
		love.graphics.setColor(.3,.3,.3)
		for i,k in ipairs(self.smoke) do
			local displaySize = math.min(k.life*self.size*2, self.size)
			love.graphics.rectangle("fill", k.x - displaySize/2, k.y - displaySize/2, displaySize, displaySize)
			--love.graphics.circle("line", k.x, k.y, displaySize)
		end
		
		love.graphics.setColor(self.color)
		for i,k in ipairs(self.base) do
			local displaySize = math.min(k.life*self.size*2, self.size)
			love.graphics.rectangle("fill", k.x - displaySize/2, k.y - displaySize/2, displaySize, displaySize)
			--love.graphics.circle("line", k.x, k.y, displaySize)
		end
	
	end

end
speed = 1/4
function love.update(dt)
	FireUpdateDriver(dt)
	
if love.keyboard.isDown("right") then
	speed = speed + .01
end

if love.keyboard.isDown("left") then
	speed = speed - .01
end

if love.keyboard.isDown("up") then
	speed = 1/4
end
time = (time + dt * speed)
	offset = 2*math.pi/#colorList
	rotation = time
	--the logic for the spinning fire stuff
	for i,k in ipairs(fireInstances) do
		k:updateCoords(300 * math.cos(offset * i + rotation) + width/2, 300/2 * math.sin(offset * i + rotation ) + height/2)
		k:updateSize(((math.sin(offset * i + rotation ) +1)) * 10 + 10)
	end

end

function love.draw()
	red = 40/255
	green = 80/255
	blue = 20/255
	love.graphics.setBackgroundColor( 0, 0, 0)
	FireDisplayDriver()
end