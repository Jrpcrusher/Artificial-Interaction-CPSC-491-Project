local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]

		TaskService.ResetForScene(player, 8)

		StartDialogue:FireClient(player, "Player", "start")

		-- Phase 1
		TaskService.LoadTasks(player, 8, {
			"go_upstairs_to_room",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_upstairs_to_room",
		})

		-- Phase 2
		TaskService.LoadTasks(player, 8, {
			"do_homework",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"do_homework",
		})

		-- Phase 3
		TaskService.LoadTasks(player, 8, {
			"talk_to_charlie",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_charlie",
		})
	end)
end

return Progression