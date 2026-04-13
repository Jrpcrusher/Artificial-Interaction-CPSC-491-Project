-- The goal of this file is to map out the different stages of the game
-- The game is divided into parts, after each part completion, increment the counter by 1
-- Then, when the users game saves automatically, the counter is increased by 1

-- Required for set function.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameSaveManager = require(ReplicatedStorage.Shared.Systems.Save.GameSaveManager)


local Progression = {}
local current_state = 1

function Progression.Increment() -- Simple function to increment where we are in the game
	if current_state == 16 then -- Max state reaached, then dont increment
		return current_state
	end

	current_state += 1
	return current_state
end

function Progression.Get() -- Get the current state of the game, can be used to save
	return current_state
end

function Progression.Reset() -- Reset the state on start of new game, useful for starting new save
	current_state = 1
	return current_state
end

function Progression.Set(user_id) -- Sets the current state from retrieving state value from GameSaveManager.
	if not user_id then
		warn("Progression.Set() called before player joined.")
		return current_state
	end

	local state = GameSaveManager.Load(user_id)
	if state then
		current_state = state
	end

	return current_state
end

return Progression
