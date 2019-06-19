-- asteroids

local asteroids = {}
local img = love.graphics.newImage('assets/musuh.png')
local et = 0

asteroids.rocks = {}

function asteroids.create(dt)
  et = et + dt
  if et >= 2 then -- create asteroid, tiap 2 detik
    local r = {}
    r.x = math.random(10, love.graphics.getWidth() - 10)
    r.y = math.random(-30, -15)
    r.a = 0
    r.life = true
  
    table.insert(asteroids.rocks, r)
    et = 0
  end
end

function asteroids.update()
  for i = #asteroids.rocks, 1, -1 do
    asteroids.rocks[i].y = asteroids.rocks[i].y + 1  -- speed musuh
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    
    if (asteroids.rocks[i].y >= love.graphics.getHeight() + 32) or (not asteroids.rocks[i].life) then
      table.remove(asteroids.rocks, i)
    end
  end
end

function asteroids.draw()
  for i = #asteroids.rocks, 1, -1 do
    love.graphics.draw(img, asteroids.rocks[i].x, asteroids.rocks[i].y, asteroids.rocks[i].a, 
      1, 1, img:getWidth() / 2, img:getHeight() / 2)
  end
end

return asteroids