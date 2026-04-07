--[[Services]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

--[[Required]]
local GuiMouseManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMouseManager)
local GuiMovementManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMovementManager)

local player = Players.LocalPlayer

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

--[[Remotes]]
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ChatRemotes = Remotes:WaitForChild("Chat")
local ChatbotRequest = ChatRemotes:WaitForChild("ChatbotRequest")
local ChatbotResponse = ChatRemotes:WaitForChild("ChatbotResponse")

--[[Message Display]]
local function addMessage(text, isPlayer)
	local row = (isPlayer and playerMessageTemplate or aiMessageTemplate):Clone()
	row.Visible = true

	local bubble = row:WaitForChild("Bubble")
	bubble.Text = tostring(text)

	row.Parent = messageHistory

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

	if not text or text:gsub("%s+", "") == "" then
		return
	end

	addMessage(text, true)
	input.Text = ""

	ChatbotRequest:FireServer(text)
end

send.MouseButton1Click:Connect(sendMessage)

input.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendMessage()
	end
end)

--[[Receiving AI Response]]
ChatbotResponse.OnClientEvent:Connect(function(response)
	addMessage(response, false)
end)