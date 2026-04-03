--[[Required setup for saving messages and game state during scene transition.]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameSaveManager = require(ReplicatedStorage.Shared.GameSaveManager)
local TranscriptManager = require(ReplicatedStorage.Shared.TranscriptManager)

local SceneFolder = script.Parent.Scenes

local Scenes = table.freeze({
	[1] = require(SceneFolder.Scene1),
	[2] = require(SceneFolder.Scene2),
	[3] = require(SceneFolder.Scene3),
	[4] = require(SceneFolder.Scene4),
	[5] = require(SceneFolder.Scene5),
	[6] = require(SceneFolder.Scene6),
	[7] = require(SceneFolder.Scene7),
	[8] = require(SceneFolder.Scene8),
	[9] = require(SceneFolder.Scene9),
	[10] = require(SceneFolder.Scene10),
	[11] = require(SceneFolder.Scene11),
	[12] = require(SceneFolder.Scene12),
	[13] = require(SceneFolder.Scene13),
	[14] = require(SceneFolder.Scene14),
	[15] = require(SceneFolder.Scene15),
	[16] = require(SceneFolder.Scene16),
})

-- Direct scene loader helper function to be used for Main Menu Logic.
function Scenes.LoadScene(player, sceneNumber: number)
	local scene = Scenes[sceneNumber]
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
function Scenes.ChangeScene(player, state: number)
	-- Given the state, load the appropriate assets
	-- Each scene will have separate logic
	local current_scene = Scenes[state]

	local success, message = pcall(function()
		if current_scene then -- Unload the previous scene
			current_scene.Unload()
		else
			error(string.format("Error unloading scene: %d", state + 1))
		end

		local next_scene = Scenes[state + 1]
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

return Scenes
