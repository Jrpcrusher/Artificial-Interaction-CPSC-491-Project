local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]
		local sceneNumber = 10

		TaskService.ResetForScene(player, sceneNumber)

		-- Phase 1
		TaskService.LoadTasks(player, sceneNumber, {
			"talk_to_friend",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_friend",
		})

		-- Phase 2
		TaskService.LoadTasks(player, sceneNumber, {
			"sit_at_desk",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"sit_at_desk",
		})

		-- Phase 3
		TaskService.LoadTasks(player, sceneNumber, {
			"flip_quiz",
		})
        
        repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"flip_quiz",
		})

        -- Phase 4
		TaskService.LoadTasks(player, sceneNumber, {
			"talk_to_ai",
		})
        
        repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_ai",
		})

        -- Phase 5
        TaskService.LoadTasks(player, sceneNumber, {
			"go_to_door",
		})
	end)
end

return Progression