local lg = love.graphics
local comet = {}
comet.__index = comet

function comet:Update(dt)

end

function comet:GetRadius()
    return self.radius
end


function comet:GetNewCoords(dt)
    return { 
        x = self.x + dt * self.vx, 
        y = self.y + dt * self.vy
    }
end

function comet:SetNewCoords(coords)
    self.x = coords.x
    self.y = coords.y
end

function comet:Collision(with)

end

function comet:GetCollisionDamage()
    return self.collisionDamage
end


function comet:ReverseVelocities()
    self.vx = -self.vx
    self.vy = -self.vy
end

function comet:Draw()
    
    lg.circle('line', self.x, self.y, self.radius)
end

function comet:Create(world, x, y, radius)
    local c = setmetatable({}, comet)
    c.world = world
    c.x = x
    c.y = y
    c.vx = 0
    c.vy = 0
    c.radius = radius
    c.collisionDamage = 10
    return c
end

return comet