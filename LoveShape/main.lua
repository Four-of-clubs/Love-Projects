--Happy Holloween 10/20/2022 
function love.load()
	love.window.setTitle("Happy Holloween 10/20/2022")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	shape = {}
	bigger = true
	sheld = false
	frame = 0
	love.math.setRandomSeed(os.time())
	
	function add_shape(x,y)
		table.insert(shape, {
			x = x,
			y=y,
			legs = legs(x,y,100)
		})
	end
	
	function legs(x,y,num)
		local tempArr = {}
			for i=1,num do
				table.insert(tempArr, {
					r = 30,
					theta = 2*math.pi/num * i,
					vr = 0,				--velocity of r (in pixels/frame)
					vtheta = 0,		--velocity of theta (in pixels/frame)
					finr = i%2==0 and 200 or 160,			-- end condition
					fintheta = 2*math.pi/num * i, 	-- end state
					x = 0,				--calcuated every frame based on polar coords above
					y = 0,				--calcuated every frame based on polar coords above
				})
			end
			return tempArr
	end
	
	function update_shape()
		local done = true
		for i,k in ipairs(shape) do
			for j,l in ipairs(k.legs) do
				if l.r < l.finr then
					l.r = bigger and l.r + l.vr or l.r
					l.theta = l.theta + l.vtheta
					
					l.vr = (l.vr + love.math.random(20)/10 - 1)*.6
					l.vr = l.vr<=0 and 0 or l.vr
					l.vtheta = (l.vtheta + (love.math.random(20)/10 - 1 )*.2 )*.7
					done = false
				else
					if l.theta+.01 >= l.fintheta or l.theta-.01 <= l.fintheta then
						l.theta = l.fintheta
					end
					l.r = l.finr
				end
				
				
				l.x = math.cos(l.theta)*l.r + k.x
				l.y = math.sin(l.theta)*l.r + k.y
			end
		end
		return done
	end
	
	function draw_shape()
		for i,k in ipairs(shape) do
			local tempx = k.legs[#k.legs].x
			local tempy = k.legs[#k.legs].y
			for j,l in ipairs(k.legs) do
				love.graphics.line(k.x,k.y,l.x,l.y)
				
				love.graphics.line(l.x,l.y, tempx, tempy)
				tempx = l.x
				tempy = l.y
			end
		end
	end
	
	baseHeight = 3*height/4
	baseWidth = width/4
	baseDist = 28
	points = {}
	length = (width/2/baseDist)
	for i=1,length do
		table.insert(points,{baseWidth+baseDist*i, baseHeight - math.cos(2*math.pi/length * i)*50})
	end
	smilePoints = {}
	smilePoints2 = {}
	function smile(frame)
		if frame > 50 and frame-50 <= #points then
			table.insert(smilePoints,{
				x = points[frame-50][1],
				y = points[frame-50][2]
			})
		elseif frame-50 >= #points+60 and frame-50 <= #points+60+100 then
			local ofs = (frame-50 - #points - 60) *1.2
			function foo()
				local tempx = smilePoints[1].x
				local tempy = smilePoints[1].y
				local tempofsl = 0
				for i,k in  ipairs(smilePoints) do
					ofsl = ofs * (1-math.abs(k.x - width/2) / (width/4))
					love.graphics.line(k.x,k.y-ofsl, tempx, tempy-tempofsl)
					love.graphics.line(k.x,k.y+ofsl, tempx, tempy+tempofsl)
					love.graphics.line(k.x,k.y-ofsl, k.x,k.y+ofsl)
					
					tempx = k.x
					tempy = k.y
					tempofsl = ofsl
				end
			end
			draw_smile = foo
		end
			
	end
	
	function draw_smile()
		if #smilePoints >= 1 then
			local tempx = smilePoints[1].x
			local tempy = smilePoints[1].y
		
			for i,k in  ipairs(smilePoints) do
				love.graphics.line(k.x,k.y, tempx, tempy)
				tempx = k.x
				tempy = k.y
			end
		end
	end
	

	add_shape(width/3, height/3)
	add_shape(2*width/3, height/3)
	
end


function love.update(dt)
	done = update_shape()
	if done then
		frame= frame + 1
		smile(frame)
	end
	if love.keyboard.isDown('r') then
		love.load()
	end
	
	if love.keyboard.isDown('s') then 
		if not sheld then bigger = not bigger end
		sheld = true
	else
		sheld = false
	end
end

function love.draw()
	draw_shape()
	draw_smile()
end