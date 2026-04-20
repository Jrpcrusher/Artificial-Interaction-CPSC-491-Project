local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene12Objects")

	local BedTrigger = SceneObjects:WaitForChild("BedTrigger")
	BedTrigger.Position = Vector3.new(16.19, 37.645, -64.643)
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene12Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		
		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene12Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 12)

		TaskService.LoadTasks(player, 12, {
			"go_to_sleep",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_sleep",
		})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression