-- References to DataStoreService and creating a data store.
local DataStoreService = game:GetService("DataStoreService")
local save_datastore = DataStoreService:GetDataStore("save_datastore")

-- Container to hold game saves.
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
    local key = "Player_" .. user_id 


    local data = {
        UserId = user_id,
        Scene = scene_number,
    }

    -- Attempts to save data using SetAsync using the attempt helper function.
    return attempt(function()
        return save_datastore:SetAsync(key, data)
    end)
end
