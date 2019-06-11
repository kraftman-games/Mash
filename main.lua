

local World = require('world')
local background = require('background')
local player = require('player')
local comet = require('comet')
local lg = love.graphics
local inputHandler = (require 'input'):create(world)
-- love.window.setFullscreen(true)

-- ===============================
DEBUG = true
-- ===============================
-- local newComet = comet:Create(world, 200, 200, 100)
-- world:AddComet(newComet)
local globalState = {
  paused  = false
}

local world = World:Create(globalState)

function love.resize(w, h) 
  -- update the background dimensions
end

function love.keypressed(key) 
  if(key == 'escape') then
    love.event.quit(0)
  end
  world:KeyPressed(key)
end

function love.keyreleased(key)
  world:KeyReleased(key)
end

function love.update(dt)
  background:update(dt)
  world:Update(dt)
end

function love.gamepadpressed(joystick, button)
  world:GamepadPressed(joystick, button)
end

function love.gamepadreleased( joystick, button )
  world:GamepadReleased(joystick, button)
end

function love.gamepadaxis( joystick, axis, value )
  world:GamepadAxis(joystick, axis, value)
end

function love.draw()
  background:draw()
  love.graphics.setColor(1,1,1,1)
  world:Draw()
  inputHandler:draw()
end