--Grid2 1/11/2022
function love.load()
	love.window.setTitle("Grid 1/11/2022")
	love.window.setFullscreen(true)
	width = love.graphics.getWidth( )  --1536
	height = love.graphics.getHeight( ) 
	time = 0
	--love.math.setRandomSeed(os.time())
	gridDist = 20	-- pixels between each line of the grid
	
	gridWidth = width/gridDist -- number of squares in width of grid
	gridHeight = height/gridDist -- number of squares in height of grid

	split = false
	
	current = 0
	
	plcx = 0
	plcy = 0
	
	Squares = 
	{state = {}, 
	clr = {{1,1,1},{0,.3,.8}}
}
		
	function Squares:initState(width, height)
		self.state = {}
		for y=1,height+1 do
			self.state[y]={}
			for x=1,width+1 do
				self.state[y][x] = {
					brtn = 0,
					r = 0,
					g = 0,
					b = 0
				}
				
			end
		end
	end
	
	function Squares:displaySquare()
		for y=1,#self.state do
			for x=1,#self.state[y] do
				if self.state[y][x].r + self.state[y][x].g + self.state[y][x].b > 0 then 
					love.graphics.setColor(self.state[y][x].r, self.state[y][x].g, self.state[y][x].b)
					--love.graphics.setColor(0, .3 * self.state[y][x].brtn/1, .8 * self.state[y][x].brtn/1)
					love.graphics.rectangle("fill", plcx + (x-1) * gridDist, plcy + (y-1) * gridDist, gridDist, gridDist)
				end
			end
		end
	end
	
	function Squares:addEntity(x,y,r,g,b,diffusion)	--use grid coords and rgb values
		-- brightens given location with according values
			if x>=1 and x<=#self.state[1] and y>=1 and y<=#self.state then
				self.state[y][x].brtn = self.state[y][x].brtn + 1
				self.state[y][x].r = self.state[y][x].r + r
				self.state[y][x].g = self.state[y][x].g + g
				self.state[y][x].b = self.state[y][x].b + b
			end
	end
	
	function Squares:updateSquares()	
		--logic for bleeding/spreading of brightness to adjacent tiles
		
		--[[
		for y=1,#self.state do			--could be gridHeight?
			for x=1,#self.state[y] do	--could be gridWidth?
				temp = self:adjacencyMax(x,y) * .8
				if temp > self.state[y][x].brtn then self.state[y][x].brtn = temp end
			end
		end
		]]
		
		--create a temp blank grid for storage
		temp = {}
		for y=1,#self.state do
			temp[y]={}
			for x=1,#self.state[y] do
				temp[y][x] = {
					brtn = 0,
					r = 0,
					g = 0,
					b = 0,
				}
			end
		end
		
		min = 1
		maxW = #self.state[1]
		maxH = #self.state 
		
		--switch x and y, sigh
		for y=1,#self.state do			--could be gridHeight?
			for x=1,#self.state[y] do	--could be gridWidth?

				temp[y][x].r = math.max(self.state[y][x].r,temp[y][x].r)
				temp[y][x].g = math.max(self.state[y][x].g,temp[y][x].g)
				temp[y][x].b = math.max(self.state[y][x].b,temp[y][x].b)
				
				--tempb = self.state[y][x].brtn * .8			--determin shared brightness

				tempr = self.state[y][x].r * .8			--determin shared red
				tempg = self.state[y][x].g * .8			--determin shared green
				tempb = self.state[y][x].b * .8			--determin shared blue
				
				--add top
				if y > min then
					temp[y-1][x].r = math.max(temp[y-1][x].r,tempr)
					temp[y-1][x].g = math.max(temp[y-1][x].g,tempg)
					temp[y-1][x].b = math.max(temp[y-1][x].b,tempb)
				end
				--add bottom
				if y < maxH then
					temp[y+1][x].r = math.max(temp[y+1][x].r,tempr)
					temp[y+1][x].g = math.max(temp[y+1][x].g,tempg)
					temp[y+1][x].b = math.max(temp[y+1][x].b,tempb)
				end
				--add left
				if x > min then
					temp[y][x-1].r = math.max(temp[y][x-1].r,tempr)
					temp[y][x-1].g = math.max(temp[y][x-1].g,tempg)
					temp[y][x-1].b = math.max(temp[y][x-1].b,tempb)
				end
				--add right
				if x < maxW then
					temp[y][x+1].r = math.max(temp[y][x+1].r,tempr)
					temp[y][x+1].g = math.max(temp[y][x+1].g,tempg)
					temp[y][x+1].b = math.max(temp[y][x+1].b,tempb)
				end
			end
		end
	
		
		
		-- fades rest of grid
		for i=1,#self.state do			--could be gridHeight?
			for k=1,#self.state[i] do	--could be gridWidth?
				self.state[i][k].r = temp[i][k].r
				self.state[i][k].g = temp[i][k].g
				self.state[i][k].b = temp[i][k].b
				if self.state[i][k].r + self.state[i][k].g + self.state[i][k].b > 0 then 
					if self.state[i][k].r + self.state[i][k].g + self.state[i][k].b < .02 then 
						 self.state[i][k].r = 0
						 self.state[i][k].g = 0
						 self.state[i][k].b = 0
					else 
						self.state[i][k].r = .95 * self.state[i][k].r 
						self.state[i][k].g = .95 * self.state[i][k].g 
						self.state[i][k].b = .95 * self.state[i][k].b 
					end
				end
			end
		end
		
	end

	function Squares:create(o)
		o = o or {}
		setmetatable(o, self)
		self.__index = self
		self.state = {}
  	return o
	end

	function Squares:adjacencyMax(x,y)
		adjacencyCoordsList = {}
		maxVal = 0
		min = 1
		maxW = #self.state[1]
		maxH = #self.state 
		table.insert(adjacencyCoordsList, {x - 1,y}) 
		table.insert(adjacencyCoordsList, {x + 1,y})
		table.insert(adjacencyCoordsList, {x,y - 1})
		table.insert(adjacencyCoordsList, {x,y + 1})
		for j,i in ipairs(adjacencyCoordsList) do
			if i[1]>=min and i[1]<= maxW and i[2]>=min and i[2]<= maxH then
				if self.state[i[2]][i[1]].brtn>maxVal then maxVal = self.state[i[2]][i[1]].brtn end
			end
		end
		return maxVal
	end

	s = Squares:create()

	s:initState(gridWidth,gridHeight)		
end

function love.update(dt)
	time = time + dt
	dispw = width*.75
	disph = height * .65
	x = width/2 + math.sin(time%(2*math.pi))* dispw/2
	y = height/2 + math.sin(2*time%(2*math.pi))* disph/2

	--blue
	s:addEntity(math.floor( x/gridDist) + 1,math.floor(y/gridDist) + 1, 0,.2,.8, .8)
	if not split then--red
		s:addEntity(math.floor( x/gridDist) + 1,math.floor(y/gridDist) + 1, .8,.1,.1, .8)
	else--red2
		x = width/2 + math.sin(-1*time%(2*math.pi))* dispw/2
		y = height/2 + math.sin(-2*time%(2*math.pi))* disph/2
		s:addEntity(math.floor( x/gridDist) + 1,math.floor(y/gridDist) + 1, .8,.1,.1, .8)
	end
	--green
	x = width/2 + math.sin(.2*time%(2*math.pi))* dispw/2
	y = height/2 + math.sin(2*.2*time%(2*math.pi))* disph/2
	s:addEntity(math.floor( x/gridDist) + 1,math.floor(y/gridDist) + 1, .1,.8,.1, .8)
	
	if love.mouse.isDown(1) then
		mx,my = love.mouse.getPosition()
		s:addEntity(math.floor( mx/gridDist) + 1, math.floor(my/gridDist) + 1, .4,.1,.4, .8)
	end
	
	if love.keyboard.isDown('space') then split=true end

	if current ~= math.floor(time/(2*math.pi)) then
		split = not split
		current = math.floor(time/(2*math.pi)) 
	end
	
	s:updateSquares()
	
	
end

function love.draw()
	s:displaySquare()
	love.graphics.setColor(1,0,0)
	--love.graphics.circle("fill", x, y ,10)
end