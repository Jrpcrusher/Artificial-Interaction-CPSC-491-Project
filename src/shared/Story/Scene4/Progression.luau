local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local DialogueTrigger1 = workspace.Scene3Objects:WaitForChild("DialogueTrigger1")
local DialogueTrigger2 = workspace.Scene3Objects:WaitForChild("DialogueTrigger2")
local DialogueTrigger3 = workspace.Scene3Objects:WaitForChild("DialogueTrigger3")
local DialogueTrigger4 = workspace.Scene3Objects:WaitForChild("DialogueTrigger4")




local Scene4Objects = workspace:WaitForChild("Scene4Objects")


local Progression = {}

function Progression.Start(player)
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene4Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 4)

        -- phase 1: entering home
        DialogueTrigger1.Touched:Connect(function(hit) -- Handle when dialogue Trigger 1 hit
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(character) then
				StartDialogue:FireClient(player, "Player", "beginning_inner")
				DialogueTrigger1:Destroy()
			end
		end)

        -- optional task of asking sister what she's drawing
        TaskService.LoadTasks(player, 4, {
			"drawing_question",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"drawing_question",
		})
        -- required task of listening in on parents
        TaskService.LoadTasks(player, 4, {
			"go_upstairs",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_upstairs",
		})
        
        -- handles going upstairs task
        DialogueTrigger2.Touched:Connect(function(hit) -- Handle when dialogue Trigger 2 hit
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(character) then
                TaskService.CompleteTask(player, 4, "go_upstairs") -- manually need to mark it done for dialoguetriggers
				DialogueTrigger2:Destroy()
			end
		end)


        -- phase 2: listening in
        DialogueTrigger3.Touched:Connect(function(hit) -- Handle when dialogue Trigger 3 hit
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(character) then
				StartDialogue:FireClient(player, "Player", "start")
                TaskService.CompleteTask(player, 4, "listen_to_conversation") -- manually need to mark it done for dialoguetriggers
				DialogueTrigger3:Destroy()
			end
		end)

        -- Remove collision on room door
		local roomCollisionPart = workspace
			:WaitForChild("Map")
			:WaitForChild("House")
			:WaitForChild("DoubleStoryUrbanHouse")
			:WaitForChild("Doors")
			:WaitForChild("TDW")
            :WaitForChild("Handle")
            :WaitForChild("CollisionPart")

		if roomCollisionPart then
			roomCollisionPart.CanCollide = false
			roomCollisionPart.CanTouch = false
			roomCollisionPart.CanQuery = false
			print("Room door collision disabled!")
		else
			warn("Room CollisionPart NOT found!")
		end

        -- phase 3: in room
        DialogueTrigger4.Touched:Connect(function(hit) -- Handle when dialogue Trigger 4 hit
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end

			if hit:IsDescendantOf(character) then
				StartDialogue:FireClient(player, "Player", "in_room")
				DialogueTrigger4:Destroy()
			end
		end)

        -- player puts backpack on chair again
        TaskService.LoadTasks(player, 4, {
			"backpack_on_chair",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"backpack_on_chair",
		})

        -- Show backpack on chair
		local backpackPart = workspace
			:WaitForChild("Scene4Objects")
			:WaitForChild("Backpack")

		if backpackPart then
			backpackPart.Transparency = 0
			print("Backpack shown!")
		else
			warn("Backpack NOT found!")
		end


        -- player interacts w bed
        TaskService.LoadTasks(player, 4, {
			"rest",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"rest",
		})

    end)
end

return Progression