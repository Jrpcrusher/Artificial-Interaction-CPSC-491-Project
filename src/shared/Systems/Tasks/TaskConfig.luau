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

function TaskConfig.GetTasksForScene(sceneNumber) -- Handle getting the tasks from the task file
	return SceneTasks[sceneNumber] or {}
end

function TaskConfig.GetTaskById(taskId, sceneNumber) -- Get tasks by their id
	local tasks = TaskConfig.GetTasksForScene(sceneNumber) -- get the tasks from gettaskforscene
	for _, task in ipairs(tasks) do
		if task.Id == taskId then
			return task
		end
	end
	return nil
end

function TaskConfig.GetTasksForStage(sceneNumber, stage) -- Get all the tasks for the stage
	local tasks = TaskConfig.GetTasksForScene(sceneNumber)
	local stageTasks = {}

	for _, task in ipairs(tasks) do
		if (task.Stage or 1) == stage then
			table.insert(stageTasks, task)
		end
	end

	return stageTasks
end

function TaskConfig.GetMaxStage(scene_number) -- Get the maximum amount of tasks for that stage
	local tasks = TaskConfig.GetTasksForScene(scene_number)
	local maxStage = 1

	for _, task in ipairs(tasks) do
		local stage = task.Stage or 1
		if stage > maxStage then
			maxStage = stage
		end
	end

	return maxStage
end

return TaskConfig