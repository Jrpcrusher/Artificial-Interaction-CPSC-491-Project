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

function Scenes.ChangeScene(user_id, state: number)
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

	return true, { "Scene changed to: ", state + 1 }
end

return Scenes
