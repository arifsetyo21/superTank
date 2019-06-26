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

-- bump.lua
local world
local bump

------------
-- add bump
------------

-- collision with bump
local player = { x=50,y=50,w=20,h=20, speed = 80 }
local cols_len = 0 -- how many collision are happening

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
  
  -- Add bump
  bump = require('bump')
  
  world = bump.newWorld()
  
  font = love.graphics.newFont('whitrabt.ttf')
  love.graphics.setFont(font)
  
  gameoverImg = love.graphics.newImage('gameover.png')
  playImg = love.graphics.newImage('play.png')
  
  score = 0
  hiscore = 0
  gameover = false
  
  bgmusic:play()
  
  world:add(player, player.x, player.y, player.w, player.h)

  -- addBlock(0,0,800,32)
  -- addBlock(0,32,32,600-32*2)
  -- addBlock(800-32,32,32, 600-32*2)
  -- addBlock(0,600-32,800,32)

  --for i=1,30 do
  --  addBlock( math.random(100, 600),
              --math.random(100, 400),
              --math.random(10, 100),
              --math.random(10, 100)
    --)
  --end
  
end

local function updatePlayer(dt)
  local speed = player.speed

  local dx, dy = 0, 0
  if love.keyboard.isDown('right') then
    dx = speed * dt
  elseif love.keyboard.isDown('left') then
    dx = -speed * dt
  end
  if love.keyboard.isDown('down') then
    dy = speed * dt
  elseif love.keyboard.isDown('up') then
    dy = -speed * dt
  end

  if dx ~= 0 or dy ~= 0 then
    local cols
    player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
    for i=1, cols_len do
      local col = cols[i]
      consolePrint(("col.other = %s, col.type = %s, col.normal = %d,%d"):format(col.other, col.type, col.normal.x, col.normal.y))
    end
  end
end

local function drawPlayer()
  drawBox(player, 0, 255, 0)
end

-- Block functions

local blocks = {}

local function addBlock(x,y,w,h)
  local block = {x=x,y=y,w=w,h=h}
  blocks[#blocks+1] = block
  world:add(block, x,y,w,h)
end

local function drawBlocks()
  for _,block in ipairs(blocks) do
    drawBox(block, 255,0,0)
  end
end

local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,70)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
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
  
  -- add bump
  cols_len = 0
  updatePlayer(dt)
  
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
      if (CheckCollision(ship.x, ship.y, ship.width, ship.height, 180, walls.y, 683, 50 )) then
        ship.x = ship.x + 0
        ship.right()
      else
        ship.x = ship.x + 2
        ship.moveTo(ship.x, ship.y)
        ship.right()
        engine:play()
      end
    elseif love.keyboard.isDown('down') then
      ship.y = ship.y + 2
      ship.moveTo(ship.x, ship.y)
      ship.down()
      engine:play()
    elseif love.keyboard.isDown('up') then
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
  
  drawBlocks()
  drawPlayer()
  drawMessage()
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

function CheckCollision(ax1, ay1, aw, ah, bx1, by1, bw, bh)
  local ax2, ay2, bx2, by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and
         ax2 > bx1 and
         ay1 < by2 and
         ay2 > by1
end
