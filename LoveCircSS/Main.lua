--Particles 3 11/13/21
--I have no idea what I am going to do with this project yet

--hold to expand, release to float?
function love.load()
	love.window.setTitle("Particles 3 11/13/2021")
	math.randomseed(os.time())
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( ) -- 800
	height = love.graphics.getHeight( ) -- 600

	bubbles = {}
	phybubs = {}
	love.graphics.setColor({1,1,1})

	x,y = love.mouse.getPosition()
	m1IsHeld = false
	m2IsHeld = false
	
	frame = 0

	for i=1,30 do
		add_bubble(math.random(width), math.random(height), math.random(50)+40)
	end
end

function add_bubble(x,y,r) -- generates bubble, only called after releasing
	table.insert(bubbles, {
	x = x,
	y = y,
	r = r,
	vy = 0,
	vx = 0,
	ax = 0,
	ay = 0,
	life = -1,
	selected = false,
	})
end

function bubble_act()

	for i,k in ipairs(bubbles) do
		
		k.vx = k.vx + k.ax
		k.vy = k.vy+ k.ay
		
		k.x = (k.x + k.vx)
		k.y = (k.y + k.vy)
		
		if (k.x<k.r or k.x>width-k.r) then
			if k.x<k.r then
				k.x = k.r
			else
				k.x = width-k.r
			end
			k.vx = k.vx*-1
		end
		
		if (k.y<k.r or k.y>height-k.r) then
			if k.y<k.r then
				k.y = k.r
			else
				k.y = height-k.r
			end
			k.vy = k.vy*-1
		end
		
		k.ax = -k.vx*.05
		k.ay = -k.vy*.05

		if k.life>0 then 
			k.life = k.life - 1
		elseif k.life == 0 then
			table.remove(bubbles,i)
		end
	end

--collision checking (with other bubbles)
	for i,k in ipairs(bubbles) do
		for l,j in ipairs(bubbles) do
			if i~=l then
				if (k.x-j.x)*(k.x-j.x) + (k.y-j.y)*(k.y-j.y) < (k.r+j.r)*(k.r+j.r) then
					hypot = math.sqrt((k.x-j.x)*(k.x-j.x) + (k.y-j.y)*(k.y-j.y))
					table.insert(phybubs, {k,j,hypot})
					displace = -.5*((k.r+j.r)-hypot)
					
					k.x = k.x - displace*(k.x-j.x)/hypot
					k.y = k.y - displace*(k.y-j.y)/hypot
					
					j.x = j.x + displace*(k.x-j.x)/hypot
					j.y = j.y + displace*(k.y-j.y)/hypot
					
					
					--[[
					--this is the start of trig mess (DOES NOT WORK)
					momentum = k.r*(math.sqrt(k.vx*k.vx+k.vy*k.vy)) + j.r*(math.sqrt(k.vx*j.vx+j.vy*j.vy))
					theta = math.atan(k.y-j.y/k.x-j.x)

					kvel = momentum/k.r
					k.vx = kvel*math.cos(theta)
					k.vy = kvel*math.sin(theta)
					
					jvel = momentum/j.r
					j.vx = -1*jvel*math.cos(theta)
					j.vy = -1*jvel*math.sin(theta)
					--this is the end of trig mess
					]]
				end
			end
		end
	end
	for i,k in ipairs(phybubs) do
		b1 = k[1] 
		b2 = k[2]
		--hypot = k[3]
		hypot = math.sqrt((b1.x-b2.x)*(b1.x-b2.x) + (b1.y-b2.y)*(b1.y-b2.y))
		
		mass1 = b1.r*10
		mass2 = b2.r*10
		
		normalx = (b1.x-b2.x)/hypot
		normaly = (b1.y-b2.y)/hypot
		
		tanx = normaly*-1
		tany = normalx
		
		--dot product tangent
		dpt1 = b1.vx*tanx + b1.vy*tany
		dpt2 = b2.vx*tanx + b2.vy*tany
		
		--dot product normal
		dpn1 = b1.vx*normalx + b1.vy*normaly
		dpn2 = b2.vx*normalx + b2.vy*normaly
		
		m1 = (dpn1 * (mass1-mass2) + 2*mass2*dpn2)/(mass1+mass2)
		m2 = (dpn2 * (mass2-mass1) + 2*mass1*dpn1)/(mass1+mass2)
		
		b1.vx = dpt1*tanx + m1*normalx
		b1.vy = dpt1*tany + m1*normaly
		b2.vx = dpt2*tanx + m2*normalx
		b2.vy = dpt2*tany + m2*normaly
	end
	phybubs = {}
end

function love.update(dt)
	--tempx, tempy = love.mouse.getPosition()
	--vx = x-tempx
	--vy = y-tempy
	x,y = love.mouse.getPosition()
	
	if love.mouse.isDown(1) and not love.mouse.isDown(2) then
	
		if not m1IsHeld then
			xrgn = x
			yrgn = y
			for i,k in ipairs(bubbles) do
				if ((x-k.x)*(x-k.x) + (y-k.y)*(y-k.y) < k.r*k.r) then
					k.selected = true
					xstart = k.x
					ystart = k.y
				end
			end
		end
		m1IsHeld = true
		
		for i,k in ipairs(bubbles) do
			if k.selected then
				k.x = xstart-(xrgn-x)
				k.y = ystart-(yrgn-y)
			end
		end
		
	elseif not love.mouse.isDown(1) and m1IsHeld then
		m1IsHeld = false
		for i,k in ipairs(bubbles) do
			k.selected = false
		end
	end
	
	
	if love.mouse.isDown(2) and not love.mouse.isDown(1) then
		if not m2IsHeld then
			for i,k in ipairs(bubbles) do
				if ((x-k.x)*(x-k.x) + (y-k.y)*(y-k.y) < k.r*k.r) then
					k.selected = true
					break
				end
			end
		end
		m2IsHeld = true
	
	elseif not love.mouse.isDown(2) and m2IsHeld then
		m2IsHeld = false
		for i,k in ipairs(bubbles) do
			if k.selected then
				k.vx = k.vx - (k.x-x)/5
				k.vy = k.vy - (k.y-y)/5
				k.selected = false
			end
		end
	end
	
	if frame==0 then
		bubbles[math.random(table.getn(bubbles))].selected = true
		xlaunch = (math.random(150)-75)
		ylaunch = (math.random(150)-75)
	elseif frame==60 then
		for i,k in ipairs(bubbles) do
			if k.selected then 
				k.vx = k.vx + xlaunch
				k.vy = k.vy + ylaunch
				k.selected = false
			end
		end
	end
	
	frame = (frame+1)%120
	
	
	bubble_act()
end

function love.draw()
--[[
	for i=0,height do
		love.graphics.setColor({1-(height-i)/height,0,(height-i)/height})
		love.graphics.line(0,i,width,i)
	end]]

	for i,k in ipairs(bubbles) do
		love.graphics.setColor({1,1,1})
		if k.selected then
			love.graphics.setColor({1,0,0})
			love.graphics.line(k.x,k.y,k.x+xlaunch*3,k.y+ylaunch*3)
			if m2IsHeld then
				love.graphics.line(k.x,k.y,x,y)
			end
			
		end
		love.graphics.circle("line", k.x, k.y, k.r)
	end

end