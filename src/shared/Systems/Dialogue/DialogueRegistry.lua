local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SceneDialogueModules = {
	[1] = require(ReplicatedStorage.Shared.Story.Scene1.Dialogue),
	[2] = require(ReplicatedStorage.Shared.Story.Scene2.Dialogue),
	[3] = require(ReplicatedStorage.Shared.Story.Scene3.Dialogue),
	[4] = require(ReplicatedStorage.Shared.Story.Scene4.Dialogue),
	[5] = require(ReplicatedStorage.Shared.Story.Scene5.Dialogue),
	[6] = require(ReplicatedStorage.Shared.Story.Scene6.Dialogue),
	[7] = require(ReplicatedStorage.Shared.Story.Scene7.Dialogue),
	[8] = require(ReplicatedStorage.Shared.Story.Scene8.Dialogue),
	[9] = require(ReplicatedStorage.Shared.Story.Scene9.Dialogue),
	[10] = require(ReplicatedStorage.Shared.Story.Scene10.Dialogue),
	[11] = require(ReplicatedStorage.Shared.Story.Scene11.Dialogue),
	[12] = require(ReplicatedStorage.Shared.Story.Scene12.Dialogue),
	[13] = require(ReplicatedStorage.Shared.Story.Scene13.Dialogue),
	[14] = require(ReplicatedStorage.Shared.Story.Scene14.Dialogue),
	[15] = require(ReplicatedStorage.Shared.Story.Scene15.Dialogue),
	[16] = require(ReplicatedStorage.Shared.Story.Scene16.Dialogue),
}

local DialogueController = {}
local handler = nil

function DialogueController.SetHandler(newHandler) -- Set where we are doing our dialogue
	handler = newHandler
end

function DialogueController.Start(dialogueTree, startNode) -- Start the dialogue
	if not handler then
		warn("Dialogue handler has not been set yet.")
		return
	end

	handler:Start(dialogueTree, startNode or "start")
end

function DialogueController.StartByNpc(player, npcId, startNode)
	local current_scene = player:GetAttribute("Scene") or 1 -- get current scene
	local sceneModule = SceneDialogueModules[current_scene] -- get module

	if not sceneModule or not sceneModule.Registry then -- if no dialogue found in registry for scene, give warning
		warn("No dialogue registry for scene:", current_scene)
		return
	end

	local entry = sceneModule.Registry[npcId]
	if not entry then -- If no dialogue, send warning
		warn("No dialogue found for NPC:", npcId, "in scene:", current_scene)
		return
	end

	DialogueController.Start(entry.tree, startNode or entry.defaultStartNode or "start") -- Start the dialogue
end

function DialogueController.Stop()
	if handler then
		handler:Stop()
	end
end

return DialogueController
