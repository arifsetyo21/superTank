-- canon

local canon = {}

local sprite = love.graphics.newImage('missile.png')
local sound = love.audio.newSource('laser.wav', 'static')

canon.missile = {}

function canon.fire(x, y)
  local m = {}
  m.x = x
  m.y = y
  m.life = true
  table.insert(canon.missile, m)
  sound:play()
end

function canon.update()
  -- perulangan terbalik, untuk savely-removal elemen tabel
  for i = #canon.missile, 1, -1 do
    canon.missile[i].y = canon.missile[i].y - 10
    
    if (canon.missile[i].y <= -6) or (not canon.missile[i].life) then
      table.remove(canon.missile, i)
    end
  end
end

function canon.draw()
  for i = 1, #canon.missile do
    love.graphics.draw(sprite, canon.missile[i].x, canon.missile[i].y, 0, 1, 1, 1, 0)
  end
end

return canon