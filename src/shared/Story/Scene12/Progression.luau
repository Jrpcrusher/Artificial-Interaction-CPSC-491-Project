local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = require(ReplicatedStorage.Shared.Story.Common.StoryCommon)
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ShowAIChatGui = Remotes.Chat:WaitForChild("ShowAIChatGui")

local Progression = {}

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
		Common.StartDialogueAndWait(player, "Player", "start")

		ShowAIChatGui:FireClient(player, "enable") -- shows AI Chat Gui

		TaskService.LoadTasks(player, 12, {
			"talk_about_cheating_on_quiz",
			"talk_about_mom_dad_arguing",
			"talk_about_sis",
			"talk_about_panic_attacks",
			"talk_about_judgement_at_school",
		})
		Common.WaitForTasks(player, {
					"talk_about_cheating_on_quiz",
					"talk_about_mom_dad_arguing",
					"talk_about_sis",
					"talk_about_panic_attacks",
					"talk_about_judgement_at_school",
				})

		Common.WaitForChatClose(player, {
					"talk_about_cheating_on_quiz",
					"talk_about_mom_dad_arguing",
					"talk_about_sis",
					"talk_about_panic_attacks",
					"talk_about_judgement_at_school"
				})

		Common.StartDialogueAndWait(player, "Player", "task1monologue")

		ShowAIChatGui:FireClient(player, "disable")

		TaskService.LoadTasks(player, 12, {
			"go_to_sleep",
		})
		Common.WaitForTasks(player, {"go_to_sleep"})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression
