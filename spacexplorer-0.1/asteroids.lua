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
    r.r = math.rad(180)
    r.speed = 1
  
    table.insert(asteroids.rocks, r)
    et = 0
  end
end



function asteroids.update()
  
 
  
  
  
  for i = #asteroids.rocks, 1, -1 do 
  -- TODO buat arah acak setiap beberapa detik sekali
    if(asteroids.rocks[i].y < 300 )then --  cek posisi musuh untuk belok 
    
    -- FIXME change arrow enemy, syncron with its movement
      -- asteroids.rocks[i].y = asteroids.rocks[i].y + 1  -- speed musuh
      -- asteroids.rocks[i].a = asteroids.rocks[i].a 
      -- asteroids.rocks[i].r = math.rad(180)

      asteroids.movement(i, 'down')
    
    elseif(asteroids.rocks[i].x < 300) then  -- pindah ke x jika posisi piksel di 300
      asteroids.rocks[i].x = asteroids.rocks[i].x + asteroids.rocks[i].speed
      asteroids.rocks[i].a = asteroids.rocks[i].a 
      asteroids.rocks[i].r = math.rad(90)
     
    elseif (asteroids.rocks[i].x > 600) then
      asteroids.rocks[i].x = asteroids.rocks[i].x - 1 -- pindah ke posisi x jika posisi 600
      asteroids.rocks[i].a = asteroids.rocks[i].a 
      asteroids.rocks[i].r = math.rad(270)
    else
      -- asteroids.rocks[i].y = asteroids.rocks[i].y + 1  -- speed musuh
      -- asteroids.rocks[i].a = asteroids.rocks[i].a 
      -- asteroids.rocks[i].r = math.rad(180)
      asteroids.movement(i, 'down')
    end
  
  
    if (not asteroids.rocks[i].life) then -- jika musuh mati maka hapus dari array 
      table.remove(asteroids.rocks, i)
    end
     end
        
end
    
  

function asteroids.draw()
  for i = #asteroids.rocks, 1, -1 do
    love.graphics.draw(img, asteroids.rocks[i].x, asteroids.rocks[i].y, asteroids.rocks[i].r, 
      1, 1, img:getWidth() / 2, img:getHeight() / 2)
  end
end

function asteroids.movement( i, key)
  if(key == 'down') then
    asteroids.rocks[i].y = asteroids.rocks[i].y + asteroids.rocks[i].speed  -- speed musuh
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    asteroids.rocks[i].r = math.rad(180)
  elseif(key == 'left') then
    asteroids.rocks[i].x = asteroids.rocks[i].x - asteroids.rocks[i].speed -- pindah ke posisi x jika posisi 600
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    asteroids.rocks[i].r = math.rad(270)
  elseif(key == 'right') then
    asteroids.rocks[i].x = asteroids.rocks[i].x + asteroids.rocks[i].speed
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    asteroids.rocks[i].r = math.rad(90)
  elseif(key == 'up') then
    asteroids.rocks[i].y = asteroids.rocks[i].y - asteroids.rocks[i].speed  -- speed musuh
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    asteroids.rocks[i].r = math.rad(0)
  end
end

return asteroids