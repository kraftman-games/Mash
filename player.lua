
local lg = love.graphics

local player = {}
local spudGun = require 'weapons.spud'
local weaponMenu = require 'weapon-menu/weapon-menu'

player.__index = player

function player:Update(dt)
  if self.menuOpen then
    self.weaponMenu:Update(dt)
  end

  self.opp = self.ignoreSteering and 0 or self.joystick:getGamepadAxis(self.axisX)
  self.vx = self.vx + self.opp * self.acceleration
  self.vx = self.vx / (1 + dt)
  self.vx = math.min(self.vx, self.maxV)
  self.vx = math.max(self.vx, -self.maxV)

  self.adj = self.ignoreSteering and 0 or self.joystick:getGamepadAxis(self.axisY)
  self.vy = self.vy + self.adj * self.acceleration
  self.vy = self.vy / (1 + dt)
  self.vy = math.min(self.vy, self.maxV)
  self.vy = math.max(self.vy, -self.maxV)
  
  self.shield = self.joystick:getGamepadAxis(self.trigger) * (2 * math.pi - self.shieldwidth*2 ) - self.shieldwidth/2

  self.angle = math.atan2(self.opp, self.adj)

  if self.firing then
      self:Fire(dt)
  end

end

function player:GetNewCoords(dt)
    return { 
        x = self.x + dt * self.speed * self.vx, 
        y = self.y + dt * self.speed * self.vy
    }
end

function player:SetNewCoords(coords)
    self.x = coords.x
    self.y = coords.y
end

function player:ReverseVelocities()
    self.vx = -self.vx
    self.vy = -self.vy
end


function player:Fire(dt)
    self.lastFired = self.lastFired + dt
    local fireRate = self.weapon:GetFireRate()
    fireRate = fireRate * self.fireRate
    -- print(self.lastFired, fireRate)
    if self.lastFired > fireRate then
        -- print('firing')
        self.lastFired = 0
        local projectile = self.weapon:Create(self.world, self.x, self.y, self.angle)
        projectile:SetPlayer(self)
        self.world:AddProjectile(projectile)
    end
end

function player:DrawShip()
  lg.setColor(self.r, self.g, self.b)
  lg.circle('fill', self.x, self.y, 5)
  lg.arc( 'fill', self.x, self.y, self.radius, self.shield-self.shieldwidth, self.shield+self.shieldwidth, 3 )
  if DEBUG then
      love.graphics.print(self.health, self.x + 10, self.y)
  end
end

function player:HideHealth()
  if self.menuOpen then
    return true
  end
end

function player:DrawHealth()
  if self:HideHealth() then
    return
  end
  local healthRad = 15
  lg.setColor(0, 255, 0)
  lg.arc('line', self.x, self.y, healthRad, 0, 2*math.pi/200*self.health)
  lg.setColor(255,255,255)
end

function player:DrawMenu()
  if self.menuOpen then
    self.weaponMenu:Draw()
  end
end

function player:GetX()
  return self.x
end

function player:GetY()
  return self.y
end

function player:GetWeapon()
  return self.weapon
end

function player:SetWeapon(weapon)
  self.weapon = weapon
end


function player:Draw()
  self:DrawShip()
  self:DrawHealth()
  self:DrawMenu()

end

function player:StartFiring()
    self.firing = true
end

function player:StopFiring()
    self.firing = false
end

function player:RemoveOOB()

end

function player:Collision(with)
    self.health = self.health - with:GetCollisionDamage()
end

function player:GetCollisionDamage()
    return self.collisionDamage
end

function player:OpenWeaponMenu()
    self.r = 220
    self.g = 100
    self.b = 100
    self.lastInput = love.timer.getTime()
    self.ignoreSteering = true
    self.menuOpen = true
    self.weaponMenu:Open()
end

function player:CloseWeaponMenu()
    self.r = 200
    self.g = 200
    self.b = 200
    self.lastInput = love.timer.getTime()
    self.ignoreSteering = false
    self.menuOpen = false
    self.weaponMenu:Close()
end

function player:SecondaryFire()
  print('firing secondary')
end

function player:ButtonDown(button)
    print('button down:', button, self.vx)
    if button == self.trigger then
        self:StartFiring()
    elseif button == self.stick then
        self:OpenWeaponMenu()
    elseif button == self.shoulder then
      self:SecondaryFire();
    end
end

function player:ButtonUp(button)
    print('button up: ', button)
    if button == self.trigger then
        self:StopFiring()
    elseif button == self.stick then
      if self.menuOpen then
        self:CloseWeaponMenu()
      end
    end
end

function player:GetRadius()
    return self.radius
end

function player:Create(world, x, y, joystick, axis )
  local defaults = {
    x = x,
    y = y,
    joystick = joystick,
    vx = 0,
    vy = 0,
    r = 200,
    g = 200,
    b = 200,
    world = world,
    axisX = axis..'x',
    axisY = axis..'y',
    stick = axis..'stick',
    trigger = 'trigger'..axis,
    shoulder = axis..'shoulder',
    stick = axis..'stick',
    speed = 2,
    maxV = 50,
    acceleration = 20,
    shield = 0,
    shieldwidth = 0.5,
    lastFired = 0,
    defaultWeapon = spudGun,
    weapon = spudGun,
    fireRate = 0.1,
    radius = 5,
    health = 200,
    collisionDamage = 5,
  }
  local p = setmetatable(defaults, player)
  p.weaponMenu = weaponMenu:Create(p)
  p.lastInput = love.timer.getTime()
  return p
end

return player