--2 Point 9/24/22
function love.load()
	love.window.setTitle("2 Point 9/24/22")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 

	mp = width/2  --midpoint (x)
	
	speed = 3
		
	frame = 0
	frameCap = 100
	
	points = {}
	
	hLine(0,width,-100,144)
	hLine(0,width,-50,144)
	
	for i=0,12 do
		vLine(width/12 * i,-50,-100,6)
	end
	
	makeBuilding(0,300,100,300)
	makeBuilding(400, 220, 100, 80)
	makeBuilding(580, 450, 200, 300)
	makeBuilding(1080, 600, 200, 256)
	
	
end

function vLine(x, height1, height2, numPoints)	--vertical line
	num = numPoints~=0 and numPoints or math.abs(height1-height2)/30
	
	for i=0,num do
		table.insert(points, {
		x = x,							-- x position
		h = (height1-height2)/num * i + height2,			-- maximum height
		y = 0,							-- y position
		size = 2;						-- size
		})
	end
end

function hLine(x1, x2, height, numPoints) --horizontal line
	num = numPoints~=0 and numPoints or math.abs(x2-x1)/20
	for i=0,num do
		table.insert(points, {
		x = x1 + (x2-x1)/num * i,							-- x position
		h = height,			-- maximum height
		y = 0,							-- y position
		size = 2;						-- size
		})
	end
end

function makeBuilding(x, height, width1, width2)
	vLine(x,height,-20,0)
	vLine(x+width1,height,-20,0)
	vLine(x+width1+width2,height,-20,0)
	
	hLine(x, x+width1, height, 0)
	hLine(x+width1, x+width1+width2, height, 0)
end

function love.update(dt)
	frame = (frame+1 < frameCap) and frame+1 or 0  --iterates frame every frame, resets to 0 when equal to frameCap
	
	--speed controlls
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	if love.keyboard.isDown("right") then
		speed = speed + .1
	end
	if love.keyboard.isDown("left") then
		speed = speed - .1
	end
	if love.keyboard.isDown("up") then
		speed = 0
	end
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	
	--update point positions
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for i,k in ipairs(points) do
		k.x = k.x + speed
		if k.x >= width then
			k.x = k.x - width
		elseif k.x<=0 then
			k.x = k.x + width
		end
			
		if k.x<mp then
			k.y = k.h * (k.x/mp)
		else 
			k.y = k.h * (2 - (k.x/mp))
		end
	end
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end


function love.draw()

	--Polar Point output
	for i,k in ipairs(points) do
		--love.graphics.circle( "fill", k.x, 3*height/4  - k.y, k.size)
		love.graphics.line(k.x, 3*height/4  - k.y, mp, 3*height/4)
		--love.graphics.line(k.x, 3*height/4  - k.y, 0, 3*height/4)
		--love.graphics.line(k.x, 3*height/4  - k.y, width, 3*height/4)
	end
end