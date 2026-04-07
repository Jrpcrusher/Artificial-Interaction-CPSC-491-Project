--[[Services]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

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
	chatFrame.Visible = true
	openButton.Visible = false

	player.CameraMode = Enum.CameraMode.Classic
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	UserInputService.MouseIconEnabled = true

	task.wait(0.05)
	input:CaptureFocus()
end

local function closeChat()
	chatFrame.Visible = false
	openButton.Visible = true

	player.CameraMode = Enum.CameraMode.LockFirstPerson
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInputService.MouseIconEnabled = false
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