local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LoadingGui = script.Parent.Parent
local MainFrame = LoadingGui.Frame
local MainMenu = script.Parent.Parent.Parent.MainMenuGui

local Text = MainFrame.TextLabel
local LoadingBar = MainFrame.LoadingBarOutline.LoadingBar
local Phone = MainFrame.Phone
local JrpGfxImage = MainFrame.JrpGfxImage

local sineStyle = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local elasticStyle = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local textFade = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local logoFade = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local goal = { Rotation = 360 }
local fadeOut = TweenService:Create(Text, textFade, { TextTransparency = 1 })
local fadeIn = TweenService:Create(Text, textFade, { TextTransparency = 0 })

local loadingSound = SoundService:WaitForChild("FemaleSound")

function playLoadingScreen() -- Play the loading screen
	MainMenu.Enabled = false -- Initialize main menu enabled to be false
	local i = 0
	task.wait(0.5)
	while i < 4 do
		i = i + 1
		TweenService:Create(Phone, elasticStyle, goal):Play()
		TweenService:Create(LoadingBar, sineStyle, { Size = UDim2.new(0, 398, 0, 28) }):Play()

		Phone.Rotation = 0
		if Phone.Rotation == 0 then
			loadingSound:Play()
		end
		if i == 1 then
			Text.Text = "Loading Assets ."
			task.wait(0.5)
			Text.Text = "Loading Assets . ."
			task.wait(0.5)
			Text.Text = "Loading Assets . . ."
			task.wait(0.5)
			continue
		end
		if i == 2 then
			Text.Text = "Loading AI Chatbot ."
			task.wait(0.5)
			Text.Text = "Loading AI Chatbot . ."
			task.wait(0.5)
			Text.Text = "Loading AI Chatbot . . ."
			task.wait(0.5)
			continue
		end
		if i == 3 then
			Text.Text = "Loading Interfaces ."
			task.wait(0.5)
			Text.Text = "Loading Interfaces . ."
			task.wait(0.5)
			Text.Text = "Loading Interfaces . . ."
			task.wait(0.5)
			continue
		end
		task.wait(1)
	end

	fadeOut:Play()
	fadeOut.Completed:Wait()
	Text.Text = "Loading successful, please enjoy the game!"
	fadeIn:Play()
	task.wait(1)
end

function fadeLoadingScreen() -- Will fade out the loading screen
	for _, obj in MainFrame:GetDescendants() do
		if obj:IsA("Frame") and obj.Name ~= "Frame" then
			TweenService:Create(obj, textFade, { BackgroundTransparency = 1 }):Play()
		elseif obj:IsA("TextLabel") then
			TweenService:Create(obj, textFade, {
				TextTransparency = 1,
				BackgroundTransparency = 1,
			}):Play()
		elseif obj:IsA("ImageLabel") then
			TweenService:Create(obj, textFade, {
				ImageTransparency = 1,
				BackgroundTransparency = 1,
			}):Play()
		end
	end
end

function fadeInJrpGfxLogo()
	task.wait(3)
	Text.Text = "Presents . . ."

	local imageTween = TweenService:Create(JrpGfxImage, logoFade, { ImageTransparency = 0 })
	local textTween = TweenService:Create(Text, logoFade, { TextTransparency = 0 })

	imageTween:Play()
	textTween:Play()

	imageTween.Completed:Wait()
	task.wait(0.75)
	MainMenu.Enabled = true -- Initialize main menu enabled to be false
	LoadingGui.Enabled = false
end

-- playLoadingScreen()
-- fadeLoadingScreen()
-- fadeInJrpGfxLogo()
