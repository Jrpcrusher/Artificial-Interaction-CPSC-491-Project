local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TaskConfig = require(Shared.Systems.Tasks.TaskConfig)
local TaskService = require(Shared.Systems.Tasks.TaskService)
local SceneDoorController = require(Shared.Systems.Scene.SceneDoorController)

local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local InteractionHandler = {}

-- local FINAL_DOOR_TASK_ID = "go_to_door"
-- don't need this since i also have go_to_school door

local function getCurrentSceneNumber(player)
	return player:GetAttribute("Scene") or 1
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
		return true
	end
	return false
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

		StartDialogue:FireClient(player, npcId)
	elseif interactionType == "Object" then
		print("Object interaction:", interactable.Name)

		local taskId = interactable:GetAttribute("TaskId")
		local completed = completeTaskIfActive(player, taskId, sceneNumber)

		if not completed then
			return
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
			elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.Transparency = 1 -- for cereal decals
			end
		end
	elseif interactionType == "Door" then
		print("Door interaction:", interactable.Name)

		-- use door's own TaskId instead of global one
		local doorTaskId = interactable:GetAttribute("TaskId")
		if not doorTaskId then
			warn("Door missing TaskId attribute:", interactable.Name)
			return
		end

		if not TaskService.IsTaskActive(player, doorTaskId) then
			print("There is more to do.")
			return
		end

		completeTaskIfActive(player, doorTaskId, sceneNumber)

		local transitioned = SceneDoorController.TriggerSceneDoor(player)
		if not transitioned then
			warn("Scene door interaction failed to transition scene for player:", player.Name)
		end
	elseif interactionType == "Static" then
		
		local taskId = interactable:GetAttribute("TaskId")
		local completed = completeTaskIfActive(player, taskId, sceneNumber)

		if not completed then
			return
		end

	end
end

return InteractionHandler
