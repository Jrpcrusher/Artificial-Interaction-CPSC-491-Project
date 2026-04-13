local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TaskConfig = require(Shared.Systems.Tasks.TaskConfig)
local TaskState = require(Shared.Systems.Tasks.TaskState)
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

local function getTasksForActiveStage(player, sceneNumber)
	local activeStage = TaskState.GetActiveStage(player)
	return TaskConfig.GetTasksForStage(sceneNumber, activeStage)
end

local function areAllRequiredTasksInActiveStageComplete(player, sceneNumber)
	local tasks = getTasksForActiveStage(player, sceneNumber)

	for _, task in ipairs(tasks) do
		if task.Type == "Required" and not TaskState.IsTaskCompleted(player, task.Id) then
			return false
		end
	end

	return true
end

local function advanceStageIfReady(player, sceneNumber)
	if not areAllRequiredTasksInActiveStageComplete(player, sceneNumber) then
		return
	end

	local maxStage = TaskConfig.GetMaxStage(sceneNumber)
	local activeStage = TaskState.GetActiveStage(player)

	if activeStage < maxStage then
		TaskState.AdvanceStage(player)
	end
end

local function completeTaskById(player, taskId, sceneNumber)
	local task = TaskConfig.GetTaskById(taskId, sceneNumber)
	if not task then
		warn("Task not found:", taskId, "scene:", sceneNumber)
		return
	end

	if TaskState.IsTaskCompleted(player, taskId) then
		return
	end

	TaskState.MarkTaskComplete(player, taskId)
	print("Completed task:", task.Title)

	advanceStageIfReady(player, sceneNumber)
	TaskUpdated:FireClient(player, taskId, sceneNumber)
end

local function resolveDialogueStartNode(interactable, sceneNumber)
	local npcId = interactable:GetAttribute("NpcId")

	if npcId == "Dad" then
		if sceneNumber == 1 then
			return "scene1Start"
		elseif sceneNumber == 2 then
			return "scene2Start"
		end
	end

	return "start"
end

local function isDoorStageActive(player, sceneNumber)
	local doorTask = TaskConfig.GetTaskById(FINAL_DOOR_TASK_ID, sceneNumber)
	if not doorTask then
		return false
	end

	return TaskState.GetActiveStage(player) == (doorTask.Stage or 1)
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

		local npcId = interactable:GetAttribute("NpcId")
		if not npcId then
			warn("NPC missing NpcId attribute:", interactable.Name)
			return
		end

		local startNode = resolveDialogueStartNode(interactable, sceneNumber)
		print("SERVER firing StartDialogue", player.Name, npcId, startNode)
		StartDialogue:FireClient(player, npcId, startNode)
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

		if not isDoorStageActive(player, sceneNumber) then
			print("There is more to do.")
			return
		end

		if not TaskState.IsTaskCompleted(player, FINAL_DOOR_TASK_ID) then
			TaskState.MarkTaskComplete(player, FINAL_DOOR_TASK_ID)
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
