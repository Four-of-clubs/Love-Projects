--Circles Pop 10/4/2022

function love.load()
	love.window.setTitle("Circles Pop 10/4/2022")
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


	for i=1,30 do
		add_bubble(math.random(width), math.random(height), math.random(60)+20)
	end
	
	frame = 0
	frameCount = 60
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
		--Gracity
		k.vy = k.vy + 1
	
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
					displace = -.5*((k.r+j.r)-hypot)
					table.insert(phybubs, {k,j,hypot+displace*2})
					
					k.x = k.x - displace*(k.x-j.x)/hypot
					k.y = k.y - displace*(k.y-j.y)/hypot
					
					j.x = j.x + displace*(k.x-j.x)/hypot
					j.y = j.y + displace*(k.y-j.y)/hypot
				end
			end
		end
	end
	
	--applies elastic physics using pairs found in collision check
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

function bubble_pop()
	for i,k in ipairs(bubbles) do
		if k.y > height - (k.r + 20) then
			k.vy = k.vy - (math.random(40)+20)
			k.vx = k.vx + math.random(10) - 5
		end
	end
end

function love.update(dt)
	--tempx, tempy = love.mouse.getPosition()
	--vx = x-tempx
	--vy = y-tempy
	
	bubble_act()
	
	
	function love.keypressed(key)
	
		if key == " " then
			bubble_pop()
		elseif key == "r" then --Creates new Circles
			bubbles = {}
			phybubs = {}
			for i=1,30 do
				add_bubble(math.random(width), math.random(height), math.random(60)+20)
			end
		end
	end
	
	frame = frameCount>frame+1 and frame + 1 or 0
	if frame==0 then bubble_pop() end
	
end


function love.draw() 
	for i,k in ipairs(bubbles) do
		love.graphics.setColor({1,1,1})
		if k.selected then
			love.graphics.setColor({1,0,0})
			if m2IsHeld then
				love.graphics.line(k.x,k.y,x,y)
			end
		end
		love.graphics.circle("line", k.x, k.y, k.r)
	end
end