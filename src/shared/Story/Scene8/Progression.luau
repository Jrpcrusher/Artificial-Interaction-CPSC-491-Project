local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local Common = require(ReplicatedStorage.Shared.Story.Common.StoryCommon)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local DialogueRemotes = Remotes:WaitForChild("Dialogue")
local StartDialogue = DialogueRemotes:WaitForChild("StartDialogue")
local ShowAIChatGui = Remotes:WaitForChild("Chat"):WaitForChild("ShowAIChatGui")


local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene8Objects")

	local Dad = SceneObjects:WaitForChild("Dad")
	Dad:PivotTo(CFrame.new(19.12, 27.434, -54.057) * CFrame.Angles(0, math.rad(-116.063), 0))

	local Mom = SceneObjects:WaitForChild("Mom")
	Mom:PivotTo(CFrame.new(24.1, 27.355, -53) * CFrame.Angles(0, math.rad(90), 0))

	local DialogueTrigger2 = SceneObjects:WaitForChild("DialogueTrigger2")
	DialogueTrigger2.Position = Vector3.new(35.5, 29.555, -36)

	local DoorTrigger = SceneObjects:WaitForChild("Part")
	DoorTrigger.Position = Vector3.new(23.65, 40.53, -77.799)

	local Homework = SceneObjects:WaitForChild("homework")
	Homework:PivotTo(CFrame.new(4.402, 38.952, -80.995) * CFrame.Angles(0, math.rad(180), 0))

	local Bed = SceneObjects:WaitForChild("Bed")
	Bed:PivotTo(CFrame.new(16.29, 38.955, -65.043))
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene8Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()

	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene8Spawn")
		local root = character:WaitForChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 8)

		StartDialogue:FireClient(player, "Player", "start")

		local DialogueTrigger2 = workspace.Scene8Objects:WaitForChild("DialogueTrigger2")
		local parentsTriggered = false

		DialogueTrigger2.Touched:Connect(function(hit)
			if parentsTriggered then
				return
			end

			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(currentCharacter) then
				parentsTriggered = true
				StartDialogue:FireClient(player, "Parents", "start")
				DialogueTrigger2:Destroy()
			end
		end)

		local DoorTrigger = workspace.Scene8Objects:WaitForChild("Part")
		local DoorPrompt = DoorTrigger:WaitForChild("ProximityPrompt")
		local RoomSpawn = workspace:WaitForChild("Spawns"):WaitForChild("Scene8RoomSpawn")
		local usedDoor = false

		DoorPrompt.Triggered:Connect(function(triggeringPlayer)
			if usedDoor or triggeringPlayer ~= player then
				return
			end

			usedDoor = true

			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			local currentRoot = currentCharacter:FindFirstChild("HumanoidRootPart")
			if currentRoot and RoomSpawn then
				currentRoot.CFrame = RoomSpawn.CFrame + Vector3.new(0, 3, 0)
			end
		end)

		TaskService.LoadTasks(player, 8, {
			"go_upstairs_to_room",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_upstairs_to_room",
		})

		TaskService.LoadTasks(player, 8, {
			"do_homework",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"do_homework",
		})

		Common.startDialogueAndWait(player, "Homework", "start")

		ShowAIChatGui:FireClient(player, "enable") -- open AI for user

		TaskService.LoadTasks(player, 8, {
			"talk_to_charlie",
		})
		Common.waitForTasksThenWaitForChatClose(player, {"talk_to_charlie"})
		ShowAIChatGui:FireClient(player, "disable")

		StartDialogue:FireClient(player, "Charlie", "start")

		TaskService.LoadTasks(player, 8, {
			"go_to_bed",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_bed",
		})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression
