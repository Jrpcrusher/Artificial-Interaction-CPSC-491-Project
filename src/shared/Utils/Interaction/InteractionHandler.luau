local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TaskConfig = require(Shared.Systems.Tasks.TaskConfig)
local TaskService = require(Shared.Systems.Tasks.TaskService)

local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local InteractionHandler = {}

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

		local taskId = interactable:GetAttribute("TaskId")
		completeTaskIfActive(player, taskId, sceneNumber)

		local npcId = interactable:GetAttribute("NpcId")
		if not npcId then
			warn("NPC missing NpcId attribute:", interactable.Name)
			return
		end

		StartDialogue:FireClient(player, npcId)
	elseif interactionType == "Object" then

		local taskId = interactable:GetAttribute("TaskId")
		local completed = completeTaskIfActive(player, taskId, sceneNumber)

		if not completed then
			return
		end

		interactable:Destroy()
	elseif interactionType == "Door" then

		-- use door's own TaskId instead of global one
		local doorTaskId = interactable:GetAttribute("TaskId")
		if not doorTaskId then
			warn("Door missing TaskId attribute:", interactable.Name)
			return
		end

		if not TaskService.IsTaskActive(player, doorTaskId) then
			return
		end

		completeTaskIfActive(player, doorTaskId, sceneNumber)
	elseif interactionType == "Static" then
		
		local taskId = interactable:GetAttribute("TaskId")
		local completed = completeTaskIfActive(player, taskId, sceneNumber)

		if not completed then
			return
		end

	end
end

return InteractionHandler
