-- tank

local tank = {}

tank.type = 'tank'
sprite = love.graphics.newImage('tank.png')
local speed = 0.05
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

tank.x = width / 2
tank.y = height / 2 
tank.dx = tank.x
tank.dy = tank.y
tank.r = 0
tank.shield = 3
tank.fuel = 42
tank.life = true
tank.height = sprite:getHeight()
tank.width = sprite:getWidth()

local function showInfo()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('shield', 10, height - 28)
  love.graphics.print('fuel', 75, height - 28)

  -- shield bar
  if tank.shield == 3 then
    love.graphics.setColor(0, 1, 0, 1)
  elseif tank.shield == 2 then
    love.graphics.setColor(1, 1, 0, 1)
  elseif tank.shield == 1 then
    love.graphics.setColor(1, 0, 0, 1)
  end

  love.graphics.rectangle('line', 10, height - 15, 44, 5)
  love.graphics.rectangle('fill', 11, height - 14, 14 * tank.shield, 3)

  -- fuel bar
  if tank.fuel >= 28 then
    love.graphics.setColor(0, 1, 0, 1)
  elseif tank.fuel >= 14 then
    love.graphics.setColor(1, 1, 0, 1)
  elseif tank.fuel > 0 then
    love.graphics.setColor(1, 0, 0, 1)
  else
    love.graphics.setColor(1, 1, 1, 1)
  end

  love.graphics.rectangle('line', 75, height - 15, 44, 5)
  love.graphics.rectangle('fill', 76, height - 14, tank.fuel, 3)

  love.graphics.setColor(1, 1, 1, 1)
end

function tank.reset()
   tank.r = 0
   tank.life = true
   tank.shield = 3
   tank.fuel = 42
   speed = 0.5
end
 
function tank.update(dt)

  local vx = (tank.dx - tank.x) * speed
  local vy = (tank.dy - tank.y) * speed

  tank.x = tank.x + vx
  tank.y = tank.y + vy
end

function tank.draw()
  love.graphics.setColor(50,50,50,1)
  love.graphics.draw(sprite, tank.x, tank.y, 3.15, 1, 1, tank.width, tank.height )
  -- love.graphics.rotate(1)
  love.graphics.rectangle('line', tank.x, tank.y, tank.width, tank.height)
  -- showInfo()
end

function tank.moveTo(dx, dy)
  tank.dx = dx
  tank.dy = dy
end

function tank.shake()
  shake:setPosition(tank.x, tank.y)
  shake:emit(5)
end

function tank.left()
  tank.r = math.rad(270)
end

function tank.right()
  tank.r = math.rad(90)
end

function tank.up()
  tank.r = math.rad(0)
end

function tank.down()
  tank.r = math.rad(180)
end


-- HARUS PAKE OOP
-- function tank.setVar(value)
--   var = value
-- end

-- function tank.getVar()
--   return var
-- end

return tank