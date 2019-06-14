
local lg = love.graphics
local bulletBase = require 'weapons.bullet-base'

local weapon = {
    fireRate = 0.1
}

weapon.__index = weapon

function weapon:GetCollisionDamage()
  return self.radius
end

function weapon:Activate(player)
  if (player.weapon == self) then
    player.weapon = player.defaultWeapon
    return
  end
  player.weapon = self
end

function weapon:GetFireRate()
  return self.fireRate
end

function weapon:Fire(dt)
  self.lastFired = self.lastFired + dt
  local fireRate = self:GetFireRate()
  if self.lastFired > fireRate then
    -- print('firing')
    self.lastFired = 0
    for k,create in pairs(self.bullets) do
      local projectile = create(self)
      self.world:AddProjectile(projectile)
    end
  end
end

local bulletTemplate = function(angle, size, damage, color)
  return function (wep)
    local defaults = {
      world = wep.world,
      x = wep.owner.x,
      y = wep.owner.y,
      owner = wep.owner,
      vx = math.sin(angle)*30,
      vy = math.cos(angle)*30,
      collisionDamage = damage,
      radius = size,
      type = 'bullet',
      color = {
        r = color.r,
        g = color.g,
        b = color.b
      }
    }
    local b = setmetatable(defaults, bulletBase)
    
    return b
  end
end
 
function weapon:Create(world, player)
  local defaults = {
    world = world,
    owner = player,
    type = 'weapon',
    lastFired = 0,
    bullets = {},
    segmentColor = {
      r = 0,
      g = 255,
      b = 0
    }
  }
  local wep = setmetatable(defaults, weapon)
  local color = {r = 255, g = 0, b = 20}
  table.insert(wep.bullets, bulletTemplate(-3.141, 5, 10, color))
  
  return wep
end

return weapon