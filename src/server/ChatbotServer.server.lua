print("ChatbotServer loaded.")

-- Reference to module script connecting AI chat bot to the game.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Query = require(ReplicatedStorage.Shared.Query)

-- References to remote events in ReplicatedStorage.
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ChatbotRequest = Remotes:WaitForChild("ChatbotRequest")
local ChatbotResponse = Remotes:WaitForChild("ChatbotResponse")

-- Fired when a player sends a message from the UI.
ChatbotRequest.OnServerEvent:Connect(function(player, message)

    -- Ask the AI model for a reply using message.
    local reply = Query.AskAI(message)

    -- Fallback if the AI fails
    if reply == -1 then
        reply = "Sorry, AI model is currently unreachable."
    end

    -- Send the AI's message response (or error message) back to the player.
    ChatbotResponse:FireClient(player, reply)
end)
