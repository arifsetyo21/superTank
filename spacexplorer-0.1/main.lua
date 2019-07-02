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
local ecanon
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

-- sqlite db
local db
local conn

-- Splash screen
local o_ten_one = require "libs/o-ten-one"
local splashy = require 'libs/splashy'
local menu = {}
menu.splash = 1
menu.main = 0

-- circular collision detection
local function checkCollision()
  for i = #asteroids.rocks, 1, -1 do
    for j = #canon.missile, 1, -1 do
      -- NOTE missiles and asteroids
      local dx = canon.missile[j].x - asteroids.rocks[i].x
      local dy = canon.missile[j].y - asteroids.rocks[i].y
      local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2)) -- distance, using hypot
      
      if d <= 30 then
        explosion.emit(asteroids.rocks[i].x, asteroids.rocks[i].y)
        canon.missile[j].life = false
        asteroids.rocks[i].life = false
        score = score + 10
        
        if score > hiscore then 
          hiscore = score 
        end
      end     
    end

    -- -- NOTE check if asteroids.rocks.y > love.graphics.getHeight()
    -- if(asteroids.rocks[i].y > love.graphics.getHeight() + 5) then
    --   asteroids.rocks[i].life = false
    -- end
    
    -- local wx = walls.x - asteroids.rocks[i].x
    -- local wy = walls.y - asteroids.rocks[i].y
    -- local w = math.sqrt(math.pow(wx, 2) + math.pow(wy, 2))
    
    -- NOTE Check COllision wall and asteroids
    -- if (CheckCollision(asteroids.rocks[i].x, asteroids.rocks[i].y, 16, 16, walls.x, walls.y, 683, 50)) then
    --   explosion.emit(asteroids.rocks[i].x, asteroids.rocks[i].y)
    --   asteroids.rocks[i].life = false
    -- end
    
    -- if (CheckCollision(ship.x, ship.y, ship.width, ship.height, walls.x, walls.y, 683, 50 )) then
    --   ship.x = ship.x + 0
    --   ship.y = ship.y + 0
    -- end
    
    
    -- NOTE check collision asteroids and ship
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

  -- NOTE check collision enemy missile with player/tank
  for k = #ecanon.missile, 1, -1 do
    local dx = ecanon.missile[k].x - ship.x
    local dy = ecanon.missile[k].y - ship.y
    local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2)) -- distance, using hypot

    -- NOTE check collision if d as trigonometry value under 30
    if d <= 30 then
      explosion.emit(ecanon.missile[k].x, ecanon.missile[k].y)
      ecanon.missile[k].life = false
      ship.shake()
      ship.shield = ship.shield - 1
      if ship.shield == 0 then
        gameover = true
        ship.life = false
        ship.moveTo(ship.x, height + 64)
      end
    end
  end

  for l = #asteroids.rocks, 1, -1 do
    for m = #asteroids.rocks, 1, -1 do
      local dx = asteroids.rocks[l].x - asteroids.rocks[m].x
      local dy = asteroids.rocks[l].y - asteroids.rocks[m].y
      local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2)) -- distance, using hypot
      
    end 
  end

end

-- show score, hi-schore, and shield-bar
local function showHUD()
  love.graphics.setColor(1, 1, 1, 1)
  if score == hiscore then love.graphics.setColor(1, 1, 0, 1) end
  love.graphics.print('score: ' .. score, 10, 10)
  love.graphics.print('hi-score: ' .. hiscore, width - 135, 10)
  
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

  -- NOTE splash screen load
  entry = {module="o-ten-one", {fill="lighten"}}
  splash = o_ten_one(unpack(entry))
  -- splash.onDone = function()  end

  -- NOTE Main menu load
  splashy.addSplash(love.graphics.newImage("assets/mainMenu.jpg"))
  splashy.onComplete(function() drawAll() end)

  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
  centerX = width / 2
  centerY = height / 2
  
  shipAnchorY = centerY + 120
  
  -- NOTE Main Menu Button
  btn_play = love.graphics.newImage('assets/button/button_play_1.png')
  btn_exit = love.graphics.newImage('assets/button/button_exit_1.png')
  btn_hc = love.graphics.newImage('assets/button/button_high-score_1.png')
  btn_back = love.graphics.newImage('assets/button/button_back_1.png')

  ----Back sound game super tank
  bgmusic = love.audio.newSource('backsound_tank.mp3', 'stream')
  bgmusic:setLooping(true)
  bgmusic:setVolume(0.6)
  engine = love.audio.newSource('tank_idle.mp3', 'stream')
  engine:setLooping(true)
  engine:setVolume(0.7)
  tembak_musuh = love.audio.newSource('assets/peluru_musuh.wav', 'stream')
  tembak_musuh:setVolume(0.9)
  dialog = love.audio.newSource('assets/dialog.mp3', 'stream')
  dialog:setVolume(0.7)

  bgspace = require('bgspace')
  
  ship = require('ship')
  ship.moveTo(centerX, shipAnchorY)
  
  canon = require('canon')
  ecanon = require('ecanon')
  stars = require('stars')
  asteroids = require('asteroids')
  aidkit = require('aidkit')
  canister = require('canister')
  explosion = require('explosion')
  powerup = require('powerup')
  walls = require('walls')
  
  font = love.graphics.newFont('whitrabt.ttf' , 16)
  love.graphics.setFont(font)
  
  gameoverImg = love.graphics.newImage('gameover.png')
  playImg = love.graphics.newImage('play.png')
  
  score = 0
  hiscore = 0
  gameover = false

	--I organized this way: "x", "y", "width", "height", "function", "arguments in a table or nil"
	--I think it's easier to use width and height instead of first x/y and last x/y
  
end

function love.update(dt)

  bgspace.update()
  stars.update()
  
  aidkit.update()
  canister.update()
  
  ship.update(dt)
  canon.update()
  
  ecanon.update()
  asteroids.update()

  explosion.update(dt)
  powerup.update(dt)
  
  if menu.splash == 3 then
    if ship.fuel <= 0 then
      gameover = true
      ship.moveTo(ship.x, (shipAnchorY + 400))
    end
    
    if not gameover then
      asteroids.create(dt)
      fire_tank_musuh() 
      checkCollision()
      
      if aidkit.heal(ship) or canister.fill(ship) then
        powerup.emit(ship.x, ship.y)
      end
    end
    
    dialog:play()
    -- Tambah kondisi apabila gameover, ship tidak bisa digerakkan
                                              
    if not gameover then
      if love.keyboard.isDown('left') then
        -- Kecepatan berjalan ship
        ship.x = ship.x - 2
        -- Mengubah posisi ship
        ship.moveTo(ship.x, ship.y)
        -- Menentukan rotasi ship sesuai arahnya
        ship.left()
        -- Memainkan soundFx engine ketika tombol ditekan
        engine:play()
      elseif love.keyboard.isDown('right') then
        
        --batasan tembok objek tidak bisa lewat jikake atas
        ship.x = ship.x + 2
        ship.moveTo(ship.x, ship.y)
        ship.right()
        engine:play()
      elseif love.keyboard.isDown('down') then
        --batasan tembok objek tidak bisa lewat jika ke bawah
        ship.y = ship.y + 2
        ship.moveTo(ship.x, ship.y)
        ship.down()
        engine:play()
      elseif love.keyboard.isDown('up') then  
        -- objek tidak bisa naik ke atas 
        ship.y = ship.y - 2
        ship.moveTo(ship.x, ship.y)
        ship.up()
        engine:play()        
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
    elseif love.keyboard.isDown('o') then
      menu.splash = 2
      splash:skip()
    elseif love.keyboard.isDown('t') then
      menu.splash = 3
    end
  end

  if love.keyboard.isDown('o') and menu.splash == 1 then 
    menu.splash = 2
    splash:skip()
  end
    
  math.randomseed( os.clock() )
  interval = math.random(27, 1000)
  
  splash:update(dt*0.5)
  splashy.update(dt*0.01)
end

function love.draw()
  
  if( menu.splash == 1) then
    splash:draw()
    love.graphics.print("press 'O' key", (love.graphics.getWidth() / 2) - 100, (love.graphics.getHeight() / 2) + 300, 0, 1.5, 1.5)
  elseif( menu.splash == 2) then
    drawMenu()
    bgmusic:play()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(btn_play, (love.graphics.getWidth() / 2) - 110, (love.graphics.getHeight() / 2), 0)
    love.graphics.draw(btn_hc, (love.graphics.getWidth() / 2) - 150, (love.graphics.getHeight() / 2) + 50, 0)
    love.graphics.draw(btn_exit, (love.graphics.getWidth() / 2) - 110, (love.graphics.getHeight() / 2) + 100, 0)
  elseif ( menu.splash == 3 ) then
    -- splashy.skipAll()
    drawAll()
  elseif ( menu.splash == 4) then
    displayHighScore()
  elseif ( menu.splash == 5) then
    exit()
  end
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
    elseif not gameover then
      local dx = ((love.graphics.getWidth()/2)-80) - x
      local dy = (love.graphics.getHeight()/2) - y
      local d = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
      
      if d <= 30 then
        menu.splash = 3
      end
    -- else
    --   ship.moveTo(x, shipAnchorY)
    --   -- canon.fire(ship.x, shipAnchorY, ship.r)
    --   canon.fire(ship.x, ship.y, ship.r)
    end
  end
end

-- function love.mousemoved(x, y)
--   if love.mouse.isDown(1) then
--     if not gameover then
--       ship.moveTo(x, shipAnchorY)
--     end
--   end
-- end


-- S

-- function love.keypressed()
  
-- end

function drawAll()

  love.graphics.setColor(1, 1, 1, 1)
  bgspace.draw()
  
  stars.draw()
  walls.draw()

  -- NOTE gambar musuh dan pelurunya
  ecanon.draw()
  asteroids.draw()

  -- NOTE gambar player dan pelurunya
  canon.draw()
  ship.draw()

  -- NOTE gambar addons
  aidkit.draw()
  canister.draw()
  explosion.draw()
  powerup.draw()

  showHUD()
end

-- function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
--   return x1 == x2+w2 and
--          x2 == x1+w1 and
--          y1 == y2+h2 and
--          y2 == y1+h1
-- end

function fire_tank_musuh()  
  for m = #asteroids.rocks, 1, -1 do
    
    if (asteroids.rocks[m] == nil) then 
    else
    -- TODO lakukan tembakan acak setiap beberapa detik, dengan tank yang acak juga
      if( m % 2 == 0) then
        if ( interval % 20 == 0) then
          if (ecanon.missile[m] == nil) then
            ecanon.fire(asteroids.rocks[m].x, asteroids.rocks[m].y, asteroids.rocks[m].r)
            tembak_musuh:play()
          -- else
          end
      -- end
        end
      elseif (m % 3 == 0) then
        if ( interval % 21 == 0) then
          if (ecanon.missile[m] == nil) then
            ecanon.fire(asteroids.rocks[m].x, asteroids.rocks[m].y, asteroids.rocks[m].r)
            tembak_musuh:play()
          -- else
          end
        -- end
        end
      elseif (m % 7 == 0) then 
        if ( interval % 22 == 0) then
          if (ecanon.missile[m] == nil) then
            ecanon.fire(asteroids.rocks[m].x, asteroids.rocks[m].y, asteroids.rocks[m].r)
            tembak_musuh:play()          
          end
        end  
      else
        if (m == 1) then
          if ( interval % 23 == 0) then
            if (ecanon.missile[m] == nil) then
              ecanon.fire(asteroids.rocks[m].x, asteroids.rocks[m].y, asteroids.rocks[m].r)
              tembak_musuh:play()            
            end
          end
        end
      end
    end    
  end
end

function drawMenu()
  splashy.draw()
end

function love.keypressed(key)
  if key == "u" then
    menu.main = 1
    resetGame()
    love.event.push("quit")
  end
end
