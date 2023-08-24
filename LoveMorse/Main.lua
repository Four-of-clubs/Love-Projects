function love.load()
	love.window.setTitle("Morse Converter 11/20/21")
	width = love.graphics.getWidth( ) -- 800
	height = love.graphics.getHeight( ) -- 600
	
	--$ is short
	--% is  long
	
	morse = { "$%", "%$$$", "%$%$", "%$$", "$", "$$%$", "%%$", "$$$$", "$$", "$%%%", "%$%", "$%$$", "%%", "%$", "%%%", 
		"$%%$", "%%$%", "$%$", "$$$", "%", "$$%", "$$$%", "$%%", "%$$%", "%$%%", "%%$$", "$%%%%", "$$%%%", 
		"$$$%%", "$$$$%","$$$$$", "%$$$$", "%%$$$", "%%%$$", "%%%%$", "%%%%%"}
		
	char = "abcdefghijklmnopqrstuvwxyz1234567890"
	
	input = "" 
	startTime = 0
	
	dit = .15
	
	delShort = dit	--delay short
	delLong = dit*3	--delay long (unused)
	
	delChar = dit*3 --delay character (between characters)
	delSpace = dit*7 --delay space
	
	
	isHeld = false
	
	spaceList = {}
end

function converter(input)	--if you spell out one of the morsekeys (ex. " sl ") in morse, it WILL get changed into "A" [bug removed ish]
	spaceList = {}
	input = "-" .. input
	for i=1,#input do --start at 1 cuz lua is nonsense , #input means length of input
		if input:sub(i,i) == "-" then
			--spaceList:insert(i)
			table.insert(spaceList,i)
		end
	end
	
	tempString = ""	
	currentMatch = false
	for i=1,(#spaceList-1) do
		currentMatch = false
		sub = input:sub(0,spaceList[1]-1)
		sub = input:sub(spaceList[i]+1,spaceList[i+1]-1)
		
		for i=1,#morse do
			if morse[i] == sub then
				tempString = tempString .. char:sub(i,i) .. ""
				currentMatch = true
			end
		end
		if not currentMatch then
			if sub:sub(1,1) == "$" or sub:sub(1,1) =="%" then
				tempString = tempString .. "[?]"
			else
				tempString = tempString .. sub
			end
		end
	end
	
	return tempString .. "-"
end

function addMorse(time, isPressed)	--if isPressed is false, then it is not pressed for that long
	if isPressed then
		if time<delShort then
			input = input .. "$" 	-- .. means concationation in lua
		else
			input = input .. "%"
		end
	else 
		if time>delSpace then
			input = input .. "- -"
			input = converter(input)
		elseif time>delChar then
			input = input .. "-"
			input = converter(input)
		end
	end
end

function love.update(dt)

	if love.keyboard.isDown("space") and not isHeld then
		isHeld = true
		if input~="" then --won't add period on first press
			addMorse(love.timer.getTime() - startTime, false)
		end
		startTime = love.timer.getTime( )
	elseif not love.keyboard.isDown("space") and isHeld then
		isHeld = false
		addMorse(love.timer.getTime()-startTime, true)
		startTime = love.timer.getTime()
	end
	
	if love.keyboard.isDown("t") then
		input = converter(input.."-")
	end
	
	if love.keyboard.isDown("r") then
		input = ""
	end

end


function love.draw()
	love.graphics.print(input,10,10)
	
	for i=1,(#spaceList-1) do
		love.graphics.print("|"..input:sub(spaceList[i]+1,spaceList[i+1]-1) .. "|",10,25+15*i)
	end

	love.graphics.setColor({1,1,1})
	love.graphics.rectangle("line", width/2-50, height/2-50, 100, 100)
	if isHeld then
		love.graphics.rectangle("fill", width/2-50, height/2-50, 100, 100)
	end
end