-- Super Tank
-- main.lua
-- main program

-- coordinate
local centerX
local centerY
local height
local width

-- music and font
local bgmusic
local font

-- reference game object
local tank 
local canon

-- add lib bump and world for collision
local bump
local world

-- test
local var = 10
local rate = 3

local consoleBuffer = {}
local consoleBufferSize = 15
for i=1,consoleBufferSize do consoleBuffer[i] = "" end
local function consolePrint(msg)
  table.remove(consoleBuffer,1)
  consoleBuffer[consoleBufferSize] = msg
end

local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,70)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  -- love.graphics.setColor(r,g,b)
  -- love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

local blocks = {}

local function addBlock(x,y,w,h)
  local block = {x=x,y=y,w=w,h=h,type='block'}
  blocks[#blocks+1] = block
  world:add(block, x,y,w,h)
end

local function drawBlocks()
  for _,block in ipairs(blocks) do
    drawBox(block, 255,255,0)
  end
end


local function drawDebug()
  bump_debug.draw(world)

  local statistics = '' --("fps: %d, mem: %dKB, collisions: %d, items: %d"):format(love.timer.getFPS(), collectgarbage("count"), cols_len, world:countItems())
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(statistics, 0, 580, 790, 'right')
end

local function drawConsole()
  local str = table.concat(consoleBuffer, "\n")
  for i=1,consoleBufferSize do
    love.graphics.setColor(255,255,255, i*255/consoleBufferSize)
    love.graphics.printf(consoleBuffer[i], 100, 580-(consoleBufferSize - i)*12, 790, "left") -- 
  end
end


-- Base function love.load()
function love.load()

   width = love.graphics.getWidth()
   height = love.graphics.getHeight()

   centerX = width / 2
   centerY = height / 2

   -- add bump 
   bump = require('bump')

    --  add asset
   tank = require('tank')
   canon = require('canon')
   tank.moveTo(centerX, centerY)

   bump_debug = require('bump_debug')

   world = bump.newWorld()

   addBlock(0,       0,     1366, 32)
   addBlock(0,      32,      32, 720-32*2)
   addBlock(1366-32, 32,      32, 720-32*2)
   addBlock(0,      720-32, 1366, 32)

   addItem(tank)

end

-- base function love.update(dt)
function love.update(dt)
   local goalX, goalY = tank.x, tank.y
   if love.keyboard.isDown("d") then
      goalX = tank.x + 2000 * dt
	elseif love.keyboard.isDown("a") then
      goalX = tank.x - 2000 * dt
	end

	if love.keyboard.isDown("s") then
    goalY = tank.y + 2000 * dt
	elseif love.keyboard.isDown("w")  then
    goalY = tank.y - 2000 * dt
  end
   
  local cols
  local actualX, actualY, cols, cols_len = world:move(tank, goalX, goalY, playerFilter)
  local totalHeight = love.graphics.getHeight()
	for i=1, cols_len do
		local col  = cols[i]
		-- if(col.type == 'touch') then
		-- 	world:remove(col.other)
		-- end
		consolePrint(("col.item = %s, col.other = %s, col.type = %s, col.normal = %d,%d, T= %d"):format(col.item,col.other, col.type, col.normal.x, col.normal.y, totalHeight))
	end

   tank.moveTo(actualX, actualY)
   tank.update(dt)
end

-- base function love.draw()
function love.draw()

  canon.draw()
  tank.draw()

   -- love.graphics.setColor(255, 255, 255)
   -- love.graphics.rectangle("fill", tank.thing.x, tank.thing.y, tank.thing.size, tank.thing.size)
   drawBlocks()
   if shouldDrawDebug then
		drawDebug()
		drawConsole()
	end
end

function addItem(item)
   world:add(item, item.x, item.y, item.width, item.height)
end

function playerFilter(item, other)
	if other.type == "block" then
		return "touch"
	elseif other.type == "notSolidWall" then
      return "cross"
   -- end   
   else 
      return "slide"
   end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
  if key == "tab"    then shouldDrawDebug = not shouldDrawDebug end
  if key == "e" then canon.fire(tank.x, tank.y) end
end

-- CATATAN
--  Setiap Object harus terdiri dari
--  type = "block", #yang digunakan untuk mendeteksi collision
--  x = 32, #untuk penempatan object
-- 	y = 128, 
-- 	width = 32, #memberi ukuran object
-- 	height = 32