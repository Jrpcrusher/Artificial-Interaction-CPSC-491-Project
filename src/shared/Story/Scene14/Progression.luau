local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local ShowAIChatGui = Remotes.Chat:WaitForChild("ShowAIChatGui")

local Scene14Objects = workspace:WaitForChild("Scene14Objects")
local DialogueTrigger1 = Scene14Objects:WaitForChild("DialogueTrigger1")
local Mom = Scene14Objects:WaitForChild("Mom")
-- local Cable = Scene14Objects:WaitForChild("Cable")
-- local RollingChair = Scene14Objects:WaitForChild("RollingChair") -- Referencing the duplicate that is in the scene folder.

local Progression = {}

function Progression.Start(player)
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

			if hit:IsDescendantOf(character) then
				StartDialogue:FireClient(player, "Mom", "scene14DialogueStart")
				DialogueTrigger1:Destroy()
			end
		end)

		-- Phase 1
		TaskService.LoadTasks(player, 14, {
			"go_to_room",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_room",
		})

		-- Teleports player to inside the room.
		if root and teleportPart then
			root.CFrame = teleportPart.CFrame + Vector3.new(0, 3, 0)
		end

		StartDialogue:FireClient(player, "Player", "scene14Task1Monologue")

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

		StartDialogue:FireClient(player, "Player", "Task2Monologue")

		-- Phase 3
		TaskService.LoadTasks(player, 14, {
			"ask_charlie_for_specific_solution",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"ask_charlie_for_specific_solution",
		})

		StartDialogue:FireClient(player, "Player", "Task3Monologue")
		ShowAIChatGui:FireClient(player) -- Hides AI Chat Gui.

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
			"go_to_door",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})
	end)

	Mom:Destroy()
end

return Progression
