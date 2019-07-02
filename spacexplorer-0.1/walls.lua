-- Wall 

walls = {}

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

walls[0] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[1] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[2] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[3] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[4] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[5] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[6] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[7] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[8] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
walls[9] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
-- local grass = love.image.newImage


-- for key, value in pairs(walls) do
--   if walls[key].type == 'grass' then
--     walls[key].image = love.graphics.newImage('assets/grass.png')
--   elseif walls[key].type == 'stone' then
--     walls[key].image = love.graphics.newImage('assets/rock5.png')
--   end
-- end

walls[0].image = love.graphics.newImage('assets/grass2.png')
walls[1].image = love.graphics.newImage('assets/rock5.png')

function walls.draw()
  love.graphics.setColor(1,1,1,1)
  -- love.graphics.rectangle("fill", walls.x, walls.y, walls.width, walls.height)
    -- love.graphics.draw(walls[0].image, walls[0].x, walls[0].y, 0, 1, 1)
    -- love.graphics.draw(walls[1].image, walls[1].x, walls[1].y, 0, 1, 1)

  for y = 0, 9 do
    for x = 1, 19 do
      if walls[y][x] == 1 then
        love.graphics.draw(walls[0].image, width * (x-1)/ 18.97, height * y / 10, 0, 1, 1)
      end
    end 
  end
-- end
end

return walls