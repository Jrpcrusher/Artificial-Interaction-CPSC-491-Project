local TraitAnalyzer = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)

local MAX_TRAITS = 10

-- System prompt designed for stable, JSON-only output
local TRAIT_SYSTEM_PROMPT = [[
You are an analysis subsystem. Your job is to read a transcript of messages between a player and an in-game AI companion.

Your task:
- Extract personality traits, behavioral patterns, emotional tendencies, or conversational habits.
- Base traits ONLY on what is observable in the transcript.
- Do NOT invent lore, diagnoses, or backstory.
- Do NOT exceed 10 traits.
- Each trait must be a short phrase (3-8 words).
- Output ONLY a JSON array of strings. No commentary, no explanation.

Example output:
["curious", "asks many questions", "emotionally reserved"]
]]

-- Converts the transcript table into a readable text block.
local function FlattenTranscript(userId)
    local transcript = TranscriptManager.Get(userId)
    if not transcript or #transcript == 0 then
        return nil
    end

    local lines = {}

    for _, entry in ipairs(transcript) do
        for timestamp, data in pairs(entry) do
            local sender = data[1] == 0 and "AI" or "Player"
            local content = data[2]
            table.insert(lines, sender .. ": " .. content)
        end
    end

    return table.concat(lines, "\n")
end

-- Main extraction function
function TraitAnalyzer.ExtractTraits(userId)
    local transcriptText = FlattenTranscript(userId)
    if not transcriptText then
        warn("TraitAnalyzer: No transcript found for userId", userId)
        return {}
    end

    local secret
    local okSecret, resultSecret = pcall(function()
        return HttpService:GetSecret("HF_TOKEN")
    end)

    if not okSecret then
        warn("TraitAnalyzer: Failed to retrieve HF_TOKEN:", resultSecret)
        return {}
    end


end

return TraitAnalyzer
