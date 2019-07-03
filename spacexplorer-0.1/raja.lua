-- Raja.lua

local sprite = love.graphics.newImage('assets/zelda.png')
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

raja = {
   image = love.graphics.newImage('assets/zelda.png'),
   x = love.graphics.getWidth()/2,
   y = love.graphics.getHeight()*(7/8),
   shield = 10,
   life = true
}

-- height = raja.image:getHeight()
-- width = raja.image:getWidth()

local shake = love.graphics.newParticleSystem(sprite, 2)
shake:setParticleLifetime(0.2, 0.5) 
shake:setLinearAcceleration(-50, -50, 50, 50)
shake:setSizeVariation(1)
shake:setColors(1, 1, 1, 0.6, 1, 0, 0, 0.5)

function raja.reset()
   raja.life = true
   raja.shield = 10
end

function showInfo()

   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.print('kings shield', 170, height - 28)

   -- shield bar
   if raja.shield <= 10 and raja.shield >=7 then 
      love.graphics.setColor(0, 1, 0, 1)
   elseif raja.shield <= 6 and raja.shield >=4 then 
      love.graphics.setColor(1, 1, 0, 1)
   elseif raja.shield <= 3 then 
      love.graphics.setColor(1, 0, 0, 1) 
   end

   love.graphics.rectangle('line', 172, height - 15, 105, 5)
   love.graphics.rectangle('fill', 173, height - 14, 10.5 * raja.shield, 3)
end

function raja.update(dt)
   shake:update(dt)
end

function raja.draw()
   -- love.graphics.rectangle('line', raja.x-30, raja.y, 64, 64)
   love.graphics.draw(raja.image, raja.x-30, raja.y, 0, 1, 1)
   love.graphics.draw(shake)  
   showInfo()
end

function raja.shake()
   shake:setPosition(raja.x+40, raja.y + 20)
   shake:emit(4)
end

return raja


