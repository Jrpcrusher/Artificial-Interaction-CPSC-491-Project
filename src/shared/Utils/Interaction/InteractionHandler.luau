local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TaskConfig = require(Shared.Systems.Tasks.TaskConfig)
local SceneDoorController = require(Shared.Systems.Scene.SceneDoorController)

local TaskUpdated = Remotes.Tasks:WaitForChild("TaskUpdated")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local InteractionHandler = {}

local FINAL_DOOR_TASK_ID = "go_to_door"

local function getCurrentSceneNumber(player)
	return player:GetAttribute("Scene") or 1
end

local function getTaskById(taskId, sceneNumber)
	return TaskConfig.GetTaskById(taskId, sceneNumber)
end

local function completeTaskById(player, taskId, sceneNumber)
	local success = TaskConfig.MarkTaskComplete(taskId, sceneNumber)
	if not success then
		warn("Task not found:", taskId, "scene:", sceneNumber)
		return
	end

	local task = TaskConfig.GetTaskById(taskId, sceneNumber)
	if task then
		print("Completed task:", task.Title)
	end

	TaskUpdated:FireClient(player, taskId, sceneNumber)
end

local function areRequiredTasksBeforeDoorComplete(sceneNumber)
	return TaskConfig.AreAllRequiredTasksBeforeDoorComplete(sceneNumber)
end

local function resolveDialogueStartNode(player, interactable, sceneNumber)
	local dialogueId = interactable:GetAttribute("DialogueId")

	if dialogueId == "Dad" then
		if sceneNumber == 1 then
			return "scene1Start"
		elseif sceneNumber == 2 then
			return "scene2Start"
		end
	end

	return "start"
end

function InteractionHandler.HandleInteraction(player, interactable)
	local interactionType = interactable:GetAttribute("InteractionType")
	local sceneNumber = getCurrentSceneNumber(player)

	if interactionType == "NPC" then
		print("Start dialogue with", interactable.Name)

		local taskId = interactable:GetAttribute("TaskId")
		if taskId then
			completeTaskById(player, taskId, sceneNumber)
		end

		local dialogueId = interactable:GetAttribute("DialogueId")
		if not dialogueId then
			warn("NPC missing DialogueId attribute:", interactable.Name)
			return
		end

		local startNode = resolveDialogueStartNode(player, interactable, sceneNumber)
		print("SERVER firing StartDialogue", player.Name, dialogueId, startNode)
		StartDialogue:FireClient(player, dialogueId, startNode)

	elseif interactionType == "Object" then
		print("Object interaction:", interactable.Name)

		local taskId = interactable:GetAttribute("TaskId")
		if taskId then
			completeTaskById(player, taskId, sceneNumber)
		end

		if interactable:IsA("BasePart") then
			interactable.Transparency = 1
			interactable.CanCollide = false
			interactable.CanTouch = false
			interactable.CanQuery = false
		end

		for _, descendant in ipairs(interactable:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Transparency = 1
				descendant.CanCollide = false
				descendant.CanTouch = false
				descendant.CanQuery = false
			elseif descendant:IsA("ProximityPrompt") then
				descendant.Enabled = false
			end
		end

	elseif interactionType == "Door" then
		print("Door interaction:", interactable.Name)

		local doorTask = getTaskById(FINAL_DOOR_TASK_ID, sceneNumber)
		if not doorTask then
			warn("Final door task not found:", FINAL_DOOR_TASK_ID, "scene:", sceneNumber)
			return
		end

		if not areRequiredTasksBeforeDoorComplete(sceneNumber) then
			print("There is more to do.")
			return
		end

		if not doorTask.Completed then
			doorTask.Completed = true
			TaskUpdated:FireClient(player, FINAL_DOOR_TASK_ID, sceneNumber)
			print("Door task completed:", doorTask.Title)
		end

		print("Door unlocked. Walking through.")

		for _, descendant in ipairs(interactable:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = false
			end
		end

		for _, descendant in ipairs(interactable:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				descendant.Enabled = false
			end
		end

		local transitioned = SceneDoorController.TriggerSceneDoor(player)
		if not transitioned then
			warn("Scene door interaction failed to transition scene for player:", player.Name)
		end
	end
end

return InteractionHandler