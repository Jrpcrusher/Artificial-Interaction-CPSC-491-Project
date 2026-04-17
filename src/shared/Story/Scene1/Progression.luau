local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

function Progression.Start(player)
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene1Spawn")
		character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end
		
		TaskService.ResetForScene(player, 1)
		StartDialogue:FireClient(player, "Player", "start")
		
		-- Phase 1
		TaskService.LoadTasks(player, 1, {
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

		-- Phase 2
		TaskService.LoadTasks(player, 1, {
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
