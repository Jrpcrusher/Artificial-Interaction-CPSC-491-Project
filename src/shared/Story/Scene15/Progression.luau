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
			"check_on_older_sibling",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"check_on_older_sibling",
		})

		-- Phase 2
		TaskService.LoadTasks(player, sceneNumber, {
			"save_your_older_sibling",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"save_your_older_sibling",
		})
	end)
end

return Progression
