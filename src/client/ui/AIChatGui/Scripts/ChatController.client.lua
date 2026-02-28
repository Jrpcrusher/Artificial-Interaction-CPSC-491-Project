--[[References to UI Elements]]
local scriptsFolder = script.Parent
local gui = scriptsFolder.Parent    -- References AIChatGui (ScreenGui)

local chatFrame = gui:WaitForChild("ChatWindow")
local openButton = gui:WaitForChild("AIOpenButton")
local closeButton = chatFrame:WaitForChild("XButton2")

local inputBar = chatFrame:WaitForChild("InputBar")
local input = inputBar:WaitForChild("TextBox")
local send = inputBar:WaitForChild("SendButton")

local messageHistory = chatFrame:WaitForChild("MessageHistory")
local playerMessageTemplate = chatFrame:WaitForChild("PlayerMessageTemplate")
local aiMessageTemplate = chatFrame:WaitForChild("AIMessageTemplate")

--[[Services & Remotes]]
local UserInputService = game:GetService("UserInputService")
--[Below code will be uncommented once remote events are created in my local project. This will also need to be done in the main project.]
-- local ChatbotRequest = game.ReplicatedStorage:WaitForChild("ChatbotRequest")
-- local ChatbotResponse = game.ReplicatedStorage:WaitForChild("ChatbotResponse")

--[[Message Display]]
local function addMessage(text, isPlayer)
    -- Chooses the template to use based on message being sent/received.
    local message = (isPlayer and playerMessageTemplate or aiMessageTemplate):Clone()

    message.Visible = true
    message.Text = text
    message.Parent = messageHistory

    -- Automatically moves to the bottom of the message history.
    task.wait()
    messageHistory.CanvasPosition = Vector2.new(0, messageHistory.AbsoluteCanvasSize.y)
end