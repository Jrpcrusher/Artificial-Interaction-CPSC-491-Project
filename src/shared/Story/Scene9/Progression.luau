local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene9Objects")

	local Sister = SceneObjects:WaitForChild("Sister")
	Sister:PivotTo(CFrame.new(37.6, 27.292, -85.793))
	print("MOved sister")
	local FridgeTrigger = SceneObjects:WaitForChild("FridgeTrigger")
	FridgeTrigger.Position = Vector3.new(54.554, 26.505, -83.203)
	print("MOved fridge")
	local FrontDoorTrigger = SceneObjects:WaitForChild("FrontDoorTrigger")
	FrontDoorTrigger.Position = Vector3.new(35.6, 27.155, -27.519)
	print("MOved trigger, loading complete")
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene9Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	print("in start of scene 9")
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene9Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end
		print("we spawned")

		local collisionPart = workspace
			:WaitForChild("Map")
			:WaitForChild("House")
			:WaitForChild("DoubleStoryUrbanHouse")
			:WaitForChild("UpperLevel")
			:WaitForChild("Doors")
			:WaitForChild("TDW")
			:WaitForChild("Door")
			:WaitForChild("ThePart")
		print("We got the collision part")
		if collisionPart then
			collisionPart.CanCollide = false
			collisionPart.CanTouch = false
			collisionPart.CanQuery = false
			print("TDW Door Collision disabled!")
		else
			warn("TDW CollisionPart NOT found!")
		end
		print("collision removed")
		TaskService.ResetForScene(player, 9)

		TaskService.LoadTasks(player, 9, {
			"eat_food",
		})
		repeat
			print("Waiting for user to eat food")
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