local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Scene13Objects = workspace:WaitForChild("Scene13Objects")
local DialogueTrigger1 = Scene13Objects:WaitForChild("DialogueTrigger1")
local Bully = Scene13Objects:WaitForChild("Bully")
local Teacher = Scene13Objects:WaitForChild("Teacher")

local Progression = {}

local function knockPlayerOver(player) -- TODO!: FIX THIS SO IT ACTUALLY WORKS
	print("in knock player over")
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.AutoRotate = false
	humanoid.PlatformStand = true
end

local function restorePlayerFromKnocked(player) -- TODO!: FIX THIS SO IT ACTUALLY WORKS
	print("in restore player")
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	humanoid.PlatformStand = false
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.AutoRotate = true
end

function Progression.Start(player)
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

		-- simple fixed delay to let the bully dialogue finish
		task.wait(4)

		knockPlayerOver(player)

		task.wait(5)

		restorePlayerFromKnocked(player)

		DialogueTrigger1.Touched:Connect(function(hit)
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(currentCharacter) then
				StartDialogue:FireClient(player, "Teacher", "start")
				DialogueTrigger1:Destroy()
			end
		end)

		TaskService.LoadTasks(player, 13, {
			"go_to_door",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})

		Bully:Destroy()
		Teacher:Destroy()
	end)
end

return Progression
