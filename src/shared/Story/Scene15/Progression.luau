local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

function Progression.Start(player)
	task.spawn(function()

		TaskService.ResetForScene(player, 15)

		-- Phase 1
		TaskService.LoadTasks(player, 15, {
			"check_on_older_sibling",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"check_on_older_sibling",
		})

		-- Phase 2
		TaskService.LoadTasks(player, 15, {
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
