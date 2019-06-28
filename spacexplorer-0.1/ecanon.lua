-- NOTE ecanon is canon for enemy
-- TODO Add missile to enemy

local ecanon = {}

local sprite = love.graphics.newImage('missile.png')

ecanon.missile = {}
local rot

function ecanon.fire(x, y, rad)
  local m = {}
  m.x = x
  m.y = y
  m.r = rad
  m.life = true
  table.insert(ecanon.missile, m)  
end

function ecanon.update()
  -- perulangan terbalik, untuk savely-removal elemen tabel
  for i = #ecanon.missile, 1, -1 do
    -- Cek rotasi tank untuk menentukan rotasi peluru dan arah jalan peluru
    -- peluru arah ke kiri
    if (ecanon.missile[i].r == math.rad(270)) then
      ecanon.missile[i].x = ecanon.missile[i].x - 20
    -- peluru arah ke atas
    elseif (ecanon.missile[i].r == math.rad(0)) then
      ecanon.missile[i].y = ecanon.missile[i].y - 20
    -- peluru arah ke kanan
    elseif (ecanon.missile[i].r == math.rad(90)) then
      ecanon.missile[i].x = ecanon.missile[i].x + 20
    -- peluru arah ke bawah
    elseif (ecanon.missile[i].r == math.rad(180)) then
      ecanon.missile[i].y = ecanon.missile[i].y + 20
    end
    
    -- menghilangkan missile ketika missile sampai pada batas window
    -- atau ketika ecanon.life berubah menjadi false saat menabrak sesuatu
    if (ecanon.missile[i].y <= 0) or (not ecanon.missile[i].life) then
      table.remove(ecanon.missile, i)
    elseif (ecanon.missile[i].y >= love.graphics.getHeight()) or (not ecanon.missile[i].life) then
      table.remove(ecanon.missile, i)
    elseif (ecanon.missile[i].x <= 0) or (not ecanon.missile[i].life) then
      table.remove(ecanon.missile, i)
    elseif (ecanon.missile[i].x >= love.graphics.getWidth()) or (not ecanon.missile[i].life) then
      table.remove(ecanon.missile, i)
    end
  end
end

function ecanon.draw()
  -- perulangan untuk menggambarkan ecanon
  for i = 1, #ecanon.missile do
    love.graphics.draw(sprite, ecanon.missile[i].x, ecanon.missile[i].y, ecanon.missile[i].r, 1, 1, 1, 0)
  end
end
return ecanon