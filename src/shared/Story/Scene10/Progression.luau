local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Progression = {}

local function isSitting(player)
	local character = player.Character
	if not character then
		return false
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return false
	end
	return humanoid.SeatPart ~= nil
end

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene10Objects")

	local Friend = SceneObjects:WaitForChild("Friend")
	Friend:PivotTo(CFrame.new(-282, -27, -28))

	local DeskTrigger = SceneObjects:WaitForChild("DeskTrigger")
	DeskTrigger.Position = Vector3.new(-243.135, -23.831, -36.207)

	local Quiz = SceneObjects:WaitForChild("Quiz")
	Quiz.Position = Vector3.new(-243.135, -21.831, -36.207)

	local SchoolDoorTrigger = SceneObjects:WaitForChild("SchoolDoorTrigger")
	SchoolDoorTrigger.Position = Vector3.new(-236.534, -26.555, -63.929)
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene10Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		
		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene10Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = CFrame.new(35.546, 29.555, -29.5) + Vector3.new(0, 3, 0)
		end

		local libraryCollisionPart = workspace
			:WaitForChild("Map")
			:WaitForChild("School")
			:WaitForChild("Doors")
			:WaitForChild("Doorway_Library")
			:WaitForChild("InsideDoor")
			:WaitForChild("CollisionPart")

		if libraryCollisionPart then
			libraryCollisionPart.CanCollide = false
			libraryCollisionPart.CanTouch = false
			libraryCollisionPart.CanQuery = false
			print("Library door collision disabled!")
		else
			warn("Library CollisionPart NOT found!")
		end

		local classroomCollisionPart = workspace
			:WaitForChild("Map")
			:WaitForChild("School")
			:WaitForChild("Doors")
			:WaitForChild("Doorway_Classroom102")
			:WaitForChild("InsideDoor")
			:WaitForChild("CollisionPart")

		if classroomCollisionPart then
			classroomCollisionPart.CanCollide = false
			classroomCollisionPart.CanTouch = false
			classroomCollisionPart.CanQuery = false
			print("Classroom 102 collision disabled!")
		else
			warn("Classroom 102 CollisionPart NOT found!")
		end

		TaskService.ResetForScene(player, 10)

		TaskService.LoadTasks(player, 10, {
			"talk_to_friend",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_friend",
		})

		TaskService.LoadTasks(player, 10, {
			"sit_at_desk",
		})
		repeat
			task.wait(0.5)
		until isSitting(player)

		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
		end

		TaskService.LoadTasks(player, 10, {
			"flip_quiz",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"flip_quiz",
		})

		if humanoid then
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
		end

		TaskService.LoadTasks(player, 10, {
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