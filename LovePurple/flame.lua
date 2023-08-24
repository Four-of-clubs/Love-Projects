flameBaseColor = col({74,10,119,255})
flameTipColor = col({210,131,255,255})
time = 0            --used in managing light effect
flames = {}

particleLife = 1.2     --in seconds
particlesPerSecond = 120    --number of particles per flame
particleNoiseX = .8  --variance on x axis in fraction of size
particleNoiseY = 1.4  --variance on y axis in fraction of size
particleAcceleration = 70    --in pixels /second/second
particleSize = 15 

pixelSize = 4   --for pixels in the torch

torchHeight = height/2 + 45    --this is based on the midpoint of the flames... my bad
numberTorchesPerScreen = 2

timeBetweenSpawn = 1/particlesPerSecond
timeElapsed = 0

torch = love.graphics.newImage("vfx/torch.png")

Flame = {}
Flame.__index = Flame

function Flame.new(x,y,size,color)
  local self = {}
  setmetatable(self,Flame)
  self.x = x
  self.y = y
  self.particles = {}
  self.size = size
  self.color = color  
  self.pulse = 0      --a number between 0 and 1 that controlls the circle glow effect
  return self
end  

function Flame:update(dt, speed)
  time = time + dt
  self.pulse = math.sin(time)/2 + 1
  
  --replenesh expired particles
  timeElapsed = timeElapsed + dt
  if timeElapsed > timeBetweenSpawn then
    for i=timeElapsed,0,-timeBetweenSpawn do
      table.insert(self.particles, {
        x = math.random(-1 * self.size * particleNoiseX, self.size * particleNoiseX),
        y = math.random(0,self.size * particleNoiseY),
        vx = math.random(-50,50)/100,
        life = particleLife
      })
    end
    
    timeElapsed = 0
  end
  
  --handle expiration
  for i=#(self.particles),1,-1 do
    local part = self.particles[i]
    part.life = part.life - dt
    if part.life <= 0 then
      table.remove(self.particles,i)
    end
  end
  
  --update particles positions
  for _,part in ipairs(self.particles) do
    part.y = part.y - particleAcceleration * dt
    part.x = part.x + part.vx
  end
  
  --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ LOGIC FOR SHIFTING TORCH WITH SPEED ~~~~~~~~~~~~~
  for _,part in ipairs(self.particles) do
    --part.x = part.x + speed
  end
  self.x = self.x + speed * dt
  
  if self.x < -(width/numberTorchesPerScreen) then self.x = self.x + width + 2*(width/numberTorchesPerScreen)  end
  
end

function Flame:draw()
  love.graphics.draw(torch, self.x - torch:getWidth() * pixelSize/2, self.y + self.size, 0 , pixelSize, pixelSize)
  
  
  love.graphics.setColor(col{220,151,225,10 + 5 * self.pulse})        --TODO: move to top of file
  love.graphics.circle("fill", self.x, self.y,100 + 20 * self.pulse)  --TODO: move to top of file
  
  for i,k in ipairs(self.particles) do
    local scalar = k.life/particleLife
    love.graphics.setColor(mergeColor(self.color, flameBaseColor, scalar))
    love.graphics.rectangle("fill", k.x + self.x - (self.size * scalar)/2, k.y + self.y - (self.size * scalar)/2, self.size * scalar, self.size * scalar)
  end
end


function updateFlame(dt, speed)
  for _,fl in ipairs(flames) do
    fl:update(dt, speed)
  end
end

function drawFlame()
  for _,fl in ipairs(flames) do
    fl:draw()
  end
end

for i=0,numberTorchesPerScreen+1 do
  x = i * (width/numberTorchesPerScreen)
  table.insert(flames, Flame.new(x, torchHeight, particleSize, flameTipColor))
end