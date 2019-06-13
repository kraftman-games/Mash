

local listenButtons = {}
listenButtons.player1 = {'leftstick', 'leftshoulder', 'triggerleft'}
listenButtons.player2 = {'rightstick', 'rightshoulder', 'triggerright'}
local player = require 'player'

local function newController(joystick)
  return {
    players = {},
    joystick = joystick,
    id = joystick:getID()
  }
end


local input = {}
input.__index = input

function input:AddController(joystick)
  local joyID = joystick:getID()
  if not self.controllers[joyID] then
    self.controllers[joyID] = newController(joystick) 
  end
end

function input:AddPlayer(controller, playerID)

  local lOrR = playerID == 'player1' and 'left' or 'right'
  local playerX = 150-math.random( 0,30 )
  local playerY = 150+math.random( 0, 70 )
  local player = player:Create(self.world, playerX, playerY, controller.joystick, lOrR)
  self.world:AddPlayer(player)
  controller.players[playerID] = player
  for _, buttonName in pairs(listenButtons[playerID]) do
    self.buttonListeners[controller.id..buttonName] = player
  end
end


function input:RemoveController(controller)
  if controller.joystick:isConnected() == true then
    return
  end
  -- remove both of the controllers players
  for _, player in pairs(controller.players) do
    self.world:RemovePlayer(player)
    for k,v in pairs(self.buttonListeners) do
      if v == player then
        self.buttonListeners[v] = nil
      end
    end
  end
  self.controllers[controller.id] = nil
end

function input:GamepadPressed(joystick, button)
  --print('gamepad pressed:', joystick, button)
  self:AddController(joystick)
  local controller = self.controllers[joystick:getID()]
  if button == 'leftstick' and not controller.players.player1 then
      self:AddPlayer(controller, 'player1')
  end
  
  if button == 'rightstick' and not controller.players.player2 then
      self:AddPlayer(controller, 'player2')
  end
  --print('player to update:', controller.id..button)
  local playerToUpdate = self.buttonListeners[controller.id..button]
  if playerToUpdate then
      playerToUpdate:ButtonDown(button)
      -- print('gamepad pressed', button)
  end
end

function input:GamepadReleased(joystick, button)
  self:AddController(joystick)
  local controller = self.controllers[joystick:getID()]
  
  local playerToUpdate = self.buttonListeners[controller.id..button]
  if playerToUpdate then
    playerToUpdate:ButtonUp(button)
  end
end

function input:GamepadAxis(joystick, axis, value)
  --print('gamepad axis:', joystick, axis, value)
  self:AddController(joystick)
  local controller = self.controllers[joystick:getID()]

  if (axis == 'leftx' or axis == 'lefty') then
      if not controller.players.player1 then
          self:AddPlayer(controller, 'player1')
      end
      local playerToUpdate = self.buttonListeners[controller.id..axis]
      if playerToUpdate then
          if axis == 'leftx' then
              -- print(value)
              playerToUpdate:SteerX(value)
          else
              playerToUpdate:SteerY(value)
          end
      end

  end
  if axis == 'triggerleft' then
    local playerToUpdate = self.buttonListeners[controller.id..axis]
    if playerToUpdate then
      if value > 0.5 then
        playerToUpdate:ButtonDown(axis)
      else  
        playerToUpdate:ButtonUp(axis)
      end
      -- print('gamepad pressed', button)
    end
  end
  if axis == 'triggerright' then
    local playerToUpdate = self.buttonListeners[controller.id..axis]
    if playerToUpdate then
      if value > 0.5 then
        playerToUpdate:ButtonDown(axis)
      else  
        playerToUpdate:ButtonUp(axis)
      end
      -- print('gamepad pressed', button)
    end
  end

  
  if (axis == 'rightx' or axis == 'righty') then
      if not controller.players.player2 then
          self:AddPlayer(controller, 'player2')
      end
      
      local playerToUpdate = self.buttonListeners[controller.id..axis]
      if playerToUpdate then
          if axis == 'rightx' then
              playerToUpdate:SteerX(value)
          else
              playerToUpdate:SteerY(value)
          end
      end
  end
end

function input:Update(dt)
  local joysticks = love.joystick.getJoysticks()
  -- add new controllers
  for i, joystick in ipairs(joysticks) do
    self:AddController(joystick)
  end 
  --remove dead controllers
  for id, controller in pairs(self.controllers) do
    self:RemoveController(controller)
  end
end

function input:Draw()
  local joysticks = love.joystick.getJoysticks()
  for i, joystick in ipairs(joysticks) do
      love.graphics.print('name:'..joystick:getName(), 10, i * 20)
      love.graphics.print('id:'..joystick:getID(), 250, i * 20)
  end 
end

function input:Create(world)
  local inp = setmetatable({}, input)
  inp.world = world
  inp.controllers = {}
  inp.buttonListeners = {}
  return inp
end

function input:KeyPressed()

end


return input