local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local DialogueTrigger1 = workspace.Scene2Objects:WaitForChild("DialogueTrigger1")

local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene2Objects")

	-- Model positioning
	local Sister = SceneObjects:WaitForChild("Sister")
	Sister:PivotTo(CFrame.new(37.6, 27.349, -85.793) * CFrame.Angles(0, math.rad(-90), 0))

	local Mom = SceneObjects:WaitForChild("Mom")
	Mom:PivotTo(CFrame.new(41.649, 27.349, -101.433) * CFrame.Angles(0, math.rad(180), 0))

	local Dad = SceneObjects:WaitForChild("Dad")
	Dad:PivotTo(CFrame.new(52.95, 27.349, -94.078) * CFrame.Angles(0, math.rad(135), 0))

	local Toast = SceneObjects:WaitForChild("Toast")
	Toast:PivotTo(CFrame.new(53.491, 26.649, -105.078) * CFrame.Angles(0, 0, math.rad(45)))
	
	local OrangeJuice = SceneObjects:WaitForChild("OrangeJuice")

	Sister:PivotTo(CFrame.new(37.6, 27.349, -85.793) * CFrame.Angles(0, math.rad(-90), 0))
	OrangeJuice:PivotTo(CFrame.new(56.53, 27.015, -101.488) * CFrame.Angles(0, math.rad(135), 0))

	-- Part positioning
	local Apple = SceneObjects:WaitForChild("Apple")
	Apple.Position = Vector3.new(46.2, 26.545, -94.378)

	local trigger = SceneObjects:WaitForChild("DialogueTrigger1")
	trigger.Position = Vector3.new(40.249, 27.755, -59.933)

	local cereal = SceneObjects:WaitForChild("Froot Loops Cereal Box")
	cereal.Position = Vector3.new(58.3, 27.002, -97.778)

	-- mesh part
	local milk = SceneObjects:WaitForChild("Milk Carton")
	milk.Position = Vector3.new(56.1, 26.636, -86.678)
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene2Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene2Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 2)

		DialogueTrigger1.Touched:Connect(function(hit) -- Handle when dialogue Trigger 1 hit
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(character) then
				StartDialogue:FireClient(player, "Player", "start")
				DialogueTrigger1:Destroy()
			end
		end)

		-- TaskService.LoadTasks(player, 2, {
		-- 	"eat_something",
		-- })
		-- repeat
		-- 	task.wait()
		-- until TaskService.AreTasksComplete(player, {
		-- 	"eat_something",
		-- })
		-- Phase 1: choose breakfast
		TaskService.LoadTasks(player, 2, {
			"grab_apple",
			"grab_milk",
			"grab_oj",
		})
		local breakfastComplete = false
		while not breakfastComplete do
			task.wait()
			-- Apple path = immediately done
			if TaskService.AreTasksComplete(player, { "grab_apple" }) then
				breakfastComplete = true
			-- Milk path = require cereal
			elseif TaskService.AreTasksComplete(player, { "grab_milk" }) then
				TaskService.LoadTasks(player, 2, {
					"grab_cereal",
				})
				repeat
					task.wait()
				until TaskService.AreTasksComplete(player, { "grab_cereal" })
				breakfastComplete = true
			-- Orange juice path = require toast
			elseif TaskService.AreTasksComplete(player, { "grab_oj" }) then
				TaskService.LoadTasks(player, 2, {
					"grab_toast",
				})
				repeat
					task.wait()
				until TaskService.AreTasksComplete(player, { "grab_toast" })

				breakfastComplete = true
			end
		end

		-- Phase 2: talk to family after breakfast
		TaskService.LoadTasks(player, 2, {
			"talk_to_mom",
			"talk_to_dad",
			"talk_to_sister",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_mom",
			"talk_to_dad",
			"talk_to_sister",
		})

		-- Phase 3: leave for school
		TaskService.LoadTasks(player, 2, {
			"go_to_door",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression
