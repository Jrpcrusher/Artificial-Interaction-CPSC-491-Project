-- References to UI Elements
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

