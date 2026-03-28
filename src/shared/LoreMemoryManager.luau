-- Module for storing and retrieving game lore.
-- Used to add lore-related/story-related guardrails to the AI chatbot.
-- Requires the player's current progress to accurately implement the guardrails.

local LoreMemory = {}

--[[
TO-DO: Add canonical lore facts here. This can be anything related to the story and quests.

Each entry should include:
{
    id = "unique_id",
    text = "TO-DO: Lore text goes here."
    min_progress = X, -- The earliest progression state where this lore becomes available.
}

An example of multiple entries will look like the following below:
LoreMemory.CANONICAL_FACTS = {
   {
        id = "intro",
        text = "TO‑DO: Describe the basic history of the game world.",
        min_progress = 1,
    },

    {
        id = "ai_backstory",
        text = "TO‑DO: Explain the AI companion's origin within the game world.",
        min_progress = 1,
    },
}
]]
LoreMemory.CANONICAL_FACTS = {
    -- TO-DO: Add lore entries.
}

-- Return all lore facts the player is allowed to know.
function LoreMemory.GetUnlockedFacts(currentProgress)
    local results = {}

    for _, fact in ipairs(LoreMemory.CANONICAL_FACTS) do
        if fact.min_progress and currentProgress >= fact.min_progress then
            table.insert(results, fact)
        end
    end

    return results
end

-- Retrieve lore relevant to a specific player message.
-- Only returns lore the player has unlocked.
function LoreMemory.GetRelevantFacts(playerMessage, currentProgress)
    local unlocked = LoreMemory.GetUnlockedFacts(currentProgress)
    local results = {}

    --[[
        TO-DO: Add keyword -> lore mappings.

        Example:
        if playerMessage:lower():match("background") then
            table.insert(results, unlocked[1])
        end
    ]]
    
    return results
end

return LoreMemory
