local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local scriptsFolder = script.Parent
local menuGui = scriptsFolder.Parent

local background = menuGui:WaitForChild("BackgroundFrame", 5)
if not background then 
    warn("CRITICAL ERROR: 'BackgroundFrame' is missing.")
    return 
end

-- REFERENCES: MAIN MENU BUTTONS
local buttonHolder = background:WaitForChild("ButtonHolder", 5)
local playBtn = buttonHolder:WaitForChild("PlayButton", 5)
local newGameBtn = buttonHolder:WaitForChild("NewGameButton", 5)
local continueBtn = buttonHolder:WaitForChild("ContinueButton", 5)
local creditsBtn = buttonHolder:WaitForChild("CreditsButton", 5)

-- REFERENCES: CREDITS & WARNING POPUP 
local credFrame = background:WaitForChild("CreditsFrame", 5)
local closeCredBtn = credFrame:WaitForChild("CloseCredits", 5)

local warningFrame = background:WaitForChild("OverwriteWarningFrame", 5)
local yesBtn = warningFrame:WaitForChild("YesButton", 5)
local noBtn = warningFrame:WaitForChild("NoButton", 5)
local warningText = warningFrame:WaitForChild("WarningText", 5)

local aiChatGui = playerGui:WaitForChild("AIChatGui", 5)

-- BACKEND HANDSHAKE
local playerHasSaveData = true 
local currentSavedScene = "Scene 2" 

-- FREEZE PLAYER ON JOIN
local function freezePlayer(player)
	local humanoid = player:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0

	-- Prevents jumping animation entirely.
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
end

if player.Character then
	freezePlayer(player.Character)
end

player.CharacterAdded:Connect(freezePlayer)

-- HIDE DEFAULT ROBLOX UI
pcall(function() 
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) 
end)

-- MENU LOGIC & STATE CHECKS

if not playerHasSaveData then
    continueBtn.Active = false
    continueBtn.TextTransparency = 0.6 
end

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
    TweenService:Create(background, tweenInfo, {BackgroundTransparency = 1}):Play()
    
    for _, child in pairs(background:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            TweenService:Create(child, tweenInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        elseif child:IsA("Frame") and child.Name ~= "CreditsFrame" and child.Name ~= "OverwriteWarningFrame" then
            TweenService:Create(child, tweenInfo, {BackgroundTransparency = 1}):Play()
        end
    end
    
    task.wait(1)
    
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50

		-- Re-enables jumping animations.
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
	end
    
    if aiChatGui then 
        aiChatGui.Enabled = true 
    end
    
    menuGui:Destroy()
end

local function startNewGame()
    print("Backend Alert: Wiping old save data.")
    transitionToGame()
end

local function continueGame()
    print("Backend Alert: Loading existing save data.")
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
    end
end)

playBtn.MouseButton1Click:Connect(function() 
    continueGame() 
end)