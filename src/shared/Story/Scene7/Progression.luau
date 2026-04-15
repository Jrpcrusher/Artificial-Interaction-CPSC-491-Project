local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]

		TaskService.ResetForScene(player, 7)

		StartDialogue:FireClient(player, "Player", "start")

		TaskService.LoadTasks(player, 7, {
			"go_home",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_home",
		})
	end)
end

return Progression