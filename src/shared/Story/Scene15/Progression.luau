local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

function Progression.Load(player)
	-- Set the player's character to the little sister
	if not player then
		warn("Progression.Load called with nil player")
		return
	end

	local SceneObjects = workspace:WaitForChild("Scene15Objects")
	local sister = SceneObjects:WaitForChild("Sister")

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	-- Remove current clothing/body colors
	for _, obj in ipairs(character:GetChildren()) do
		if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("BodyColors") then
			obj:Destroy()
		end
	end

	-- Copy Sister's clothing/body colors
	local sisterShirt = sister:FindFirstChildOfClass("Shirt")
	if sisterShirt then
		sisterShirt:Clone().Parent = character
	end

	local sisterPants = sister:FindFirstChildOfClass("Pants")
	if sisterPants then
		sisterPants:Clone().Parent = character
	end

	local sisterBodyColors = sister:FindFirstChildOfClass("BodyColors")
	if sisterBodyColors then
		sisterBodyColors:Clone().Parent = character
	end

	-- Optional: remove accessories from player's current avatar
	for _, obj in ipairs(character:GetChildren()) do
		if obj:IsA("Accessory") then
			obj:Destroy()
		end
	end

	-- Copy Sister's accessories if she has any
	for _, obj in ipairs(sister:GetChildren()) do
		if obj:IsA("Accessory") then
			humanoid:AddAccessory(obj:Clone())
	end
end
	-- Make door to sisters room nocollision
	local door = workspace.Map.House.DoubleStoryUrbanHouse.LowerLevel.Doors.SisDoorway.SisDoor

	for _, obj in ipairs(door:GetChildren()) do
		if obj:IsA("Part") then
			obj.CanCollide = false
		end
	end
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene15Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end

end

function Progression.Start(player)
	Progression.Load(player)
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene15Spawn")
		character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 15)
		StartDialogue:FireClient(player, "Sister", "scene15Start")

		-- Phase 1
		TaskService.LoadTasks(player, 15, {
			"check_on_older_sibling",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"check_on_older_sibling",
		})

		-- Phase 2
		TaskService.LoadTasks(player, 15, {
			"save_your_older_sibling",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"save_your_older_sibling",
		})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression
