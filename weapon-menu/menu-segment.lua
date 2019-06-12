


local segment = {}
local lg = love.graphics

segment.__index = segment

function segment:Draw()

  
  lg.setColor(self.color.r, self.color.g, self.color.b)
  print(self.color.r, self.color.g, self.color.b)
  
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

function segment:Activate(player)
  if not self.assignedSkill then
    return
  end
  self.assignedSkill:Activate(player)
end 

function segment:SetColor(color)
  print('setting color:', color.r, color.g, color.b)
  self.color = color
end

function segment:SetSkill(skill)
  self.assignedSkill = skill
  self:SetColor(skill.segmentColor)
end

function segment:Create(menu, angle, type)
  local mySegment = setmetatable({}, segment)
  mySegment.color = {r = 100, g = 100, b = 100}
  mySegment.angle = angle
  mySegment.enabled = true
  mySegment.menu = menu
  mySegment.active = true
  mySegment.type = type
  mySegment.assignedSkill = nil
  return mySegment
end

return segment

