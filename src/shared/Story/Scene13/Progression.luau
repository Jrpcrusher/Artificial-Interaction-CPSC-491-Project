local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local Scene13Objects = workspace:WaitForChild("Scene13Objects")
local DialogueTrigger1 = Scene13Objects:WaitForChild("DialogueTrigger1")
local Bully = Scene13Objects:WaitForChild("Bully")
local Teacher = Scene13Objects:WaitForChild("Teacher")

local Progression = {}

local function knockPlayerOver(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.AutoRotate = false
	humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
end

local function restorePlayerFromKnocked(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.AutoRotate = true
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
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

		-- Phase 1
		TaskService.LoadTasks(player, 13, {
			"talk_to_bully",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_bully",
		})

		knockPlayerOver(player) -- Knocks player over (i.e., ragdoll the player) due to player getting punched by the bully.

		DialogueTrigger1.Touched:Connect(
			function(hit) -- Triggers dialogue between bully, teacher, and ending monologue.
				local currentCharacter = player.Character
				if not currentCharacter then
					return
				end

				if hit:IsDescendantOf(character) then
					showNPC(Teacher)
					StartDialogue:FireClient(player, "Teacher", "start")
					DialogueTrigger1.Destroy()
				end
			end
		)

		restorePlayerFromKnocked(player) -- Restores player from getting knocked over by bully.

		-- Phase 2
		TaskService.LoadTasks(player, 13, {
			"go_to_door",
		})

		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_to_door",
		})
	end)

	-- Destroys NPCs once task is complete.
	Bully:Destroy()
	Teacher:Destroy()
end

return Progression
