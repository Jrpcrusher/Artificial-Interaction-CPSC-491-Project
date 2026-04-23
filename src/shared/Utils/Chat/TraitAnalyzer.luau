local TraitAnalyzer = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)

local MAX_TRAITS = 10

-- System prompt designed for stable, JSON-only output
local TRAIT_SYSTEM_PROMPT = [[
You are an analysis subsystem. Your job is to read a transcript of messages between a player and an in-game AI companion.

Your task:
- Extract personality traits, behavioral patterns, emotional tendencies, or conversational habits, you can describe their interests as well.
- When extracting personality traits, such as if they actually gave full sentence questions, or just rapidly went through prompts by typing 1 word or letter.
- Base traits ONLY on what is observable in the transcript and sent by the player, do not analyze your own messages.
- Do NOT invent lore, diagnoses, or backstory.
- Do NOT exceed 10 traits.
- Each trait must be a short phrase (5-8 words).
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
        for _, data in pairs(entry) do
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

    local okSecret, resultSecret = pcall(function()
        return HttpService:GetSecret("HF_TOKEN")
    end)

    if not okSecret then
        warn("TraitAnalyzer: Failed to retrieve HF_TOKEN:", resultSecret)
        return {}
    end

    local responseOk, response = pcall(function()
        return HttpService:RequestAsync({
            Url = "https://router.huggingface.co/v1/chat/completions",
            Method = "POST",
            Headers = {
                ["authorization"] = resultSecret:AddPrefix("Bearer "),
                ["content-type"] = "application/json",
            },
            Body = HttpService:JSONEncode({
                model = "Qwen/Qwen2-7B-Instruct:featherless-ai",
                messages = {
                    { role = "system", content = TRAIT_SYSTEM_PROMPT },
                    { role = "user", content = transcriptText },
                },
            }),
        })
    end)

    if not responseOk or not response.Success then
        warn("TraitAnalyzer: API request failed:", responseOk, response and response.StatusCode, response and response.Body)
        return {}
    end

    local okDecode, decodeResult = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not okDecode then
        warn("TraitAnalyzer: Failed to decode API response JSON:", decodeResult)
        return {}
    end

    local content = decodeResult
        and decodeResult.choices
        and decodeResult.choices[1]
        and decodeResult.choices[1].message
        and decodeResult.choices[1].message.content

    if not content or content == "" then
        warn("TraitAnalyzer: Missing content in AI response")
        return {}
    end

    -- Parse the JSON array returned by the model
    local traits
    local okTraits, traitsResult = pcall(function()
        return HttpService:JSONDecode(content)
    end)

    if not okTraits or typeof(traitsResult) ~= "table" then
        warn("TraitAnalyzer: Failed to parse traits JSON:", traitsResult)
        return {}
    end

    traits = traitsResult

    -- Enforce maximum trait count
    local final = {}
    for i = 1, math.min(MAX_TRAITS, #traits) do
        table.insert(final, traits[i])
    end

    return final
end

return TraitAnalyzer
