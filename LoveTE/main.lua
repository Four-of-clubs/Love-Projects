function love.load()
	love.window.setTitle("TextMeasure Example 5/16/2022")
	love.window.setFullscreen(true)
	screenWidth = love.graphics.getWidth( ) -- 800
	screenHeight = love.graphics.getHeight( ) -- 600
	
	righttoleft = true
	mousex, mousey = love.mouse.getPosition()
	
	font = love.graphics.newFont(46) --change this number for changing text size
	love.graphics.setFont(font)
	
	tHeld = false --used to make toggle effect on T
	
	characterHeight = font:getHeight("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
	
	mainString = "The Five Boxing Wizards Jumped Quickly. This is filler text to help test spacing and ensure that this will work in the ways it is intended to. Don't forget to make percentage display. "
	tempArray = {}
	for word in string.gmatch(mainString, "[^%s]+") do --seperates string by *any* white spaces
		table.insert(tempArray, word)
	end
	
	boxList = {}
	displayBox  = true
	textList = {}
	
	bufferSize = 20
	
	xMargine = .10 --as a multiplyer of screenWidth
	yMargine = .20 -- as a multiplyer of screenHeight
	distX = screenWidth*xMargine --distance in pixels of how far into each line the next word must be placed
	currentLine = 0 --number of lines down
	for i,word in ipairs(tempArray) do
		width = font:getWidth(word)
		if width + distX >= screenWidth * (1-xMargine) then
			distX = screenWidth*xMargine
			currentLine = currentLine + 2
		end
		
		createTextBox(distX, currentLine*characterHeight + screenHeight*yMargine, word)
		createBox(distX - bufferSize, currentLine*characterHeight + screenHeight*yMargine - bufferSize, 
			width + bufferSize*2, characterHeight + bufferSize*2)
		distX = distX + width + font:getWidth(" ")
	end
	
end

function createTextBox(x,y,text)
	table.insert(textList, {
	x = x,
	y = y,
	text = text,
	})
end

function createBox(x,y,width,height)
	table.insert(boxList, {
	x = x,
	y = y,
	w = width,
	h = height,
	seen = false,
	})
end

function checkCollision(x, y)	--if a given point is inside any box, turns them true
	for i,k in ipairs(boxList) do
		if (x >= k.x and x <= k.x + k.w and y >= k.y and y <= k.y+k.h) then
			k.seen = true
		end
	end
end

function love.update(dt)
	tempx = mousex
	tempy = mousey
	mousex, mousey = love.mouse.getPosition()
	
	if (righttoleft==false) then
		checkCollision(mousex, mousey)
	elseif (mousex-tempx > 0) then
		checkCollision(tempx,tempy)
		checkCollision(mousex,mousey)
	end



	if love.keyboard.isDown("r") then
		for i,k in ipairs(boxList) do k.seen = false end
	end
	
	if love.keyboard.isDown("t") then
		if tHeld == false then
			if displayBox then
				displayBox = false
			else
				displayBox = true
			end
		end
		tHeld = true
	else
		tHeld = false
	end
end

function love.draw()
	temp = 0
	for i,k in ipairs(boxList) do
		if k.seen then 
			love.graphics.setColor( {0, .8, .2})  
			temp = temp + 1
		end
		if displayBox then
			love.graphics.rectangle("line", k.x, k.y, k.w, k.h)
			love.graphics.setColor({1, 1, 1})
		end
	end
	love.graphics.setColor({1, 1, 1})
	love.graphics.print( ("%.0f%%"):format((temp/#boxList)*100) , 10, 10)
	
	for i,k in ipairs(textList) do
		love.graphics.print(k.text, k.x, k.y)
	end
end
