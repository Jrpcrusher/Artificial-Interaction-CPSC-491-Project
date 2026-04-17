local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]
		local sceneNumber = 9

		TaskService.ResetForScene(player, sceneNumber)

		-- Phase 1
		TaskService.LoadTasks(player, sceneNumber, {
			"eat_something",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"eat_something",
		})

		-- Phase 2
		TaskService.LoadTasks(player, sceneNumber, {
			"talk_to_sister",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_sister",
		})

		-- Phase 3
		TaskService.LoadTasks(player, sceneNumber, {
			"talk_to_ai",
		})
        
        repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_ai",
		})

        -- Phase 4
        TaskService.LoadTasks(player, sceneNumber, {
			"go_to_door",
		})
	end)
end

return Progression