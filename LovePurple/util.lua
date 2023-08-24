love.graphics.setDefaultFilter( "nearest" )
width = love.graphics.getWidth()
height = love.graphics.getHeight()

function col(x)
  local temp = {}
  for i,k in ipairs(x) do
    table.insert(temp, k/255)
  end
  return temp
end

function mergeColor(col1, col2, weight)
  local newColor = {col1[1]*weight + col2[1]*(1-weight),col1[2]*weight + col2[2]*(1-weight),col1[3]*weight + col2[3]*(1-weight)}
  return newColor
end