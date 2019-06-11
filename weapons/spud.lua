
local lg = love.graphics

local bullet = {
    fireRate = 0.8
}

bullet.__index = bullet

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

function bullet:SetNewCoords(coords)
    self.x = coords.x
    self.y = coords.y
end

function bullet:Draw()
    lg.circle('line', self.x, self.y, self.radius)
end

function bullet:Collision()
    self.destroyed = true
end

function bullet:GetRadius()
    return self.radius
end

function bullet:GetFireRate()
    return self.fireRate
end

function bullet:SetPlayer(player)
    self.owner = player
end

function bullet:RemoveOOB()
    self.world:RemoveProjectile(self)
end

function bullet:ReverseVelocities()
    
end

function bullet:GetCollisionDamage()
    return self.radius
end

local getSegment = function()
    return {
      color= {r = 255, g = 255, b = 255}
    }
  end
  
function bullet:Create(world, x, y)
  local defaults = {
    world = world,
    x = x - 10,
    y = y,
    vx = 0,
    vy = -10,
    collisionDamage = 20,
    radius = 5,
    type = 'bullet',
    slot = weapon,
    segment = getSegment()
  }
  local b = setmetatable(defaults, bullet)

  return b
end

return bullet