--Gold 8/21/2023
--https://coolors.co/palette/ff7b00-ff8800-ff9500-ffa200-ffaa00-ffb700-ffc300-ffd000-ffdd00-ffea00

require("util")
require("hall")
require("mote")

speed = -100
function love.load()
  math.randomseed(os.time())
end

function love.update(dt)
  updateMote(dt,speed)
  updateHall(dt, speed)
end

function love.draw()
  drawHall()  --draw mote is run within drawHall()
end