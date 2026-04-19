local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

local function setSceneActive(sceneNumber, isActive)
	local folderName = "Scene" .. sceneNumber .. "Objects"
	local folder = workspace:FindFirstChild(folderName)

	if not folder then
		warn("Missing folder:", folderName)
		return
	end

	for _, obj in ipairs(folder:GetDescendants()) do
		if obj:IsA("BasePart") then
			if obj:GetAttribute("OriginalPositionX") == nil then
				obj:SetAttribute("OriginalPositionX", obj.Position.X)
				obj:SetAttribute("OriginalPositionY", obj.Position.Y)
				obj:SetAttribute("OriginalPositionZ", obj.Position.Z)
			end

			local originalPosition = Vector3.new(
				obj:GetAttribute("OriginalPositionX"),
				obj:GetAttribute("OriginalPositionY"),
				obj:GetAttribute("OriginalPositionZ")
			)

			if isActive then
				obj.Position = originalPosition
			else
				obj.Position = originalPosition + Vector3.new(0, -1000, 0)
			end
		elseif obj:IsA("ProximityPrompt") then
			obj.Enabled = isActive
		end
	end
end

function Progression.Start(player)
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene6Spawn")
		character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		setSceneActive(5, false)
		setSceneActive(6, true)

		TaskService.ResetForScene(player, 6)
		StartDialogue:FireClient(player, "Player", "start")

		-- Phase 1
		TaskService.LoadTasks(player, 6, {
			"eat_something",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"eat_something",
		})

		-- Phase 2
		TaskService.LoadTasks(player, 6, {
			"grab_coat",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"grab_coat",
		})

		-- Phase 3
		TaskService.LoadTasks(player, 6, {
			"go_to_door",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})
	end)
end

return Progression