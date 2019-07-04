-- Wall 

-- walls = {}

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local rock = love.graphics.newImage('assets/rock5.png')
local grass = love.graphics.newImage('assets/grass2.png')

walls = {
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}
}
-- local grass = love.image.newImage


-- for key, value in pairs(walls) do
--   if walls[key].type == 'grass' then
--     walls[key].image = love.graphics.newImage('assets/grass.png')
--   elseif walls[key].type == 'stone' then
--     walls[key].image = love.graphics.newImage('assets/rock5.png')
--   end
-- end

-- walls[1].image = love.graphics.newImage('assets/grass2.png')
-- walls[2].image = love.graphics.newImage('assets/rock5.png')

function walls.draw()
  love.graphics.setColor(1,1,1,1)
  -- love.graphics.rectangle("fill", walls.x, walls.y, walls.width, walls.height)
    -- love.graphics.draw(walls[0].image, walls[0].x, walls[0].y, 0, 1, 1)
    -- love.graphics.draw(walls[1].image, walls[1].x, walls[1].y, 0, 1, 1)

  for y = 1, 10 do
    for x = 0, 19 do
      if walls[y][x] == 0 then
        -- love.graphics.draw(rock, width * (x-1)/ 18.97, height * (y-1) / 10, 0, 1, 1)
      elseif walls[y][x] == 1 then
        love.graphics.draw(rock, width * (x-1)/ 18.97, height * (y-1) / 10, 0, 1, 1)
      elseif walls[y][x] == 2 then
        love.graphics.draw(grass, width * (x-1)/ 18.97, height * (y-1) / 10, 0, 1, 1)
      end
    end 
  end
-- end
end

return walls