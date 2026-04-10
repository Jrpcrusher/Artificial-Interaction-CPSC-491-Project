local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

function Progression.Start()
	task.spawn(function()
		local player = Players:GetPlayers()[1]
		local sceneNumber = 1

		TaskService.ResetForScene(player, sceneNumber)

		-- Phase 1
		TaskService.LoadTasks(player, sceneNumber, {
			"pick_up_apple",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"pick_up_apple",
		})

		-- Phase 2
		TaskService.LoadTasks(player, sceneNumber, {
			"talk_to_dad",
			"talk_to_mom",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_dad",
			"talk_to_mom",
		})

		-- Phase 3
		TaskService.LoadTasks(player, sceneNumber, {
			"go_to_door",
		})
	end)
end

local TasksModule = require(script.Parent.Tasks)
local Dialogue = require(script.Parent.Dialogue)
local SceneData = require(script.Parent.SceneData)

local TaskConfig = require(ReplicatedStorage.Shared.Systems.Tasks.TaskConfig)

local Scene1Progression = {}

local function playDialogue(player, lines)
	if not lines then
		return
	end

	local showDialogueEvent = ReplicatedStorage:FindFirstChild("ShowDialogue")
	if showDialogueEvent then
		showDialogueEvent:FireClient(player, lines)
	else
		print("ShowDialogue event not found. Dialogue lines:")
		for _, line in ipairs(lines) do
			print(line)
		end
	end
end

local function completeTask(taskId)
	-- for _, task in ipairs(TaskConfig.Tasks) do
	-- 	if task.Id == taskId then
	-- 		if not task.Completed then
	-- 			task.Completed = true
	-- 			print("Completed task:", taskId)
	-- 		end
	-- 		return true
	-- 	end
	-- end

	warn("Task not found:", taskId)
	return false
end

local function cloneTasks(tasks)
	local copiedTasks = {}

	for _, task in ipairs(tasks) do
		table.insert(copiedTasks, {
			Id = task.Id,
			Title = task.Title,
			Objective = task.Objective,
			Type = task.Type,
			Completed = false,
		})
	end

	return copiedTasks
end

function Scene1Progression.Load(player)
	print("Loading Scene 1 for", player.Name)

	-- Reset and load Scene 1 tasks into the shared task config
	-- TaskConfig.Tasks = cloneTasks(TasksModule)

	-- Optional: enable interactables here later if needed
	-- Optional: setup scene state here later if needed

	-- Play opening inner dialogue
	playDialogue(player, Dialogue.Start)
end

function Scene1Progression.CanLeaveRoom()
	-- for _, task in ipairs(TaskConfig.Tasks) do
	-- 	if task.Id ~= "open_bedroom_door" and not task.Completed then
	-- 		return false
	-- 	end
	-- end

	return true
end

function Scene1Progression.OnObjectInteracted(player, objectName)
	print(player.Name .. " interacted with " .. objectName)

	if objectName == "Backpack" then
		completeTask("grab_backpack")
		return
	end

	if objectName == "Calculator" then
		completeTask("grab_calculator")
		return
	end

	if objectName == "Keys" then
		completeTask("grab_keys")
		return
	end

	if objectName == "BedroomDoor" then
		if Scene1Progression.CanLeaveRoom() then
			completeTask("open_bedroom_door")
			print("Player can leave the room now.")

			-- You can add door-opening logic here later
			-- Example: animate door, disable collision, etc.
		else
			playDialogue(player, Dialogue.NotReady)
		end

		return
	end

	warn("Unhandled object interaction in Scene 1:", objectName)
end

function Scene1Progression.OnTriggerEntered(player, triggerName)
	print(player.Name .. " entered trigger " .. triggerName)

	if triggerName == "StairsTrigger" then
		playDialogue(player, Dialogue.Stairs)

		task.wait(2)

		playDialogue(player, Dialogue.Final)

		task.wait(2)

		Scene1Progression.Unload(player)

		print("Scene 1 complete. Ready to load Scene 2.")
		-- Hook your scene manager here later:
		-- local SceneManager = require(ReplicatedStorage.Shared.Story.SceneManager)
		-- SceneManager.LoadScene(player, "Scene2")
		return
	end

	warn("Unhandled trigger in Scene 1:", triggerName)
end

function Scene1Progression.Unload(player)
	print("Unloading Scene 1 for", player.Name)

	-- Optional cleanup goes here
	-- Example:
	-- clear scene-specific state
	-- disable triggers
	-- remove temporary assets
end

return Scene1Progression
