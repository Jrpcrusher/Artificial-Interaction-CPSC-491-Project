local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene11Objects")

	local Dad = SceneObjects:WaitForChild("Dad")
	Dad:PivotTo(CFrame.new(5.784, 27.233, -36.256))
	print("Loaded dad")

	local Mom = SceneObjects:WaitForChild("Mom")
	Mom:PivotTo(CFrame.new(8.882, 27.233, -33.134))
	print("Loaded mom")
	local Phone = SceneObjects:WaitForChild("Phone")
	Phone:PivotTo(CFrame.new(4.729, 25.875, -29.223))
	print("Loaded phone")
	local RoomDoorTrigger = SceneObjects:WaitForChild("RoomDoorTrigger")
	RoomDoorTrigger.Position = Vector3.new(20.21, 40.555, -77.999)
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene11Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	print("In scene 11")
	Progression.Load()
	print("In scene 11 loading finished")
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		
		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene11Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end
		print("spawned player")

		TaskService.ResetForScene(player, 11)

		TaskService.LoadTasks(player, 11, {
			"talk_to_parents",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_parents",
		})

		TaskService.LoadTasks(player, 11, {
			"answer_phone",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"answer_phone",
		})

		TaskService.LoadTasks(player, 11, {
			"go_to_room",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_room",
		})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression