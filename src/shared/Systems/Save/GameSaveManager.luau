-- References to DataStoreService and creating a data store.
local DataStoreService = game:GetService("DataStoreService")
local save_datastore = DataStoreService:GetDataStore("save_datastore")

-- Table to contain all save-related functions.
local GameSaveManager = {}

-- Number of retries for the helper function.
local RETRIES = 3

-- Helper function for retrying DataStore operations.
local function attempt(callback)
	for i = 1, RETRIES do
		-- pcall safely runs the callback and catches errors
		local success, result = pcall(callback)
		if success then
			return true, result
		end
		-- If failed, wait before retrying again (backoff increases each retry)
		task.wait(0.5 * i)
	end
	-- If all retries fail, return false and error message.
	return false, "Failed after three attempts."
end

-- Save the player's game state.
function GameSaveManager.Save(user_id, scene_number)
	-- Attempts to save data using SetAsync using the attempt helper function.
	return attempt(function()
		return save_datastore:SetAsync(user_id, scene_number)
	end)
end

-- Loads the player's game state and returns the scene number they were at.
function GameSaveManager.Load(user_id)
	local success, result = attempt(function()
		return save_datastore:GetAsync(user_id)
	end)
	if success and result then
		-- If the save data exists, then return the saved scene value from the saved table.
		return result.Scene
	end
	-- If no data exists or loading failed, return nil.
	return nil
end

-- Deletes the player's saved data entirely.
function GameSaveManager.Delete(user_id)
	-- Attempts to remove the key from the DataStore.
	return attempt(function()
		return save_datastore:RemoveAsync(user_id)
	end)
end

return GameSaveManager
-- Returns the table so other scripts can require() and use it.
