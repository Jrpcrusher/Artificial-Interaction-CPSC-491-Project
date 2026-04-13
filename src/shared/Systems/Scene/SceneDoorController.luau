local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local SceneDoorController = {}

function SceneDoorController.TriggerSceneDoor(player: Player): boolean -- Function to trigger when we touch the door
	if not player or not player:IsDescendantOf(game.Players) then
		warn("SceneDoorController.TriggerSceneDoor called with invalid player") -- If we arent able to open, then dont
		return false
	end

	local ok, msg = SceneManager.Transition(player) -- Call transition to the next scene when interacting with the door
	if not ok then
		warn(msg) -- if fail, say warning message
		return false
	end

	return true
end

return SceneDoorController