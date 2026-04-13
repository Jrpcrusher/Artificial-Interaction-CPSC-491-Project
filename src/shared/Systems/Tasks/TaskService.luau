local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TaskConfig = require(Shared.Systems.Tasks.TaskConfig)
local TaskState = require(Shared.Systems.Tasks.TaskState)

local TaskRemotes = Remotes:WaitForChild("Tasks")
local TaskUpdated = TaskRemotes:WaitForChild("TaskUpdated")
local TaskSync = TaskRemotes:WaitForChild("TaskSync")

local TaskService = {}

local function toList(setTable)
	local result = {}

	for key, value in pairs(setTable) do
		if value then
			table.insert(result, key)
		end
	end

	table.sort(result)
	return result
end

local function syncTasks(player, sceneNumber)
	TaskSync:FireClient(
		player,
		sceneNumber,
		toList(TaskState.GetActiveTaskIds(player)),
		toList(TaskState.GetCompletedTaskIds(player))
	)
end

function TaskService.ResetForScene(player, sceneNumber)
	TaskState.SetScene(player, sceneNumber)
	syncTasks(player, sceneNumber)
end

function TaskService.LoadTasks(player, sceneNumber, taskIds)
	if type(taskIds) ~= "table" then
		warn("TaskService.LoadTasks expected taskIds table")
		return false
	end

	for _, taskId in ipairs(taskIds) do
		local task = TaskConfig.GetTaskById(taskId, sceneNumber)
		if not task then
			warn("TaskService.LoadTasks: unknown task:", taskId, "scene:", sceneNumber)
			return false
		end
	end

	TaskState.SetActiveTasks(player, taskIds)
	syncTasks(player, sceneNumber)
	return true
end

function TaskService.CompleteTask(player, sceneNumber, taskId)
	local task = TaskConfig.GetTaskById(taskId, sceneNumber)
	if not task then
		warn("TaskService.CompleteTask: unknown task:", taskId, "scene:", sceneNumber)
		return false
	end

	if not TaskState.IsTaskActive(player, taskId) then
		return false
	end

	if TaskState.IsTaskCompleted(player, taskId) then
		return true
	end

	TaskState.MarkTaskComplete(player, taskId)
	TaskUpdated:FireClient(player, taskId, sceneNumber)
	return true
end

function TaskService.IsTaskActive(player, taskId)
	return TaskState.IsTaskActive(player, taskId)
end

function TaskService.IsTaskCompleted(player, taskId)
	return TaskState.IsTaskCompleted(player, taskId)
end

function TaskService.AreTasksComplete(player, taskIds)
	if type(taskIds) ~= "table" then
		return false
	end

	for _, taskId in ipairs(taskIds) do
		if not TaskState.IsTaskCompleted(player, taskId) then
			return false
		end
	end

	return true
end

function TaskService.AreActiveTasksComplete(player)
	for taskId, isActive in pairs(TaskState.GetActiveTaskIds(player)) do
		if isActive and not TaskState.IsTaskCompleted(player, taskId) then
			return false
		end
	end

	return true
end

function TaskService.GetActiveTaskIds(player)
	return TaskState.GetActiveTaskIds(player)
end

function TaskService.GetCompletedTaskIds(player)
	return TaskState.GetCompletedTaskIds(player)
end

return TaskService
