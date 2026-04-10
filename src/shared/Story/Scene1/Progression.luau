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

local currentTasks = {}

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
	for _, task in ipairs(currentTasks) do
		if task.Id == taskId then
			if not task.Completed then
				task.Completed = true
				print("Completed task:", taskId)
			end
			return true
		end
	end

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

function Progression.Load(player)
	print("Loading Scene 1 for", player.Name)

	currentTasks = cloneTasks(TasksModule)

	playDialogue(player, Dialogue.Start)
end

function Progression.CanLeaveRoom()
	for _, task in ipairs(currentTasks) do
		if task.Id ~= "go_to_door" and not task.Completed then
			return false
		end
	end
	return true
end

function Progression.OnObjectInteracted(player, objectName)
	print(player.Name .. " interacted with " .. objectName)

	if objectName == SceneData.Objects.Backpack then
		completeTask("grab_backpack")
		return
	end

	if objectName == SceneData.Objects.Calculator then
		completeTask("grab_calculator")
		return
	end

	if objectName == SceneData.Objects.Keys then
		completeTask("grab_keys")
		return
	end

	if objectName == SceneData.Objects.BedroomDoor then
		if Progression.CanLeaveRoom() then
			completeTask("open_bedroom_door")
			print("Player can leave the room now.")
		else
			playDialogue(player, Dialogue.NotReady)
		end

		return
	end

	warn("Unhandled object interaction in Scene 1:", objectName)
end

function Progression.OnTriggerEntered(player, triggerName)
	print(player.Name .. " entered trigger " .. triggerName)

	if triggerName == "StairsTrigger" then
		playDialogue(player, Dialogue.Stairs)

		task.wait(2)

		playDialogue(player, Dialogue.Final)

		task.wait(2)

		Progression.Unload(player)

		print("Scene 1 complete. Ready to load Scene 2.")
		return
	end

	warn("Unhandled trigger in Scene 1:", triggerName)
end

function Progression.Unload(player)
	print("Unloading Scene 1 for", player.Name)

	currentTasks = {}
end

return Progression
