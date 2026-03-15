local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskConfig = require(ReplicatedStorage.Shared.TaskConfig)

local InteractionHandler = {}

local function areRequiredTasksComplete()
	for _, task in ipairs(TaskConfig.Tasks) do
		if task.Type == "Required" and not task.Completed then
			return false
		end
	end

	return true
end

function InteractionHandler.HandleInteraction(player, interactable)
	local interactionType = interactable:GetAttribute("InteractionType")

	if interactionType == "NPC" then
		print("Start dialogue with", interactable.Name)

	elseif interactionType == "Object" then
		print("Object interaction:", interactable.Name)

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

		if areRequiredTasksComplete() then
			print("All required tasks complete. Advance story.")
		else
			print("There is more to do.")
		end
	end
end

return InteractionHandler