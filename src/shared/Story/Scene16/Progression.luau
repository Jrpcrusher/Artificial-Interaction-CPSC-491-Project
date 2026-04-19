local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Ending = Remotes:WaitForChild("Ending")

local ShowEndingCard = Ending:WaitForChild("ShowEndCard")
local EndingCardFinished = Ending:WaitForChild("EndingCardFinished")
local ShowEndingTraits = Ending:WaitForChild("ShowEndingTraits")

local TraitStore = require(ReplicatedStorage.Shared.Utils.Chat.TraitStore)

local Progression = {}

local function triggerEndingForPlayer(player)
	print("Server: firing ending card to", player.Name)
	ShowEndingCard:FireClient(player)
end

local function showTraitsCard(player)
	local traits = TraitStore.Get(player.UserId) or {}
	print("Server: showing traits to", player.Name, #traits)
	ShowEndingTraits:FireClient(player, traits)
end

function Progression.Start(player)
	local connection
	connection = EndingCardFinished.OnServerEvent:Connect(function(finishedPlayer)
		print("Server: got EndingCardFinished from", finishedPlayer.Name)

		if finishedPlayer == player then
			connection:Disconnect()
			showTraitsCard(player)
		end
	end)

	triggerEndingForPlayer(player)
end

return Progression