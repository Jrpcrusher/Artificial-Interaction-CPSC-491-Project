local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local DialogueTrigger1 = workspace.Scene3Objects:WaitForChild("DialogueTrigger1")
local DialogueTrigger2 = workspace.Scene3Objects:WaitForChild("DialogueTrigger2")
local DialogueTrigger3 = workspace.Scene3Objects:WaitForChild("DialogueTrigger3")

local Scene3Objects = workspace:WaitForChild("Scene3Objects")
local Bully = Scene3Objects:WaitForChild("Bully")

local Progression = {}

local function hideBully() -- Helper function to hide bully

	for _, descendant in ipairs(Bully:GetDescendants()) do
		if descendant:IsA("BasePart") then
			if descendant.Name ~= "HumanoidRootPart" then
				descendant.Transparency = 1
			end
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		elseif descendant:IsA("ProximityPrompt") then
			descendant.Enabled = false
		elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
			descendant.Transparency = 1
		end
	end
end

local function showBully() -- Helper function to show bully
	for _, descendant in ipairs(Bully:GetDescendants()) do
		if descendant:IsA("BasePart") then
			if descendant.Name ~= "HumanoidRootPart" then
				descendant.Transparency = 0
			end
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		elseif descendant:IsA("ProximityPrompt") then
			descendant.Enabled = true
		elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
			descendant.Transparency = 0
		end
	end
end

function Progression.Start(player)
    hideBully()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene3Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 3)
		
		-- Phase 1: put stuff in locker after talking w friend/bully whatever his name is lol
        DialogueTrigger1.Touched:Connect(function(hit) -- Handle when dialogue Trigger 1 hit
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(character) then
				StartDialogue:FireClient(player, "Player", "start")
                showBully()
				DialogueTrigger1:Destroy()
			end
		end)

        TaskService.LoadTasks(player, 3, {
			"put_stuff_away",
		})
		
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"put_stuff_away",
		})

		hideBully()
		

		local collisionPart = workspace
			:WaitForChild("Map")
			:WaitForChild("School")
			:WaitForChild("Doors")
			:WaitForChild("Doorway_Classroom102")  -- this grabs the second Doorway since that's the one with InsideDoor
			:WaitForChild("InsideDoor")
			:WaitForChild("CollisionPart")

		if collisionPart then
			collisionPart.CanCollide = false
			collisionPart.CanTouch = false
			collisionPart.CanQuery = false
			print("Collision disabled!")
		else
			warn("CollisionPart NOT found!")
		end

		-- Phase 2: go to class
		DialogueTrigger2.Touched:Connect(function(hit) -- Handle when dialogue Trigger 2 hit
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(character) then
				StartDialogue:FireClient(player, "Player", "teacher_intro")
				TaskService.CompleteTask(player, 3, "go_class") -- manually need to mark it done for dialoguetriggers
				DialogueTrigger2:Destroy()
			end
		end)

		TaskService.LoadTasks(player, 3, {
			"go_class",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_class",
		})

		TaskService.LoadTasks(player, 3, {
			"get_worksheet",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"get_worksheet",
		})

		-- Remove collision on library door
		local libraryCollisionPart = workspace
			:WaitForChild("Map")
			:WaitForChild("School")
			:WaitForChild("Doors")
			:WaitForChild("Doorway_Library")
			:WaitForChild("InsideDoor")
			:WaitForChild("CollisionPart")

		if libraryCollisionPart then
			libraryCollisionPart.CanCollide = false
			libraryCollisionPart.CanTouch = false
			libraryCollisionPart.CanQuery = false
			print("Library door collision disabled!")
		else
			warn("Library CollisionPart NOT found!")
		end

		-- Phase 3: library
		DialogueTrigger3.Touched:Connect(function(hit) -- Handle when dialogue Trigger 3 hit
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(character) then
				StartDialogue:FireClient(player, "Player", "friend_notice")
				TaskService.CompleteTask(player, 3, "go_library") -- manually need to mark it done for dialoguetriggers
				DialogueTrigger3:Destroy()
			end
		end)

		TaskService.LoadTasks(player, 3, {
			"go_library",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_library",
		})
		-- re enable the collision on library door to smoothly transition to scene 4
		if libraryCollisionPart then
			libraryCollisionPart.CanCollide = true
			libraryCollisionPart.CanTouch = true
			libraryCollisionPart.CanQuery = true
			print("Library door collision enabled!")
		else
			warn("Library CollisionPart NOT found!")
		end
		-- -----------------------end of phase 3

		-- once everything is done, go to door and it'll start scene 4
		TaskService.LoadTasks(player, 3, {
			"go_to_door",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})

		SceneManager.Transition(player)
		
	end)
end

return Progression
