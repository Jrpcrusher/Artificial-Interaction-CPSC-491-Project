local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Story = ReplicatedStorage.Shared.Story

local SceneTasks = {
	[1] = require(Story.Scene1.Tasks),
	[2] = require(Story.Scene2.Tasks),
	[3] = require(Story.Scene3.Tasks),
	[4] = require(Story.Scene4.Tasks),
	[5] = require(Story.Scene5.Tasks),
	[6] = require(Story.Scene6.Tasks),
	[7] = require(Story.Scene7.Tasks),
	[8] = require(Story.Scene8.Tasks),
	[9] = require(Story.Scene9.Tasks),
	[10] = require(Story.Scene10.Tasks),
	[11] = require(Story.Scene11.Tasks),
	[12] = require(Story.Scene12.Tasks),
	[13] = require(Story.Scene13.Tasks),
	[14] = require(Story.Scene14.Tasks),
	[15] = require(Story.Scene15.Tasks),
	[16] = require(Story.Scene16.Tasks)
}
local TaskConfig = {}

function TaskConfig.GetTasksForScene(sceneNumber)
	return SceneTasks[sceneNumber] or {}
end

function TaskConfig.GetTaskById(taskId, sceneNumber)
	local tasks = TaskConfig.GetTasksForScene(sceneNumber)
	for _, task in ipairs(tasks) do
		if task.Id == taskId then
			return task
		end
	end
	return nil
end

function TaskConfig.AreAllRequiredTasksBeforeDoorComplete(sceneNumber)
	local tasks = TaskConfig.GetTasksForScene(sceneNumber)

	for _, task in ipairs(tasks) do
		if task.Type == "Required" and task.Id ~= "go_to_door" then
			if not task.Completed then
				return false
			end
		end
	end
	return true
end

function TaskConfig.IsDoorTaskEnabled(sceneNumber)
	local doorTask = TaskConfig.GetTaskById("go_to_door", sceneNumber)
	if not doorTask then
		return false
	end

	return TaskConfig.AreAllRequiredTasksBeforeDoorComplete() and not doorTask.Completed
end

function TaskConfig.MarkTaskComplete(taskId, sceneNumber)
	local task = TaskConfig.GetTaskById(taskId, sceneNumber)
	if task then
		task.Completed = true
		return true
	end
	return false
end

return TaskConfig