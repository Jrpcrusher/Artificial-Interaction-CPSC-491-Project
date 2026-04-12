local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local EndingFolder = Remotes:WaitForChild("Ending")
local ShowEndingTraits = EndingFolder:WaitForChild("ShowEndingTraits")

--[[Required]]
local GuiMouseManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMouseManager)
local GuiMovementManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMovementManager)

-- [[References to UI Elements]]
local scriptsFolder = script.Parent
local gui = scriptsFolder.Parent

local background = gui:WaitForChild("BackgroundFrame", 5)
local traitList = gui:WaitForChild("TraitListFrame", 5)
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
