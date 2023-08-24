--Purple 8/20/2023
--https://coolors.co/palette/310055-3c0663-4a0a77-5a108f-6818a5-8b2fc9-ab51e3-bd68ee-d283ff-dc97ff
require("util")
require("flame")
require("cavern")

speed = -200

function love.load()
  math.randomseed(os.time())
end

function love.update(dt)
  updateCavern(dt, speed)
  updateFlame(dt, speed)
end

function love.draw()
  drawCavern()
  drawFlame()
end