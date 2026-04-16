local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local DialogueTrigger1 = workspace.Scene2Objects:WaitForChild("DialogueTrigger1")

local Progression = {}

function Progression.Start(player)
	task.spawn(function()
        local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene2Spawn")
		character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
        end

        TaskService.ResetForScene(player, 2)

        DialogueTrigger1.Touched:Connect(function(hit) -- Handle when dialogue Trigger 1 hit
            print("TRIGGER TOUCHED by:", hit:GetFullName())
			local currentCharacter = player.Character
			if not currentCharacter then
                print("No character")
				return
			end

			if hit:IsDescendantOf(character) then
                print("PLAYER touched trigger")
				StartDialogue:FireClient(player, "Player", "start")
                DialogueTrigger1:Destroy()
			end
		end)


        TaskService.LoadTasks(player, 2, {
			"eat_something"
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"eat_something"
		})
	end)
end

return Progression