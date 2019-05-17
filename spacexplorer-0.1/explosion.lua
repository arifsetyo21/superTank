-- explosion
-- particel system untuk efek ledakan asteroid

local explosion = {}

local sound = love.audio.newSource('explosion.wav', 'static')
local texture = love.graphics.newImage('explosion.png')

local psystem = love.graphics.newParticleSystem(texture, 200)
psystem:setParticleLifetime(0.5, 2) 
psystem:setLinearAcceleration(-50, 50, 50, 100)
psystem:setSizeVariation(1)
psystem:setColors(1, 1, 0, 1, 1, 1, 1, 0)

function explosion.emit(x, y)
  sound:play()
  psystem:setPosition(x, y)
  psystem:emit(100)
end

function explosion.update(dt)
  psystem:update(dt)
end

function explosion.draw()
  love.graphics.draw(psystem)
end

return explosion