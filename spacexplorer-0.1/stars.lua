-- stars
-- bintang, efek paralax

local stars = {}

stars.dot = {}

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
for i = 1, 20 do
  local d = {}
  d.x = math.random(10, width - 10)
  d.y = math.random(10, height - 10)
  d.r = math.random(1, 3)
  stars.dot[i] = d
end

function stars.update()
  for i = 1, #stars.dot do
    stars.dot[i].y = stars.dot[i].y + 0.5 * stars.dot[i].r
    
    if stars.dot[i].y + 5 >= height then
      stars.dot[i].x = math.random(10, width - 10)
      stars.dot[i].y = math.random(-10, -5)
      stars.dot[i].r = math.random(1, 3)
    end
  end
end

function stars.draw()
  love.graphics.setColor(1, 1, 1, 0.5)
  for i = 1, #stars.dot do
    local x = stars.dot[i].x
    local y = stars.dot[i].y
    local r = stars.dot[i].r
    love.graphics.circle('fill', x, y, r)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return stars