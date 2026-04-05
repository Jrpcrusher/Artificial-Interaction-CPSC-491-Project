local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Scene1 = require(ReplicatedStorage.Shared.Scenes.Scene1)
local Scene2 = require(ReplicatedStorage.Shared.Scenes.Scene2)
local Scene3 = require(ReplicatedStorage.Shared.Scenes.Scene2)
local Scene4 = require(ReplicatedStorage.Shared.Scenes.Scene2)
local Scene5 = require(ReplicatedStorage.Shared.Scenes.Scene2)
local Scene6 = require(ReplicatedStorage.Shared.Scenes.Scene2)
local Scene7 = require(ReplicatedStorage.Shared.Scenes.Scene2)
local Scene8 = require(ReplicatedStorage.Shared.Scenes.Scene2)

local DialogueController = {}

local handler = nil

local DialogueRegistry = {
	GuardIntro = {
		tree = Scene1.DialogueTree,
		startNode = "start",
	},
}

function DialogueController.SetHandler(newHandler)
	handler = newHandler
end

function DialogueController.Start(dialogueTree, startNode)
	if not handler then
		warn("Dialogue handler has not been set yet.")
		return
	end

	handler:Start(dialogueTree, startNode or "start")
end

function DialogueController.StartById(dialogueId, startNode)
	local entry = DialogueRegistry[dialogueId]
	if not entry then
		warn("Unknown dialogue id:", dialogueId)
		return
	end
	DialogueController.Start(entry.tree, startNode or entry.startNode or "start")
end

function DialogueController.Stop()
	if handler then
		handler:Stop()
	end
end

return DialogueController
