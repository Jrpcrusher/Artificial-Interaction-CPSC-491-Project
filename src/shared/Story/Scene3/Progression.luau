local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local DialogueTrigger1 = workspace.Scene3Objects:WaitForChild("DialogueTrigger1")

local Scene3Objects = workspace:WaitForChild("Scene3Objects")
local Bully = Scene3Objects:WaitForChild("Bully")

local Progression = {}

local function hideBully() -- Helper function to hide bully
	
	-- make move function for bully & teacher

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
		-- Phase 1: put stuff in locker after talking w friend/bully whatever his name is lol
		hideBully()
        TaskService.LoadTasks(player, 3, {
			"put_stuff_away",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"put_stuff_away",
		})

		-- after "put stuffaway" task is done, the collisions to the classroom 102 door will go away.
		--==========================
		-- TO DO: enter logic for when the task "put_stuff_away" is finished, then remove collisions on the collision part of the door.
		--==========================
		-- then user can go to class

		-- Phase 2: go to class
		TaskService.LoadTasks(player, 3, {
			"get_worksheet",
		})

		-- here, we wait until the user goes to class but for backend logic, this will wait for when the user walks into
		-- the magic box (similar to dialogue trigger). During this trigger, it triggers only phase 2 dialogue.
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"get_worksheet",
		})

		-- once user gets worksheet, task will become complete & next task is to go to library. so now, the door to the library, will turn off collision
		-- and once user goes into THIS magic box, the task marks complete and dialogue ALSO triggers for phase 3.
		TaskService.LoadTasks(player, 3, {
			"go_library",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_library",
		})
		-- -----------------------end of phase 3

		-- once everything is done, go to door and it'll start scene 4
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})
		
	end)
end

return Progression
