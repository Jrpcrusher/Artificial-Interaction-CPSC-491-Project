local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TaskConfig = require(Shared.Systems.Tasks.TaskConfig)
local TaskService = require(Shared.Systems.Tasks.TaskService)
local SceneDoorController = require(Shared.Systems.Scene.SceneDoorController)

local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local InteractionHandler = {}

local FINAL_DOOR_TASK_ID = "go_to_door"

local function getCurrentSceneNumber(player)
	return player:GetAttribute("Scene") or 1
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

local function completeTaskIfActive(player, taskId, sceneNumber)
	if not taskId then
		return
	end

	local completed = TaskService.CompleteTask(player, sceneNumber, taskId)
	if completed then
		local task = TaskConfig.GetTaskById(taskId, sceneNumber)
		if task then
			print("Completed task:", task.Title)
		end
	end
end

function InteractionHandler.HandleInteraction(player, interactable)
	local interactionType = interactable:GetAttribute("InteractionType")
	local sceneNumber = getCurrentSceneNumber(player)

	if interactionType == "NPC" then
		print("Start dialogue with", interactable.Name)

		local taskId = interactable:GetAttribute("TaskId")
		completeTaskIfActive(player, taskId, sceneNumber)

		local npcId = interactable:GetAttribute("NpcId")
		if not npcId then
			warn("NPC missing NpcId attribute:", interactable.Name)
			return
		end

		local startNode = resolveDialogueStartNode(interactable, sceneNumber)
		StartDialogue:FireClient(player, npcId, startNode)

	elseif interactionType == "Object" then
		print("Object interaction:", interactable.Name)

		local taskId = interactable:GetAttribute("TaskId")
		completeTaskIfActive(player, taskId, sceneNumber)

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

		if not TaskService.IsTaskActive(player, FINAL_DOOR_TASK_ID) then
			print("There is more to do.")
			return
		end

		completeTaskIfActive(player, FINAL_DOOR_TASK_ID, sceneNumber)

		for _, descendant in ipairs(interactable:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = false
			elseif descendant:IsA("ProximityPrompt") then
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