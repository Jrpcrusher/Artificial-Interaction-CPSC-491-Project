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

return SceneDoorController