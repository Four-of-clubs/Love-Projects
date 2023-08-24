--Flip 4/10/2023
function love.load()
	love.window.setTitle("Flip 4/10/2023")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) --864
	love.math.setRandomSeed(os.time())
	time = 0
	
	shapes = {}
	
	function newShape(x, y, radius, numPoints, state)
		table.insert(shapes, {
			x = x,
			y = y,
			radius = radius,
			numPoints = numPoints,
			state = state,
			side = 1,
			colors = {{.8,.2,.3}, {.2,.7,.3}, {.2,.2,.7}}
		})
		return #shapes
	end


	function displayShape()
		for i,k in ipairs(shapes) do
			pointList = {}
			numberPoints = k.numPoints --+ (k.side-1) * 2
			for i=0,numberPoints do
				ofs = ((i+.5)/numberPoints)*(2*math.pi) + (3*math.pi/2)
				x = k.x + k.radius * math.cos(ofs)
				y = k.y + k.radius * math.sin(ofs)
				table.insert(pointList, {x=x,y=y})
			end
			
			temp = math.sin(( (k.state+50) /100)*math.pi)
			for f,d in ipairs(pointList) do
				distanceFromMidpoint = d.x - k.x
				d.x = k.x + distanceFromMidpoint * temp
			end
			
			
			love.graphics.setColor(k.colors[k.side])
			
			fillStep = 1
			for segment=1,(#pointList)/2 do
				a = pointList[segment]
				b = pointList[segment+1]
				for s=a.y,b.y,fillStep do
					c = {x = k.x, y = s}
					widthOfRec = (b.x - a.x) * (c.y-a.y) / (b.y - a.y) + (a.x - k.x)
					love.graphics.rectangle("fill", k.x - widthOfRec,c.y,2*widthOfRec,fillStep)
				end
			end
	
			for i=1,(#pointList-1) do
				pt1 = pointList[i]
				pt2 = pointList[i+1]
				love.graphics.line(pt1.x, pt1.y, pt2.x, pt2.y)
			end
			
		end
	end
	
	step = 1
	function flip(shape)
		shape.state = (shape.state + step) % 100
		
		if shape.state>=50 and shape.state<50+step then
			shape.side = shape.side + 1
			if shape.side > #(shape.colors) then shape.side = 1 end
		end
	end
	
	radius = 96/2
	numCorners = 6
	
	function generate() 
		for x=radius,width+radius,radius*2 do
			for y=radius,height+radius,radius*2 do
				--(y*x)/(width+radius*height+radius) * 100
				newShape(x,y,radius-1,numCorners,(y*x)/(width+radius*height+radius) * 100)
			end
		end
	end
	
	generate()
	
end

function love.update(dt)
	time = math.max(time - dt, 0)
	if love.keyboard.isDown('right') then
		if (time==0) then
			shapes = {}
			numCorners = numCorners + 1
			generate()
			time = .2
		end
	end
	
	if love.keyboard.isDown('left') then
		if (time==0) then
			shapes = {}
			numCorners = numCorners - 1
			generate()
			time = .2
		end
	end
	
	for i,k in ipairs(shapes) do
		flip(k)
	end
	
end

function love.draw()
	displayShape()
end