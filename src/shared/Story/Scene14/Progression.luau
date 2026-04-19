local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local FinishDialogue = Remotes.Dialogue:WaitForChild("FinishDialogue")
local ShowAIChatGui = Remotes.Chat:WaitForChild("ShowAIChatGui")
local ChatWindowIsClosed = Remotes.Chat:WaitForChild("ChatWindowIsClosed")

local Scene14Objects = workspace:WaitForChild("Scene14Objects")
local DialogueTrigger1 = Scene14Objects:WaitForChild("DialogueTrigger1")

local Progression = {}

local function waitForDialogueToEnd(player, expectedStartNode)
	local bindable = Instance.new("BindableEvent")
	local connection

	connection = FinishDialogue.OnServerEvent:Connect(function(firingPlayer, finishedStartNode)
		if firingPlayer == player and finishedStartNode == expectedStartNode then
			connection:Disconnect()
			bindable:Fire()
		end
	end)

	bindable.Event:Wait()
	bindable:Destroy()
	print("dialogue finished")
end

local function waitForChatWindowToClose(player, chatWindowClosed)
	local bindable = Instance.new("BindableEvent")
	local connection

	connection = ChatWindowIsClosed.OnServerEvent:Connect(function(firingPlayer, chatWindowStatus)
		if firingPlayer == player and chatWindowStatus == chatWindowClosed then
			connection:Disconnect()
			bindable:Fire()
		end
	end)

	bindable.Event:Wait()
	bindable:Destroy()
	print("chat window has been closed")
end

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene14Objects")

	-- Model positioning
	local Mom = SceneObjects:WaitForChild("Mom")
	Mom:PivotTo(CFrame.new(21.486, 27.311, -48.541) * CFrame.Angles(0, math.rad(-135), 0))

	-- Part positioning
	local Cable = SceneObjects:WaitForChild("Cable")
	Cable:PivotTo(CFrame.new(-1.725, 38.929, -74.941) * CFrame.Angles(math.rad(90), math.rad(180), 0))

	local RollingChair = SceneObjects:WaitForChild("RollingChair")
	RollingChair:PivotTo(CFrame.new(1.887, 37.855, -76.695) * CFrame.Angles(0, math.rad(-125), 0))

	local dialogueTrigger = SceneObjects:WaitForChild("DialogueTrigger1")
	dialogueTrigger.Position = Vector3.new(35.5, 28.855, -46)

	local roomInteractionTrigger = SceneObjects:WaitForChild("GoToRoomInteraction")
	roomInteractionTrigger.Position = Vector3.new(20.1, 39.155, -75.999)

	print("loading complete")
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene14ObjectsObjects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene14Spawn")
		local teleportPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene14-2Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 14)
		StartDialogue:FireClient(player, "Player", "scene14IntroMonologue")

		DialogueTrigger1.Touched:Connect(function(hit)
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(currentCharacter) then
				StartDialogue:FireClient(player, "Mom", "scene14DialogueStart")
				DialogueTrigger1:Destroy()
			end
		end)

		TaskService.LoadTasks(player, 14, {
			"go_to_room",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_room",
		})

		waitForDialogueToEnd(player, "scene14DialogueStart")

		-- Phase 1

		-- Teleports player to inside the room.
		if root and teleportPart then
			root.CFrame = teleportPart.CFrame + Vector3.new(0, 3, 0)
		end

		StartDialogue:FireClient(player, "Player", "scene14Task1Monologue")
		waitForDialogueToEnd(player, "scene14Task1Monologue")

		ShowAIChatGui:FireClient(player) -- shows AI Chat Gui

		-- Phase 2
		TaskService.LoadTasks(player, 14, {
			"tell_charlie_mom_being_destructive",
			"tell_charlie_about_fight_at_school",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
				"tell_charlie_mom_being_destructive",
				"tell_charlie_about_fight_at_school",
			})

		-- Trigger to wait for player to close AI chat gui with 'X' GUI button or 'Q' key.
		waitForChatWindowToClose(player, true)

		StartDialogue:FireClient(player, "Player", "scene14Task2Monologue")
		waitForDialogueToEnd(player, "scene14Task2Monologue")
		-- Phase 3
		TaskService.LoadTasks(player, 14, {
			"ask_charlie_for_specific_solution",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"ask_charlie_for_specific_solution",
		})

		waitForChatWindowToClose(player, true)

		StartDialogue:FireClient(player, "Player", "scene14Task3Monologue")
		waitForDialogueToEnd(player, "scene14Task3Monologue")

		ShowAIChatGui:FireClient(player)

		-- Phase 4
		TaskService.LoadTasks(player, 14, {
			"grab_computer_cord",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"grab_computer_cord",
		})

		-- Phase 5
		TaskService.LoadTasks(player, 14, {
			"do_the_unthinkable",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"do_the_unthinkable",
		})

		task.wait(5)
		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression
