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
    
    if( asteroids.rocks[i].y > 125 and  asteroids.rocks[i].x > 200  and asteroids.rocks[i].x < 300)then -- cek posisi musuh untuk belok
      
    asteroids.rocks[i].x = asteroids.rocks[i].x + 1  -- speed musuh
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    
    
    elseif( asteroids.rocks[i].y > 145 and  asteroids.rocks[i].x > 400  and asteroids.rocks[i].x < 750)then -- cek posisi musuh untuk belok
      
    asteroids.rocks[i].x = asteroids.rocks[i].x - 1  -- speed musuh
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    
    
    
  elseif(asteroids.rocks[i].y > 155 and  asteroids.rocks[i].x > 500 and asteroids.rocks[i].x < 900 ) then  -- pindah ke x jika posisi piksel di 300
    
    asteroids.rocks[i].x = asteroids.rocks[i].x + 1
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    
  elseif(asteroids.rocks[i].y > 650 and asteroids.rocks[i].x > 700) then  -- pindah ke x jika posisi piksel di 300
    
    asteroids.rocks[i].x = asteroids.rocks[i].x - 1
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    
    elseif(asteroids.rocks[i].y > 650 and asteroids.rocks[i].x < 700) then  -- pindah ke x jika posisi piksel di 300
    
    asteroids.rocks[i].x = asteroids.rocks[i].x + 1
    asteroids.rocks[i].a = asteroids.rocks[i].a      
     
  else
    
    asteroids.rocks[i].y = asteroids.rocks[i].y + 1  -- speed musuh
    asteroids.rocks[i].a = asteroids.rocks[i].a 
    
  end
  
  
    if (not asteroids.rocks[i].life) then -- jika musuh mati maka hapus dari array 
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