-- Initial file to set everything up for the user
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-----------------------------------------------------------------------------------
-- Create TaskUpdated RemoteEvent FIRST before any require()
-- InteractionHandler and TaskScript both WaitForChild("TaskUpdated")
-- so it must exist before those modules are loaded
-----------------------------------------------------------------------------------
local TaskUpdated = ReplicatedStorage.Shared:FindFirstChild("TaskUpdated")
if not TaskUpdated then
	TaskUpdated = Instance.new("RemoteEvent")
	TaskUpdated.Name = "TaskUpdated"
	TaskUpdated.Parent = ReplicatedStorage.Shared
end
-----------------------------------------------------------------------------------
-- TaskUpdated: End
-----------------------------------------------------------------------------------

-- Now safe to require modules that depend on TaskUpdated
local Progression = require(ReplicatedStorage.Shared.ProgressionManager) -- Module to keep track of the progression in the story
local TranscriptManager = require(ReplicatedStorage.Shared.TranscriptManager)
local InteractionHandler = require(ReplicatedStorage.Shared.InteractionHandler) -- keeps track of interaction

-----------------------------------------------------------------------------------
-- Interaction setup
-----------------------------------------------------------------------------------
local function connectPrompt(prompt)
	prompt.Triggered:Connect(function(player) -- when player presses E
		local interactable = prompt:FindFirstAncestorOfClass("Model") or prompt.Parent -- finds 1st proxprompt in model

		if interactable then
			InteractionHandler.HandleInteraction(player, interactable) -- call interactionhandler script
		end
	end)
end

local function setupInteractionPrompts() -- connects every proximityprompt to system
	for _, obj in ipairs(workspace:GetDescendants()) do -- Looks through entire world and finds every ProximityPrompt
		if obj:IsA("ProximityPrompt") then
			connectPrompt(obj) -- attaches the behavior to the prompt
		end
	end

	-- Also catch any prompts added after server start
	workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("ProximityPrompt") then
			connectPrompt(obj)
		end
	end)
end
-----------------------------------------------------------------------------------
-- Interaction setup: End
-----------------------------------------------------------------------------------

-- Wire up prompts immediately when server starts, before any player joins
setupInteractionPrompts()

-----------------------------------------------------------------------------------
-- Section 1: Player join handling
-----------------------------------------------------------------------------------
local function onPlayerAdded(player)
	local user_id = player.UserId
	local _, message = TranscriptManager.Create(user_id)
	print(message)

	-----------------------------------------------------------------------------------
	-- Section 2: GUI logic for main menu
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	-- Section 2: End
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	-- Section 3: Load the scene based on save state
	-----------------------------------------------------------------------------------
	local newGame = true -- Temporary variable, remove this later

	if newGame then
		Progression.Reset()
		-- Todo: add method to reset the chat messages between the user and AI
		-- Todo: Make method to update datastoreservice to remove the information of the previous save
	else
		local _game_state = Progression.Get()
		--Scenes.Load(game_state)
	end
	-----------------------------------------------------------------------------------
	-- Section 3: End
	-----------------------------------------------------------------------------------
end

-- Handle all future players
Players.PlayerAdded:Connect(onPlayerAdded)

-- Handle anyone already in-game when this script runs (Studio edge case)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
-----------------------------------------------------------------------------------
-- Section 1: End
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 4: On user disconnect
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 4: End
-----------------------------------------------------------------------------------