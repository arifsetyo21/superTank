-- highscore

highscorenote = {}

local xml2lua = require("xml2lua")
--Uses a handler that converts the XML to a Lua table
local handler = require("xmlhandler.tree")

local xml = xml2lua.loadFile("score.xml")

--Instantiates the XML parser
local parser = xml2lua.parser(handler)
parser:parse(xml)

--[[
By default, assumes the people table has just one person table.
Iterating over the people table we'll directly get the single person that it represents.
]]
local scores = handler.root.scores

--[[
If there is more than one person, then person is an array instead of regular table.
This way, we need to iterate over the person array instead of the people table.
]]
if #scores.score > 1 then
   scores = scores.score
end

--Manually prints the table (since the XML structure for this example is previously known)
function highscorenote.tampil()
   -- love.graphics.setColor(1,1,1,1)
   -- love.graphics.print('coba ajaa', 10, 10, 0, 2, 2)
   -- print('hello')
   for i, p in pairs(scores) do
      love.graphics.print(i.. " score: " .. p.value .. "  Date: " .. p.date, love.graphics.getWidth()/2 , 20 * i, 0)
   end
end

return highscorenote