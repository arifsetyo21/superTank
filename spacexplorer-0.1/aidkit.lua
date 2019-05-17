-- aidkit

local aidkit = {}

local image = love.graphics.newImage('aidkit.png')

aidkit.x = math.random(64, love.graphics.getWidth() - 64)
aidkit.y = -250
aidkit.r = 0
aidkit.active = false

function aidkit.reset()
  aidkit.x = math.random(64, love.graphics.getWidth() - 64)
  aidkit.y = -250
  aidkit.r = 0
  aidkit.active = false
end

function aidkit.update()
  if aidkit.active then
    aidkit.y = aidkit.y + 1.5
    aidkit.r = aidkit.r + 0.01
    
    if aidkit.y > love.graphics.getHeight() + 16 then
      aidkit.reset()
    end
  end
end

function aidkit.draw()
  if aidkit.active then
    love.graphics.draw(image, aidkit.x, aidkit.y, aidkit.r, 1, 1, 8, 8)
  end
end

function aidkit.heal(ship)
  if ship.shield < 2 then
    if not aidkit.active then
      aidkit.active = true
      return false
    end
    
    local dx = aidkit.x - ship.x
    local dy = aidkit.y - ship.y
    local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
    
    if d <= 32 then
      ship.shield = 3
      aidkit.reset()
      
      return true
    end
  end
  
  return false
end

return aidkit