local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TransitionEvent = ReplicatedStorage:WaitForChild("TransitionEvent") -- Trigger the transition screen gui

local TransitionGui = script.Parent.Parent
local MainFrame = TransitionGui.Frame

local Text = MainFrame.TextLabel
local Phone = MainFrame.Phone

local elasticStyle = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local textFade = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local goal = { Rotation = 360 }
local fadeOut = TweenService:Create(Text, textFade, { TextTransparency = 1 })
local fadeIn = TweenService:Create(Text, textFade, { TextTransparency = 0 })

local loadingSound = SoundService.FemaleSound

local function fadeObject(obj, value)
	if obj:IsA("Frame") then
		TweenService:Create(obj, textFade, {
			BackgroundTransparency = value,
		}):Play()
	elseif obj:IsA("TextLabel") then
		TweenService:Create(obj, textFade, {
			TextTransparency = value,
		}):Play()
	elseif obj:IsA("ImageLabel") then
		TweenService:Create(obj, textFade, {
			ImageTransparency = value,
		}):Play()
	end
end

local function playTransition()
	TransitionGui.Enabled = true
	local i = 0
	fadeObject(MainFrame, 0)
	for _, obj in ipairs(MainFrame:GetDescendants()) do
		fadeObject(obj, 0)
	end
	task.wait(0.5)
	while i < 4 do
		i = i + 1
		TweenService:Create(Phone, elasticStyle, goal):Play()

		Phone.Rotation = 0
		if Phone.Rotation == 0 then
			loadingSound:Play()
		end
		Text.Text = "Loading Scene ."
		task.wait(0.35)
		Text.Text = "Loading Scene . ."
		task.wait(0.35)
		Text.Text = "Loading Scene . . ."
		task.wait(0.35)
	end
	fadeOut:Play()
	fadeOut.Completed:Wait()
	Text.Text = "Loading successful."
	fadeIn:Play()
	task.wait(0.15)

	fadeObject(MainFrame, 1)

	for _, obj in ipairs(MainFrame:GetDescendants()) do
		fadeObject(obj, 1)
	end
end

TransitionEvent.OnClientEvent:Connect(function()
	playTransition()
    task.wait(1)
	TransitionGui.Enabled = false
end)
