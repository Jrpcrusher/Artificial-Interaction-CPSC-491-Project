local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GuiMouseManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMouseManager)

local SaveRemotes = ReplicatedStorage.Remotes:WaitForChild("Save")
local SaveDataRequest = SaveRemotes:WaitForChild("SaveDataRequest")
local SaveDataResponse = SaveRemotes:WaitForChild("SaveDataResponse")
local StartNewGame = SaveRemotes:WaitForChild("StartNewGame")
local ContinueGameRemote = SaveRemotes:WaitForChild("ContinueGame")

local EndingRemotes = ReplicatedStorage.Remotes:WaitForChild("Ending")
local ShowMainMenu = EndingRemotes:WaitForChild("ShowMainMenu")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local scriptsFolder = script.Parent
local menuGui = scriptsFolder.Parent
local flickerActive = true

local background = menuGui:WaitForChild("BackgroundFrame", 5)
if not background then
	warn("CRITICAL ERROR: 'BackgroundFrame' is missing.")
	return
end

GuiMouseManager.OpenGui()

local buttonHolder = background:WaitForChild("ButtonHolder", 5)
local playBtn = buttonHolder:WaitForChild("PlayButton", 5)
local newGameBtn = buttonHolder:WaitForChild("NewGameButton", 5)
local continueBtn = buttonHolder:WaitForChild("ContinueButton", 5)
local creditsBtn = buttonHolder:WaitForChild("CreditsButton", 5)

local credFrame = background:WaitForChild("CreditsFrame", 5)
local closeCredBtn = credFrame:WaitForChild("CloseCredits", 5)

local warningFrame = background:WaitForChild("OverwriteWarningFrame", 5)
local backgroundImage = background:WaitForChild("ImageLabel")
local lightObj = backgroundImage:WaitForChild("LightGlow")
local yesBtn = warningFrame:WaitForChild("YesButton", 5)
local noBtn = warningFrame:WaitForChild("NoButton", 5)
local warningText = warningFrame:WaitForChild("WarningText", 5)

local aiChatGui = playerGui:WaitForChild("AIChatGui", 5)
local taskGui = playerGui:WaitForChild("Tasks", 5)

local ButtonHover = SoundService:WaitForChild("ButtonHover")
local ButtonClick = SoundService:WaitForChild("ButtonClick")
local MainMenuSound = SoundService:WaitForChild("MainMenuSoundTrack")

-- Main menu owns startup visibility
MainMenuSound:Play() -- Play the main menu sound

if aiChatGui then
	aiChatGui.Enabled = false
end

if taskGui then
	taskGui.Enabled = false
end

local playerHasSaveData = false
local currentSavedScene = "Scene 1"

local function updateContinueButton()
	continueBtn.Visible = true
	if playerHasSaveData then
		continueBtn.Active = true
		continueBtn.TextTransparency = 0
	else
		continueBtn.Active = false
		continueBtn.TextTransparency = 0.9
	end
end

SaveDataResponse.OnClientEvent:Connect(function(hasSave, sceneNumber)
	playerHasSaveData = hasSave
	currentSavedScene = "Scene " .. tostring(sceneNumber)
	updateContinueButton()
end)

updateContinueButton()
SaveDataRequest:FireServer()

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

creditsBtn.MouseButton1Click:Connect(function()
	ButtonClick:Play()
	credFrame.Visible = true
end)

closeCredBtn.MouseButton1Click:Connect(function()
	ButtonClick:Play()
	credFrame.Visible = false
end)

local function transitionToGame()
	flickerActive = false
	playBtn.Active = false
	newGameBtn.Active = false
	continueBtn.Active = false
	creditsBtn.Active = false

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local linearTransition = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

	TweenService:Create(background, tweenInfo, { BackgroundTransparency = 1 }):Play()

	for _, child in pairs(background:GetDescendants()) do
		if child:IsA("TextLabel") or child:IsA("TextButton") then
			TweenService:Create(child, tweenInfo, {
				TextTransparency = 1,
				BackgroundTransparency = 1,
			}):Play()
		elseif child:IsA("Frame") and child.Name ~= "CreditsFrame" and child.Name ~= "OverwriteWarningFrame" then
			TweenService:Create(child, tweenInfo, {
				BackgroundTransparency = 1,
			}):Play()
		elseif child:IsA("ImageLabel") then
			TweenService:Create(child, tweenInfo, {
				ImageTransparency = 1,
				BackgroundTransparency = 1,
			}):Play()
		end
	end

	TweenService:Create(MainMenuSound, linearTransition, { Volume = 0 }):Play()

	task.wait(1.2)

	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 0
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
	end

	if taskGui then
		taskGui.Enabled = true
	end

	GuiMouseManager.CloseGui()
	menuGui.Enabled = false
end

local function startNewGame()
	StartNewGame:FireServer()
	transitionToGame()
end

local function continueGame()
	ContinueGameRemote:FireServer()
	transitionToGame()
end

local function flickerLight(lightObj)
	local baseSize = lightObj.Size
	local basePos = lightObj.Position

	task.spawn(function()
		while flickerActive and lightObj and lightObj.Parent do
			lightObj.ImageTransparency = 0.35 + math.random() * 0.2

			local sizeOffset = math.random(-2, 2)
			lightObj.Size = UDim2.new(
				baseSize.X.Scale,
				baseSize.X.Offset + sizeOffset,
				baseSize.Y.Scale,
				baseSize.Y.Offset + sizeOffset
			)

			local posOffsetX = math.random(-1, 1)
			local posOffsetY = math.random(-1, 1)
			lightObj.Position = UDim2.new(
				basePos.X.Scale,
				basePos.X.Offset + posOffsetX,
				basePos.Y.Scale,
				basePos.Y.Offset + posOffsetY
			)

			task.wait(math.random(4, 10) / 100)
		end

		lightObj.Size = baseSize
		lightObj.Position = basePos
	end)
end

flickerLight(lightObj)

for _, child in pairs(menuGui:GetDescendants()) do -- Do animation of the buttons
	if child:IsA("TextButton") then
		local originalSize = child.Size
		local hoverSize = originalSize + UDim2.new(0, 10, 0, 4)

		child.MouseEnter:Connect(function()
			ButtonHover:Play()
			TweenService:Create(child, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(235, 235, 235),
				Size = hoverSize,
			}):Play()
		end)

		child.MouseLeave:Connect(function()
			TweenService:Create(child, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				Size = originalSize,
			}):Play()
		end)
	end
end

newGameBtn.MouseButton1Click:Connect(function()
	ButtonClick:Play()
	if playerHasSaveData then
		warningText.Text = "Do you wish to override last save?\n(Current Progress: " .. currentSavedScene .. ")"
		warningFrame.Visible = true
	else
		startNewGame()
	end
end)

yesBtn.MouseButton1Click:Connect(function()
	ButtonClick:Play()
	warningFrame.Visible = false
	startNewGame()
end)

noBtn.MouseButton1Click:Connect(function()
	ButtonClick:Play()
	warningFrame.Visible = false
end)

continueBtn.MouseButton1Click:Connect(function()
	ButtonClick:Play()
	if playerHasSaveData then
		continueGame()
	else
		print("No save file detected. Click play.")
	end
end)

playBtn.MouseButton1Click:Connect(function()
	ButtonClick:Play()
	if playerHasSaveData then
		continueGame()
	else
		startNewGame()
	end
end)

ShowMainMenu.OnClientEvent:Connect(function()
    -- Re-enable the main menu GUI
    menuGui.Enabled = true

    -- Restore menu visibility state
    background.BackgroundTransparency = 0
    for _, child in pairs(background:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child.TextTransparency = 0
            child.BackgroundTransparency = 0
        elseif child:IsA("Frame") and child.Name ~= "CreditsFrame" and child.Name ~= "OverwriteWarningFrame" then
            child.BackgroundTransparency = 0
        end
    end

    -- Disable gameplay UI
    if aiChatGui then
		aiChatGui.Enabled = false
	end
    
	if taskGui then
		taskGui.Enabled = false
	end

    -- Freeze player again
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        end
    end

    -- Re-enable mouse GUI mode
    GuiMouseManager.OpenGui()

    -- Refresh save data
    SaveDataRequest:FireServer()
end)