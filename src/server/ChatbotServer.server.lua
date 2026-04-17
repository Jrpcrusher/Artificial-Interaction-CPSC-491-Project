local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Query = require(ReplicatedStorage.Shared.Utils.Chat.Query)
local MessageManager = require(ReplicatedStorage.Shared.Utils.Chat.MessageManager)
local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)
local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ChatRemotes = Remotes:WaitForChild("Chat")
local ChatbotRequest = ChatRemotes:WaitForChild("ChatbotRequest")
local ChatbotResponse = ChatRemotes:WaitForChild("ChatbotResponse")

local SendMessage = SoundService:WaitForChild("SendMessage")
local Reply = SoundService:WaitForChild("ReplyMessage")

ChatbotRequest.OnServerEvent:Connect(function(player, message)
	print("Server received chat message from", player.Name, message)

	if typeof(message) ~= "string" then
		ChatbotResponse:FireClient(player, "Invalid message.")
		return
	end

	message = message:gsub("^%s+", ""):gsub("%s+$", "")
	if message == "" then
		ChatbotResponse:FireClient(player, "Please type a message first.")
		return
	end

	local timeValue = os.time()
	print("Before save")
	TranscriptManager.Add(player.UserId, MessageManager.Create(player.UserId, timeValue, message))
	print("Before after save")
	SendMessage:Play()
	local reply = Query.AskAI(message)

	print("after send")
	Reply:Play()

	if reply == -1 or reply == nil then
		reply = "Sorry, AI model is currently unreachable."
	end

	local sceneNumber = player:GetAttribute("Scene")
	TaskService.CompleteTask(player, sceneNumber, "talk_to_ai")

	timeValue = os.time()
	TranscriptManager.Add(player.UserId, MessageManager.Create(0, timeValue, reply))

	ChatbotResponse:FireClient(player, reply)
end)
