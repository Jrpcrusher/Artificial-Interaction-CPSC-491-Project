local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DialogueRemotes = Remotes:WaitForChild("Dialogue")
local StartDialogue = DialogueRemotes:WaitForChild("StartDialogue")
local FinishDialogue = Remotes.Dialogue:WaitForChild("FinishDialogue")
local ChatWindowIsClosed = Remotes.Chat:WaitForChild("ChatWindowIsClosed")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local StoryCommon = {}

function StoryCommon.WaitForTasks(player, taskIds)
	repeat
		task.wait()
	until TaskService.AreTasksComplete(player, taskIds)
end

function StoryCommon.StartDialogueAndWait(player, dialogueName, startNode)
	local bindable = Instance.new("BindableEvent")
	local connection

	connection = FinishDialogue.OnServerEvent:Connect(function(firingPlayer, finishedDialogue, finishedStartNode)
		if firingPlayer == player and finishedDialogue == dialogueName and finishedStartNode == startNode then
			connection:Disconnect()
			connection = nil
			bindable:Fire()
		end
	end)

	StartDialogue:FireClient(player, dialogueName, startNode)
	bindable.Event:Wait()

	if connection then
		connection:Disconnect()
	end
	bindable:Destroy()
end

function StoryCommon.WaitForChatClose(player, taskIds)
	local bindable = Instance.new("BindableEvent")
	local connection
	local tasksFinished = false
	local completed = false

	local function finish()
		if completed then
			return
		end
		completed = true
		if connection then
			connection:Disconnect()
			connection = nil
		end
		bindable:Fire()
	end
	connection = ChatWindowIsClosed.OnServerEvent:Connect(function(firingPlayer, chatWindowStatus)
		if firingPlayer ~= player then
			return
		end
		if tasksFinished and chatWindowStatus == true then
			finish()
		end
	end)
	StoryCommon.WaitForTasks(player, taskIds)
	tasksFinished = true
	if not completed then
		bindable.Event:Wait()
	end
	if connection then
		connection:Disconnect()
	end
	bindable:Destroy()
end

return StoryCommon
