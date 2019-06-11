

local world = require('world')
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
function love.resize(w, h) 
  -- update the background dimensions
end

function love.keypressed(key) 
  if(key == 'escape') then
    love.event.quit(0)
  end
  inputHandler:keypressed(key)
end

function love.keyreleased(key)
  inputHandler:keyreleased(key)
end

function love.update(dt)
  inputHandler:update(dt)
  background:update(dt)
  world:Update(dt)
end

-- joytick buttons pressed down 
function love.joystickpressed(joystick,button)
    -- print('jostickpressed:', joystick:getID(), joystick:getGUID(), button)
 end

function love.gamepadpressed(joystick, button)
  inputHandler:gamepadpressed(joystick, button)
end

function love.gamepadreleased( joystick, button )
  inputHandler:gamepadreleased(joystick, button)
end

function love.gamepadaxis( joystick, axis, value )
  inputHandler:gamepadaxis(joystick, axis, value)
end

function love.draw()
  background:draw()
  love.graphics.setColor(1,1,1,1)
  world:Draw()
  inputHandler:draw()
end