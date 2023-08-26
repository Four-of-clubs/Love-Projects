--Stars 10/15/21
function love.load()
	love.window.setTitle("Stars 10/15/21")
	particles = {}
	math.randomseed(os.time())
	speed = 1
	rpressed = false
	
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )
	height = love.graphics.getHeight( )

	for i=1,450 do
		add_star(math.random(width),math.random(height))
	end

	--don't mind this
	--[[
	ptList = {{x=0,y=10},{x=5,y=10},{x=10,y=10},{x=15,y=10},{x=20,y=10},{x=0,y=0},{x=0,y=5},{x=0,y=10},{x=0,y=15},{x=0,y=20},{x=0,y=0}}
	for i,k in ipairs(ptList) do
		add_star(k.x+300,k.y+300)
	end
	]]
end

function add_star(x,y) -- function to generate particles
	local t = (math.random(150)-75)/100 * math.abs(y-(height/2))/(height/2)
	table.insert(particles,{
	x = x, --x position
	y = y, --y position
	spd = t, 
	r = (t+1)*1.5,
	})
end

function love.update(dt)

	for i,k in pairs(particles) do
		k.x = (k.x - k.spd*speed)%width
	
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
		particles = {}
		for i=1,450 do
			add_star(math.random(width),math.random(height))
		end
	elseif love.keyboard.isDown('r')==false then
		rpressed = false
	end
	
end

function love.draw() 

	for i,k in ipairs(particles) do
		love.graphics.circle("fill",k.x,k.y,k.r)
	end

end


