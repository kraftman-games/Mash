

local world = require('world')
local background = require('background')
local player = require('player')
local comet = require('comet')
local lg = love.graphics
local controllers = {}
local buttonListeners = {}


-- ===============================
DEBUG = true
-- ===============================
local newComet = comet:Create(world, 200, 200, 100)
world:AddComet(newComet)

function love.resize(w, h) 
  -- update the background dimensions
end

local function RemoveController(controller)
    if controller.joystick:isConnected() == false then
        for k, player in pairs(controller.players) do
            world:RemovePlayer(player)
            for k,v in pairs(buttonListeners) do
                if v == player then
                    buttonListeners[v] = nil
                end
            end
        end
        controllers[controller.id] = nil
    end
end

local function AddController(joystick)
    local joyID = joystick:getID()
    if not controllers[joyID] then
        controllers[joystick:getID()] = {players = {}, joystick = joystick, id = joyID}
    end
end

function love.keypressed(key) 
  if(key == 'escape') then
    love.event.quit(0)
  end
end

function love.update(dt)
  local joysticks = love.joystick.getJoysticks()
  -- add controllers
  for i, joystick in ipairs(joysticks) do
      AddController(joystick)
  end 
  --remove controllers
  for id, controller in pairs(controllers) do
      RemoveController(controller)
  end
  background:update(dt)
  world:Update(dt)
end

function AddPlayer(controller, playerID)
    print('creating player: ', playerID)
    local listenButtons = {}
    listenButtons.player1 = {'leftstick', 'leftshoulder'}
    listenButtons.player2 = {'rightstick', 'rightshoulder'}

    local lOrR = playerID == 'player1' and 'left' or 'right'
    local player = player:Create(world, 50, 50, controller.joystick, lOrR)
    world:AddPlayer(player)
    controller.players[playerID] = player
    for k, v in pairs(listenButtons[playerID]) do
        buttonListeners[controller.id..v] = player
    end

end

function love.joystickpressed(joystick,button)
    print(joystick:getID(), joystick:getGUID(), button)
 end

function love.gamepadpressed(joystick, button)
    AddController(joystick)
    local controller = controllers[joystick:getID()]
    if button == 'leftstick' and not controller.players.player1 then
        AddPlayer(controller, 'player1')
    end
    
    if button == 'rightstick' and not controller.players.player2 then
        AddPlayer(controller, 'player2')
    end
    local playerToUpdate = buttonListeners[controller.id..button]
    if playerToUpdate then
        playerToUpdate:ButtonDown(button)
        print(button)
    end
end

function love.gamepadreleased( joystick, button )
    AddController(joystick)
    local controller = controllers[joystick:getID()]
    
    local playerToUpdate = buttonListeners[controller.id..button]
    if playerToUpdate then
        playerToUpdate:ButtonUp(button)
    end
end

function love.gamepadaxis( joystick, axis, value )
    AddController(joystick)
    local controller = controllers[joystick:getID()]

    if (axis == 'leftx' or axis == 'lefty') then
        if not controller.players.player1 then
            AddPlayer(controller, 'player1')
        end
        local playerToUpdate = buttonListeners[controller.id..axis]
        if playerToUpdate then
            if axis == 'leftx' then
                print(value)
                playerToUpdate:SteerX(value)
            else
                playerToUpdate:SteerY(value)
            end


        end

    end
    
    if (axis == 'rightx' or axis == 'righty') then
        if not controller.players.player2 then
            AddPlayer(controller, 'player2')
        end
        
        local playerToUpdate = buttonListeners[controller.id..axis]
        if playerToUpdate then
            if axis == 'rightx' then
                playerToUpdate:SteerX(value)
            else
                playerToUpdate:SteerY(value)
            end
        end
    end
end

function love.draw()
  background:draw()
  love.graphics.setColor(1,1,1,1)
  world:Draw()
  local joysticks = love.joystick.getJoysticks()
  for i, joystick in ipairs(joysticks) do
      love.graphics.print(joystick:getName(), 10, i * 20)
      love.graphics.print(joystick:getID(), 250, i * 20)

  end 
  --love.timer.sleep(0.01)
end