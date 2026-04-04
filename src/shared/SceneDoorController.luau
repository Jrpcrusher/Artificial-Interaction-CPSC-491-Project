-- References required for this module script.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Scenes = require(ReplicatedStorage.Shared.SceneManager)

local SceneDoorController = {}

local function getCurrentSceneForPlayer(player: Player): number
    local sceneAttr = player:GetAttribute("Scene")
    if typeof(sceneAttr) == "number" then
        return sceneAttr
    end

    -- Fallback if attribute is missing
    return 1
end

function SceneDoorController.TriggerSceneDoor(player: Player): boolean
	if not player or not player:IsDescendantOf(game.Players) then
		warn("SceneDoorController.TriggerSceneDoor called with invalid player")
		return false
	end

	-- Simple re-entry guard so a spammed door doesn't double-transition
	if player:GetAttribute("IsSceneTransitioning") then
		return false
	end

	player:SetAttribute("IsSceneTransitioning", true)

	local currentScene = getCurrentSceneForPlayer(player)
	local ok, msg = Scenes.ChangeScene(player, currentScene)

	if not ok then
		-- msg is a table: { "Scene transition failed: ", message }
		warn(table.unpack(msg))
		player:SetAttribute("IsSceneTransitioning", false)
		return false
	end

	player:SetAttribute("IsSceneTransitioning", false)
	return true
end

return SceneDoorController