local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Ending = Remotes:WaitForChild("Ending")

local ShowEndingCard = Ending:WaitForChild("ShowEndingCard")
local TraitsCard = Ending:WaitForChild("ShowEndingCard")

local Progression = {}

local function triggerEndingForPlayer(player)
	ShowEndingCard:FireClient(player)
end

local function showTraitsCard(player)
    TraitsCard:FireClient(player)
end

function Progression.Start(player)
    triggerEndingForPlayer(player)
    showTraitsCard(player)
end

return Progression