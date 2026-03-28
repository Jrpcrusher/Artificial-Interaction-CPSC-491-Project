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



return LoreMemory
