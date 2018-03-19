
local function ObjectsCollide(first, second, firstCoords, secondCoords)

    totalRad = first:GetRadius() + second:GetRadius()
    local newRad = math.sqrt((firstCoords.x - secondCoords.x)^2 + (firstCoords.y - secondCoords.y)^2)

    return newRad < totalRad 
end

local M = {
    collidables = {},
    players = {},
    projectiles = {},
    comets = {},
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight(),
    bufferWidth = 40
}

function M:RemoveOOB()
    for k,v in pairs(self.collidables) do
        if (v.x < - self.bufferWidth or v.x > self.width + self.bufferWidth) or
           (v.y < - self.bufferWidth or v.y > self.height + self.bufferWidth) then
            v:RemoveOOB()
        end
    end
end

function M:ResolveCollisions(dt)
    local firstObject, secondObject, firstCoords, secondCoords
    for i = 1, #self.collidables do
        firstObject = self.collidables[i]
        firstCoords = firstObject:GetNewCoords(dt)
        for j = i + 1, #self.collidables do
            secondObject = self.collidables[j]
            secondCoords = secondObject:GetNewCoords(dt)
            if ObjectsCollide(firstObject, secondObject, firstCoords, secondCoords) then
                firstObject:ReverseVelocities()
                secondObject:ReverseVelocities()

                firstObject:SetNewCoords(firstObject:GetNewCoords(dt))
                secondObject:SetNewCoords(secondObject:GetNewCoords(dt))
                firstObject:Collision(secondObject)
                secondObject:Collision(firstObject)
                
            else
                firstObject:SetNewCoords(firstCoords)
                secondObject:SetNewCoords(secondCoords)
            end
        end
    end

end

function M:Update(dt)
    self:RemoveOOB()
    for k, player in pairs(self.players) do
        player:Update(dt)
    end
    for k, player in pairs(self.projectiles) do
        player:Update(dt)
    end
    for k, comet in pairs(self.comets) do
        comet:Update(dt)
    end

    self:ResolveCollisions(dt)
end

function M:Draw()
    for k, projectile in pairs(self.players) do
        projectile:Draw()
    end
    for k, projectile in pairs(self.projectiles) do
        projectile:Draw()
    end
    for k, comet in pairs(self.comets) do
        comet:Draw()
    end
end

function M:AddPlayer(player)
    self.players[player] = player
    table.insert(self.collidables, player)
end

function M:AddProjectile(projectile)
    self.projectiles[projectile] = projectile
    table.insert(self.collidables, projectile)
end

function M:RemovePlayer(player)
    self.players[player] = nil
    self.collidables[player] = nil
end

function M:AddComet(comet)
    self.comets[comet] = comet
    table.insert(self.collidables, comet)
end

function M:RemoveProjectile(projectile)
    self.projectiles[projectile] = nil
    for i = 1, #self.collidables do
        if self.collidables[i] == projectile then
            table.remove(self.collidables, i)
        end
    end
end

return M