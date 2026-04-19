local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Ending = Remotes:WaitForChild("Ending")

local ShowEndCard = Ending:WaitForChild("ShowEndCard")
local TraitsCard = Ending:WaitForChild("ShowEndingTraits")

local Progression = {}

local function triggerEndingForPlayer(player)
	ShowEndCard:FireClient(player)
end

local function showTraitsCard(player)
	TraitsCard:FireClient(player)
end

function Progression.Start(player)
	print("in progression 16")
	triggerEndingForPlayer(player)
	-- showTraitsCard(player)
end

return Progression