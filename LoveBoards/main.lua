--Boards 8/4/2023
function love.load()
	love.window.setTitle("Boards 8/4/2023")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	love.math.setRandomSeed(os.time())
	time = 0
	
	plank = {64/255, 40/255, 25/255}
	line = {28/255, 18/255, 12/255}
	nail = {67/255, 72/255, 79/255}
	
	boards = {
	}
	
	function newBoard(y,h,space)
		table.insert(boards, {
			y = y,
			h = h,
			x1 = 0,
			x2 = 0,
			space = space,
		})
	end
	
	floor = height - 255
	function updateBoards(dt)
		for i,k in ipairs(boards) do
			time = time + dt/20
			k.space = (math.sin(time - (k.y / height)) +1)/4 * width
			
			k.x1 = k.space/2
			k.x2 = k.space/2
			
		end
	end
	
	function displayBoards()
		for i,k in ipairs(boards) do
			local x1 = width/2 - k.x1
			local x2 = width/2 + k.x2
			
			love.graphics.setColor(plank)
			love.graphics.rectangle("fill", 0, k.y, x1,k.h)
			love.graphics.rectangle("fill", x2, k.y, width, k.h)
			
			love.graphics.setColor(line)
			love.graphics.line(0, k.y, x1, k.y)
			love.graphics.line(x1, k.y, x1, k.y + k.h)
			love.graphics.line(0, k.y + k.h, x1, k.y + k.h)
			
			love.graphics.line(width, k.y, x2, k.y)
			love.graphics.line(x2, k.y, x2, k.y + k.h)
			love.graphics.line(width, k.y + k.h, x2, k.y + k.h)
			
			love.graphics.setColor(nail)
			love.graphics.circle("fill", x1 - k.h/2, k.y + k.h/4, k.h/8)
			love.graphics.circle("fill", x1 - k.h/2, k.y + 3 * k.h/4, k.h/8)
			
			love.graphics.circle("fill", x2 + k.h/2, k.y + k.h/4, k.h/8)
			love.graphics.circle("fill", x2 + k.h/2, k.y + 3 * k.h/4, k.h/8)
			
			
		end
	end
	
	step = 40
	for i=1,height,step do
		newBoard(i,step,i)
	end
	
end

function love.update(dt)
	updateBoards(dt)
end

function love.draw()
	displayBoards()
end