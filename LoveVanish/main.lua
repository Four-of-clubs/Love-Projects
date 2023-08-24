--vanishing point 10/21/21
function love.load()
	love.window.setTitle("vanishing point 10/21/21")
	particles = {}
	
	love.window.setMode(600, 600)
	width = love.graphics.getWidth( ) -- 600
	height = love.graphics.getHeight( ) -- 600
	depth = 600
	
	xoffset = 0
	yoffset = 0
	zoffset = 0
	speed = 5
	rspeed = math.pi*2/480
	
	pt_distance = 50
	
	init()
end


function init()
	particles = {}
	for x=15,width,pt_distance do
		for y=15,height,pt_distance do
			for z=15,depth*.8,pt_distance do
				add_point(x-(width/2),y-(height/2),z)
			end
		end
	end
end

function init_random()
	particles = {}
	for i=1,1000 do
		add_point(math.floor(math.random(600)-300),math.floor(math.random(600)-300),math.floor(math.random(600)))
	end

end


function add_point(x,y,z)
	table.insert(particles, {
	x=x,
	y=y,
	z=z,
	})
end

function love.update(dt)

	if love.keyboard.isDown("right") then
		xoffset = xoffset + speed
	end
	
	if love.keyboard.isDown("left") then
		xoffset = xoffset - speed
	end
	
	if love.keyboard.isDown("up") then
		yoffset = yoffset - speed
	end
	
	if love.keyboard.isDown("down") then
		yoffset = yoffset + speed
	end

	if love.keyboard.isDown("x") then
		zoffset = zoffset + speed
	end
	
	if love.keyboard.isDown("c") then
		zoffset = zoffset - speed
	end
	
	--[[
	if love.keyboard.isDown("s") then
		for i,k in ipairs(particles) do
			theta = math.atan(k.z/k.x)
			
			k.x = math.cos(theta+rspeed)*(math.sqrt(k.x*k.x+k.z*k.z))
		end
	end
	
	if love.keyboard.isDown("d") then
		for i,k in ipairs(particles) do
			k.x = math.cos(rspeed)*k.x-math.sin(rspeed)*k.y-k.x
		end
	end
	]]
	
end

function love.draw()
	love.graphics.print(love.timer.getFPS( ),0,0)
	
	for i,k in ipairs(particles) do
		--zscale = (((depth)-(k.z))/(depth+zoffset))--this is wrong and idk how to fix it...
		zscale = (depth-k.z+300)/(depth+zoffset)
		if (k.z+zoffset>0) then
			--love.graphics.points((xoffset+k.x)*zscale +(width/2), (yoffset+k.y)*zscale +(height/2))
			love.graphics.circle("fill",(xoffset+k.x)*zscale +(width/2), (yoffset+k.y)*zscale +(height/2), 2)
			--[[
			if (zscale*4)>0 then
				love.graphics.circle("fill",(xoffset+k.x)*zscale +(width/2), (yoffset+k.y)*zscale +(height/2), zscale*4)
			end
			]]
		end
	end
end