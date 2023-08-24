--Falling Star 10/17/2022 
function love.load()
	love.window.setTitle("Falling Star 10/17/2022 ")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	
	groundY = 650 								--Termination height for falling stars
	
	wheld = false
	ss = true
	ssx1 = 0
	ssy1 = 0
	ssx2 = 0
	ssy2 = 0
	ssx3 = 0
	ssy3 = 0
	
	falling_stars = {}
	function make_star(argx,argy)				--Takes argument of mouse input
		vxtemp = love.math.random(600)/100 - 3
		vytemp = 10
		table.insert(falling_stars, {
			x = argx - vxtemp*groundY/vytemp,	--lower x value of star
			y = math.min(argy - groundY, 0),					--lower y value of star
			
			vx = vxtemp,						--velocuty y
			vy = vytemp,						--velocity x
			
			life = -1,							--used to measure how long in ground
			
			l = 15								--length of star tail
		})
	end
	
	function update_star()
		for i=#falling_stars,1,-1 do
			k = falling_stars[i]
			
			if k.y <= groundY then
				k.x = k.x + k.vx
				k.y = k.y + k.vy
				--
			elseif k.life == -1 then
				k.life = 0
				make_hit(k.x)
			else 
				k.life = k.life - 1
				
			end

			if k.life == 0 then
				table.remove(falling_stars, i)
			end
			
		end
	end
	
	function disp_star()
		love.graphics.setColor(1,1,1)
		for i,k in ipairs(falling_stars) do
			love.graphics.line(k.x, k.y, k.x - (k.vx*k.l), k.y - (k.vy*k.l))
		end
	end
	
	hit_effect = {}
	function make_hit(x)
		table.insert(hit_effect, {
			x = x,
			life = 15,
		})
	end
	
	function update_hit()
		for i=#hit_effect,1,-1 do
			k = hit_effect[i]
			k.life = k.life - 1
			if k.life==0 then
				table.remove(hit_effect, i)
			end
		end
	end
	
	function disp_hit()
		for i,k in ipairs(hit_effect) do
			love.graphics.setColor({(k.life)/15,(k.life)/15,(k.life)/15})
			love.graphics.circle( "fill", k.x, groundY,15 + 45 *(15-k.life)/15)
		end
	end
end


function love.update(dt)
	mx,my = love.mouse.getPosition()			--gets mouse 
	
	if love.mouse.isDown(1) then
		for i=1,15 do
			make_star(mx,my)
		end
	end
	if love.keyboard.isDown("w") then
		if not wheld then
			ss = not ss
			wheld = true
		end
	elseif wheld then
		wheld = false
	end
	if ss then
		time = love.timer.getTime( )
		tim = -1 * (time % 5)
		ssx1 = math.cos(tim/5 * 2 * math.pi) * 600 + width/2
		ssy1 = math.sin(tim/5 * 2 * math.pi * 2) * 250 + height/2 -100
		for i=1,15 do
			make_star(ssx1,ssy1)
		end
		tim = -1 * (time + 5/3) % 5
		ssx2 = math.cos(tim/5 * 2 * math.pi) * 600 + width/2
		ssy2 = math.sin(tim/5 * 2 * math.pi * 2) * 250 + height/2 -100
		for i=1,15 do
			make_star(ssx2,ssy2)
		end
		tim = -1 * (time + 5/3*2) % 5
		ssx3 = math.cos(tim/5 * 2 * math.pi) * 600 + width/2
		ssy3 = math.sin(tim/5 * 2 * math.pi * 2) * 250 + height/2 -100
		for i=1,15 do
			make_star(ssx3,ssy3)
		end
		
	end
	
	
	update_star()
	update_hit()
end

function love.draw()
	--love.graphics.circle("fill", ssx1, ssy1, 10)
	--love.graphics.circle("fill", ssx2, ssy2, 10)
	--love.graphics.circle("fill", ssx3, ssy3, 10)
	disp_hit()
	disp_star()
	love.graphics.line(0, groundY, width, groundY)
end