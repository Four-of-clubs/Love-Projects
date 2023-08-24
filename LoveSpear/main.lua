--Spear 7/21/2023
function love.load()
	love.window.setTitle("Spear 7/21/2023")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	love.math.setRandomSeed(os.time())
	time = 0
  
  fire = -1
	
	pointMasses = {
	}
	
	function newPointMass(x, y, theta)
		table.insert(pointMasses, {
			x = x,
			y = y,
		  theta = theta,
			vx = love.math.random(20)/5 - 2,
			vy = love.math.random(20)/5 - 2,
      size = 40,
		})
	end
	
	
	function updatePointMasses(dt)
    if (fire == -1) then
      mx,my = love.mouse.getPosition()
    end
    
		for i=#pointMasses,1,-1 do
      k = pointMasses[i]
      
      if (k.x < 0 or k.x > width) then
        k.vx = -k.vx
      elseif (k.y < 0 or k.y > height) then
        k.vy = -k.vy
      end
      
      local distanceSquared = (k.x - mx)^2 + (k.y - my)^2
      if (distanceSquared > k.size^2 or fire == -1) then
        k.x = k.x + k.vx
        k.y = k.y + k.vy
      end
      
      local newTheta = math.atan2(my - k.y, mx - k.x)
			k.theta = newTheta
      
		end
	end
	
	function displayPointMasses()
		for i,k in ipairs(pointMasses) do
      local p1 = {x = k.x + (2/3) * k.size*math.cos(k.theta), y = k.y + (2/3) * k.size*math.sin(k.theta)}
      local p2 = {x = k.x + (1/6) * k.size*math.cos(k.theta + math.pi / 2), y = k.y + (1/6) * k.size*math.sin(k.theta + math.pi / 2)}
      local p3 = {x = k.x + (1/3) * k.size*math.cos(k.theta + math.pi), y = k.y + (1/3) * k.size*math.sin(k.theta + math.pi)}
      local p4 = {x = k.x + (1/6) * k.size*math.cos(k.theta + 3*math.pi / 2), y = k.y + (1/6) * k.size*math.sin(k.theta + 3*math.pi / 2)}
      
			love.graphics.line(p1.x, p1.y, p2.x, p2.y)
			love.graphics.line(p2.x, p2.y, p3.x, p3.y)
			love.graphics.line(p3.x, p3.y, p4.x, p4.y)
			love.graphics.line(p4.x, p4.y, p1.x, p1.y)
      love.graphics.circle("fill",k.x,k.y,3)
		end
	end
	
	--newPointMass(width/2, height/2, 0)
  for i=1,1000 do 
    local x = love.math.random(width)
    local y = love.math.random(height)
    newPointMass(x, y, 0)
  end
end

function love.update(dt)
	updatePointMasses(dt)
  
  if love.keyboard.isDown("space") then
    if (fire==-1) then
      fire = 100
      for i,k in ipairs(pointMasses) do
        k.vx = 0
        k.vy = 0
      end
    end
  end
  
  if (fire>0) then
    fire = fire - 1
  end
    
  if (fire == 0) then
    for i,k in ipairs(pointMasses) do
      k.vx = math.cos(k.theta) * 60
      k.vy = math.sin(k.theta) * 60
    end
  end
  
end

function love.draw()
  love.graphics.setColor({.7,.1,.2})
  love.graphics.circle("fill", mx, my, 5)
  love.graphics.setColor(1,1,1)
  displayPointMasses()
end