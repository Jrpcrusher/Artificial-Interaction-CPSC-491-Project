local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Ending = Remotes:WaitForChild("Ending")

local ShowEndingCard = Ending:WaitForChild("ShowEndCard")
local EndingCardFinished = Ending:WaitForChild("EndingCardFinished")
local ShowEndingTraits = Ending:WaitForChild("ShowEndingTraits")

local TraitStore = require(ReplicatedStorage.Shared.Utils.Chat.TraitStore)
local TraitAnalyzer = require(ReplicatedStorage.Shared.Utils.Chat.TraitAnalyzer)

local Progression = {}

local function triggerEndingForPlayer(player)
	ShowEndingCard:FireClient(player)
end

local function showTraitsCard(player)
	local traits = TraitStore.Get(player.UserId) or {}
	ShowEndingTraits:FireClient(player, traits)
end

function Progression.Start(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene16Spawn")
	local root = character:FindFirstChild("HumanoidRootPart")

	if root and spawnPart then
		root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
	end

	local connection
	connection = EndingCardFinished.OnServerEvent:Connect(function(finishedPlayer)
		if finishedPlayer == player then
			connection:Disconnect()

			local traits = TraitAnalyzer.ExtractTraits(player.UserId)
			TraitStore.Set(player.UserId, traits)

			showTraitsCard(player)
		end
	end)

	triggerEndingForPlayer(player)
end

return Progression