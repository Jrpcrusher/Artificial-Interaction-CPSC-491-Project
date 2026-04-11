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


return TraitAnalyzer
