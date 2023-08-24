--3d pts 10/16/21
function love.load()
	love.window.setTitle("3d pts 10/15/21")
	particles = {}
	particles2 = {}
	math.randomseed(os.time())
	speed = 1
	rpressed = false
	dpressed = false
	xpressed = false
	
	displace = true
	
	welcome = false
	
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( ) -- 800
	height = love.graphics.getHeight( ) -- 600
	depth = 600
	
	maxLength = math.sqrt(width*width + depth*depth) /2
	global_disp = 0
	
	
	init1()
	
end

--[[

function init()
	particles = {}
	global_disp = 0
	displace = false
	for i=1,20 do 
		add_star(100+math.random(700),math.random(600),math.random(600))
	end
end

function add_star(x,y,z) -- function to generate particles
	tempx = x - width/2 -- x - 400
	tempz = z - depth/2 -- z - 300

	table.insert(particles,{
	x = x, --x position
	y = y, --y position
	z = z, --z position
	
	rad = math.atan(tempz/tempx), --radians
	l = math.sqrt(tempx*tempx + tempz*tempz)
	})
	
	
end

]]

function init()
	particles = {}
	global_disp = 0
	displace = false
	
	for i=1,100 do 
		add_star(math.random(maxLength), (math.random(100))%(math.pi*2), math.random(height))
	end
end

function init1()
	particles = {}
	global_disp = 0
	for i=1,20 do
		add_star(150,(math.pi*2)/20*i, height/2-200)
	end
	
	for i=1,20 do
		add_star(150,(math.pi*2)/20*i, height/2)
	end
	
	for i=1,20 do
		add_star(150,(math.pi*2)/20*i, height/2+200)
	end
end

function add_particle(x,y) -- function to generate particles
	table.insert(particles2,{
	x = x, --x position
	y = y, --y position
	vx = (math.random(200)-100)/100, --x velocity
	vy = -3, --y velocity - NEGATIVE IS UP
	life = 120, --ttl in frames
	})
end

function add_star(length, radians, y) -- function to generate particles
	table.insert(particles,{
	y = y, --y position
	
	rad = radians, --radians
	l = length, -- length
	
	dispy = math.random(100)/100-.5, -- displacement y
	--displ = math.random(100)/200
	})
end

function love.update(dt)

	
	--[[ --normal
	for i,k in pairs(particles) do
		k.rad = (k.rad + speed/100)%(2*math.pi)
	
	end
	]]
	
	if welcome then
		for i=1,10 do
			add_particle(width/2+40-8,height/2-8-200)
		end
		
		for i=1,10 do
			add_particle(width/2-8,height/2-8-200)
		end
	
		for i=1,10 do
			add_particle(width/2-40-8,height/2-8-200)
		end
	end
	
	--displacement
	for i,k in pairs(particles) do
		k.rad = (k.rad + speed/100)%(2*math.pi)
		
		if (global_disp>=0 or speed>1) and displace then
		global_disp = global_disp + speed
		k.y = k.y +k.dispy*speed
		k.l = k.l +.5*speed
		end
	end
	
	for i,k in pairs(particles2) do
		k.x = k.x + k.vx
		k.y = k.y + k.vy
		k.vy = k.vy + .2 --this constant is 'gravity' in pixels/second/second
		k.life = k.life-1
		
		if k.life<=0 then
			table.remove(particles2,i)
		end
	end
	
	
	if love.keyboard.isDown("right") then
		speed = speed-.2
	end
	
	if love.keyboard.isDown("left") then
		speed = speed+.2
	end
	
	if love.keyboard.isDown("up") then
		speed = 0
	end
	
	
	
	if love.keyboard.isDown("r") and rpressed == false then
		rpressed = true
		if love.keyboard.isDown("e") then
			init()
		else
			init1()
		end
	elseif love.keyboard.isDown('r')==false then
		rpressed = false
	end
	
	if love.keyboard.isDown("d") and dpressed == false then
		dpressed = true
		if displace then
			displace = false
		else
			displace = true
		end
	elseif love.keyboard.isDown('d')==false then
		dpressed = false
	end
	
	if love.keyboard.isDown("x") and xpressed == false then
		xpressed = true
		if welcome then
			welcome = false
		else
			welcome = true
		end
		

	elseif love.keyboard.isDown('x')==false then
		xpressed = false
	end
	
	
end

function love.draw() 
	--love.graphics.print(width, 0, 0)
	--love.graphics.print(depth, 0, 15)
	--k.l*math.sin(k.rad)+(depth/2)
	
	love.graphics.circle("fill",width/2,height/2,3)

	for i,k in ipairs(particles) do
		--love.graphics.print(k.l, 0, 0)
		--love.graphics.print(k.rad, 0, 15)
		
		--
		love.graphics.circle("fill",k.l*math.cos(k.rad)+(width/2),
		k.y - (k.l/maxLength)*math.sin(k.rad+math.pi)*100*(k.y/height-.5),
		4+(k.l/maxLength*3*math.sin(k.rad)))
		
		--[[
		love.graphics.line(k.l*math.cos(k.rad)+(width/2),
		k.y - (k.l/maxLength)*math.sin(k.rad+math.pi)*100*(k.y/height-.5), width/2, height/2)
		]]
	end
	
	if love.keyboard.isDown("c") then
		love.graphics.print("ta da", width/2-20, height/2+25)
	end
	
	for i,k in ipairs(particles2) do
		love.graphics.rectangle("fill", (k.x), (k.y), 16, 16)
	end
	
	

end

