local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _player = Players:GetPlayers()[1]

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local FinishDialogue = Remotes.Dialogue:WaitForChild("FinishDialogue")
local DialogueTrigger1 = workspace.Scene13Objects:WaitForChild("DialogueTrigger1")

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

local function knockPlayerOver(player) -- TODO!: FIX THIS SO IT ACTUALLY WORKS
	print("in knock player over")
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	-- Disable movement
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.AutoRotate = false

	-- Put the humanoid into a physics state
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	-- Force the character onto their back
	if root then
		root.CFrame = root.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
	end

	-- Let physics take over
	humanoid.PlatformStand = true
end

local function restorePlayerFromKnocked(player) -- TODO!: FIX THIS SO IT ACTUALLY WORKS
	print("in restore player")
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	-- Step 1: Turn off PlatformStand
	humanoid.PlatformStand = false

	-- Step 2: Wait one frame so physics settles
	task.wait()

	-- Step 3: Reset orientation so the character isn't sideways
	if root then
		local pos = root.Position
		root.CFrame = CFrame.new(pos) -- upright, no rotation
	end

	-- Step 4: Force a stable humanoid state
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

	-- Step 5: Restore movement
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.AutoRotate = true
end

local function LoadTeacher() -- Used to load the teacher in separately after initial dialogue with bully is finished.
	local SceneObjects = workspace:WaitForChild("Scene13Objects")

	-- Model positioning
	local Teacher = SceneObjects:WaitForChild("Teacher")
	Teacher:PivotTo(CFrame.new(-270.235, 26.687, -64.258) * CFrame.Angles(0, math.rad(-90), 0))
end

function Progression.Load()
	local SceneObjects = workspace:WaitForChild("Scene13Objects")

	-- Model positioning
	local Bully = SceneObjects:WaitForChild("Bully")
	Bully:PivotTo(CFrame.new(-268.235, 26.687, -69.258) * CFrame.Angles(0, math.rad(-135), 0))

	-- Part positioning
	local trigger = SceneObjects:WaitForChild("DialogueTrigger1")
	trigger.Position = Vector3.new(-265.5, 32.187, -62.829)
end

function Progression.Unload()
	local SceneObjects = workspace:WaitForChild("Scene13Objects")
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene13Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 13)
		StartDialogue:FireClient(player, "Player", "scene13IntroMonologue")

		TaskService.LoadTasks(player, 13, {
			"talk_to_bully",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_bully",
		})

		waitForDialogueToEnd(player, "scene13Task1Start") -- Waits for dialogue between player and bully to end.

		knockPlayerOver(player)

		task.wait(3)

		DialogueTrigger1.Touched:Connect(function(hit)
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(currentCharacter) then
				LoadTeacher()
				StartDialogue:FireClient(player, "Teacher", "start")
				DialogueTrigger1:Destroy()
			end
		end)

		waitForDialogueToEnd(player, "start") -- Waits for dialogue between teacher and bully to end.

		restorePlayerFromKnocked(player)

		TaskService.LoadTasks(player, 13, {
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
