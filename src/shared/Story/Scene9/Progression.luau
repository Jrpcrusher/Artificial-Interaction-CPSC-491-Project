local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene9Objects")

	local Sister = SceneObjects:WaitForChild("Sister")
	Sister:PivotTo(CFrame.new(37.6, -27.349, -85.793))

	local FridgeTrigger = SceneObjects:WaitForChild("FridgeTrigger")
	FridgeTrigger.Position = Vector3.new(57.554, -26.555, -83.203)

	local FrontDoorTrigger = SceneObjects:WaitForChild("FrontDoorTrigger")
	FrontDoorTrigger.Position = Vector3.new(35.6, -27.355, -27.038)
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene9Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene9Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = CFrame.new(35.546, 28.555, -29.5) + Vector3.new(0, 3, 0)
		end

		local collisionPart = workspace
			:WaitForChild("Map")
			:WaitForChild("House")
			:WaitForChild("Doors")
			:WaitForChild("TDW")
			:WaitForChild("InsideDoor")
			:WaitForChild("CollisionPart")

		if collisionPart then
			collisionPart.CanCollide = false
			collisionPart.CanTouch = false
			collisionPart.CanQuery = false
			print("TDW Door Collision disabled!")
		else
			warn("TDW CollisionPart NOT found!")
		end

		TaskService.ResetForScene(player, 9)

		TaskService.LoadTasks(player, 9, {
			"eat_food",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"eat_food",
		})

		TaskService.LoadTasks(player, 9, {
			"talk_to_sister",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_sister",
		})

		TaskService.LoadTasks(player, 9, {
			"go_to_door",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression