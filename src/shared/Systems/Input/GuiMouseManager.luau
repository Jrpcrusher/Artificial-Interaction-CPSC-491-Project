local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local GuiMouseManager = {}

local openGuiCount = 0

local DEFAULT_ZOOM = 0.5
local GUI_ZOOM = 6

local currentTween = nil

local function tweenZoom(target)
	if currentTween then
		currentTween:Cancel()
	end

	currentTween = TweenService:Create(
		player,
		TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{
			CameraMinZoomDistance = target,
			CameraMaxZoomDistance = target,
		}
	)

	currentTween:Play()
end

local function applyState()
	if openGuiCount > 0 then
		player.CameraMode = Enum.CameraMode.Classic
		tweenZoom(GUI_ZOOM)

		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	else
		player.CameraMode = Enum.CameraMode.LockFirstPerson
		tweenZoom(DEFAULT_ZOOM)

		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	end
end

function GuiMouseManager.OpenGui()
	openGuiCount += 1
	applyState()
end

function GuiMouseManager.CloseGui()
	openGuiCount = math.max(0, openGuiCount - 1)
	applyState()
end

function GuiMouseManager.ForceFirstPerson()
	openGuiCount = 0
	applyState()
end

player.CharacterAdded:Connect(function()
	task.wait(0.1)
	applyState()
end)

return GuiMouseManager