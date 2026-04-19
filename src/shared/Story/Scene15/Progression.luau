local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local FinishDialogue = Remotes.Dialogue:WaitForChild("FinishDialogue")

local Progression = {}

local function waitForDialogueToEnd(player, expectedStartNode)
	local bindable = Instance.new("BindableEvent")
	local connection

	connection = FinishDialogue.OnServerEvent:Connect(function(firingPlayer, finishedStartNode)
		if firingPlayer == player and finishedStartNode == expectedStartNode then
			connection:Disconnect()
			bindable:Fire()
		end
	end)

	bindable.Event:Wait()
	bindable:Destroy()
	print("dialogue finished")
end

local function clonePlayer(character, SceneObjects)
	if not character or not SceneObjects then
		warn("clonePlayer: missing character or SceneObjects")
		return nil
	end

	character.Archivable = true

	local clone = character:Clone()
	if not clone then
		warn("clonePlayer: clone failed")
		return nil
	end

	clone.Name = character.Name .. "_Clone"
	clone.Parent = SceneObjects

	for _, obj in ipairs(clone:GetDescendants()) do
		if obj:IsA("Script") or obj:IsA("LocalScript") then
			obj:Destroy()
		end
	end

	for _, obj in ipairs(clone:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Anchored = true
			obj.CanCollide = false
		end
	end

	local humanoid = clone:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.AutoRotate = false
		humanoid.PlatformStand = true
	end

	clone:PivotTo(CFrame.new(0.667, 36.131, -74.54) * CFrame.fromOrientation(math.rad(90), math.rad(-90), math.rad(0)))

	return clone
end

local function changeToSister(character, sister, humanoid)
	for _, obj in ipairs(character:GetChildren()) do
		if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("BodyColors") then
			obj:Destroy()
		end
	end

	-- Copy Sister's sclothing/body colors
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

	-- remove accessories from player's current avatar
	for _, obj in ipairs(character:GetChildren()) do
		if obj:IsA("Accessory") then
			obj:Destroy()
		end
	end
	-- THIS SECTION MAKES THE PLAYER INTO THE SISTER

	-- Copy Sister's accessories if she has any
	for _, obj in ipairs(sister:GetChildren()) do
		if obj:IsA("Accessory") then
			humanoid:AddAccessory(obj:Clone())
		end
	end
end

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

	clonePlayer(character, SceneObjects) -- Logic for handling cloning player to position
	changeToSister(character, sister, humanoid) -- logic for changing player to sister

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
		character:PivotTo(CFrame.new(15.182, 38.855, -78.081) * CFrame.Angles(0, math.rad(90), 0))
		StartDialogue:FireClient(player, "Sister", "scene15Task1Response")

		-- Phase 2
		TaskService.LoadTasks(player, 15, {
			"save_your_older_sibling",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"save_your_older_sibling",
		})

		StartDialogue:FireClient(player, "Player", "scene15Task2Response")
		waitForDialogueToEnd(player, "scene15Task2Response")
		task.wait(1)
		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression
