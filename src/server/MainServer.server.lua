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
local ReturnToMenu = getOrCreateRemote(EndingFolder, "ReturnToMenu")
local ShowMainMenu = getOrCreateRemote(EndingFolder, "ShowMainMenu")

getOrCreateRemote(EndingFolder, "StoryCompleted")
getOrCreateRemote(EndingFolder, "ShowEndingTraits")
getOrCreateRemote(TaskFolder, "TaskUpdated")
getOrCreateRemote(DialogueFolder, "StartDialogue")
getOrCreateRemote(DialogueFolder, "FinishDialogue")
getOrCreateRemote(ChatFolder, "ChatbotRequest")
getOrCreateRemote(ChatFolder, "ChatbotResponse")
getOrCreateRemote(ChatFolder, "ShowAIChatGui")
getOrCreateRemote(ChatFolder, "ChatWindowIsClosed")

local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)
local InteractionHandler = require(ReplicatedStorage.Shared.Utils.Interaction.InteractionHandler)
local GameSaveManager = require(ReplicatedStorage.Shared.Systems.Save.GameSaveManager)
local Scenes = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)
local TraitStore = require(ReplicatedStorage.Shared.Utils.Chat.TraitStore)

-- Helper function to find door ancestor named "Door"

local function findDoorAncestor(instance)
	local current = instance

	while current do
		if current:GetAttribute("InteractionType") == "Door" then
			return current
		end
		current = current.Parent
	end
	return nil
end

-- Updated: Connect interactable Models, Accessories, and Tools to appropriate interaction
local function connectPrompt(prompt)
	prompt.Triggered:Connect(function(player)
		local interactable = findDoorAncestor(prompt)
			or prompt:FindFirstAncestorWhichIsA("Accessory")
			or prompt:FindFirstAncestorWhichIsA("Tool")
			or prompt:FindFirstAncestorOfClass("Model")
			or prompt.Parent

		if interactable then
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

	player.CharacterAdded:Connect(function(character) -- Remove player forcefield
		task.wait()
		removeForceField(character)
	end)

	if player.Character then -- Remove player forcefield
		removeForceField(player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded) -- Call onPlayerAdded

for _, player in ipairs(Players:GetPlayers()) do -- Get all the players
	onPlayerAdded(player)
end

SaveDataRequest.OnServerEvent:Connect(function(player) -- RemoteEvent savedatarequest fired
	local userId = player.UserId
	local loadedScene = GameSaveManager.Load(userId)
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

ReturnToMenu.OnServerEvent:Connect(function(player)
	player:SetAttribute("Scene", nil)
	player:SetAttribute("IsSceneTransitioning", false)
	ShowMainMenu:FireClient(player)
end)
