local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local DialogueTrigger1 = workspace.Scene2Objects:WaitForChild("DialogueTrigger1")

local Progression = {}

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene2Objects")
	local Sister = SceneObjects:WaitForChild("Sister")
	Sister:PivotTo(CFrame.new(37.6, 27.349, -85.793))
end

function Progression.Unload() -- ! DELETE ALL ASSETS FROM PREVIOUS SCENE
	local SceneObjects = workspace:WaitForChild("Scene2Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
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
