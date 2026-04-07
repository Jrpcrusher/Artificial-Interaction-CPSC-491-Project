--[[Required setup for saving messages and game state during scene transition.]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameSaveManager = require(ReplicatedStorage.Shared.Systems.Save.GameSaveManager)
local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)

local SceneFolder = script.Parent.Parent.Parent.Story

local SceneModules = table.freeze({
	[1] = require(SceneFolder.Scene1.Progression),
	[2] = require(SceneFolder.Scene2.Progression),
	[3] = require(SceneFolder.Scene3.Progression),
	[4] = require(SceneFolder.Scene4.Progression),
	[5] = require(SceneFolder.Scene5.Progression),
	[6] = require(SceneFolder.Scene6.Progression),
	[7] = require(SceneFolder.Scene7.Progression),
	[8] = require(SceneFolder.Scene8.Progression),
	[9] = require(SceneFolder.Scene9.Progression),
	[10] = require(SceneFolder.Scene10.Progression),
	[11] = require(SceneFolder.Scene11.Progression),
	[12] = require(SceneFolder.Scene12.Progression),
	[13] = require(SceneFolder.Scene13.Progression),
	[14] = require(SceneFolder.Scene14.Progression),
	[15] = require(SceneFolder.Scene15.Progression),
	[16] = require(SceneFolder.Scene16.Progression),
})

local SceneManager = {}

-- Direct scene loader helper function to be used for Main Menu Logic.
function SceneManager.LoadScene(player, sceneNumber: number)
	local scene = SceneModules[sceneNumber]
	if not scene then
		return false, string.format("Invalid scene number: %d", sceneNumber)
	end

	local success, message = pcall(function()
		scene.Load()
	end)

	if not success then
		return false, string.format("Error loading scene %d: %s", sceneNumber, message)
	end

	player:SetAttribute("Scene", sceneNumber)
	return true, string.format("Scene loaded: %d", sceneNumber)
end

-- Takes in player object to be used by GameSaveManager.
function SceneManager.ChangeScene(player, state: number)
	-- Given the state, load the appropriate assets
	-- Each scene will have separate logic
	local current_scene = SceneModules[state]

	local success, message = pcall(function()
		if current_scene then -- Unload the previous scene
			current_scene.Unload()
		else
			error(string.format("Error unloading scene: %d", state + 1))
		end

		local next_scene = SceneModules[state + 1]
		if next_scene then -- Load the next state now
			next_scene.Load()
		else
			error(string.format("Error loading scene: %d", state + 1))
		end
	end)

	if not success then -- If we fail, say that we do
		return false, { "Scene transition failed: ", message }
	end

	-- Saves current game state and messages after successful transition.
	local new_scene_number = state + 1
	player:SetAttribute("Scene", new_scene_number) -- Live state of the player's current save.
	GameSaveManager.Save(player.UserId, new_scene_number) -- Persistent state of the player's current save.

	TranscriptManager.Save(player.UserId)

	return true, { "Scene changed to: ", state + 1 }
end

function SceneManager.GetScene(sceneNumber: number)
	return SceneModules[sceneNumber]
end

return SceneManager
