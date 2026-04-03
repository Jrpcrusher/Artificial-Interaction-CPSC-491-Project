local TaskConfig = {}

TaskConfig.Tasks = {
	{
		Id = "pick_up_apple",
		Title = "Find the Apple",
		Objective = "Look around the room for the Apple.",
		Steps = "Search the floor next to Spawn.",
		Type = "Required",
		Completed = false,
	},
	{
		Id = "talk_to_dad",
		Title = "Talk to Dad",
		Objective = "Speak with Dad.",
		Steps = "Walk over to Dad and press E.",
		Type = "Required",
		Completed = false,
	},
	{
		Id = "talk_to_mom",
		Title = "Talk to Mom",
		Objective = "Speak with Mom.",
		Steps = "Walk over to Mom and press E.",
		Type = "Required",
		Completed = false,
	},
	{
		Id = "filler_task",
		Title = "Ex Task",
		Objective = "Ex Objective.",
		Steps = "Ex Steps.",
		Type = "Required",
		Completed = true,
	},
	{ -- if all tasks are done, we use this task to go to next scene
		Id = "go_to_door",
		Title = "Go to the Door",
		Objective = "Head to the door and leave.",
		Steps = "Walk to the door and press interact.",
		Type = "Required",
		Completed = false,
	},
}

function TaskConfig.GetTaskById(taskId)
	for _, task in ipairs(TaskConfig.Tasks) do
		if task.Id == taskId then
			return task
		end
	end
	return nil
end

function TaskConfig.AreAllRequiredTasksBeforeDoorComplete()
	for _, task in ipairs(TaskConfig.Tasks) do
		if task.Type == "Required" and task.Id ~= "go_to_door" then
			if not task.Completed then
				return false
			end
		end
	end
	return true
end

function TaskConfig.IsDoorTaskEnabled()
	local doorTask = TaskConfig.GetTaskById("go_to_door")
	if not doorTask then
		return false
	end

	return TaskConfig.AreAllRequiredTasksBeforeDoorComplete() and not doorTask.Completed
end

return TaskConfig