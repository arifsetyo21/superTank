---------------------------------------------------------------------------
-- SpaceXplorer
-- main.lua
-- Main program
-- credit:
--   BG Music: Cavern and Blade (Open Game Art)
---------------------------------------------------------------------------

-- coordinat
local centerX
local centerY
local shipAnchorY
local height
local width

-- music and font
local bgmusic
local font

-- references for game objects
local ship
local bgspace 
local canon
local stars
local asteroids
local aidkit
local canister
local explosion
local powerup
local walls

-- score and button
local score
local hiscore
local gameover
local gameoverImg
local playImg

-- circular collision detection
local function checkCollision()
  for i = #asteroids.rocks, 1, -1 do
    for j = #canon.missile, 1, -1 do
      -- missiles and asteroids
      local dx = canon.missile[j].x - asteroids.rocks[i].x
      local dy = canon.missile[j].y - asteroids.rocks[i].y
      local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2)) -- distance, using hypot
      
      if d <= 16 then
        explosion.emit(asteroids.rocks[i].x, asteroids.rocks[i].y)
        canon.missile[j].life = false
        asteroids.rocks[i].life = false
        score = score + 10
        
        if score > hiscore then 
          hiscore = score 
        end
      end     
    end
    
    local wx = walls.x - asteroids.rocks[i].x
    local wy = walls.y - asteroids.rocks[i].y
    local w = math.sqrt(math.pow(wx, 2) + math.pow(wy, 2))
    
    -- Check COllision wall and asteroids
    if (CheckCollision(asteroids.rocks[i].x, asteroids.rocks[i].y, 16, 16, walls.x, walls.y, 683, 50)) then
      explosion.emit(asteroids.rocks[i].x, asteroids.rocks[i].y)
      asteroids.rocks[i].life = false
    end
    
    if (CheckCollision(ship.x, ship.y, ship.width, ship.height, walls.x, walls.y, 683, 50 )) then
      ship.x = ship.x + 0
      ship.y = ship.y + 0
    end
    
    
    -- asteroids and ship
    local dx = asteroids.rocks[i].x - ship.x
    local dy = asteroids.rocks[i].y - ship.y
    local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2)) -- distance, using hypot
      
    if d <= 85 then
      explosion.emit(asteroids.rocks[i].x, asteroids.rocks[i].y)
      asteroids.rocks[i].life = false
      ship.shake()
      ship.shield = ship.shield - 1
      
      if ship.shield == 0 then
        gameover = true
        ship.life = false
        ship.moveTo(ship.x, height + 64)
      end
    end
  end
end

-- show score, hi-schore, and shield-bar
local function showHUD()
  love.graphics.setColor(1, 1, 1, 1)
  if score == hiscore then love.graphics.setColor(1, 1, 0, 1) end
  love.graphics.print('score: ' .. score, 10, 10)
  love.graphics.print('hi-score: ' .. hiscore, width - 125, 10)
  
  if gameover then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameoverImg, centerX, centerY, 0, 1, 1, 100, 23)
    love.graphics.draw(playImg, centerX, shipAnchorY, 0, 1, 1, 24, 24)
  end
end

function resetGame()
  gameover = false
  score = 0
  aidkit.reset()
  ship.reset()
   
  ship.moveTo(centerX, shipAnchorY)
end

function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
  centerX = width / 2
  centerY = height / 2
  
  shipAnchorY = centerY + 75
  
    ----Back sound game super tank
    
      bgmusic = love.audio.newSource('backsound_tank.mp3', 'stream')
      bgmusic:setLooping(true)
      bgmusic:setVolume(0.4)
      engine = love.audio.newSource('tank_idle.mp3', 'stream')
      engine:setLooping(true)
      engine:setVolume(0.7)
  
  bgspace = require('bgspace')
  
  ship = require('ship')
  ship.moveTo(centerX, shipAnchorY)
  
  canon = require('canon')
  stars = require('stars')
  asteroids = require('asteroids')
  aidkit = require('aidkit')
  canister = require('canister')
  explosion = require('explosion')
  powerup = require('powerup')
  walls = require('walls')
  
  font = love.graphics.newFont('whitrabt.ttf')
  love.graphics.setFont(font)
  
  gameoverImg = love.graphics.newImage('gameover.png')
  playImg = love.graphics.newImage('play.png')
  
  score = 0
  hiscore = 0
  gameover = false
  
  bgmusic:play()
  
end

function love.update(dt)
  bgspace.update()
  stars.update()
  
  aidkit.update()
  canister.update()
  
  ship.update(dt)
  canon.update()
  
  asteroids.update()
  explosion.update(dt)
  powerup.update(dt)
  
  if ship.fuel <= 0 then
    gameover = true
    ship.moveTo(ship.x, shipAnchorY + 100)
  end
  
  if not gameover then
    asteroids.create(dt)  
    checkCollision()
    
    if aidkit.heal(ship) or canister.fill(ship) then
      powerup.emit(ship.x, ship.y)
    end
  end
  
  -- Tambah kondisi apabila gameover, ship tidak bisa digerakkan
  if not gameover then
    if love.keyboard.isDown('left') then
      
      
         if (ship.x+70 < 1160 and ship.x > 340) then
              if(ship.y+30 > 360 and ship.y-30 < 410 ) then
                ship.x = ship.x - 0
                ship.left()
              else
                ship.x = ship.x - 2
                ship.moveTo(ship.x, ship.y)
                ship.left()
                engine:play()           
                
                end
          else      
      
              
              -- Kecepatan berjalan ship
              ship.x = ship.x - 2
              -- Mengubah posisi ship
              ship.moveTo(ship.x, ship.y)
              -- Menentukan rotasi ship sesuai arahnya
              ship.left()
              -- Memainkan soundFx engine ketika tombol ditekan
              engine:play()
      end
    elseif love.keyboard.isDown('right') then
      --batasan tembok objek tidak bisa lewat jikake atas
          if (ship.x+70 < 1160  and ship.x > 340) then
              if(ship.y+30 > 360 and ship.y-30 < 410 ) then
                ship.x = ship.x + 0
                ship.right()
              else
                ship.x = ship.x + 2
                ship.moveTo(ship.x, ship.y)
                ship.right()
                engine:play()           
                
                end
          else
            ship.x = ship.x + 2
            ship.moveTo(ship.x, ship.y)
            ship.right()
            engine:play()
          end
    elseif love.keyboard.isDown('down') then
      
       --batasan tembok objek tidak bisa lewat jika ke bawah
      if (ship.y+70 > 360  and ship.y+70 < 410) then
              if(ship.x+30 > 341 and ship.x-30 < 1024 ) then
                    ship.y = ship.y + 0
                    ship.down()
                else
                    ship.y = ship.y + 2
                    ship.moveTo(ship.x, ship.y)
                    ship.down()
                    engine:play()          
                
              end
      else
        ship.y = ship.y + 2
        ship.moveTo(ship.x, ship.y)
        ship.down()
        engine:play()
      end
    elseif love.keyboard.isDown('up') then
      
      -- objek tidak bisa naik ke atas 
             if (ship.y-65 < 410 and ship.y-65 > 360 )then
                    if(ship.x+30 > 341 and ship.x-30 < 1024 ) then
                    ship.y = ship.y - 0
                    ship.up()
                else
                  ship.y = ship.y - 2
                  ship.moveTo(ship.x, ship.y)
                  ship.up()
                  engine:play()
                end
            else     
            
                ship.y = ship.y - 2
                ship.moveTo(ship.x, ship.y)
                ship.up()
                engine:play()
            end
    else
      engine:stop()
    end

  end
  
  -- Tambah kodisi ketika gameover tidak bisa eksekusi canon.fire
  if love.keyboard.isDown('a') then    
    if not gameover then
      if (#canon.missile == 0) then
        canon.fire(ship.x, ship.y, ship.r)
      end
    end
  -- tambah tombol 'r' untuk reset gameover
  elseif love.keyboard.isDown('r') and gameover then
    resetGame()
  end
    
  
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  
  bgspace.draw()
  
  stars.draw()
  walls.draw()
  asteroids.draw()
  canon.draw()
  ship.draw()
  aidkit.draw()
  canister.draw()
  explosion.draw()
  powerup.draw()
  
  showHUD()
  
  
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if gameover then
      local dx = centerX - x
      local dy = shipAnchorY - y
      local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
      
      if d <= 24 then
        resetGame()
      end
    else
      ship.moveTo(x, shipAnchorY)
      -- canon.fire(ship.x, shipAnchorY, ship.r)
      canon.fire(ship.x, ship.y, ship.r)
    end
  end
end

function love.mousemoved(x, y)
  if love.mouse.isDown(1) then
    if not gameover then
      ship.moveTo(x, shipAnchorY)
    end
  end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 == x2+w2 and
         x2 == x1+w1 and
         y1 == y2+h2 and
         y2 == y1+h1
end