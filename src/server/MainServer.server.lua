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

local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)
local InteractionHandler = require(ReplicatedStorage.Shared.Utils.Interaction.InteractionHandler)
local GameSaveManager = require(ReplicatedStorage.Shared.Systems.Save.GameSaveManager)
local Scenes = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local TraitAnalyzer = require(ReplicatedStorage.Shared.Utils.Chat.TraitAnalyzer)
local TraitStore = require(ReplicatedStorage.Shared.Utils.Chat.TraitStore)

local function handleStoryCompletion(player)
    local userId = player.UserId

	-- If player already has stored traits (e.g., loading into an already-completed game)
	local storedTraits = TraitStore.Get(userId)
	if storedTraits and #storedTraits > 0 then
		ShowEndingTraits:FireClient(player, storedTraits)
		return
	end

    -- Extract traits once at the end of the story
    local traits = TraitAnalyzer.ExtractTraits(userId)
    TraitStore.Set(userId, traits)

    -- Fire the ending UI to the client
    ShowEndingTraits:FireClient(player, traits)

    print("Story completed for", player.Name, "Traits generated:", #traits)
end

local function connectPrompt(prompt) -- Connect dialogue to NPC
	prompt.Triggered:Connect(function(player)
		local interactable =
			prompt:FindFirstAncestorWhichIsA("Accessory")
			or prompt:FindFirstAncestorWhichIsA("Tool")
			or prompt:FindFirstAncestorWhichIsA("Model")
			or prompt.Parent

		if interactable then
			print("Resolved interactable:", interactable:GetFullName())
			print("InteractionType:", interactable:GetAttribute("InteractionType"))
			print("TaskId:", interactable:GetAttribute("TaskId"))

			InteractionHandler.HandleInteraction(player, interactable)
		end
	end)
end

local function setupInteractionPrompts() -- setup NPC interactions
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

local function removeForceField(character) -- Simple function to remove forcefield
	local forceField = character:FindFirstChildOfClass("ForceField")
	if forceField then
		forceField:Destroy()
	end
end

setupInteractionPrompts()

local function onPlayerAdded(player) -- Function to handle when a player joins the game
	local userId = player.UserId
	local message = ""

	-- Get the transcript
	local success, transcript = TranscriptManager.Load(userId)

    if success and transcript ~= nil then -- Check if transcript loaded
        message = "Transcript loaded"
	elseif success then -- If success, but no transcript, then create new one
        TranscriptManager.Create(userId)
        message = "Created new transcript"
    else -- Otherwise we didnt get a transcript
		message = "Failed to load transcript"
		warn(message)
	end

	print(message)

	player.CharacterAdded:Connect(function(character) -- Remove player forcefield
		task.wait()
		removeForceField(character)
	end)

	if player.Character then  -- Remove player forcefield
		removeForceField(player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded) -- Call onPlayerAdded

for _, player in ipairs(Players:GetPlayers()) do -- Get all the players
	onPlayerAdded(player)
end

SaveDataRequest.OnServerEvent:Connect(function(player) -- RemoteEvent savedatarequest fired
	local userId = player.UserId
	local loadedScene = GameSaveManager.Load(userId) -- Call game save to load

	local hasSave = loadedScene ~= nil
	local sceneNumber = loadedScene or 1

	SaveDataResponse:FireClient(player, hasSave, sceneNumber)
end)

StartNewGame.OnServerEvent:Connect(function(player) -- On start new game, delete everything and reset
	local userId = player.UserId

	GameSaveManager.Delete(userId)
	TranscriptManager.Delete(userId)
	TranscriptManager.Create(userId)
	TraitStore.Clear(userId)

	local ok, msg = Scenes.LoadSceneNumber(player, 1)
	if not ok then
		warn("Failed to load new game scene:", msg)
	end
end)

ContinueGame.OnServerEvent:Connect(function(player) -- On continue game, load the correct scene
	local ok, msg = Scenes.ContinueFromSave(player) -- Load the scene for the user
	if not ok then
		warn("Failed to load continue scene:", msg)
	end
end)

StoryCompleted.OnServerEvent:Connect(function(player)
	handleStoryCompletion(player)
end)

ReturnToMenu.OnServerEvent:Connect(function(player)
	player:SetAttribute("Scene", nil)
	player:SetAttribute("IsSceneTransitioning", false)
	ShowMainMenu:FireClient(player)
end)