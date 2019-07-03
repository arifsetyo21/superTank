-- ship

local ship = {}

local sprite = love.graphics.newImage('tank_2.png')
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local speed = 0.05

ship.x = width / 2
ship.y = height
ship.dx = ship.x
ship.dy = ship.y
ship.r = 0
ship.shield = 10
ship.fuel = 42
ship.life = true
ship.height = height
ship.width = width

-- local exhtexture = love.graphics.newImage('exhaust.png')
-- local exhaust = love.graphics.newParticleSystem(exhtexture, 500)
-- exhaust:setParticleLifetime(0.5, 2)
-- exhaust:setEmissionRate(250)
-- exhaust:setSizeVariation(1)
-- exhaust:setLinearAcceleration(-5, 30, 5, 35)
-- exhaust:setColors(1, 1, 0, 1, 1, 0, 0, 0) -- Fade to transparency.

local shake = love.graphics.newParticleSystem(sprite, 2)
shake:setParticleLifetime(0.2, 0.5) 
shake:setLinearAcceleration(-50, -50, 50, 50)
shake:setSizeVariation(1)
shake:setColors(1, 1, 1, 0.6, 1, 0, 0, 0.5)

local function showInfo()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('tank shield', 10, height - 28)
  love.graphics.print('fuel', 120, height - 28)
  
  -- shield bar
  if ship.shield <= 10 and ship.shield >=7 then 
    love.graphics.setColor(0, 1, 0, 1)
  elseif ship.shield <= 6 and ship.shield >=4 then 
    love.graphics.setColor(1, 1, 0, 1)
  elseif ship.shield <= 3 then 
    love.graphics.setColor(1, 0, 0, 1) 
  end
  
  love.graphics.rectangle('line', 10, height - 15, 98, 5)
  love.graphics.rectangle('fill', 11, height - 14, 9.8 * ship.shield, 3)
  
  -- fuel bar
  if ship.fuel >= 28 then 
    love.graphics.setColor(0, 1, 0, 1)
  elseif ship.fuel >= 14 then 
    love.graphics.setColor(1, 1, 0, 1)
  elseif ship.fuel > 0 then 
    love.graphics.setColor(1, 0, 0, 1)
  else
    love.graphics.setColor(1, 1, 1, 1)
  end
  
  love.graphics.rectangle('line', 120, height - 15, 44, 5)
  love.graphics.rectangle('fill', 120, height - 14, ship.fuel, 3)
  
  love.graphics.setColor(1, 1, 1, 1)
end

function ship.reset()
  ship.r = 0
  ship.life = true
  ship.shield = 10
  ship.fuel = 42
  speed = 0.05
end

function ship.update(dt)
  if ship.life then
    if ship.fuel > 0 then
      ship.fuel = ship.fuel - 0.007
    elseif ship.fuel > 10 then
      speed = 0.01
    else
      ship.life = false
      ship.x = love.graphics.getWidth() / 2
      ship.y = love.graphics.getHeight() + 100
    end
  else
    ship.r = ship.r + 0.005
  end
          
  local vx = (ship.dx - ship.x) * speed
  local vy = (ship.dy - ship.y) * speed
    
  ship.x = ship.x + vx
  ship.y = ship.y + vy
    
  -- exhaust:update(dt)
  shake:update(dt)
end

function ship.draw()
  --if ship.life then
    --love.graphics.draw(exhaust, ship.x - 17, ship.y + 25) --roket bekas pesawat 
   -- love.graphics.draw(exhaust, ship.x + 17, ship.y + 25)
 -- end

  love.graphics.draw(sprite, ship.x, ship.y , ship.r, 1, 1, sprite:getWidth() / 2, sprite:getHeight() / 2 )
  love.graphics.draw(shake)  
  showInfo()

end

function ship.moveTo(dx, dy)
  ship.dx = dx
  ship.dy = dy
end

function ship.shake()
  shake:setRotation(ship.r)
  shake:setPosition(ship.x, ship.y)
  shake:emit(5)
end

function ship.left()
  ship.r = math.rad(270)
end

function ship.right()
  ship.r = math.rad(90)
end

function ship.up()
  ship.r = math.rad(0)
end

function ship.down()
  ship.r = math.rad(180)
end

return ship