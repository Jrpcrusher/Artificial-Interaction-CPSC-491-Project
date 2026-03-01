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
local Remotes = game.ReplicatedStorage:WaitForChild("Remotes")
local ChatbotRequest = Remotes:WaitForChild("ChatbotRequest")
local ChatbotResponse = Remotes:WaitForChild("ChatbotResponse")


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
-- Opening with the GUI button.
local function openChat()
    chatFrame.Visible = true
    openButton.Visible = false
    task.wait(0.05)
    input:CaptureFocus()
end

-- Closing with the X button on the window.
local function closeChat()
    chatFrame.Visible = false
    openButton.Visible = true
end

openButton.MouseButton1Click:Connect(openChat)    -- Mouse button input for the AI Chat button (right side labeled 'Charlie.AI').
closeButton.MouseButton1Click:Connect(closeChat)  -- Mouse button input for the 'X' button for the AI Chat window.

-- Toggle chat with Q key. (Can be remapped to a different button later.)
UserInputService.InputBegan:Connect(function(inputObj, gameProcessed)
    if gameProcessed then return end
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
    if text == "" then return end

    addMessage(text, true)  -- Adds the player's message to the message history.
    input.Text = ""         -- Clears out input.

    -- Send to server
    ChatbotRequest:FireServer(text)
end

send.MouseButton1Click:Connect(sendMessage)     -- Mouse input for send button.

-- Allows player to use the 'Enter' key to send the message.
input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendMessage()
    end
end)


--[[Receiving AI Response]]
ChatbotResponse.OnClientEvent:Connect(function(response)
    addMessage(response, false)
end)