--JpDots 3/15/2023
function love.load()
	love.window.setTitle("JpDots 3/15/2023")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	love.math.setRandomSeed(os.time())
	
	gravity = 980 --pixles per second per second
	jumpVelocity = 600 --pixels per second
	maxHeight = 1/2 * (jumpVelocity^2 / gravity) --this is slightly too high ??
	
	--using my base poinMasses file, these things dont actually have mass
	pointMasses = {
	}
	
	function newPointMass(x, y, base, color)
		table.insert(pointMasses, {
			x = x,
			y = y,
			base = base,
			vx = 0,
			vy = 0,
			color = color,
		})
	end
	
	function updatePointMasses(dt)
		for i,k in ipairs(pointMasses) do
			k.x = k.x + (k.vx * dt)
			k.y = k.y + (k.vy * dt)
			
			k.vy = k.vy + (gravity * dt)
			
			if k.y > height - k.base then
				k.y = height - k.base;
				--jump(k)
				if k.vy > 0 then k.vy = 0 end
			end
		end
	end

	function jump(pointMass)
		if pointMass.y >= height - pointMass.base then
			pointMass.vy = pointMass.vy - jumpVelocity
		end 
	end
	
	function displayPointMasses()
		for i,k in ipairs(pointMasses) do
			vividCoeficient = 1
			vividCoeficient = ((height-k.base-k.y) / maxHeight) 
			--newColor = {k.color[1], k.color[2], k.color[3] }
			love.graphics.setColor(k.color[1], k.color[2], k.color[3], vividCoeficient)
			--love.graphics.circle("fill", k.x, k.y, 5)
			love.graphics.rectangle("fill", k.x, k.y, 30, 30)
		end
	end
	
	function distanceFromPointMassToLine(pointmass, A, B, C) 
		return math.abs(A*pointmass.x + B * pointmass.y + C)/(math.sqrt(A^2 + B^2))
	end
	
	columnWidth = 50
	rowWidth = 50
	for i=(width*.1),width-(width*.1),columnWidth do
		for k=(height*.1),height-(height*.3),rowWidth do
			newPointMass(i, height-k, k, {i/width,0,k/height}) --{i/width,0,k/height}
		end
	end
	
	for i=0,20 do
		--newPointMass(width/2, -i*20, 100, {1,0,1})
	end
	
end

A = 1
B = 1
C = -100
Step = 10

baseJump = 0
baseJumpIterate = 10
function love.update(dt)
	updatePointMasses(dt)
	
	C = C - (B*Step)	--this is just batch stuff 
	if (-A * height - C) > width then C = 0 end
	for i,k in ipairs(pointMasses) do
		if distanceFromPointMassToLine(k,A,B,C) < Step then
			jump(k)
		end
	end
	
end

function love.draw()
	displayPointMasses()
	love.graphics.print(baseJump)
	--love.graphics.setColor(1,1,1)
	love.graphics.setColor({1,1,1})
	love.graphics.line((-A * height - C) / A, height, (-C), 0)
end