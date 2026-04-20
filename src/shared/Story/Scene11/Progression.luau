local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene11Objects")

	local Dad = SceneObjects:WaitForChild("Dad")
	Dad:PivotTo(CFrame.new(52.95, -27.349, -94.078))

	local Mom = SceneObjects:WaitForChild("Mom")
	Mom:PivotTo(CFrame.new(41.649, -27.349, -101.433))

	local Phone = SceneObjects:WaitForChild("Phone")
	Phone.Position = Vector3.new(47, -26.155, -91.378)

	local RoomDoorTrigger = SceneObjects:WaitForChild("RoomDoorTrigger")
	RoomDoorTrigger.Position = Vector3.new(19.563, -40.355, -77.999)
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene11Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		
		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene11Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = CFrame.new(35.546, 30.555, -29.5) + Vector3.new(0, 3, 0)
		end

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