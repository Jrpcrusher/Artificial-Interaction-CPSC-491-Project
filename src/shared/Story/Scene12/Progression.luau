local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]
		local sceneNumber = 12

		TaskService.ResetForScene(player, sceneNumber)

		-- Phase 1
		TaskService.LoadTasks(player, sceneNumber, {
			"talk_to_ai",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_ai",
		})

		-- Phase 2
		TaskService.LoadTasks(player, sceneNumber, {
			"go_to_sleep",
		})
    end)
end

return Progression