

local DENSITY = 0.0009
local flotsam = require 'flotsam'
local rand = math.random

local M = {
  flotsam = {}
  
}

function M:updateDimensions()
  local w, h = love.graphics.getDimensions()
  self.w = w
  self.h = h
  self.area = w*h
end

function M:update(dt)
  if not self.area then
    self:updateDimensions()
  end
  if (#self.flotsam/self.area < DENSITY) then
    local newF = flotsam:create(self)
    self.flotsam[#self.flotsam+1] = newF
  end

  for k,flot in pairs(self.flotsam) do
    flot:update(dt)
  end

end

function M:draw()
  for k,v in pairs(self.flotsam) do
    v:draw()
  end
end



return M