--8/25/2023 Motes
numberOfMotes = 1000

maxSize = 7
minSize = 2

maxSpeedMultiplier = 1.5
minSpeedMultiplier = .8

maxOpacity = .3
minOpacity = .02

floatMovement = 10

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mote = {}

function newMote(x,y,z)
	local theta = math.random(100)/100 * math.pi
	table.insert(mote, {
		x = x,
		y = y,
		z = z,
		r = minSize + (maxSize-minSize) * z,
		vx = math.cos(theta) * floatMovement,
		vy = math.sin(theta) * floatMovement,
	})
end

for i=1,numberOfMotes do
  local x = math.random(0,width)
  local y = math.random(0,height)
  local z = math.random(0,100)/100
  newMote(x,y,z)
end

function updateMote(dt,speed)
	for i,k in ipairs(mote) do
		k.x = k.x + dt * speed * (minSpeedMultiplier + (maxSpeedMultiplier - minSpeedMultiplier) * k.z )
		
		if k.x < -k.r then k.x = k.x + width + 2 * k.r end
		if k.x > width + k.r then k.x = k.x - width - 2 * k.r end
		
		if k.y < -k.r then k.y = k.y + height + 2 * k.r end
		if k.y > height + k.r then k.y = k.y - height - 2 * k.r end
		
		k.x = k.x + k.vx * dt
		k.y = k.y + k.vy * dt
		
	end
end

function drawMote()
  love.graphics.setColor({1,1,1,.1})
	for i,k in ipairs(mote) do
		love.graphics.circle("fill",k.x,k.y,k.r)
	end
end