-- Used to temporarily store player traits determined by the AI model.
-- Used at the end of the game to help with displaying the traits in the UI.
local TraitStore = {}

-- Internal table storing traits per userID.
local store = {}

-- Save traits for a player.
function TraitStore.Set(userId, traits)
    if typeof(userId) ~= "number" then
        warn("TraitStore.Set: invalid userID", userId)
        return
    end

    if typeof(traits) ~= "table" then
        warn("TraitStore.Set: traits must be a table")
        return
    end

    store[userId] = traits
end

return TraitStore