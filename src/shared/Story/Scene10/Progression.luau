local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Common = require(ReplicatedStorage.Shared.Story.Common.StoryCommon)

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ShowAIChatGui = Remotes.Chat:WaitForChild("ShowAIChatGui")

local SceneObjects = workspace:WaitForChild("Scene10Objects")
local Quiz = SceneObjects:WaitForChild("Quiz")
local Teacher = SceneObjects:WaitForChild("Teacher")

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
	local Friend = SceneObjects:WaitForChild("Friend")
	Friend:PivotTo(CFrame.new(-282, 26.428, -28))

	Teacher:PivotTo(CFrame.new(-266.735, 26.555, -19.429))

	local DeskTrigger = SceneObjects:WaitForChild("DeskTrigger")
	DeskTrigger.Position = Vector3.new(-243.135, -23.831, -36.207)

	Quiz.Position = Vector3.new(-243.135, 25.011, -35.094)
	Quiz.Orientation = Vector3.new(-243.135, 12.011, -35.094)

	local SchoolDoorTrigger = SceneObjects:WaitForChild("SchoolDoorTrigger")
	SchoolDoorTrigger.Position = Vector3.new(-237.635, 26.873, -63.929)
end

function Progression.Unload()
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
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
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
		else
			warn("Classroom 102 CollisionPart NOT found!")
		end

		TaskService.ResetForScene(player, 10)

		TaskService.LoadTasks(player, 10, {
			"talk_to_friend",
		})
		Common.WaitForTasks(player, {"talk_to_friend"})

		TaskService.LoadTasks(player, 10, {
			"sit_at_desk",
		})
		repeat
			task.wait()
		until isSitting(player)

		
		-- Spawn teacher when sitting

		Teacher:PivotTo(CFrame.new(-257.735, 26.555, -20.429) * CFrame.Angles(0, math.rad(-20), 0))

		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
		end

		TaskService.LoadTasks(player, 10, {
			"flip_quiz",
		})
		Common.WaitForTasks(player, {"flip_quiz"})

		-- Have the dialogue play for the quiz is hard
		Common.StartDialogueAndWait(player, "Teacher", "teacherStart")

		task.wait(1)
		-- Animation of flipping the quiz
		local goal = {
			Orientation = Quiz.Orientation + Vector3.new(0, 180, 0),
		}
		local FlipQuiz = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local animation = TweenService:Create(Quiz, FlipQuiz, goal)
		animation:Play()
		animation.Completed:Wait()

		-- Start the next length of dialogue
		Common.StartDialogueAndWait(player, "Player", "start")

		-- Now charlie comes in
		ShowAIChatGui:FireClient(player, "enable") -- shows AI Chat Gui
		TaskService.LoadTasks(player, 10, {
			"use_charlie_on_quiz",
		})

		Common.WaitForTasks(player, {"use_charlie_on_quiz"})
		Common.WaitForChatClose(player, {"use_charlie_on_quiz"})
		Common.StartDialogueAndWait(player, "Player", "relief")
		ShowAIChatGui:FireClient(player, "disable") -- close AI Chat Gui

		-- Now spawn the teacher
		Teacher:PivotTo(CFrame.new(-244.317, 26.555, -33.934) * CFrame.Angles(0, math.rad(-30), 0))
		Common.StartDialogueAndWait(player, "Teacher", "catchCheating")

		Quiz:Destroy()
		task.wait(3)
		if humanoid then
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
		end

		TaskService.LoadTasks(player, 10, {
			"go_to_door",
		})
		Common.WaitForTasks(player, {"go_to_door"})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression
