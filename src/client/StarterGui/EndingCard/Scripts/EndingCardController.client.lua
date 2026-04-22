local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")


local EndingFolder = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Ending")
local ShowEndCardEvent = EndingFolder:WaitForChild("ShowEndCard")
local EndingCardFinished = EndingFolder:WaitForChild("EndingCardFinished")

local EndingCard = script.Parent.Parent
local MainFrame = EndingCard:WaitForChild("Frame")
local Text = MainFrame:WaitForChild("TextLabel")

local EndingMusic = SoundService:WaitForChild("EndingMusic")

local textFade = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local backgroundFade = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local fadeOut = TweenService:Create(Text, textFade, {
	TextTransparency = 1
})

local fadeIn = TweenService:Create(Text, textFade, {
	TextTransparency = 0
})

local TextBank = {
	"AI, is a tool. It can generate words, solve equations, and create things on a whim.",
	"It can code, make your life easier, and provide suggestions.",
	"But, it can never replicate, understand, or feel the same way you can.",
	"It is nothing but an Artificial Interaction.",
	"Use AI responsibly, and productively.",
	"Thank you for playing <3"
}

local function playEndCard()
	EndingCard.Enabled = true
	Text.TextTransparency = 0
	TweenService:Create(MainFrame, backgroundFade, {BackgroundTransparency = 0}):Play()
	for _, text in ipairs(TextBank) do
		fadeOut:Play()
		fadeOut.Completed:Wait()
		task.wait(3)
		Text.Text = text

		fadeIn:Play()
		fadeIn.Completed:Wait()
		task.wait(3)
	end
end

ShowEndCardEvent.OnClientEvent:Connect(function()
	EndingMusic:Play()
	playEndCard()
	task.wait(1)
	EndingCard.Enabled = false
	EndingCardFinished:FireServer()
end)