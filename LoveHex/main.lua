--Hex 11/3/2022
function love.load()
	love.window.setTitle("Hex 11/3/2022")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	love.math.setRandomSeed(os.time())
	
	sideLength = 0
	refresh = true
	
	hex = {} --hex line active (x1, y1, x2, y2, completed) a line but growing
	
	function makeHex(x1,y1,x2,y2,state)
		table.insert(hex, {
			x1 = x1,
			y1 = y1,
			x2 = x2,
			y2 = y2,
			percent = 0,
			finished = false,
			state = state
		})
	end
	
 function updateHex()
	 for i=#hex,1,-1 do
		 k = hex[i]
		 if k.percent < 100 then
		 	k.percent = k.percent + math.max(100*(1-(sideLength*2/55)), 10)
			k.percent = k.percent>100 and 100 or k.percent
	 	elseif not k.finished and k.y2 <= height then
			k.finished = true
			if k.state == 0 then
				--r = ((k.x2 - k.x1)^2 + (k.y2 - k.y1)^2)^(1/2)
				r = sideLength
				makeHex(k.x2, k.y2, k.x2 + r * math.cos(1 * math.pi /2 - math.pi/3),k.y2 + r * math.sin(1 * math.pi /2 - math.pi/3),3)
				makeHex(k.x2, k.y2, k.x2 + r * math.cos(1 * math.pi /2 + math.pi/3),k.y2 + r * math.sin(1 * math.pi /2 + math.pi/3),4)
			elseif k.state == 5 then
				r = sideLength
				makeHex(k.x2, k.y2, k.x2 + r * math.cos(1 * math.pi /2 - math.pi/3),k.y2 + r * math.sin(1 * math.pi /2 - math.pi/3),4)
				makeHex(k.x2, k.y2, k.x2 + r * math.cos(1 * math.pi /2 + math.pi/3),k.y2 + r * math.sin(1 * math.pi /2 + math.pi/3),6)
			elseif k.state == 3 then
				makeHex(k.x2, k.y2, k.x2, k.y2 + sideLength, 5)
			elseif k.state == 4 then
				makeHex(k.x2, k.y2, k.x2, k.y2 + sideLength, -1)
			elseif k.state==6 then
				makeHex(k.x2, k.y2, k.x2, k.y2 + sideLength, 0)
			end
		elseif k.y2 > height then
			refresh = true
	 end
 	end
end

 function displayHex()
	 for i,k in ipairs(hex) do
		 love.graphics.line(k.x1, k.y1, k.x1 + (k.x2-k.x1)* k.percent/100, k.y1 + (k.y2-k.y1)* k.percent/100)
		 --love.graphics.line(k.x1, k.y1,k.x2, k.y2)
	 end
 end
end


function love.update(dt)
	for i=1,10 do
		updateHex()
	end
	--
	if love.keyboard.isDown('r') then
	 refresh = true
  end
	
	if refresh then
		refresh = false
		hex = {}
		sideLength = math.random(50)+5
		for i=0,width+sideLength*sideLength*math.sqrt(3),sideLength*math.sqrt(3) do
			makeHex(i,0,i,sideLength,0)
		end
	end
	
end

function love.draw()
	displayHex()
end