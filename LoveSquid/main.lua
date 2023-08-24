--Fire Does not work 10/24/2022
function love.load()
	love.window.setTitle("Fire Does not work 10/24/2022")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 

	--love.math.setRandomSeed(os.time())
	fireworks = {}
	function add_firework(x,y,z,num,force,life,color)
		table.insert(fireworks, {
			x = x,
			y = y,
			sparks = add_spark(num,force),
			life = life,
			color = color
		})
	end
	
	function add_spark(num, force)
		--local time = love.timer.getTime( )
		--local time = time/2 % (2*math.pi)
		local time = 0
		local sparks = {}
		for i=1,num do
			table.insert(sparks, {
				x = 0,							--will be calculated every frame
				y = 0,							--will be calculated ever frame
				vy = math.cos((math.pi * 2 / num) * i + time) * force,
				vx = math.sin((math.pi * 2 / num) * i + time) * force
			})
		end
		return sparks
	end
	
	--add_firework(width/2, height/2, 0, 10, 10, 60)
	
	function update_fireworks()
		for i=#fireworks,1,-1 do
			this = fireworks[i]
			for j,k in ipairs(this.sparks) do
				k.x = k.x + k.vx
				k.y = k.y + k.vy
				
				k.vx = k.vx * .9
				k.vy = (k.vy + .2) * .9
			end
			if this.life > 1 then
				this.life = this.life - 1
			else
				table.remove(fireworks, i)
			end
		end
		
		
	end
	
	function disp_fireworks()
		for i=#fireworks,1,-1 do
			this = fireworks[i]
			if this.color == 1 then
				love.graphics.setColor(math.min(this.life/2,20)/20 ,.2 ,.5)
			elseif this.color == 2 then
				love.graphics.setColor(.5 ,math.min(this.life/2,10)/10 ,.2)
			elseif this.color == 3 then
				love.graphics.setColor(.5 ,.3 ,math.min(this.life/2,10)/10)
			end
			for j,k in ipairs(this.sparks) do
				love.graphics.circle("fill",this.x + k.x, this.y + k.y, math.min(this.life/2,10))
			end
		end
	end
	
end
frame = 0
function love.update(dt)
	update_fireworks()
	
	mx,my = love.mouse.getPosition()
	
	if love.keyboard.isDown("space") then
		add_firework(mx, my, 0, 10, 10, 60)
	end
	time = love.timer.getTime( )
	time = time*.8 % (2 * math.pi * 10)
	frame = frame<180 and frame+1 or 0
	if not (frame>160 and frame%2 ==0) then
		add_firework(width/2 + math.cos(time/2+math.pi)*500, height/2 + math.sin(time)*200, 0, 10, 10, 60,1)
		add_firework(width/2 + math.cos((time-1.6)/2+math.pi)*500, height/2 + math.sin(time-1.6)*200, 0, 10, 10, 60,2)
		add_firework(width/2 + math.cos((time-3.2)/2+math.pi)*500, height/2 + math.sin(time-3.2)*200, 0, 10, 10, 60,3)
	end
end

function love.draw()
	disp_fireworks()
end