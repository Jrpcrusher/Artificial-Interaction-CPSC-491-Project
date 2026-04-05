local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DialogueHandler = require(ReplicatedStorage.Shared.DialogueHandler)
local DialogueController = require(ReplicatedStorage.Shared.DialogueController)

local dialogueGui = script.Parent.Parent
local handler = DialogueHandler.new(dialogueGui)

DialogueController.SetHandler(handler)