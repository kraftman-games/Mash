

local M = {
    players = {}
}


function M:Update(dt)
    for k, player in pairs(self.players) do
        player:Update(dt)
    end
end

function M:Draw()
    for k, player in pairs(self.players) do
        player:Draw()
    end
end

function M:AddPlayer(player)
    self.players[player] = player
end

function M:RemovePlayer(player)
    self.players[player] = nil
end

return M