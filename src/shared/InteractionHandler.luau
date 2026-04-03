local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskConfig = require(ReplicatedStorage.Shared.TaskConfig)
local TaskUpdated = ReplicatedStorage.Shared:WaitForChild("TaskUpdated")

local InteractionHandler = {}

local FINAL_DOOR_TASK_ID = "go_to_door"

local function getTaskById(taskId)
	for _, task in ipairs(TaskConfig.Tasks) do
		if task.Id == taskId then
			return task
		end
	end

	return nil
end

local function completeTaskById(player, taskId)
	for _, task in ipairs(TaskConfig.Tasks) do
		if task.Id == taskId then
			if task.Completed then
				return
			end

			task.Completed = true
			print("Completed task:", task.Title)

			TaskUpdated:FireClient(player, taskId) -- this notifies the UI
			return
		end
	end

	warn("Task not found:", taskId)
end

local function areRequiredTasksBeforeDoorComplete()
	for _, task in ipairs(TaskConfig.Tasks) do
		if task.Type == "Required" and task.Id ~= FINAL_DOOR_TASK_ID and not task.Completed then
			return false
		end
	end

	return true
end

function InteractionHandler.HandleInteraction(player, interactable)
	local interactionType = interactable:GetAttribute("InteractionType")

	if interactionType == "NPC" then
		print("Start dialogue with", interactable.Name)

		local taskId = interactable:GetAttribute("TaskId")
		if taskId then
			completeTaskById(player, taskId)
		end

	elseif interactionType == "Object" then
		print("Object interaction:", interactable.Name)

		local taskId = interactable:GetAttribute("TaskId")
		if taskId then
			completeTaskById(player, taskId)
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

		local doorTask = getTaskById(FINAL_DOOR_TASK_ID)

		if not doorTask then
			warn("Final door task not found:", FINAL_DOOR_TASK_ID)
			return
		end

		-- All required tasks must be completed before door unlocks
		if not areRequiredTasksBeforeDoorComplete() then
			print("There is more to do.")
			return
		end

		if not doorTask.Completed then
			doorTask.Completed = true
			TaskUpdated:FireClient(player, FINAL_DOOR_TASK_ID)
			print("Door task completed:", doorTask.Title)
		end

		print("Door unlocked. Walking through.")

		-- Just remove collision so player can walk through, no animation
		for _, descendant in ipairs(interactable:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = false
			end
		end

		-- Disable the prompt so player can't interact again
		for _, descendant in ipairs(interactable:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				descendant.Enabled = false
			end
		end
	end
end

return InteractionHandler
