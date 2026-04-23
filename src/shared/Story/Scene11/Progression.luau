local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local Common = require(ReplicatedStorage.Shared.Story.Common.StoryCommon)


local SceneObjects = workspace:WaitForChild("Scene11Objects")
local DialogueTrigger1 = SceneObjects:WaitForChild("DialogueTrigger1")

local PhoneRing = SoundService:WaitForChild("Phone")

local Progression = {}


function Progression.Load()

	local Dad = SceneObjects:WaitForChild("Dad")
	Dad:PivotTo(CFrame.new(5.784, 27.233, -36.256) * CFrame.Angles(0, math.rad(-69.731), 0))
	local Mom = SceneObjects:WaitForChild("Mom")
	Mom:PivotTo(CFrame.new(8.882, 27.233, -33.134) * CFrame.Angles(0, math.rad(45), 0))
	local Phone = SceneObjects:WaitForChild("Phone")
	Phone:PivotTo(CFrame.new(4.729, 25.959, -29.223) * CFrame.Angles(math.rad(90), math.rad(50), 0))
	local RoomDoorTrigger = SceneObjects:WaitForChild("RoomDoorTrigger")
	RoomDoorTrigger.Position = Vector3.new(20.21, 40.555, -77.999)
	DialogueTrigger1.Position = Vector3.new(7.3, 29.326, -35.505)
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
		
		local spawnPart = workspace:WaitForChild("Spawns"):WaitForChild("Scene11Spawn")
		local root = character:FindFirstChild("HumanoidRootPart")

		if root and spawnPart then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
		end

		TaskService.ResetForScene(player, 11)
		TaskService.LoadTasks(player, 11, {
			"talk_to_parents",
		})
		local connection
		connection = DialogueTrigger1.Touched:Connect(function(hit)
			local currentCharacter = player.Character
			if not currentCharacter then
				return
			end
			if hit:IsDescendantOf(currentCharacter) then
				connection:Disconnect()
				TaskService.CompleteTask(player, 11, "talk_to_parents")
				DialogueTrigger1:Destroy()
			end
		end)
		Common.WaitForTasks(player, {"talk_to_parents"})
		Common.StartDialogueAndWait(player, "Player", "scene11discussion")
		PhoneRing.Looped = true
		PhoneRing:Play()
		task.wait(3)
		Common.StartDialogueAndWait(player, "Dad", "phoneCall")
		PhoneRing:Stop()
		task.wait(5)
		Common.StartDialogueAndWait(player, "Dad", "scene11Fight")

		TaskService.LoadTasks(player, 11, {
			"go_to_room",
		})
		Common.WaitForTasks(player, {"go_to_room"})

		Progression.Unload()
		SceneManager.Transition(player)
	end)
end

return Progression