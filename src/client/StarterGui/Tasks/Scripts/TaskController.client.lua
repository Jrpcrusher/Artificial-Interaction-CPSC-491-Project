local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local TaskComplete = SoundService:WaitForChild("TaskComplete")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TaskConfig = require(Shared.Systems.Tasks:WaitForChild("TaskConfig"))
local GuiMouseManager = require(Shared.Systems.Input.GuiMouseManager)
local GuiMovementManager = require(Shared.Systems.Input.GuiMovementManager)

local TaskRemotes = Remotes:WaitForChild("Tasks")
local TaskUpdated = TaskRemotes:WaitForChild("TaskUpdated")
local TaskSync = TaskRemotes:WaitForChild("TaskSync")

local tasksGui = playerGui:WaitForChild("Tasks")

local aiChatGui = playerGui:WaitForChild("AIChatGui")
local dialogueGui = playerGui:WaitForChild("DialogueGui")

local chatFrame = aiChatGui:WaitForChild("ChatWindow")
local dialogueBar = dialogueGui:WaitForChild("DialogueBar")

local currentScene = 1
local activeTaskIds = {}
local completedTaskIds = {}
local selectedTask = nil

-- Left pinned tracker
local tasksOpenButton = tasksGui:WaitForChild("TasksOpenButton")
local taskFrame = tasksOpenButton:WaitForChild("Task")
local finishedTaskFrame = tasksOpenButton:WaitForChild("FinishedTask")

local taskObjectiveLabel = taskFrame:WaitForChild("TaskObjective")
local taskStepsLabel = taskFrame:WaitForChild("TaskSteps")
local taskBulletPointBullet = taskFrame:WaitForChild("BulletPointBullet")

local finishedTaskObjectiveLabel = finishedTaskFrame:WaitForChild("TaskObjective")
local finishedTaskBulletPoint = finishedTaskFrame:WaitForChild("BulletPoint")

-- Middle popup task menu
local openTasks = tasksGui:WaitForChild("OpenTasks")
local frameCanvas = openTasks:WaitForChild("FrameCanvas")
local mainFrame = frameCanvas:WaitForChild("Main")
local listFrame = mainFrame:WaitForChild("List")
local exitTaskMenu = mainFrame:WaitForChild("ExitTaskMenu")

local template = listFrame:WaitForChild("Template")
local completedTemplate = listFrame:WaitForChild("CompletedTemplate")

template.Visible = false
completedTemplate.Visible = false
tasksOpenButton.Visible = true
mainFrame.Visible = false

local function isTaskActive(taskId)
	return activeTaskIds[taskId] == true
end

local function isTaskCompleted(taskId)
	return completedTaskIds[taskId] == true
end

local function buildRuntimeTask(taskDefinition)
	local task = table.clone(taskDefinition)
	task.Completed = isTaskCompleted(task.Id)
	return task
end

local function getCurrentTasks()
	local allTasks = TaskConfig.GetTasksForScene(currentScene)
	local runtimeTasks = {}

	for _, taskDefinition in ipairs(allTasks) do
		if isTaskActive(taskDefinition.Id) then
			table.insert(runtimeTasks, buildRuntimeTask(taskDefinition))
		end
	end

	return runtimeTasks
end

local function isTaskMenuOpen()
	return mainFrame.Visible
end

local function setTaskMenuOpen(isOpen)
	mainFrame.Visible = isOpen
end

local function isAnotherGuiOpen()
	local chatIsOpen = aiChatGui.Enabled and chatFrame.Visible
	local dialogueIsOpen = dialogueGui.Enabled and dialogueBar.Visible
	return chatIsOpen or dialogueIsOpen
end

local function clearGeneratedEntries()
	for _, child in ipairs(listFrame:GetChildren()) do
		if
			child ~= template
			and child ~= completedTemplate
			and not child:IsA("UIListLayout")
			and not child:IsA("UIPadding")
			and not child:IsA("UICorner")
		then
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
	end
end

local function getProgressText(task)
	if task.Completed then
		TaskComplete:Play()
		return "Completed"
	end

	if task.Type == "Optional" then
		return "Optional"
	end

	return "In Progress"
end

local function updatePinnedTracker(task)
	if not task then
		tasksOpenButton.Text = "No Task"
		taskObjectiveLabel.Text = "No objective."
		taskStepsLabel.Text = "No steps."
		taskFrame.Visible = true
		finishedTaskFrame.Visible = false
		return
	end

	local titleText = task.Title

	tasksOpenButton.Text = titleText

	if task.Completed then
		taskFrame.Visible = false
		finishedTaskFrame.Visible = true
		finishedTaskObjectiveLabel.Text = "Completed"
		finishedTaskObjectiveLabel.TextColor3 = Color3.fromRGB(85, 255, 127)

		if finishedTaskBulletPoint:IsA("TextLabel") then
			finishedTaskBulletPoint.Text = "✓"
		end
	else
		taskFrame.Visible = true
		finishedTaskFrame.Visible = false
		taskObjectiveLabel.Text = task.Objective or "No objective."
		taskStepsLabel.Text = task.Steps or "No steps."

		if taskBulletPointBullet:IsA("TextLabel") then
			taskBulletPointBullet.Text = "□"
		end
	end
end

local function closeTaskMenu()
	if not isTaskMenuOpen() then
		return
	end

	setTaskMenuOpen(false)
	GuiMouseManager.CloseGui()
	GuiMovementManager.Unlock()
end

local function buildTaskEntry(task)
	local entry = (task.Completed and completedTemplate or template):Clone()
	entry.Name = task.Id
	entry.Visible = true
	entry.Parent = listFrame

	local taskTitle = entry:FindFirstChild("TaskTitle")
	local taskProgress = entry:FindFirstChild("TaskProgress")

	if taskTitle and taskTitle:IsA("TextLabel") then
		taskTitle.Text = task.Title
	end

	if taskProgress and taskProgress:IsA("TextLabel") then
		taskProgress.Text = getProgressText(task)
	end

	entry.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			selectedTask = task
			updatePinnedTracker(task)
			closeTaskMenu()
		end
	end)
end

local function populateTaskList()
	clearGeneratedEntries()

	for _, task in ipairs(getCurrentTasks()) do
		buildTaskEntry(task)
	end
end

local function getDefaultTask()
	local tasks = getCurrentTasks()

	for _, task in ipairs(tasks) do
		if not task.Completed and task.Type == "Required" then
			return task
		end
	end

	for _, task in ipairs(tasks) do
		if not task.Completed then
			return task
		end
	end

	return tasks[1]
end

local function openTaskMenu()
	if isTaskMenuOpen() then
		return
	end

	if isAnotherGuiOpen() then
		return
	end

	setTaskMenuOpen(true)
	GuiMouseManager.OpenGui()
	GuiMovementManager.Lock()
end

local function refreshTaskUI()
	populateTaskList()
	selectedTask = getDefaultTask()
	updatePinnedTracker(selectedTask)
end

local function setScene(sceneNumber)
	currentScene = sceneNumber
	activeTaskIds = {}
	completedTaskIds = {}
	refreshTaskUI()
end

local function replaceSet(targetTable, values)
	table.clear(targetTable)

	for _, value in ipairs(values) do
		targetTable[value] = true
	end
end

tasksOpenButton.MouseButton1Click:Connect(openTaskMenu)
exitTaskMenu.MouseButton1Click:Connect(closeTaskMenu)

TaskSync.OnClientEvent:Connect(function(sceneNumber, activeTaskIdList, completedTaskIdList)
	currentScene = sceneNumber or currentScene

	replaceSet(activeTaskIds, activeTaskIdList or {})
	replaceSet(completedTaskIds, completedTaskIdList or {})

	refreshTaskUI()
end)

TaskUpdated.OnClientEvent:Connect(function(taskId, sceneNumber)
	if sceneNumber and sceneNumber ~= currentScene then
		return
	end

	if not taskId or not isTaskActive(taskId) then
		return
	end

	completedTaskIds[taskId] = true
	refreshTaskUI()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.J then
		if isTaskMenuOpen() then
			closeTaskMenu()
		else
			openTaskMenu()
		end
	end
end)

refreshTaskUI()

return {
	SetScene = setScene,
	Refresh = refreshTaskUI,
}
