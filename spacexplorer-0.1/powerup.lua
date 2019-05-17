-- power up

local powerup = {}

local texture = love.graphics.newImage('powerup.png')
local sound = love.audio.newSource('powerup.wav', 'static')

local psystem = love.graphics.newParticleSystem(texture, 50)
psystem:setParticleLifetime(1, 5) 
psystem:setLinearAcceleration(-100, -100, 100, 100)
psystem:setSizeVariation(1)
psystem:setColors(0.33, 0.6, 1, 1, 1, 1, 0, 0)

function powerup.emit(x, y)
  sound:play()
  psystem:setPosition(x, y)
  psystem:emit(25)
end

function powerup.update(dt)
  psystem:update(dt)
end

function powerup.draw()
  love.graphics.draw(psystem)
end

return powerup