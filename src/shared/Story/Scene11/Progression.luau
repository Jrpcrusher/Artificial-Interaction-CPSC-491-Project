local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]
		local sceneNumber = 11

		TaskService.ResetForScene(player, sceneNumber)

		-- Phase 1
		TaskService.LoadTasks(player, sceneNumber, {
			"talk_to_parents",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_parents",
		})

		-- Phase 2
		TaskService.LoadTasks(player, sceneNumber, {
			"answer_phone",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"answer_phone",
		})

		-- Phase 3
		TaskService.LoadTasks(player, sceneNumber, {
			"go_to_door",
		})
	end)
end

return Progression