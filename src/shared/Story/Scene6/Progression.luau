local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = require(ReplicatedStorage.Shared.Story.Common.StoryCommon)
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")


local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene6Objects")

	-- NPC positioning
	local Mom = SceneObjects:WaitForChild("Mom")
	Mom:PivotTo(CFrame.new(45.1, 27.355, -44) * CFrame.Angles(0, math.rad(90), 0))

	-- Breakfast items
	local Toast = SceneObjects:WaitForChild("Toast")
	Toast:PivotTo(CFrame.new(53.491, 26.649, -105.078) * CFrame.Angles(0, 0, math.rad(45)))

	local OrangeJuice = SceneObjects:WaitForChild("OrangeJuice")
	OrangeJuice:PivotTo(CFrame.new(56.53, 27.015, -101.488) * CFrame.Angles(0, math.rad(135), 0))

	local Apple = SceneObjects:WaitForChild("Apple")
	Apple.CFrame = CFrame.new(46.2, 26.545, -94.378) * CFrame.Angles(0, 0, 0)

	local trigger = SceneObjects:WaitForChild("DialogueTrigger1")
	trigger.Position = Vector3.new(31.137, 36.355, -67.3472)

	local cereal = SceneObjects:WaitForChild("Froot Loops Cereal Box")
	cereal.CFrame = CFrame.new(58.3, 27.049, -97.778) * CFrame.Angles(0, 0, 0)

	local milk = SceneObjects:WaitForChild("Milk Carton")
	milk.CFrame = CFrame.new(56.1, 26.64, -86.678) * CFrame.Angles(0, math.rad(-135), 0)

	local PictureFrame = SceneObjects:WaitForChild("Picture Frame")
	PictureFrame:PivotTo(CFrame.new(41.115, 22.993, -44.036) * CFrame.Angles(math.rad(90), 0, 0))
	
	local BrokenGlass = SceneObjects:WaitForChild("BrokenGlass")
	BrokenGlass:PivotTo(CFrame.new(38.619, 23.04, -43.476) * CFrame.Angles(0, 0, math.rad(-90)))
	local Coat = SceneObjects:WaitForChild("Coat")
	Coat:PivotTo(CFrame.new(41.205, 28.498, -29.99))
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene6Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	Common.PlayRain()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene6Spawn")
		local root = character:WaitForChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 6)

		-- ONLY start one opening dialogue tree
		task.wait(1)
		StartDialogue:FireClient(player, "Player", "start")

		-- Enable crash trigger after opening dialogue has had time to finish
		local DialogueTrigger1 = workspace.Scene6Objects:WaitForChild("DialogueTrigger1")
		local triggered = false
		local triggerEnabled = false

		task.delay(4, function()
			triggerEnabled = true
		end)

		DialogueTrigger1.Touched:Connect(function(hit)
			if triggered or not triggerEnabled then
				return
			end

			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(currentCharacter) then
				triggered = true
				StartDialogue:FireClient(player, "Crash", "start")
				DialogueTrigger1:Destroy()
			end
		end)

		TaskService.LoadTasks(player, 6, {
			"talk_to_mom",
		})
		Common.WaitForTasks(player, {"talk_to_mom"})

		-- Phase 1: choose breakfast
		TaskService.LoadTasks(player, 6, {
			"grab_apple",
			"grab_milk",
			"grab_oj",
		})

		local breakfastComplete = false
		while not breakfastComplete do
			task.wait()

			-- Apple path
			if TaskService.AreTasksComplete(player, { "grab_apple" }) then
				breakfastComplete = true

			-- Milk path
			elseif TaskService.AreTasksComplete(player, { "grab_milk" }) then
				TaskService.LoadTasks(player, 6, {
					"grab_cereal",
				})
				repeat
					task.wait()
				until TaskService.AreTasksComplete(player, { "grab_cereal" })
				breakfastComplete = true

			-- Orange juice path
			elseif TaskService.AreTasksComplete(player, { "grab_oj" }) then
				TaskService.LoadTasks(player, 6, {
					"grab_toast",
				})
				repeat
					task.wait()
				until TaskService.AreTasksComplete(player, { "grab_toast" })
				breakfastComplete = true
			end
		end

		-- Phase 2: grab coat
		TaskService.LoadTasks(player, 6, {
			"grab_coat",
		})
		Common.WaitForTasks(player, {"grab_coat"})

		-- Phase 3: leave for school
		TaskService.LoadTasks(player, 6, {
			"go_to_door",
		})
		Common.WaitForTasks(player, {"go_to_door"})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression