
local segment = require('weapon-menu/menu-segment')
local megaBullets = require'projectiles.megabullet'
local bullets = require 'projectiles.bullet'

local menu = {}
local lg = love.graphics

menu.__index = menu

function menu:Draw()
  for k, v in pairs(self.segments) do
    v:Draw()
  end
end

function menu:Update(dt)
  print('me u update')
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
  return self.player.x
end

function menu:GetY()
  return self.player.y
end


function menu:CreateSegments()
  local segments = {}
  local segmentOffset = -1
  segments[1] = segment:Create(self, 1*(math.pi/3)-segmentOffset, {r = 255, g =0, b = 0})
  segments[2] = segment:Create(self, 2*(math.pi/3)-segmentOffset, {r = 255,g = 255,b = 255})
  segments[3] = segment:Create(self, 3*(math.pi/3)-segmentOffset, {r = 0,g = 255,b =  0})
  segments[4] = segment:Create(self, 4*(math.pi/3)-segmentOffset, {r = 255,g = 255,b = 255})
  segments[5] = segment:Create(self, 5*(math.pi/3)-segmentOffset, {r = 0,g = 0,b = 255})
  segments[6] = segment:Create(self, 6*(math.pi/3)-segmentOffset, {r = 0,g = 0,b = 255})
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
  if self.player.projectile == bullets then
    self.player.projectile = megaBullets
  else 
    self.player.projectile = bullets
  end
end

return menu

