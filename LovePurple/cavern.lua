groundSpeedMultiplier = 1
layer1SpeedMultiplier = .8
layer2SpeedMultiplier = .2
layer3SpeedMultiplier = .15
layer4SpeedMultiplier = .1

groundX = 0
layer1X = 0
layer2X = 0
layer3X = 0
layer4X = 0

bgColor1 = col({49,0,85,255})
bgColor2 = col({90,16,143,255})
bgColor3 = col({139,47,201,255})
bgColor4 = col({171,85,227,255})
bgColor5 = col({210,131,255,255})

purpleBlock = love.graphics.newImage("vfx/PurpleBlock.png")
bgLayer1 = love.graphics.newImage("vfx/bgLayer1.png")
bgLayer2 = love.graphics.newImage("vfx/bgLayer2.png")
bgLayer3 = love.graphics.newImage("vfx/bgLayer3.png")
bgLayer4 = love.graphics.newImage("vfx/bgLayer4.png")

bgPixelSize = 8

function updateCavern(dt, speed)
  groundX = groundX + speed * groundSpeedMultiplier * dt
  layer1X = layer1X + speed * layer1SpeedMultiplier * dt
  layer2X = layer2X + speed * layer2SpeedMultiplier * dt
  layer3X = layer3X + speed * layer3SpeedMultiplier * dt
  layer4X = layer4X + speed * layer4SpeedMultiplier * dt
  
  
  if groundX < -purpleBlock:getWidth()*bgPixelSize then groundX = groundX + purpleBlock:getWidth()*bgPixelSize end
  if layer1X < -bgLayer1:getWidth()*bgPixelSize then layer1X = layer1X + bgLayer1:getWidth()*bgPixelSize end
  if layer2X < -bgLayer2:getWidth()*bgPixelSize then layer2X = layer2X + bgLayer2:getWidth()*bgPixelSize end
  if layer3X < -bgLayer3:getWidth()*bgPixelSize then layer3X = layer3X + bgLayer3:getWidth()*bgPixelSize end
  if layer4X < -bgLayer4:getWidth()*bgPixelSize then layer4X = layer4X + bgLayer4:getWidth()*bgPixelSize end
end

function drawCavern()
  love.graphics.setColor(bgColor5)
  love.graphics.rectangle("fill", 0,0,width,height)
  
  love.graphics.setColor(bgColor4)
  for i=0,width/bgLayer4:getWidth()*bgPixelSize do
    offset = i * bgLayer4:getWidth()*bgPixelSize
    love.graphics.draw(bgLayer4, layer4X + offset, 0, 0, bgPixelSize, bgPixelSize)
  end
  
  love.graphics.setColor(bgColor3)
  for i=0,width/bgLayer3:getWidth()*bgPixelSize do
    offset = i * bgLayer3:getWidth()*bgPixelSize
    love.graphics.draw(bgLayer3, layer3X + offset, 0, 0, bgPixelSize, bgPixelSize)
  end
  
  love.graphics.setColor(bgColor2)
  for i=0,width/bgLayer2:getWidth()*bgPixelSize do
    offset = i * bgLayer2:getWidth()*bgPixelSize
    love.graphics.draw(bgLayer2, layer2X + offset, 0, 0, bgPixelSize, bgPixelSize)
  end
  
  love.graphics.setColor(bgColor1)
  for i=0,width/bgLayer1:getWidth()*bgPixelSize do
    offset = i * bgLayer1:getWidth()*bgPixelSize
    love.graphics.draw(bgLayer1, layer1X + offset, 0, 0, bgPixelSize, bgPixelSize)
  end
    
  
  love.graphics.setColor({1,1,1,1})
  for i=0,width/(pixelSize * purpleBlock:getWidth())+2 do
    offset = i * pixelSize * purpleBlock:getWidth() + groundX
    love.graphics.draw(purpleBlock, offset, height-purpleBlock:getHeight()*pixelSize, 0,pixelSize,pixelSize)
  end
  
  
end