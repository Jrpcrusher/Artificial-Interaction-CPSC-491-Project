local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local EndingFolder = Remotes:WaitForChild("Ending")
local ShowEndingTraits = EndingFolder:WaitForChild("ShowEndingTraits")
local ReturnToMainMenu = EndingFolder:WaitForChild("ReturnToMainMenu")

--[[Required]]
local GuiMouseManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMouseManager)
local GuiMovementManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMovementManager)

-- [[References to UI Elements]]
local scriptsFolder = script.Parent
local gui = scriptsFolder.Parent

local background = gui:WaitForChild("BackgroundFrame", 5)
local traitList = background:WaitForChild("TraitListFrame", 5)
local template = traitList:WaitForChild("TraitTemplate", 5)
local returnButton = background:WaitForChild("ReturnButton", 5)

-- Hide UI initially.
gui.Enabled = false

-- Clear old trait labels (if trait labels are there from previous playthrough)
local function clearTraits()
	for _, child in ipairs(traitList:GetChildren()) do
		if child:IsA("TextLabel") and child ~= template then
			child:Destroy()
		end
	end
end

-- Populate trait list
local function populateTraits(traits)
	clearTraits()

	for _, trait in ipairs(traits) do
		local label = template:Clone()
		label.Visible = true
		label.Text = "- " .. trait
		label.Parent = traitList
	end
end

-- Server triggers this when story ends
ShowEndingTraits.OnClientEvent:Connect(function(traits)
	populateTraits(traits)
	gui.Enabled = true
    GuiMouseManager.OpenGui()
    GuiMovementManager.Lock()
end)

-- Return to main menu button behavior
returnButton.MouseButton1Click:Connect(function()
    gui.Enabled = false
    GuiMouseManager.CloseGui()
    
    -- Put unlock here to hopefully prevent any movement issues when starting a new game from the main menu
    -- Movement is frozen once entering the main menu anyways
    GuiMovementManager.Unlock()

    -- Tell the server the player wants to return to the main menu
    ReturnToMainMenu:FireServer()
end)