local Players = game:GetService("Players")
local gui = script.Parent

-- Grab References to the Objects created
local background = gui:WaitForChild("BackgroundFrame")
local buttonHolder = background:WaitForChild("ButtonHolder")
local playButton = buttonHolder:WaitForChild("PlayButton")
local creditsButton = buttonHolder:WaitForChild("CreditsButton")

local creditsFrame = background:WaitForChild("CreditsFrame")
local closeCreditsBtn = creditsFrame:WaitForChild("CloseCredits")

-- Play Button Logic
-- Simple fade out effect [Other Option can be set Visible to false]
playButton.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

-- Open Credits Logic
creditsButton.MouseButton1Click:Connect(function()
	creditsFrame.Visible = true
	buttonHolder.Visible = false -- Hide the main buttons
end)

-- Close Credits Logic
closeCreditsBtn.MouseButton1Click:Connect(function()
	creditsFrame.Visible = false
	buttonHolder.Visible = true -- Show the main buttons again
end)