-- Handles how the player can move when gui open or closed
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local GuiMovementManager = {}

local lockCount = 0

local DEFAULT_WALK_SPEED = 16
local DEFAULT_JUMP_POWER = 50

local function applyState()
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	if lockCount > 0 then
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.AutoRotate = false
	else
		humanoid.WalkSpeed = DEFAULT_WALK_SPEED
		humanoid.JumpPower = DEFAULT_JUMP_POWER
		humanoid.AutoRotate = true
	end
end

function GuiMovementManager.Lock()
	lockCount += 1
	applyState()
end

function GuiMovementManager.Unlock()
	lockCount = math.max(0, lockCount - 1)
	applyState()
end

function GuiMovementManager.ForceUnlock()
	lockCount = 0
	applyState()
end

player.CharacterAdded:Connect(function()
	task.wait(0.1)
	applyState()
end)

return GuiMovementManager
