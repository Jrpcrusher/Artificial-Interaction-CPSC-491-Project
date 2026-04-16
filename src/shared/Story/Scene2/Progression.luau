local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Scene2Progression = {}

function Scene2Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]

		TaskService.ResetForScene(player, 2)

		-- Intro dialogue
		StartDialogue:FireClient(player, "Player", "start")

		-- Phase 1: choose breakfast
		TaskService.LoadTasks(player, 2, {
			"grab_apple",
			"grab_milk",
			"grab_oj",
		})

		local breakfastComplete = false

		while not breakfastComplete do
			task.wait()

			-- Apple path = immediately done
			if TaskService.AreTasksComplete(player, { "grab_apple" }) then
				breakfastComplete = true

			-- Milk path = require cereal
			elseif TaskService.AreTasksComplete(player, { "grab_milk" }) then
				TaskService.LoadTasks(player, 2, {
					"grab_cereal",
				})

				repeat
					task.wait()
				until TaskService.AreTasksComplete(player, { "grab_cereal" })

				breakfastComplete = true

			-- Orange juice path = require toast
			elseif TaskService.AreTasksComplete(player, { "grab_oj" }) then
				TaskService.LoadTasks(player, 2, {
					"grab_toast",
				})

				repeat
					task.wait()
				until TaskService.AreTasksComplete(player, { "grab_toast" })

				breakfastComplete = true
			end
		end

		-- Phase 2: talk to family after breakfast
		TaskService.LoadTasks(player, 2, {
			"talk_to_mom",
			"talk_to_dad",
			"talk_to_sister",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_mom",
			"talk_to_dad",
			"talk_to_sister",
		})

		-- Phase 3: leave for school
		TaskService.LoadTasks(player, 2, {
			"go_to_school",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_school",
		})
	end)
end

return Scene2Progression