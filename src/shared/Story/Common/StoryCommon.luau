local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DialogueRemotes = Remotes:WaitForChild("Dialogue")
local StartDialogue = DialogueRemotes:WaitForChild("StartDialogue")
local FinishDialogue = Remotes.Dialogue:WaitForChild("FinishDialogue")
local ChatWindowIsClosed = Remotes.Chat:WaitForChild("ChatWindowIsClosed")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)
--  This file is a refactor for common helpers
local StoryCommon = {}

local function waitForTasks(player, taskIds)
	repeat
		task.wait()
	until TaskService.AreTasksComplete(player, taskIds)
end

function StoryCommon.startDialogueAndWait(player, dialogueName, startNode)
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

function StoryCommon.waitForTasksThenCloseAndDisableChat(player, taskIds, toggleChatRemote)
    	local bindable = Instance.new("BindableEvent")
	local connection
	local tasksFinished = false
	local chatIsClosed = false

	connection = ChatWindowIsClosed.OnServerEvent:Connect(function(firingPlayer, chatWindowStatus)
		if firingPlayer ~= player then
			return
		end

		chatIsClosed = chatWindowStatus

		if tasksFinished and chatIsClosed then
			connection:Disconnect()
			connection = nil
			bindable:Fire()
		end
	end)

	waitForTasks(player, taskIds)
	tasksFinished = true

	if chatIsClosed then
		if connection then
			connection:Disconnect()
			connection = nil
		end
		bindable:Fire()
	end

	bindable.Event:Wait()

	if connection then
		connection:Disconnect()
	end
	bindable:Destroy()

	toggleChatRemote:FireClient(player)
end
return StoryCommon