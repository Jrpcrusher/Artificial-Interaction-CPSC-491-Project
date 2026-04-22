local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")

local DialogueTrigger1 = workspace.Scene4Objects:WaitForChild("DialogueTrigger1")
local DialogueTrigger2 = workspace.Scene4Objects:WaitForChild("DialogueTrigger2")
local DialogueTrigger3 = workspace.Scene4Objects:WaitForChild("DialogueTrigger3")
local DialogueTrigger4 = workspace.Scene4Objects:WaitForChild("DialogueTrigger4")
local HelperPartBed = workspace.Scene4Objects:WaitForChild("HelperPartBed")
local ProximityPrompt = HelperPartBed:WaitForChild("ProximityPrompt")

local Progression = {}
    
local SceneObjects = workspace:WaitForChild("Scene4Objects")

    function Progression.Load()

    local Sister = SceneObjects:WaitForChild("Sister")
    Sister:PivotTo(CFrame.new(42.608, 27.355, -68.229) * CFrame.Angles(0, math.rad(-90), 0))

    local Drawing = SceneObjects:WaitForChild("Drawing")
    Drawing:PivotTo(CFrame.new(44.923, 25.846, -68.229) * CFrame.Angles(0, math.rad(90), 0))

    -- Position legs for sitting pose
    local leftLeg = Sister:FindFirstChild("Left Leg")
    if leftLeg then
        leftLeg.CFrame = CFrame.new(43.423, 24.771, -68.729) * CFrame.Angles(math.rad(90), math.rad(-90), 0)
    end

    local rightLeg = Sister:FindFirstChild("Right Leg")
    if rightLeg then
        rightLeg.CFrame = CFrame.new(43.423, 24.771, -67.729) * CFrame.Angles(math.rad(90), math.rad(-90), 0)
    end

    local Backpack = SceneObjects:WaitForChild("Backpack")
    Backpack.Position = Vector3.new(2.411, 39.424, -76.023)

    DialogueTrigger1.Position = Vector3.new(35.4, 27.755, -38.229)
    DialogueTrigger2.Position = Vector3.new(29.599, 40.755, -73.004)
    DialogueTrigger3.Position = Vector3.new(23.8, 40.755, -59.781)
    DialogueTrigger4.Position = Vector3.new(15.925, 41.955, -71)

    local HelperPartBackpack = SceneObjects:WaitForChild("HelperPartBackpack")
    HelperPartBackpack.Position = Vector3.new(1.98, 39.424, -76.5)

    HelperPartBed.Position = Vector3.new(14.108, 37.855, -65.294)
	ProximityPrompt.Enabled = false
end

function Progression.Unload()
    for _, obj in ipairs(SceneObjects:GetChildren()) do
        if obj:IsA("Model") then
            obj:PivotTo(CFrame.new(0, -500, 0))
        elseif obj:IsA("BasePart") then
            obj.Position = Vector3.new(0, -500, 0)
        end
    end
end

function Progression.Start(player)
    Progression.Load()
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

        -- required task of listening in on parents
        TaskService.LoadTasks(player, 4, {
			"go_upstairs",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"go_upstairs",
		})


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

        TaskService.LoadTasks(player, 4, {
			"listen_to_conversation",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"listen_to_conversation",
		})

        -- Remove collision on room door
		local TDW = workspace
			:WaitForChild("Map")
			:WaitForChild("House")
			:WaitForChild("DoubleStoryUrbanHouse")
            :WaitForChild("UpperLevel")
			:WaitForChild("Doors")
			:WaitForChild("TDW")

		for _, descendant in ipairs(TDW:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
            end
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

        for _, descendant in ipairs(TDW:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = true
                descendant.CanTouch = true
                descendant.CanQuery = true
            end
        end

        -- Show backpack on chair
		local backpackPart = workspace
			:WaitForChild("Scene4Objects")
			:WaitForChild("Backpack")

		if backpackPart then
			backpackPart.Transparency = 0
		else
			warn("Backpack NOT found!")
		end

		ProximityPrompt.Enabled = true
        -- player interacts w bed
        TaskService.LoadTasks(player, 4, {
			"rest",
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"rest",
		})

        Progression.Unload()
        SceneManager.Transition(player)

    end)
end

return Progression