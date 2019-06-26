local consoleBuffer = {}
local consoleBufferSize = 15
for i=1,consoleBufferSize do consoleBuffer[i] = "" end
local function consolePrint(msg)
  table.remove(consoleBuffer,1)
  consoleBuffer[consoleBufferSize] = msg
end

function love.load()
	bump = require "bump"
	bump_debug = require 'bump_debug'
	world = bump.newWorld()

	player = {
		type = "player",
		x = love.graphics.getWidth() / 2 - 16,
		y = love.graphics.getHeight() / 2 - 16,
		size = 32
	}

	solidWall = {
		type = "solidWall",
		x = 32, 
		y = 128,
		width = 32,
		height = 32
	}

	notSolidWall = {
		type = "notSolidWall",
		x = love.graphics.getWidth() - 64, 
		y = 128,
		width = 32,
		height = 32
	}

	world:add(player, player.x, player.y, player.size, player.size)
	world:add(solidWall, solidWall.x, solidWall.y, solidWall.height, solidWall.width)
	world:add(notSolidWall, notSolidWall.x, notSolidWall.y, notSolidWall.height, notSolidWall.width)

end

function playerFilter(item, other)
	if other.type == "solidWall" then
		return "touch"
	elseif other.type == "notSolidWall" then
		return "cross"
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
    love.graphics.printf(consoleBuffer[i], 10, 580-(consoleBufferSize - i)*12, 790, "left")
  end
end

function love.update(dt)
	local goalX, goalY = player.x, player.y
	if love.keyboard.isDown("d") then
		goalX = player.x + 200 * dt
	elseif love.keyboard.isDown("a") then
		goalX = player.x - 200 * dt
	end

	if love.keyboard.isDown("s") then
		goalY = player.y + 200 * dt
	elseif love.keyboard.isDown("w")  then
		goalY = player.y - 200 * dt
	end

	local cols
	local score = 1
	local actualX, actualY, cols, cols_len = world:move(player, goalX, goalY, playerFilter)
	for i=1, cols_len do
		local col  = cols[i]
		if(col.type == 'touch') then
			world:remove(col.other)
		end
		consolePrint(("scoreeeee = %s, col.item = %s, col.other = %s, col.type = %s, col.normal = %d,%d"):format(score, col.item,col.other, col.type, col.normal.x, col.normal.y))
	end

	player.x = actualX
	player.y = actualY
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)

	love.graphics.setColor(0, 125, 255)
	love.graphics.rectangle("fill", solidWall.x, solidWall.y, solidWall.width, solidWall.height)

	love.graphics.setColor(255, 125, 0)
	love.graphics.rectangle("fill", notSolidWall.x, notSolidWall.y, notSolidWall.width, notSolidWall.height)
	if shouldDrawDebug then
	    drawDebug()
	    drawConsole()
	 end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == "tab"    then shouldDrawDebug = not shouldDrawDebug end
end

-- source https://love2d.org/forums/viewtopic.php?t=82776