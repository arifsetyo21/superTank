-- canon

local canon = {}

local sprite = love.graphics.newImage('missile.png')
local sound = love.audio.newSource('laser.wav', 'static')

canon.missile = {}
local rot

function canon.fire(x, y, rad)
  
  local m = {}
  m.x = x
  m.y = y
  m.r = rad
  m.life = true
  table.insert(canon.missile, m)
  sound:play()
end

function canon.update()
  -- perulangan terbalik, untuk savely-removal elemen tabel
  for i = #canon.missile, 1, -1 do
    if (canon.missile[i].r == math.rad(270)) then
      canon.missile[i].x = canon.missile[i].x - 10
    elseif (canon.missile[i].r == math.rad(0)) then
      canon.missile[i].y = canon.missile[i].y - 10
    elseif (canon.missile[i].r == math.rad(90)) then
      canon.missile[i].x = canon.missile[i].x + 10
    elseif (canon.missile[i].r == math.rad(180)) then
      canon.missile[i].y = canon.missile[i].y + 10
    end
    
    if (canon.missile[i].y <= -1) or (not canon.missile[i].life) then
      table.remove(canon.missile, i)
    end
  end
end

function canon.draw()
  for i = 1, #canon.missile do
    love.graphics.draw(sprite, canon.missile[i].x, canon.missile[i].y, canon.missile[i].r, 1, 1, 1, 0)
  end
end
return canon