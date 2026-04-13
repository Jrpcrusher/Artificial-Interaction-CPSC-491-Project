local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]
		local sceneNumber = 1

		TaskService.ResetForScene(player, sceneNumber)

		-- Phase 1
		TaskService.LoadTasks(player, sceneNumber, {
			"pick_up_apple",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"pick_up_apple",
		})

		-- Phase 2
		TaskService.LoadTasks(player, sceneNumber, {
			"talk_to_dad",
			"talk_to_mom",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_dad",
			"talk_to_mom",
		})

		-- Phase 3
		TaskService.LoadTasks(player, sceneNumber, {
			"go_to_door",
		})
	end)
end

return Progression