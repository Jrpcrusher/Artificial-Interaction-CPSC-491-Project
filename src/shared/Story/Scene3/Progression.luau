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

function Progression.Load()
    local SceneObjects = workspace:WaitForChild("Scene3Objects")

    local Bully = SceneObjects:WaitForChild("Bully")
    Bully:PivotTo(CFrame.new(-269.006, 26.527, -60.419) * CFrame.Angles(0, math.rad(-65), 0))

    local FriendinLibrary = SceneObjects:WaitForChild("FriendinLibrary")
    FriendinLibrary:PivotTo(CFrame.new(-288.422, 26.327, -26.033) * CFrame.Angles(0, math.rad(70), 0))

    local Locker = SceneObjects:WaitForChild("Locker")
    Locker:PivotTo(CFrame.new(-273.669, 25.192, -53.832) * CFrame.Angles(0, 0, math.rad(-90)))

    local TeacherInLibrary = SceneObjects:WaitForChild("TeacherInLibrary")
    TeacherInLibrary:PivotTo(CFrame.new(-280.735, 26.355, -43.939) * CFrame.Angles(0, math.rad(90), 0))

    local TeacherInClass = SceneObjects:WaitForChild("TeacherInClass")
    TeacherInClass:PivotTo(CFrame.new(-259.235, 26.555, -20.839) * CFrame.Angles(0, 0, 0))

    local DialogueTrigger1 = SceneObjects:WaitForChild("DialogueTrigger1")
    DialogueTrigger1.Position = Vector3.new(-267.84, 26.927, -64.229)

    local DialogueTrigger2 = SceneObjects:WaitForChild("DialogueTrigger2")
    DialogueTrigger2.Position = Vector3.new(-256.685, 27.955, -38.229)

    local DialogueTrigger3 = SceneObjects:WaitForChild("DialogueTrigger3")
    DialogueTrigger3.Position = Vector3.new(-292.055, 27.955, -28.028)

    local StackOfPapers = SceneObjects:WaitForChild("StackOfPapers")
    StackOfPapers.Position = Vector3.new(-247.435, 25.355, -23.829)

    local Papers = SceneObjects:WaitForChild("Papers")
    Papers.Position = Vector3.new(-292.235, 24.955, -29.429)
end

function Progression.Unload()
    local SceneObjects = workspace:WaitForChild("Scene3Objects")
    for _, obj in ipairs(SceneObjects:GetChildren()) do
        obj:Destroy()
    end
end

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
	Progression.Load()
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

		Progression.Unload()
		SceneManager.Transition(player)
		
	end)
end

return Progression
