

backgroundSpeedMultiplier = 1
foregroundSpeedMultiplier = 2
groundSpeedMultiplier = 1
wallSpeedMultiplier = 1

columnBackgroundPixelSize = 4
columnForegroundPixelSize = 8
groundPixelSize = 4
glassPixelSize = 8
wallPixelSize = 4

glassNumberBetweenCols = 1  --change into glass between columns
columnBackgroundNumberPerScreen = 2
columnForegroundNumberPerScreen = 1

columnBackgroundHeight = 25       --number of "columnBackgrondPixelsSize" from bottom of screen

groundX = 0
wallX = 0
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

columnBackground = love.graphics.newImage("vfx/columnBackground.png")
columnForeground = love.graphics.newImage("vfx/columnForeground.png")
goldBlock = love.graphics.newImage("vfx/goldBlock.png")
glow = love.graphics.newImage("vfx/glow.png")
wall = love.graphics.newImage("vfx/wall.png")

--automate this a bit
glass1 = love.graphics.newImage("vfx/glass1.png")
glass2 = love.graphics.newImage("vfx/glass2.png")
glass3 = love.graphics.newImage("vfx/glass3.png")

glassSpriteArray = {glass1, glass2, glass3}

columnBackgroundY = height - (columnBackground:getHeight() + columnBackgroundHeight) * columnBackgroundPixelSize
distanceBetweenBackgroundColumns = width/columnBackgroundNumberPerScreen

backgroundArray = {}    --contains both columns and glass (type: 1 = column, 2-x = different glass types)
columnForegroundArray = {}

distanceBetweenBackgroundElements = (distanceBetweenBackgroundColumns - columnBackground:getWidth() * columnBackgroundPixelSize
- glass1:getWidth() * glassPixelSize * glassNumberBetweenCols) / (glassNumberBetweenCols + 1)

function addBackground() 
  glassCount = 0
  for i = 0,columnBackgroundNumberPerScreen do
    table.insert(backgroundArray, {
      type = 0,
      x = distanceBetweenBackgroundColumns * i
    })
    for k = 1, glassNumberBetweenCols do
      table.insert(backgroundArray, {
        type = (glassCount%#glassSpriteArray) + 1,
        x = (distanceBetweenBackgroundColumns * i) + 
        (distanceBetweenBackgroundColumns*1.2) * (k/(glassNumberBetweenCols+1)) 
        - (glass1:getWidth() * glassPixelSize)/2,
        
        --x = width * k/3 - (glass1:getWidth() * glassPixelSize)/2
        
        x = (distanceBetweenBackgroundColumns * i) + (k) * (distanceBetweenBackgroundElements) + (k-1) * glass1:getWidth() * glassPixelSize
        + columnBackground:getWidth() * columnBackgroundPixelSize
      })
      glassCount = glassCount + 1
    end
  end
end

addBackground()


function addForeground(BackgroundColumnXCentered)
  local HalfFGW = columnForeground:getWidth() * columnForegroundPixelSize * 1/2
  local FGS = foregroundSpeedMultiplier
  local BGS = backgroundSpeedMultiplier
  local BGXC = BackgroundColumnXCentered
  local FGXC = ((((((width/2) - BGXC)) * FGS)/BGS) - width/2) * -1
  table.insert(columnForegroundArray, {
    x = FGXC - HalfFGW
  })
end

for i,k in ipairs(backgroundArray) do
  if k.type == 0 then
    addForeground(k.x + columnBackground:getWidth() * columnBackgroundPixelSize/2)
  end
end


function updateHall(dt, speed)
  groundX = groundX + speed * groundSpeedMultiplier * dt
  if groundX < -goldBlock:getWidth()*groundPixelSize then groundX = groundX + goldBlock:getWidth()*groundPixelSize end
  
  wallX = wallX + speed * wallSpeedMultiplier * dt
  if wallX < -wall:getWidth()*wallPixelSize then wallX = wallX + wall:getWidth()*wallPixelSize end
  
  --[[
  for i in ipairs(columnArray) do
    columnArray[i] = columnArray[i] + speed * dt * columnSpeedMultiplier
    if columnArray[i] < -width then columnArray[i] = columnArray[i] + 2*width end
  end]]
  
  for i,k in ipairs(backgroundArray) do
    k.x = k.x + speed * dt * backgroundSpeedMultiplier
    if k.type == 0 then
      if k.x < -1 * columnBackground:getWidth() * columnBackgroundPixelSize then
        k.x = k.x + width + distanceBetweenBackgroundColumns
        addForeground(k.x + columnBackground:getWidth() * columnBackgroundPixelSize / 2)
      end
    else
      if k.x < -1 * glass1:getWidth() * glassPixelSize then
        k.x = k.x + width + distanceBetweenBackgroundColumns
      end
    end
  end
  
  for i,k in ipairs(columnForegroundArray) do
    k.x = k.x + speed * dt * foregroundSpeedMultiplier
    if k.x < -1 * columnForeground:getWidth() * columnForegroundPixelSize  then
      table.remove(columnForegroundArray,i)
    end
  end
  
end


function drawHall()
  love.graphics.setColor(col({255, 170, 0,255}))
  love.graphics.rectangle("fill",0,0,width,height)
  
  love.graphics.setColor({1,1,1,1})
  
  for y=0,height/(wallPixelSize * wall:getHeight())+2 do
    for x=0,width/(wallPixelSize * wall:getWidth())+2 do
      love.graphics.draw(wall, wallX + x * wallPixelSize * wall:getWidth(), y * wallPixelSize * wall:getHeight(),
        0, wallPixelSize, wallPizelSize)
    end
  end
  
  for i=0,width/(groundPixelSize * goldBlock:getWidth())+2 do
    offset = i * groundPixelSize * goldBlock:getWidth() + groundX
    love.graphics.draw(goldBlock, offset, height-goldBlock:getHeight()*groundPixelSize, 0,groundPixelSize,groundPixelSize)
  end
  
  for i=0,width/(groundPixelSize * goldBlock:getWidth())+3 do
    offset = i * (groundPixelSize * goldBlock:getWidth()) + groundX
    love.graphics.draw(goldBlock, offset - (groundPixelSize * goldBlock:getWidth())/2, height-goldBlock:getHeight()*groundPixelSize*2, 0,groundPixelSize,groundPixelSize)
  end
  
  for i=0,width/(groundPixelSize * goldBlock:getWidth())+2 do
    offset = i * groundPixelSize * goldBlock:getWidth() + groundX
    love.graphics.draw(goldBlock, offset, height-goldBlock:getHeight()*groundPixelSize*3, 0,groundPixelSize,groundPixelSize)
  end
  
  love.graphics.setColor({1,1,1,.16})  
  for _,glass in ipairs(backgroundArray) do
    if glass.type > 0 then
      love.graphics.draw(glow,glass.x,0,0,glassPixelSize,glassPixelSize)
    end
  end
  
  love.graphics.setColor({1,1,1,1})
  for _,glass in ipairs(backgroundArray) do
    if glass.type > 0 then
      love.graphics.draw(glassSpriteArray[glass.type],glass.x,-200,0,glassPixelSize,glassPixelSize)
    end
  end
  
  love.graphics.setColor({1,1,1,1})
  for _,col in ipairs(backgroundArray) do
    if col.type == 0 then
      love.graphics.draw(columnBackground,col.x,columnBackgroundY,0,columnBackgroundPixelSize,columnBackgroundPixelSize)
    end
  end
  
  drawMote()
  
  love.graphics.setColor({1,1,1,1})
  for _,col in ipairs(columnForegroundArray) do
    love.graphics.draw(columnForeground,col.x,0,0,columnForegroundPixelSize,columnForegroundPixelSize)
  end
  
end