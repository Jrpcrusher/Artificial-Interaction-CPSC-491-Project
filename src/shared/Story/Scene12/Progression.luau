local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

local function LoadObjects()
	local sceneObjects = Workspace:FindFirstChild("Scene12Objects")
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
	local sceneObjects = Workspace:FindFirstChild("Scene12Objects")
	if sceneObjects then
		sceneObjects:Destroy()
	end
end

function Progression.Start(player)
	task.spawn(function()
		LoadObjects()
		TaskService.ResetForScene(player, 12)

		TaskService.LoadTasks(player, 12, {
			"go_to_sleep",
		})
		repeat 
			task.wait() 
		until TaskService.AreTasksComplete(player, { "go_to_sleep" })

		UnloadObjects()
	end)
end

return Progression