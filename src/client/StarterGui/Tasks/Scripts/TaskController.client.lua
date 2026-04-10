local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TaskConfig = require(Shared.Systems.Tasks:WaitForChild("TaskConfig"))
local GuiMouseManager = require(Shared.Systems.Input.GuiMouseManager)
local GuiMovementManager = require(Shared.Systems.Input.GuiMovementManager)

local TaskRemotes = Remotes:WaitForChild("Tasks")
local TaskUpdated = TaskRemotes:WaitForChild("TaskUpdated")

local tasksGui = playerGui:WaitForChild("Tasks")

local aiChatGui = playerGui:WaitForChild("AIChatGui")
local dialogueGui = playerGui:WaitForChild("DialogueGui")

local chatFrame = aiChatGui:FindFirstChild("ChatWindow")
local dialogueBar = dialogueGui:FindFirstChild("DialogueBar")

local currentScene = player:GetAttribute("Scene") or 1
local selectedTask = nil

print("TASK CONTROLLER RUNNING:", script:GetFullName())

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

local function getCurrentTasks()
	return TaskConfig.GetTasksForScene(currentScene)
end

local function isTaskMenuOpen()
	return mainFrame.Visible
end

local function setTaskMenuOpen(isOpen)
	mainFrame.Visible = isOpen
end

local function isAnotherGuiOpen()
	local chatIsOpen = aiChatGui.Enabled and chatFrame and chatFrame.Visible
	local dialogueIsOpen = dialogueGui.Enabled and dialogueBar and dialogueBar.Visible
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
	if task.Type == "Optional" then
		titleText ..= " (Optional)"
	end

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
		print("Task menu blocked because another GUI is open")
		return
	end

	print("Opening task menu...")
	print("mainFrame before:", mainFrame.Visible)

	setTaskMenuOpen(true)

	print("mainFrame after:", mainFrame.Visible)

	GuiMouseManager.OpenGui()
	GuiMovementManager.Lock()
end

local function refreshTaskUI()
	local tasks = getCurrentTasks()

	print("Refreshing task UI. Scene:", currentScene, "Task count:", #tasks)

	populateTaskList()
	selectedTask = getDefaultTask()
	updatePinnedTracker(selectedTask)
end

local function setScene(sceneNumber)
	currentScene = sceneNumber or 1
	refreshTaskUI()
end

tasksOpenButton.MouseButton1Click:Connect(openTaskMenu)
exitTaskMenu.MouseButton1Click:Connect(closeTaskMenu)

TaskUpdated.OnClientEvent:Connect(function(taskId, sceneNumber)
	if sceneNumber and sceneNumber ~= currentScene then
		return
	end

	local success = TaskConfig.MarkTaskComplete(taskId, currentScene)
	if not success then
		warn("Task not found for current scene:", taskId, currentScene)
		return
	end

	refreshTaskUI()
end)

player:GetAttributeChangedSignal("Scene"):Connect(function()
	currentScene = player:GetAttribute("Scene") or 1
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

task.wait()
currentScene = player:GetAttribute("Scene") or 1
tasksGui.Enabled = true
tasksOpenButton.Visible = true

refreshTaskUI()

return {
	SetScene = setScene,
	Refresh = refreshTaskUI,
}