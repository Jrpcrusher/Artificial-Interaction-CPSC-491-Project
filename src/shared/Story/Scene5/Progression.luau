local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = require(ReplicatedStorage.Shared.Story.Common.StoryCommon)
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene5Objects")

	-- Keys
	local Keys = SceneObjects:WaitForChild("Keys")
	Keys.Position = Vector3.new(-2.411, 38.944, -74.665)
	Keys.Orientation = Vector3.new(-90, 90, 0)

	-- Backpack
	local Backpack = SceneObjects:WaitForChild("Backpack")
	Backpack.Position = Vector3.new(3.349, 38.991, -75.691)
	Backpack.Orientation = Vector3.new(-0.007, -125, 0)

	-- Calculator
	local Calculator = SceneObjects:WaitForChild("Calculator")
	Calculator:PivotTo(CFrame.new(10.65, 38.061, -61.338))
	
	-- Bedroom door prompt
	local prompt = workspace.Map.House.DoubleStoryUrbanHouse.UpperLevel.Doors.TDW.Door.ThePart:WaitForChild("ProximityPrompt")
	prompt.Enabled = true
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene5Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end

	local prompt = workspace.Map.House.DoubleStoryUrbanHouse.UpperLevel.Doors.TDW.Door.ThePart:WaitForChild("ProximityPrompt")
	prompt.Enabled = false
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene5Spawn")
		character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end
		
		TaskService.ResetForScene(player, 5)
		StartDialogue:FireClient(player, "Player", "start")
		
		-- Phase 1
		TaskService.LoadTasks(player, 5, {
			"grab_backpack",
			"grab_calculator",
			"grab_keys",
		})
		Common.WaitForTasks(player, {
			"grab_backpack",
			"grab_calculator",
			"grab_keys",
		})

		-- Phase 2
		TaskService.LoadTasks(player, 5, {
			"go_to_door",
		})
		Common.WaitForTasks(player, {"go_to_door"})


		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression