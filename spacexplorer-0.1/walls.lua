-- Wall 

local walls = {}

walls.x = love.graphics.getWidth() / 4
walls.y = love.graphics.getHeight() / 2

walls.width = 683
walls.height = 50

function walls.draw()
  love.graphics.rectangle("fill", walls.x, walls.y, walls.width, walls.height)
end

return walls