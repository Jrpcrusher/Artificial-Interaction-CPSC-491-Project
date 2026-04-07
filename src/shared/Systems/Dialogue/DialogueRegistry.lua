local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Scene1 = require(ReplicatedStorage.Shared.Story.Scene1.Dialogue)
local Scene2 = require(ReplicatedStorage.Shared.Story.Scene2.Dialogue)
local Scene3 = require(ReplicatedStorage.Shared.Story.Scene3.Dialogue)
local Scene4 = require(ReplicatedStorage.Shared.Story.Scene4.Dialogue)
local Scene5 = require(ReplicatedStorage.Shared.Story.Scene5.Dialogue)
local Scene6 = require(ReplicatedStorage.Shared.Story.Scene6.Dialogue)
local Scene7 = require(ReplicatedStorage.Shared.Story.Scene7.Dialogue)
local Scene8 = require(ReplicatedStorage.Shared.Story.Scene8.Dialogue)
local Scene9 = require(ReplicatedStorage.Shared.Story.Scene9.Dialogue)
local Scene10 = require(ReplicatedStorage.Shared.Story.Scene10.Dialogue)
local Scene11 = require(ReplicatedStorage.Shared.Story.Scene11.Dialogue)
local Scene12 = require(ReplicatedStorage.Shared.Story.Scene12.Dialogue)
local Scene13 = require(ReplicatedStorage.Shared.Story.Scene13.Dialogue)
local Scene14 = require(ReplicatedStorage.Shared.Story.Scene14.Dialogue)
local Scene15 = require(ReplicatedStorage.Shared.Story.Scene15.Dialogue)
local Scene16 = require(ReplicatedStorage.Shared.Story.Scene16.Dialogue)


local DialogueController = {}

local handler = nil

local DialogueRegistry = {
	Dad = {
		tree = Scene1.DadDialogueTree,
		startNode = "scene1Start",
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
