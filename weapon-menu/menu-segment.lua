


local segment = {}
local lg = love.graphics

segment.__index = segment

function segment:Draw()

  if self.enabled then
    lg.setColor(self.color.r, self.color.g, self.color.b)
  end
  local rad = 40
  local startAng = self.angle
  local endAng = startAng + 0.5
  lg.arc('line', self.menu:GetX(), self.menu:GetY(), 40, startAng, endAng)
  if self.active then
    local offset = 50
    lg.setColor(self.color.r-offset, self.color.g-offset, self.color.b-offset)
    lg.arc('line', self.menu:GetX(), self.menu:GetY(), 45, startAng, endAng)
    lg.setColor(self.color.r-offset*2, self.color.g-offset*2, self.color.b-offset*2)
    lg.arc('line', self.menu:GetX(), self.menu:GetY(), 50, startAng, endAng)
  end
end

function segment:SetActive(bool)
  self.active = bool
end

function segment:Activate()
  -- self.onActivate(player)
end 

function segment:Create(menu, angle, type)
  local mySegment = setmetatable({}, segment)
  mySegment.color = {r = 100, g = 100, b = 100}
  mySegment.angle = angle
  mySegment.enabled = true
  mySegment.menu = menu
  mySegment.active = true
  mySegment.type = type
  return mySegment
end

return segment

