
local lg = love.graphics

local player = {}

player.__index = player

function player:Update(dt)
    self.x = self.x + dt * self.speed * self.vx
    self.y = self.y + dt * self.speed * self.vy

    local axisXValue = self.joystick:getGamepadAxis(self.axisX)
    self.vx = self.vx + axisXValue * self.acceleration
    self.vx = math.min(self.vx, self.maxV)
    self.vx = math.max(self.vx, -self.maxV)
    local axisYValue = self.joystick:getGamepadAxis(self.axisY)
    
    self.vy = math.min(self.vy, self.maxV)
    self.vy = math.max(self.vy, -self.maxV)
    self.vy = self.vy + axisYValue * self.acceleration

    
    self.shield = self.joystick:getGamepadAxis(self.trigger) * (2 * math.pi - self.shieldwidth*2 ) - self.shieldwidth/2

end


function player:Draw()
    lg.setColor(self.r, self.g, self.b)
    lg.circle('fill', self.x, self.y, 5)
    lg.arc( 'fill', self.x, self.y, 200, self.shield-self.shieldwidth, self.shield+self.shieldwidth, 3 )
end

function player:ButtonDown(button)
    print('button down:', button, self.vx)
    self.r = 220
    self.g = 100
    self.b = 100
    self.lastInput = love.timer.getTime()
end

function player:ButtonUp(button)
    print('button up: ', button)
    self.r = 200
    self.g = 200
    self.b = 200
    self.lastInput = love.timer.getTime()
end

function player:Create(x, y, joystick, axis )
    local p = setmetatable({}, player)
    p.x = x
    p.y = y
    p.joystick = joystick
    p.vx = 0
    p.vy = 0
    p.r = 200
    p.g = 200
    p.b = 200
    p.axisX = axis..'x'
    p.axisY = axis..'y'
    p.stick = axis..'stick'
    p.trigger = 'trigger'..axis
    p.speed = 2
    p.maxV = 30
    p.acceleration = 1
    p.shield = 0
    p.shieldwidth = 0.5
    p.lastInput = love.timer.getTime()
    return p
end

return player