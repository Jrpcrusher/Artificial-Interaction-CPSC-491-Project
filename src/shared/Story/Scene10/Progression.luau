local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

local function LoadObjects()
	local sceneObjects = Workspace:FindFirstChild("Scene10Objects")
	if not sceneObjects then 
		return 
	end

	for _, child in ipairs(sceneObjects:GetChildren()) do
		if child:IsA("Model") then
			local cf = child:GetPivot()
			if cf.Position.Y < 0 then
				local newCf = CFrame.new(cf.Position.X, math.abs(cf.Position.Y), cf.Position.Z) * cf.Rotation
				child:PivotTo(newCf)
			end
		elseif child:IsA("BasePart") then
			local cf = child.CFrame
			if cf.Position.Y < 0 then
				local newCf = CFrame.new(cf.Position.X, math.abs(cf.Position.Y), cf.Position.Z) * cf.Rotation
				child.CFrame = newCf
			end
		end
	end
end

local function UnloadObjects()
	local sceneObjects = Workspace:FindFirstChild("Scene10Objects")
	if sceneObjects then
		sceneObjects:Destroy()
	end
end

function Progression.Start(player)
	task.spawn(function()
		LoadObjects()
		TaskService.ResetForScene(player, 10)

		TaskService.LoadTasks(player, 10, {
			"talk_to_friend",
		})
		repeat 
			task.wait() 
		until TaskService.AreTasksComplete(player, { "talk_to_friend" })

		TaskService.LoadTasks(player, 10, {
			"sit_at_desk",
		})
		repeat 
			task.wait() 
		until TaskService.AreTasksComplete(player, { "sit_at_desk" })

		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
		end

		TaskService.LoadTasks(player, 10, {
			"flip_quiz",
		})
		repeat 
			task.wait() 
		until TaskService.AreTasksComplete(player, { "flip_quiz" })

		if humanoid then
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
		end

		TaskService.LoadTasks(player, 10, {
			"go_to_door",
		})
		repeat 
			task.wait() 
		until TaskService.AreTasksComplete(player, { "go_to_door" })

		UnloadObjects()
	end)
end

return Progression