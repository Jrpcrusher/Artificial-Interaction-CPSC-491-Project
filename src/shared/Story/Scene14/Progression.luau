local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Common = require(ReplicatedStorage.Shared.Story.Common.StoryCommon)
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local ShowAIChatGui = Remotes.Chat:WaitForChild("ShowAIChatGui")

local Scene14Objects = workspace:WaitForChild("Scene14Objects")
local DialogueTrigger1 = Scene14Objects:WaitForChild("DialogueTrigger1")

local Progression = {}

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
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene14Objects")
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
		task.wait(1)
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
		Common.WaitForTasks(player, { "go_to_room" })

		-- Phase 1

		-- Teleports player to inside the room.
		if root and teleportPart then
			root.CFrame = teleportPart.CFrame + Vector3.new(0, 3, 0)
		end

		Common.StartDialogueAndWait(player, "Player", "scene14Task1Monologue")

		ShowAIChatGui:FireClient(player, "enable") -- shows AI Chat Gui

		-- Phase 2
		TaskService.LoadTasks(player, 14, { "tell_charlie_mom_being_destructive" })
		Common.WaitForTasks(player, { "tell_charlie_mom_being_destructive" })

		TaskService.LoadTasks(player, 14, { "tell_charlie_about_fight_at_school" })
		Common.WaitForTasks(player, { "tell_charlie_about_fight_at_school" })

		Common.StartDialogueAndWait(player, "Player", "scene14Task2Monologue")

		-- Phase 3
		TaskService.LoadTasks(player, 14, {
			"ask_charlie_for_specific_solution",
		})
		Common.WaitForTasks(player, { "ask_charlie_for_specific_solution" })
		Common.WaitForChatClose(player, { "ask_charlie_for_specific_solution" })

		Common.StartDialogueAndWait(player, "Player", "scene14Task3Monologue")

		ShowAIChatGui:FireClient(player, "disable")

		-- Phase 4
		TaskService.LoadTasks(player, 14, {
			"grab_computer_cord",
		})
		Common.WaitForTasks(player, { "grab_computer_cord" })

		-- Phase 5
		TaskService.LoadTasks(player, 14, {
			"do_the_unthinkable",
		})
		Common.WaitForTasks(player, { "do_the_unthinkable" })

		task.wait(5)
		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression
