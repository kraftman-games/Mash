


local segment = {}
local lg = love.graphics

segment.__index = segment

function segment:Draw()
  if self.enabled then
    lg.setColor(200,200,200)
  else 
    lg.setColor(self.color.r, self.color.g, self.color.b)
  end
  local rad = 40
  local startAng = self.angle
  local endAng = startAng + 0.5
  lg.arc('line', self.menu:GetX(), self.menu:GetY(), 40, startAng, endAng)
end

function segment:Create(menu, angle, color )
  local mySegment = setmetatable({}, segment)
  mySegment.angle = angle
  mySegment.enabled = false
  mySegment.color = color
  mySegment.menu = menu
  return mySegment
end

return segment

