local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DialogueHandler = require(ReplicatedStorage.Shared.Systems.Dialogue.DialogueHandler)
local DialogueController = require(ReplicatedStorage.Shared.Systems.Dialogue.DialogueRegistry)

local DialogueRemotes = ReplicatedStorage.Remotes:WaitForChild("Dialogue")
local StartDialogue = DialogueRemotes:WaitForChild("StartDialogue")

local player = Players.LocalPlayer
local dialogueGui = script.Parent.Parent
local handler = DialogueHandler.new(dialogueGui)

DialogueController.SetHandler(handler)

StartDialogue.OnClientEvent:Connect(function(npcId, startNode)
	DialogueController.StartByNpc(player, npcId, startNode)
end)