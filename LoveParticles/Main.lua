--Particles 10/12/2021
function love.load()
	love.window.setTitle("Particles 10/12/2021")
	particles = {}
	math.randomseed(os.time())
	mousevx = 0
	mousevy = 0
	x,y = love.mouse.getPosition()
	
	col_list = { {.58,.05,.08}, {.02,.25,.03}}
end

--[[
function add_particle(x,y) -- function to generate particles
	table.insert(particles,{
	x = x, --x position
	y = y, --y position
	vx = (math.random(200)-100)/100, --x velocity
	vy = -3, --y velocity - NEGATIVE IS UP
	life = 120, --ttl in frames
	})
end
]]

function add_particle(x,y) -- function to generate particles
	table.insert(particles,{
	x = x, --x position
	y = y, --y position
	vx = (math.random(200)-100)/100 - mousevx*.7, --x velocity
	vy = -3 - mousevy*.7, --y velocity - NEGATIVE IS UP
	life = 120, --ttl in frames
	col = col_list[math.random(#col_list)]
	})
end

function love.update(dt)
	tempx, tempy = love.mouse.getPosition()
	mousevx = x-tempx
	mousevy = y-tempy

	for i in pairs(particles) do
		particles[i].x = particles[i].x + particles[i].vx
		particles[i].y = particles[i].y + particles[i].vy
		particles[i].vy = particles[i].vy + .2 --this constant is 'gravity' in pixels/second/second
		particles[i].life = particles[i].life-1

		if particles[i].life<=0 then
			table.remove(particles,i)
		end
	end

	x, y = love.mouse.getPosition()

	if love.mouse.isDown(1) then
		--for i=1,10 do
			add_particle(x,y)
		--end
	end
end

function love.draw()

	for i,particle in ipairs(particles) do
		--love.graphics.rectangle("fill", (particles[i].x), (particles[i].y), (particles[i].life/10), (particles[i].life/10))
		--love.graphics.line((particles[i].x), (particles[i].y), x, y)
		love.graphics.setColor(particle.col)
		love.graphics.circle("fill",particle.x,particle.y,10)
	end
end
