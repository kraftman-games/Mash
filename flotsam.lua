
local lg = love.graphics
local rand = math.random

local maxSpeed = 3
local maxPathLength = 30
local depth = 3

local M = {
   
}

M.__index = M

function M:setRandom()
  self.x, self.y, self.depth = rand(self.bg.w), rand(self.bg.h), depth
end

function M:newPath()
  self.vx, self.vy = rand(-maxSpeed, maxSpeed), rand(-maxSpeed, maxSpeed)
  self.vz = rand(-maxSpeed/10, maxSpeed/10)
end

function M:update(dt)
  self.current = self.current + dt
  if (self.current > self.nextUpdate) then
    self.current = 0
    self:newPath()
  end
  self.x = self.x + (self.vx * dt)*4*(1- (self.depth / depth))
  self.y = self.y + (self.vy * dt)*4*(1- (self.depth / depth))
  local newDepth = self.depth + self.vz*dt

  if newDepth < 0 then
    self.depth = self.depth - self.vz*dt
    self.vz = - self.vz
  else
    self.depth = newDepth
  end
end

function M:draw()
  local alpha = (1- (self.depth / depth))/2 
  lg.setColor(1,1,1, alpha)
  lg.circle('fill', self.x, self.y, depth - self.depth)
end

function M:create(bg) 
  local f = setmetatable({}, M)
  f.x = x
  f.y = y
  f.z = z
  f.bg = bg
  f:setRandom()
  f:newPath()
  f.nextUpdate = rand(maxPathLength)
  f.current = 0
  return f

end

return M