print("ChatbotServer loaded.")

-- Reference to module script connecting AI chat bot to the game.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Query = require(ReplicatedStorage.Shared.Query)
local MessageManager = require(ReplicatedStorage.Shared.MessageManager)
local TranscriptManager = require(ReplicatedStorage.Shared.TranscriptManager)

-- References to remote events in ReplicatedStorage.
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local function getOrCreateRemote(name: string)
	local remote = Remotes:FindFirstChild(name) -- Checks if the remote event is in the Remotes folder of Replicated Storage.
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = Remotes
	end

	return remote
end

local ChatbotRequest = getOrCreateRemote("ChatbotRequest")
local ChatbotResponse = getOrCreateRemote("ChatbotResponse")

-- Fired when a player sends a message from the UI.
ChatbotRequest.OnServerEvent:Connect(function(player, message)
	local time_value = os.time()
	TranscriptManager.Add(MessageManager.Create(player.UserId, time_value, message))
	-- Ask the AI model for a reply using message.
	local reply = Query.AskAI(message)
	time_value = os.time()
	TranscriptManager.Add(MessageManager.Create(0, time_value, reply))

	-- Fallback if the AI fails
	if reply == -1 then
		reply = "Sorry, AI model is currently unreachable."
	end

	-- Send the AI's message response (or error message) back to the player.
	ChatbotResponse:FireClient(player, reply)
end)
