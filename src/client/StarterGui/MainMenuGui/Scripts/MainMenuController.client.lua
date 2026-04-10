local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GuiMouseManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMouseManager)

local SaveRemotes = ReplicatedStorage.Remotes:WaitForChild("Save")
local SaveDataRequest = SaveRemotes:WaitForChild("SaveDataRequest")
local SaveDataResponse = SaveRemotes:WaitForChild("SaveDataResponse")
local StartNewGame = SaveRemotes:WaitForChild("StartNewGame")
local ContinueGameRemote = SaveRemotes:WaitForChild("ContinueGame")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local scriptsFolder = script.Parent
local menuGui = scriptsFolder.Parent

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
local yesBtn = warningFrame:WaitForChild("YesButton", 5)
local noBtn = warningFrame:WaitForChild("NoButton", 5)
local warningText = warningFrame:WaitForChild("WarningText", 5)

local aiChatGui = playerGui:WaitForChild("AIChatGui", 5)
local taskGui = playerGui:WaitForChild("Tasks", 5)

-- Main menu owns startup visibility
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

local function freezePlayer(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
end

if player.Character then
	freezePlayer(player.Character)
end

player.CharacterAdded:Connect(freezePlayer)

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

creditsBtn.MouseButton1Click:Connect(function()
	credFrame.Visible = true
end)

closeCredBtn.MouseButton1Click:Connect(function()
	credFrame.Visible = false
end)

local function transitionToGame()
	playBtn.Active = false
	newGameBtn.Active = false
	continueBtn.Active = false
	creditsBtn.Active = false

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local linearTransition = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
	TweenService:Create(background, tweenInfo, { BackgroundTransparency = 1 }):Play()

	for _, child in pairs(background:GetDescendants()) do
		if child:IsA("TextLabel") or child:IsA("TextButton") then
			TweenService:Create(child, tweenInfo, { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
		elseif child:IsA("Frame") and child.Name ~= "CreditsFrame" and child.Name ~= "OverwriteWarningFrame" then
			TweenService:Create(child, tweenInfo, { BackgroundTransparency = 1 }):Play()
		elseif child:IsA("ImageLabel") then
			TweenService:Create(child, tweenInfo, { ImageTransparency = 1 }):Play()
			task.wait(2)
			TweenService:Create(child, linearTransition, { BackgroundTransparency = 1 }):Play()
		end
	end

	task.wait(1)

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
	menuGui:Destroy()
end

local function startNewGame()
	StartNewGame:FireServer()
	transitionToGame()
end

local function continueGame()
	ContinueGameRemote:FireServer()
	transitionToGame()
end

newGameBtn.MouseButton1Click:Connect(function()
	if playerHasSaveData then
		warningText.Text = "Do you wish to override last save?\n(Current Progress: " .. currentSavedScene .. ")"
		warningFrame.Visible = true
	else
		startNewGame()
	end
end)

yesBtn.MouseButton1Click:Connect(function()
	warningFrame.Visible = false
	startNewGame()
end)

noBtn.MouseButton1Click:Connect(function()
	warningFrame.Visible = false
end)

continueBtn.MouseButton1Click:Connect(function()
	if playerHasSaveData then
		continueGame()
	else
		print("No save file detected. Click play.")
	end
end)

playBtn.MouseButton1Click:Connect(function()
	if playerHasSaveData then
		continueGame()
	else
		startNewGame()
	end
end)
