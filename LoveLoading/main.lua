function love.load()
	love.window.setTitle("Circles but not 5/13/2022")
	width = love.graphics.getWidth( ) -- 800
	height = love.graphics.getHeight( ) -- 600
	
	points = {}
	frames = 0
	fullTraversal = 120
	
	
	numPoints = 6
	for i=0,numPoints do
		addPoint(width/2, height/2, (i/numPoints/2) , (i/numPoints) * fullTraversal/2, 10, 120)
		addPoint(width/2, height/2, (i/numPoints/2) , (i/numPoints) * fullTraversal/2 + 20, 7, 80)
		addPoint(width/2, height/2, (i/numPoints/2) , (i/numPoints) * fullTraversal/2 + 40, 4, 40)
	end

end

function addPoint(x,y,tilt,offset, radius, size)
	table.insert(points, {
	originx = x,
	originy = y,
	x = x,
	y = y,
	t = tilt,
	ofs = offset,
	r = radius,
	s = size,
	})
end

function updatePoints(frames)
	--some way to do this with vektors? Dot product?
	for i,k in pairs(points) do
		distance = k.s* math.cos((frames + k.ofs)/fullTraversal * 2 * math.pi)	--distance from original position
		k.x = k.originx + distance * math.cos(k.t*2*math.pi)
		k.y = k.originy + distance * math.sin(k.t*2*math.pi)
	end
end

function love.update(dt)
	frames = frames + 1
	frames = frames % fullTraversal
	updatePoints(frames)
end

function love.draw()
	for i,k in pairs(points) do
		love.graphics.circle("fill", k.x, k.y, k.r)
		--love.graphics.line(k.originx + 120 * math.cos(k.t*2*math.pi), k.originy + 120 * math.sin(k.t*2*math.pi), 
			--k.originx - 120 * math.cos(k.t*2*math.pi), k.originy - 120 * math.sin(k.t*2*math.pi))
	end
	love.graphics.print(frames,10,10)
	
	
end