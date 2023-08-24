

function love.load()
	
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( ) -- 800
	height = love.graphics.getHeight( ) -- 600

	
	numPoints = 7
	points = {}
	for i=1,numPoints do
		table.insert(points, {
		r = 0,
		theta = i* (2*math.pi/numPoints),
		offset = i/numPoints,
		size = 12
		})
	end
	frame = 0
	frameCap = 100
end


function love.update(dt)
	frame = (frame+1 < frameCap) and frame+1 or 0  --iterates frame every frame, resets to 0 when equal to frameCap

	for i,k in ipairs(points) do
		
		k.r = math.cos(2*math.pi* ((frame / frameCap) + k.offset/2) ) * 130
		k.size = 3 * (1+math.sin(2 * math.pi * ((frame / frameCap) + k.offset/2))) + 6
		k.theta = k.theta + 0.01
	end
end


function love.draw()

	--Polar Point output
	for i,k in ipairs(points) do
		love.graphics.circle( "fill", k.r * math.cos(k.theta) + width/2, k.r * math.sin(k.theta) + height/2, k.size)
	end
	
end