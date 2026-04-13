local TaskState = {}

local stateByUserId = {}

local function getPlayerState(player)
	local userId = player.UserId

	if not stateByUserId[userId] then
		stateByUserId[userId] = {
			sceneNumber = 1,
			activeTaskIds = {},
			completedTaskIds = {},
		}
	end

	return stateByUserId[userId]
end

function TaskState.SetScene(player, sceneNumber)
	local state = getPlayerState(player)
	state.sceneNumber = sceneNumber
	state.activeTaskIds = {}
	state.completedTaskIds = {}
end

function TaskState.GetScene(player)
	return getPlayerState(player).sceneNumber
end

function TaskState.SetActiveTasks(player, taskIds)
	local state = getPlayerState(player)
	state.activeTaskIds = {}

	for _, taskId in ipairs(taskIds) do
		state.activeTaskIds[taskId] = true
	end
end

function TaskState.GetActiveTaskIds(player)
	return getPlayerState(player).activeTaskIds
end

function TaskState.IsTaskActive(player, taskId)
	return getPlayerState(player).activeTaskIds[taskId] == true
end

function TaskState.MarkTaskComplete(player, taskId)
	getPlayerState(player).completedTaskIds[taskId] = true
end

function TaskState.IsTaskCompleted(player, taskId)
	return getPlayerState(player).completedTaskIds[taskId] == true
end

function TaskState.GetCompletedTaskIds(player)
	return getPlayerState(player).completedTaskIds
end

function TaskState.ClearPlayer(player)
	stateByUserId[player.UserId] = nil
end

return TaskState
