--[[Services]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[[Required]]
local GuiMouseManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMouseManager)
local GuiMovementManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMovementManager)

--[[References to UI Elements]]
local scriptsFolder = script.Parent
local gui = scriptsFolder.Parent

local chatFrame = gui:WaitForChild("ChatWindow")
local openButton = gui:WaitForChild("AIOpenButton")
local closeButton = chatFrame:WaitForChild("XButton2")

local inputBar = chatFrame:WaitForChild("InputBar")
local input = inputBar:WaitForChild("TextBox")
local send = inputBar:WaitForChild("SendButton")

local messageHistory = chatFrame:WaitForChild("MessageHistory")
local playerMessageTemplate = chatFrame:WaitForChild("PlayerMessageTemplate")
local aiMessageTemplate = chatFrame:WaitForChild("AIMessageTemplate")

-- STARTUP STATE:
-- AI chat is unavailable until some scene/event enables it.
gui.Enabled = false
chatFrame.Visible = false
openButton.Visible = false

--[[Services & Remotes]]
local UserInputService = game:GetService("UserInputService")
local Remotes = game.ReplicatedStorage:WaitForChild("Remotes")
local ChatbotRequest = Remotes:WaitForChild("Chat"):WaitForChild("ChatbotRequest")
local ChatbotResponse = Remotes:WaitForChild("Chat"):WaitForChild("ChatbotResponse")
local LoadTranscript = Remotes:WaitForChild("LoadTranscript")

--[[Message Display]]
local function addMessage(text, isPlayer)
	-- Chooses the correct row template to use based on message being sent/received.
	local row = (isPlayer and playerMessageTemplate or aiMessageTemplate):Clone()
	row.Visible = true

	-- Bubble is the Textlabel (text message) inside the row.
	local bubble = row:WaitForChild("Bubble")
	bubble.Text = text

	-- Add message (row) to scrolling frame.
	row.Parent = messageHistory

	-- Automatically moves to the most recent message in message history.
	task.wait()
	messageHistory.CanvasPosition = Vector2.new(0, messageHistory.AbsoluteCanvasSize.Y)
end

--[[Opening & Closing Chat Window]]
local function openChat()
	if not gui.Enabled then
		return
	end

	chatFrame.Visible = true
	openButton.Visible = false

	GuiMouseManager.OpenGui()
	GuiMovementManager.Lock()

	task.wait(0.05)
	input:CaptureFocus()
end

local function closeChat()
	chatFrame.Visible = false

	-- only show the open button if the whole AI gui is enabled
	openButton.Visible = gui.Enabled

	GuiMouseManager.CloseGui()
	GuiMovementManager.Unlock()
end

openButton.MouseButton1Click:Connect(openChat)
closeButton.MouseButton1Click:Connect(closeChat)

UserInputService.InputBegan:Connect(function(inputObj, gameProcessed)
	if gameProcessed then
		return
	end
	if inputObj.KeyCode == Enum.KeyCode.Q then
		if chatFrame.Visible then
			closeChat()
		else
			openChat()
		end
	end
end)

--[[Sending Player Message]]
local function sendMessage()
	local text = input.Text
	if text == "" then
		return
	end

	addMessage(text, true) -- Adds the player's message to the message history.
	input.Text = "" -- Clears out input.

	-- Send to server
	ChatbotRequest:FireServer(text)
end

send.MouseButton1Click:Connect(sendMessage) -- Mouse input for send button.

input.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendMessage()
	end
end)

--[[Receiving AI Response]]
ChatbotResponse.OnClientEvent:Connect(function(response)
	addMessage(response, false)
end)

--[[Loading messages from Transcript.]]
LoadTranscript.OnClientEvent:Connect(function(transcript)
	if not transcript then
		return
	end

	-- Sort messages by timestamp
	local sorted = {}

	for _, entry in ipairs(transcript) do
		for timestamp, data in pairs(entry) do
			table.insert(sorted, {
				time = timestamp,
				sender = data[1],
				content = data[2],
			})
		end
	end

	table.sort(sorted, function(a, b)
		return a.time < b.time
	end)

	-- Rebuild UI
	for _, msg in ipairs(sorted) do
		local isPlayer = msg.sender ~= 0
		addMessage(msg.content, isPlayer)
	end
end)
