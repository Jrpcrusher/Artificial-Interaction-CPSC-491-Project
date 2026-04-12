local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local Text = script.Parent.Parent.Frame.TextLabel
local LoadingBar = script.Parent.Parent.Frame.LoadingBar
local Phone = script.Parent.Parent.Frame.Phone
local MainFrame = script.Parent.Parent.Frame
local JrpGfxImage = script.Parent.Parent.Frame.JrpGfxImage
local LoadingGui = script.Parent.Parent.Parent.LoadingGui

local sineStyle = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local elasticStyle = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local textFade = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local goal = { Rotation = 360 }
local fadeOut = TweenService:Create(Text, textFade, { TextTransparency = 1 })
local fadeIn = TweenService:Create(Text, textFade, { TextTransparency = 0 })

local loadingSound = SoundService.LoadingSound

function playLoadingScreen() -- Play the loading screen
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
		elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
			TweenService:Create(obj, textFade, {
				ImageTransparency = 1,
				BackgroundTransparency = 1,
			}):Play()
		end
	end
end

function fadeInJrpGfxLogo()
	task.wait(3)
	TweenService:Create(JrpGfxImage, textFade, { ImageTransparency = 0 }):Play()
	Text.Text = "Presents . . ."
	fadeIn:Play()
	task.wait(3)
	LoadingGui.Enabled = false
end

playLoadingScreen()
fadeLoadingScreen()
fadeInJrpGfxLogo()
