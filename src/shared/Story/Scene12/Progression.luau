local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local FinishDialogue = Remotes.Dialogue:WaitForChild("FinishDialogue")
local ShowAIChatGui = Remotes.Chat:WaitForChild("ShowAIChatGui")
local ChatWindowIsClosed = Remotes.Chat:WaitForChild("ChatWindowIsClosed")

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
	local SceneObjects = workspace:WaitForChild("Scene12Objects")

	local BedTrigger = SceneObjects:WaitForChild("BedTrigger")
	BedTrigger.Position = Vector3.new(14.145, 37.355, -65.143)
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

		StartDialogue:FireClient(player, "Player", "start")
		waitForDialogueToEnd(player, "start")
		ShowAIChatGui:FireClient(player)

		TaskService.LoadTasks(player, 12, {
			"talk_about_cheating_on_quiz",
			"talk_about_mom_dad_arguing",
			"talk_about_sis",
			"talk_about_panic_attacks",
			"talk_about_judgement_at_school",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
				"talk_about_cheating_on_quiz",
				"talk_about_mom_dad_arguing",
				"talk_about_sis",
				"talk_about_panic_attacks",
				"talk_about_judgement_at_school",
			})

		waitForChatWindowToClose(player, true)

		StartDialogue:FireClient(player, "Player", "task1monologue")
		waitForDialogueToEnd(player, "task1monologue")
		ShowAIChatGui:FireClient(player)

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
