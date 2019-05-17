-- canister

local canister = {}

local image = love.graphics.newImage('canister.png')
canister.x = math.random(64, love.graphics.getWidth() - 64)
canister.y = -250
canister.r = 0
canister.active = false

function canister.reset()
  canister.x = math.random(64, love.graphics.getWidth() - 64)
  canister.y = -250
  canister.r = 0
  canister.active = false
end

function canister.update()
  if canister.active then
    canister.y = canister.y + 1.5
    canister.r = canister.r + 0.01
    
    if canister.y > love.graphics.getHeight() + 16 then
      canister.reset()
    end
  end
end

function canister.draw()
  if canister.active then
    love.graphics.draw(image, canister.x, canister.y, canister.r, 1, 1, 8, 8)
  end
end

function canister.fill(ship)
  if ship.fuel < 14 then
    if not canister.active then
      canister.active = true
      return false
    end
    
    local dx = canister.x - ship.x
    local dy = canister.y - ship.y
    local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
    
    if d <= 32 then
      ship.fuel = 42
      canister.reset()
      
      return true
    end
  end
  
  return false
end

return canister