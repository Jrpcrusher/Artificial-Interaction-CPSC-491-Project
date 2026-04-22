local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = require(ReplicatedStorage.Shared.Story.Common.StoryCommon)
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local SceneObjects = workspace:WaitForChild("Scene9Objects")

local Cup = SceneObjects:WaitForChild("Cup")
local Glass = SceneObjects:WaitForChild("Glass")
local DialogueTrigger1 = SceneObjects:WaitForChild("DialogueTrigger1")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartDialogue = Remotes.Dialogue:WaitForChild("StartDialogue")
local ShowAIChatGui = Remotes.Chat:WaitForChild("ShowAIChatGui")

local Progression = {}

function Progression.Load()
	local Sister = SceneObjects:WaitForChild("Sister")
	Sister:PivotTo(CFrame.new(37.6, 27.292, -85.793) * CFrame.Angles(0, math.rad(-150), 0))
	local Mom = SceneObjects:WaitForChild("Mom")
	Mom:PivotTo(CFrame.new(17.421, 27.434, -48.622) * CFrame.Angles(0, math.rad(26.062), 0))

	local Dad = SceneObjects:WaitForChild("Dad")
	Dad:PivotTo(CFrame.new(11.531, 27.434, -49.896) * CFrame.Angles(0, math.rad(-93.938), 0))
	
	Cup:PivotTo(CFrame.new(15.688, 25.755, -56.853))
	
	local FridgeTrigger = SceneObjects:WaitForChild("FridgeTrigger")
	FridgeTrigger.Position = Vector3.new(57.302, 26.94, -83.203)
	local FrontDoorTrigger = SceneObjects:WaitForChild("FrontDoorTrigger")
	FrontDoorTrigger.Position = Vector3.new(35.6, 27.155, -27.519)

end

function Progression.Unload()
	for _, obj in ipairs(SceneObjects:GetChildren()) do
		obj:Destroy()
	end
end

function Progression.Start(player)
	Progression.Load()
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()

		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene9Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 9)

		TaskService.LoadTasks(player, 9, {
			"eat_food",
		})
		Common.WaitForTasks(player, {"eat_food"})


		TaskService.LoadTasks(player, 9, {
			"talk_to_sister",
		})
		Common.WaitForTasks(player, {"talk_to_sister"})


		TaskService.LoadTasks(player, 9, {
			"find_noise",
		})

		Cup:Destroy()
		Glass:PivotTo(CFrame.new(14.509, 23.119, -51.675) * CFrame.Angles(0, 0, math.rad(-90)))
		DialogueTrigger1.Position = Vector3.new(17.394, 28.655, -50.003)

		local connection
		connection = DialogueTrigger1.Touched:Connect(function(hit)
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end
			if hit:IsDescendantOf(currentCharacter) then
				connection:Disconnect()
				TaskService.CompleteTask(player, 9, "find_noise")
				DialogueTrigger1:Destroy()
			end
		end)
		Common.WaitForTasks(player, {"find_noise"})

		Common.StartDialogueAndWait(player, "Player", "scene9Fight")
		ShowAIChatGui:FireClient(player, "enable") -- shows AI Chat Gui

		TaskService.LoadTasks(player, 9, {
			"talk_to_charlie",
			"thank_charlie"
		})
		repeat
			task.wait()
		until TaskService.AreTasksComplete(player, {
			"talk_to_charlie",
			"thank_charlie"
		})

		Common.WaitForChatClose(player, {"talk_to_charlie", "thank_charlie"})
		ShowAIChatGui:FireClient(player, "disable") -- shows AI Chat Gui
		ShowAIChatGui:FireClient(player) -- close AI chat gui

		TaskService.LoadTasks(player, 9, {
			"go_to_door",
		})
		Common.WaitForTasks(player, {"go_to_door"})


		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression