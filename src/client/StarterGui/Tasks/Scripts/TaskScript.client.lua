local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local TaskConfig = require(Shared:WaitForChild("TaskConfig"))
local TaskUpdated = Shared:WaitForChild("TaskUpdated")

local tasksGui = playerGui:WaitForChild("Tasks")

-- Left pinned tracker
local tasksOpenButton = tasksGui:WaitForChild("TasksOpenButton")
local taskFrame = tasksOpenButton:WaitForChild("Task")
local finishedTaskFrame = tasksOpenButton:WaitForChild("FinishedTask")

local taskObjectiveLabel = taskFrame:WaitForChild("TaskObjective")
local taskStepsLabel = taskFrame:WaitForChild("TaskSteps")
local taskBulletPointSpace = taskFrame:WaitForChild("BulletPointSpace")
local taskBulletPointBullet = taskFrame:WaitForChild("BulletPointBullet")

local finishedTaskObjectiveLabel = finishedTaskFrame:WaitForChild("TaskObjective")
local finishedTaskBulletPoint = finishedTaskFrame:WaitForChild("BulletPoint")
-- Full menu
local openTasks = tasksGui:WaitForChild("OpenTasks")
local frameCanvas = openTasks:WaitForChild("FrameCanvas")
local mainFrame = frameCanvas:WaitForChild("Main")
local listFrame = mainFrame:WaitForChild("List")
local exitTaskMenu = mainFrame:WaitForChild("ExitTaskMenu")

local template = listFrame:WaitForChild("Template")
local completedTemplate = listFrame:WaitForChild("CompletedTemplate")

template.Visible = false
completedTemplate.Visible = false

openTasks.Enabled = false
tasksOpenButton.Visible = true

local selectedTask = nil

print("Tasks loaded:")

for _, task in ipairs(TaskConfig.Tasks) do
	print(task.Title, task.Objective)
end

local function clearGeneratedEntries()
	for _, child in ipairs(listFrame:GetChildren()) do
		if child ~= template
			and child ~= completedTemplate
			and not child:IsA("UIListLayout")
			and not child:IsA("UIPadding")
			and not child:IsA("UICorner") then

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
	finishedTaskObjectiveLabel.TextColor3 = Color3.fromRGB(85, 255, 127) -- green

	if finishedTaskBulletPoint:IsA("TextLabel") then
		finishedTaskBulletPoint.Text = "✓"
	end
	else
		taskFrame.Visible = true
		finishedTaskFrame.Visible = false
		taskObjectiveLabel.Text = task.Objective
		taskStepsLabel.Text = task.Steps

		if taskBulletPointBullet:IsA("TextLabel") then
			taskBulletPointBullet.Text = "□"
		end
	end
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
			openTasks.Enabled = false
		end
	end)
end

local function populateTaskList()
	clearGeneratedEntries()

	for _, task in ipairs(TaskConfig.Tasks) do
		buildTaskEntry(task)
	end
end

local function getDefaultTask()
	for _, task in ipairs(TaskConfig.Tasks) do
		if not task.Completed and task.Type == "Required" then
			return task
		end
	end

	for _, task in ipairs(TaskConfig.Tasks) do
		if not task.Completed then
			return task
		end
	end

	return TaskConfig.Tasks[1]
end

tasksOpenButton.MouseButton1Click:Connect(function()
	openTasks.Enabled = true
end)

exitTaskMenu.MouseButton1Click:Connect(function()
	openTasks.Enabled = false
end)

populateTaskList()

selectedTask = getDefaultTask()
updatePinnedTracker(selectedTask)

TaskUpdated.OnClientEvent:Connect(function(taskId)
	for _, task in ipairs(TaskConfig.Tasks) do
		if task.Id == taskId then
			task.Completed = true
			break
		end
	end

	populateTaskList()
	selectedTask = getDefaultTask()
	updatePinnedTracker(selectedTask)
end)