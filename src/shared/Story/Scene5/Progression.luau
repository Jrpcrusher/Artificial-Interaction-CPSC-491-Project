local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]

		TaskService.ResetForScene(player, 5)

		StartDialogue:FireClient(player, "Player", "start")

		TaskService.LoadTasks(player, 5, {
			"grab_backpack",
			"grab_calculator",
			"grab_keys",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"grab_backpack",
			"grab_calculator",
			"grab_keys",
		})
		TaskService.LoadTasks(player, 5, {
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