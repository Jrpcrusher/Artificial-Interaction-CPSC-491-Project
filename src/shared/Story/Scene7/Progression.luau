local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

local function seatPlayer(player)
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	local sceneFolder = workspace:WaitForChild("Scene7Objects")
	local chair = sceneFolder:WaitForChild("ClassroomPlayerDesk")
	local seatTarget = chair:WaitForChild("Seat")

	if not humanoid or not root then
		return
	end

	root.CFrame = seatTarget.CFrame + Vector3.new(0, 2, 0)
	task.wait(0.1)

	humanoid.Sit = true
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.JumpHeight = 0
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
end

local function unseatPlayer(player)
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	humanoid.Sit = false
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.JumpHeight = 7.2
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
end

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene7Objects")

	local Boy1 = SceneObjects:WaitForChild("Boy1")
	Boy1:PivotTo(CFrame.new(-253.735, 24.555, -33.951) * CFrame.Angles(0, 0, 0))

	local Boy2 = SceneObjects:WaitForChild("Boy2")
	Boy2:PivotTo(CFrame.new(-253.576, 24.579, -38.35) * CFrame.Angles(0, math.rad(180), 0))

	local ClassroomPlayerDesk = SceneObjects:WaitForChild("ClassroomPlayerDesk")
	ClassroomPlayerDesk:PivotTo(CFrame.new(-243.135, 23.831, -36.207) * CFrame.Angles(0, math.rad(180), math.rad(180)))

	local Student = SceneObjects:WaitForChild("Student")
	Student:PivotTo(CFrame.new(-260.12, 25.029, -24.93) * CFrame.Angles(0, math.rad(135), 0))

	local Student2 = SceneObjects:WaitForChild("Student2")
	Student2:PivotTo(CFrame.new(-257.735, 24.755, -20.429) * CFrame.Angles(0, math.rad(45), 0))

	local Teacher = SceneObjects:WaitForChild("Teacher")
	Teacher:PivotTo(CFrame.new(-264.135, 25.405, -20.033) * CFrame.Angles(0, math.rad(-45), 0))

	local Chair = SceneObjects:WaitForChild("Chair")
	Chair.CFrame = CFrame.new(-243.435, 24.085, -36.584) * CFrame.Angles(0, 0, 0)
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene7Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()

	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene7Spawn")
		local root = character:WaitForChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 7)


		StartDialogue:FireClient(player, "Player", "start")

		TaskService.LoadTasks(player, 7, {
			"sit_down",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"sit_down",
		})

		seatPlayer(player)

		task.wait(0.5)
		StartDialogue:FireClient(player, "Conversation", "start")


		task.wait(10)
		unseatPlayer(player)


		TaskService.LoadTasks(player, 7, {
			"go_home",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_home",
		})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression