function love.load()
	love.window.setTitle("Circles gradient 11/21/2021")
	math.randomseed(os.time())
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( ) -- 800 (defualt)
	height = love.graphics.getHeight( ) -- 600 (defualt)
	
	circles = {}
	
	colorShift = 0
	longShift = 0
	
	speed = 1
	
	rIsPressed = false
	
	init()
	
end

function addCircle(x,y,r)
	table.insert(circles, {
	x = x,
	y = y,
	--vx = 0,
	--vy = 0,
	r = r,
	offSet = 1-x/width,
	})
end

function initR()
	circles = {}
	isColiding = false
	for i=0,50 do
		repeat
			isColiding = false
			x = math.random(width-100)+50
			y = math.random(height-100)+50
			r = math.random(20)+40
			for i,k in pairs(circles) do
				if ((k.x-x)*(k.x-x)+(k.y-y)*(k.y-y)) < (k.r+r)*(k.r+r)+10 then
					isColiding = true
				end
			end
		until(not isColiding)
		
		addCircle(x,y,r)
	end
end

function init()
	circles = {}
	r = 30
	for i=r,width,2*r+10 do
		for k=r,height,2*r+15 do
			addCircle(i,k,r)
		end
	end
end

function love.update(dt)
	
	if not love.keyboard.isDown("p") then
		colorShift = (colorShift+speed)%120
		cs = colorShift/60 --climbes from 0 to 2 every two seconds
		longShift = (longShift+speed)%720
		ls = longShift/360
		if ls>1 then
			ls = 2-ls
		end
		
	end
	
	if love.keyboard.isDown("r") and not rIsPressed then
		rIsPressed = true
		if love.keyboard.isDown("e") then
			init()
		else
			initR()
		end
	elseif not love.keyboard.isDown("r") and rIsPressed then
		rIsPressed = false
	end
	
	if love.keyboard.isDown("up") then
		speed = 1
	end
	
	if love.keyboard.isDown("right") then
		speed = speed +.1
	end
	
	if love.keyboard.isDown("left") then
		speed = speed - .1
	end
end

function love.draw()
	
	for i,k in pairs(circles) do
		--love.graphics.setColor({1,1,1})
		r = k.r - (ls)*8
		for j=-r,r do
			gradient = (1+j/r)/2+(math.sin((cs+k.offSet)*math.pi)+1)/2
			love.graphics.setColor({gradient/2+ls/2,0,gradient})
			length = 2*math.sqrt(r*r-j*j)
			love.graphics.rectangle("fill", k.x-length/2, k.y-j, length, 2)
		end
		
	end
end