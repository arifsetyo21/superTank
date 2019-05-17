-- bgspace

local bgspace = {}
local bgspaceImg = love.graphics.newImage('background.jpg')

bgspace.x = 0
bgspace.y1 = -bgspaceImg:getHeight() + love.graphics.getHeight()
bgspace.y2 = bgspace.y1 - bgspaceImg:getHeight()

function bgspace.update()
  bgspace.y1 = bgspace.y1 + 0.5
  bgspace.y2 = bgspace.y2 + 0.5
  
  if bgspace.y1 >= love.graphics.getHeight() then
    bgspace.y1 = bgspace.y2 - bgspaceImg:getHeight()
  end
  if bgspace.y2 >= love.graphics.getHeight() then
    bgspace.y2 = bgspace.y1 - bgspaceImg:getHeight()
  end
end

function bgspace.draw()
  love.graphics.draw(bgspaceImg, bgspace.x, bgspace.y1)
  love.graphics.draw(bgspaceImg, bgspace.x, bgspace.y2)
end

return bgspace