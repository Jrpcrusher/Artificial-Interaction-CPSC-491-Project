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
