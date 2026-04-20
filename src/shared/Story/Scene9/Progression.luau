local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

local function LoadObjects()
	local sceneObjects = Workspace:FindFirstChild("Scene9Objects")
	if not sceneObjects then 
		warn("Scene9Objects missing!")
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
	local sceneObjects = Workspace:FindFirstChild("Scene9Objects")
	if sceneObjects then
		sceneObjects:Destroy()
	end
end

function Progression.Start(player)
	task.spawn(function()
		LoadObjects()
		TaskService.ResetForScene(player, 9)

		TaskService.LoadTasks(player, 9, {
			"eat_food",
		})
		repeat 
			task.wait() 
		until TaskService.AreTasksComplete(player, { "eat_food" })

		TaskService.LoadTasks(player, 9, {
			"talk_to_sister",
		})
		repeat 
			task.wait() 
		until TaskService.AreTasksComplete(player, { "talk_to_sister" })

		TaskService.LoadTasks(player, 9, {
			"go_to_door",
		})
		repeat 
			task.wait() 
		until TaskService.AreTasksComplete(player, { "go_to_door" })

		UnloadObjects()
	end)
end

return Progression