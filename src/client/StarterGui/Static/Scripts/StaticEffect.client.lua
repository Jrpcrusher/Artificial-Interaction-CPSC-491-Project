local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local staticGui = script.Parent.Parent
local frame = staticGui:WaitForChild("Frame")
local blackout = staticGui:WaitForChild("Blackout")
local remote = ReplicatedStorage.Remotes:WaitForChild("StaticEvent")

local Textures = {
	"rbxassetid://268592485",
	"rbxassetid://268592462",
	"rbxassetid://268592427",
	"rbxassetid://268590007",
}

local Frames = {}
local StaticTransparency = 0.3
local FramesToWait = 2
local running = false

for _, imageId in ipairs(Textures) do
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "StaticFrame"
	imageLabel.Image = imageId
	imageLabel.BackgroundTransparency = 1
	imageLabel.ImageTransparency = 1
	imageLabel.Visible = false
	imageLabel.ZIndex = 10
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
	imageLabel.Parent = frame

	table.insert(Frames, imageLabel)
end

local function setTransparency(value)
	for _, imageLabel in ipairs(Frames) do
		imageLabel.ImageTransparency = value
	end
end

local function fadeBlackoutIn()
	TweenService:Create(
		blackout,
		TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{BackgroundTransparency = 0}
	):Play()
end

local function fadeBlackoutOut()
	TweenService:Create(
		blackout,
		TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{BackgroundTransparency = 1}
	):Play()
end

local function startStatic()
	if running then
		return
	end

	running = true
	blackout.BackgroundTransparency = 1
	setTransparency(StaticTransparency)
	fadeBlackoutIn()

	task.spawn(function()
		while running do
			local last = nil

			for _, imageLabel in ipairs(Frames) do
				if not running then
					break
				end

				if last then
					last.Visible = false
				end

				imageLabel.Visible = true
				last = imageLabel

				for _ = 1, FramesToWait do
					RunService.RenderStepped:Wait()
				end
			end

			if last then
				last.Visible = false
			end
		end
	end)
end

local function stopStatic()
	running = false
	fadeBlackoutOut()

	for _, imageLabel in ipairs(Frames) do
		imageLabel.Visible = false
	end
end

remote.OnClientEvent:Connect(function(action)
	if action == "Start" then
		startStatic()
	elseif action == "Stop" then
		stopStatic()
	end
end)