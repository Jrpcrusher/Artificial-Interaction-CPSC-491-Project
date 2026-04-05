local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DialogueHandler = require(ReplicatedStorage.Shared.DialogueHandler)
local DialogueController = require(ReplicatedStorage.Shared.DialogueController)

local StartDialogue = ReplicatedStorage.Shared.Remotes:WaitForChild("StartDialogue")

local dialogueGui = script.Parent.Parent
local handler = DialogueHandler.new(dialogueGui)

DialogueController.SetHandler(handler)

StartDialogue.OnClientEvent:Connect(function(dialogueId, startNode)
    DialogueController.StartById(dialogueId, startNode)
end)