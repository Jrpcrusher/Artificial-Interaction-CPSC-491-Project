local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]

		TaskService.ResetForScene(player, 6)

		StartDialogue:FireClient(player, "Player", "start")

		-- Phase 1
		TaskService.LoadTasks(player, 6, {
			"eat_something",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"eat_something",
		})

		-- Phase 2
		TaskService.LoadTasks(player, 6, {
			"grab_coat",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"grab_coat",
		})

		-- Phase 3
		TaskService.LoadTasks(player, 6, {
			"go_to_door",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})
	end)
end

return Progression