
local segment = require('weapon-menu/menu-segment')

local spudgun = require'weapons.spud'
local cannon = require 'weapons.cannon'
local orb = require 'weapons.orb'

local menu = {}
local lg = love.graphics

menu.__index = menu

function menu:Draw()
  for k, v in pairs(self.segments) do
    print(v.type)
    v:Draw()
  end
end

function menu:Update(dt)
  local x = self.player.joystick:getGamepadAxis(self.player.axisX)
  local y = -self.player.joystick:getGamepadAxis(self.player.axisY)
  print(x,y)
  local selectedID = math.floor((math.atan2(x,y)/math.pi)*3+3+0.999)
  for k,v in pairs(self.segments) do
    v:SetActive(false)
  end
  print(selectedID)
  self.selectedSegment = self.segments[selectedID]
  self.selectedSegment:SetActive(true)

end

function menu:GetX()
  return self.player:GetX()
end

function menu:GetY()
  return self.player:GetY()
end

function menu:CreateSegments()
  local segments = {}
  local segmentOffset = -1
  segments[1] = segment:Create(self, 1*(math.pi/3)-segmentOffset, 'weapon')
  segments[2] = segment:Create(self, 2*(math.pi/3)-segmentOffset, 'weapon')
  segments[3] = segment:Create(self, 3*(math.pi/3)-segmentOffset, 'weapon')
  segments[4] = segment:Create(self, 4*(math.pi/3)-segmentOffset, 'special')
  segments[5] = segment:Create(self, 5*(math.pi/3)-segmentOffset, 'special')
  segments[6] = segment:Create(self, 6*(math.pi/3)-segmentOffset, 'special')
  return segments
end


function menu:Create(player)
  local myMenu = setmetatable({}, menu)
  myMenu.player = player
  myMenu.segments = myMenu:CreateSegments()
  return myMenu
end

function menu:Open()

end

function menu:Close()
  self.selectedSegment:Activate()
end

return menu

