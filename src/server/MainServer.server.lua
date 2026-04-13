local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local function getOrCreateFolder(parent, name)
	local folder = parent:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end
	return folder
end

local function getOrCreateRemote(parent, name)
	local remote = parent:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = parent
	end
	return remote
end

local SaveFolder = getOrCreateFolder(Remotes, "Save")
local TaskFolder = getOrCreateFolder(Remotes, "Tasks")
local DialogueFolder = getOrCreateFolder(Remotes, "Dialogue")
local ChatFolder = getOrCreateFolder(Remotes, "Chat")
local EndingFolder = getOrCreateFolder(Remotes, "Ending")

local SaveDataRequest = getOrCreateRemote(SaveFolder, "SaveDataRequest")
local SaveDataResponse = getOrCreateRemote(SaveFolder, "SaveDataResponse")
local StartNewGame = getOrCreateRemote(SaveFolder, "StartNewGame")
local ContinueGame = getOrCreateRemote(SaveFolder, "ContinueGame")

local StoryCompleted = getOrCreateRemote(EndingFolder, "StoryCompleted")
local ShowEndingTraits = getOrCreateRemote(EndingFolder, "ShowEndingTraits")
local ReturnToMenu = getOrCreateRemote(EndingFolder, "ReturnToMenu")
local ShowMainMenu = getOrCreateRemote(EndingFolder, "ShowMainMenu")

local TaskUpdated = getOrCreateRemote(TaskFolder, "TaskUpdated")
local StartDialogue = getOrCreateRemote(DialogueFolder, "StartDialogue")
local ChatbotRequest = getOrCreateRemote(ChatFolder, "ChatbotRequest")
local ChatbotResponse = getOrCreateRemote(ChatFolder, "ChatbotResponse")

local Progression = require(ReplicatedStorage.Shared.Systems.Progression.ProgressionManager)
local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)
local InteractionHandler = require(ReplicatedStorage.Shared.Utils.Interaction.InteractionHandler)
local GameSaveManager = require(ReplicatedStorage.Shared.Systems.Save.GameSaveManager)
local Scenes = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local TraitAnalyzer = require(ReplicatedStorage.Shared.Utils.Chat.TraitAnalyzer)
local TraitStore = require(ReplicatedStorage.Shared.Utils.Chat.TraitStore)

local FINAL_PROGRESS = 16  -- Used to check if the player has reached the final scene before showing them their traits.

local function handleStoryCompletion(player)
    local userId = player.UserId

    -- Extract traits once at the end of the story
    local traits = TraitAnalyzer.ExtractTraits(userId)
    TraitStore.Set(userId, traits)

    -- Fire the ending UI to the client
    ShowEndingTraits:FireClient(player, traits)

    print("Story completed for", player.Name, "Traits generated:", #traits)
end

local function connectPrompt(prompt)
	prompt.Triggered:Connect(function(player)
		local interactable = prompt:FindFirstAncestorOfClass("Model") or prompt.Parent
		if interactable then
			InteractionHandler.HandleInteraction(player, interactable)
		end
	end)
end

local function setupInteractionPrompts()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			connectPrompt(obj)
		end
	end

	workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("ProximityPrompt") then
			connectPrompt(obj)
		end
	end)
end

local function removeForceField(character)
	local forceField = character:FindFirstChildOfClass("ForceField")
	if forceField then
		forceField:Destroy()
	end
end

setupInteractionPrompts()

local function onPlayerAdded(player)
	local userId = player.UserId
	local _, message = TranscriptManager.Create(userId)
	print(message)

	player.CharacterAdded:Connect(function(character)
		task.wait()
		removeForceField(character)
	end)

	if player.Character then
		removeForceField(player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

SaveDataRequest.OnServerEvent:Connect(function(player)
	local userId = player.UserId
	local loadedScene = GameSaveManager.Load(userId)

	local hasSave = loadedScene ~= nil
	local sceneNumber = loadedScene or 1

	SaveDataResponse:FireClient(player, hasSave, sceneNumber)
end)

StartNewGame.OnServerEvent:Connect(function(player)
	local userId = player.UserId

	GameSaveManager.Delete(userId)
	TranscriptManager.Delete(userId)
	Progression.Reset()
	TranscriptManager.Create(userId)

	player:SetAttribute("Scene", 1)

	local ok, msg = Scenes.LoadScene(player, 1)
	if not ok then
		warn("Failed to load new game scene:", msg)
	end
end)

ContinueGame.OnServerEvent:Connect(function(player)
	local userId = player.UserId

	local loadedScene = GameSaveManager.Load(userId)
	local sceneNumber = loadedScene or 1

	Progression.Set(userId)
	player:SetAttribute("Scene", sceneNumber)

	local ok, msg = Scenes.LoadScene(player, sceneNumber)
	if not ok then
		warn("Failed to load continue scene:", msg)
	end
end)

StoryCompleted.OnServerEvent:Connect(function(player)
	handleStoryCompletion(player)
end)

ReturnToMenu.OnServerEvent:Connect(function(player) 
	local userId = player.UserId
	local currentScene = player:GetAttribute("Scene")

	-- Check if player is on final scene and unload.
	if currentScene == FINAL_PROGRESS then
		local ok, msg = Scenes.UnloadScene(player, currentScene)
		if not ok then
			warn("Failed to unload scene:", msg)
		end
	end

	-- Reset player scene attribute
	player:SetAttribute("Scene", nil)

	-- Tell the client to show the main menu again.
	ShowMainMenu:FireClient(player)
end)