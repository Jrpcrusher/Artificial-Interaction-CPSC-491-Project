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

-----------------------------------------------------------------------------------
-- Additional Remotes for Save System Integration with Main Menu
-----------------------------------------------------------------------------------
local function getOrCreateRemote(name: string)
	local remote = ReplicatedStorage.Remotes:FindFirstChild(name) -- Checks if the remote event is in the Remotes folder of Replicated Storage.
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = ReplicatedStorage.Remotes
	end

	return remote
end

local SavaDataRequest = getOrCreateRemote("SaveDataRequest")
local SaveDataResponse = getOrCreateRemote("SaveDataResponse")
local StartNewGame = getOrCreateRemote("StartNewGame")
local ContinueGame = getOrCreateRemote("ContinueGame")
-----------------------------------------------------------------------------------
-- Remotes Setup End
-----------------------------------------------------------------------------------

-- Now safe to require modules that depend on TaskUpdated
local Progression = require(ReplicatedStorage.Shared.ProgressionManager) -- Module to keep track of the progression in the story
local TranscriptManager = require(ReplicatedStorage.Shared.TranscriptManager)
local InteractionHandler = require(ReplicatedStorage.Shared.InteractionHandler) -- keeps track of interaction
local GameSaveManager = require(ReplicatedStorage.Shared.GameSaveManager)
local Scenes = require(ReplicatedStorage.Shared.SceneManager)

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
-- Section 2: Check for save data
-----------------------------------------------------------------------------------
SavaDataRequest.OnServerEvent:Connect(function(player)
	local user_id = player.UserId
	local loadedScene = GameSaveManager.Load(user_id)

	local hasSave = loadedScene ~= nil	-- Stores scene number or has value of nil if there is no save.
	local sceneNumber = loadedScene or 1 -- Returns stored scene number or scene 1 if there is no save.

	SaveDataResponse:FireClient(player, hasSave, sceneNumber)
end)
-----------------------------------------------------------------------------------
-- Section 2: End
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 3: Load the scene based on save state
-----------------------------------------------------------------------------------
-- Client chose "New Game"
StartNewGame.OnServerEvent:Connect(function(player)
	local user_id = player.UserId

	-- Deletes save and resets transcripts and progression regardless of whether the
	-- player is playing for the first time or is starting a new game after a playthrough.
	GameSaveManager.Delete(user_id)
	TranscriptManager.Delete(user_id)
	Progression.Reset()
	TranscriptManager.Create(user_id)

	local ok, msg = Scenes.LoadScene(player, 1)
	if not ok then 
		warn("Failed to load new game scene:", msg)
	end
end)

-- Client chose "Continue"
ContinueGame.OnServerEvent:Connect(function(player)
	local user_id = player.UserId

	local loadedScene = GameSaveManager.Load(user_id)
	local sceneNumber = loadedScene or 1	-- Scene Number is 1 if the retrieval of the saved scene number fails.

	Progression.Set(user_id)
	player:SetAttribute("Scene", sceneNumber)	-- Sets the live state of the player's current save. Required for SceneDoorController.
	-- TO-DO: Load transcript which will be then be loaded onto AI Chat GUI.

	local ok, msg = Scenes.LoadScene(player, sceneNumber)
	if not ok then
		warn ("Failed to load continue scene:", msg)
	end
end)
-----------------------------------------------------------------------------------
-- Section 3: End
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
-- Section 4: On user disconnect
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 4: End
-----------------------------------------------------------------------------------