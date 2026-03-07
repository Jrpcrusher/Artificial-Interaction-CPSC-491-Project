print("ChatbotServer loaded.")

-- Reference to module script connecting AI chat bot to the game.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Query = require(ReplicatedStorage.Shared.Query)
local MessageManager = require(ReplicatedStorage.Shared.MessageManager)
local TranscriptManager = require(ServerScriptService.Server.TranscriptManager)

-- References to remote events in ReplicatedStorage.
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ChatbotRequest = Remotes:WaitForChild("ChatbotRequest")
local ChatbotResponse = Remotes:WaitForChild("ChatbotResponse")

-- Fired when a player sends a message from the UI.
ChatbotRequest.OnServerEvent:Connect(function(player, message)
	-- Ask the AI model for a reply using message.
	local reply = Query.AskAI(message)
	local time_value = os.time()
	local _, debug_statement = TranscriptManager.Add(MessageManager.Create("AI", time_value, reply))
	TranscriptManager.Save()
	print(TranscriptManager.Get())
	print(debug_statement)

	-- Fallback if the AI fails
	if reply == -1 then
		reply = "Sorry, AI model is currently unreachable."
	end

	-- Send the AI's message response (or error message) back to the player.
	ChatbotResponse:FireClient(player, reply)
end)
