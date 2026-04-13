local TaskState = {}

local stateByUserId = {}

local function getPlayerState(player)
	local userId = player.UserId

	if not stateByUserId[userId] then
		stateByUserId[userId] = {
			sceneNumber = 1,
			activeStage = 1,
			completedTaskIds = {},
		}
	end

	return stateByUserId[userId]
end

function TaskState.ResetPlayer(player, sceneNumber)
	local state = getPlayerState(player)
	state.sceneNumber = sceneNumber or 1
	state.activeStage = 1
	state.completedTaskIds = {}
end

function TaskState.SetScene(player, sceneNumber)
	local state = getPlayerState(player)
	state.sceneNumber = sceneNumber
	state.activeStage = 1
	state.completedTaskIds = {}
end

function TaskState.GetScene(player)
	return getPlayerState(player).sceneNumber
end

function TaskState.GetActiveStage(player)
	return getPlayerState(player).activeStage
end

function TaskState.IsTaskCompleted(player, taskId)
	return getPlayerState(player).completedTaskIds[taskId] == true
end

function TaskState.MarkTaskComplete(player, taskId)
	local state = getPlayerState(player)
	state.completedTaskIds[taskId] = true
end

function TaskState.GetCompletedTaskIds(player)
	return getPlayerState(player).completedTaskIds
end

function TaskState.AdvanceStage(player)
	local state = getPlayerState(player)
	state.activeStage += 1
end

function TaskState.ClearPlayer(player)
	stateByUserId[player.UserId] = nil
end

return TaskState