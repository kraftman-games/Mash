

local bullet = {
}

bullet.__index = bullet
local lg = love.graphics

function bullet:Update(dt)
  if self.destroyed then
    self.world:RemoveProjectile(self)
  end
end

function bullet:GetNewCoords(dt)
  return {
    x = self.x + (self.vx * dt),
    y = self.y + self.vy * dt
  }
end

function bullet:ReverseVelocities()
end

function bullet:SetNewCoords(coords)
  self.x = coords.x
  self.y = coords.y
end

function bullet:Draw()
  lg.setColor(self.color.r, self.color.g, self.color.b)
  lg.circle('fill', self.x, self.y, self.radius+20)
end

function bullet:Collision()
  self.destroyed = true
end

function bullet:GetRadius()
  return self.radius
end


function bullet:SetOwner(player)
  self.owner = player
end

function bullet:GetOwner()
  return self.owner
end

function bullet:RemoveOOB()
  self.world:RemoveProjectile(self)
end


function bullet:GetCollisionDamage()
  return self.radius
end




return bullet




