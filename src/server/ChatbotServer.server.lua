-- Reference to module script connecting AI chat bot to the game.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Query = require(ReplicatedStorage.Shared.Query)

-- References to remote events in ReplicatedStorage.
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ChatbotRequest = Remotes:WaitForChild("ChatbotRequest")
local ChatbotResponse = Remotes:WaitForChild("ChatbotResponse")