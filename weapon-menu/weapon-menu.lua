
local segment = require('weapon-menu/menu-segment')

local menu = {}
local lg = love.graphics

menu.__index = menu

function menu:Draw()
  for k, v in pairs(self.segments) do
    v:Draw()
  end
end

function menu:GetX()
  return self.player.x
end

function menu:GetY()
  return self.player.y
end


function menu:CreateSegments()
  local segments = {}
  segments[1] = segment:Create(self, 1*(math.pi/3), {r = 255, g =0, b = 0})
  segments[2] = segment:Create(self, 2*(math.pi/3), {r = 255,g = 255,b = 255})
  segments[3] = segment:Create(self, 3*(math.pi/3), {r = 0,g = 255,b =  0})
  segments[4] = segment:Create(self, 4*(math.pi/3), {r = 255,g = 255,b = 255})
  segments[5] = segment:Create(self, 5*(math.pi/3), {r = 0,g = 0,b = 255})
  return segments
end



function menu:Create(player)
  local myMenu = setmetatable({}, menu)
  myMenu.player = player
  myMenu.segments = myMenu:CreateSegments()
  return myMenu
end

return menu

