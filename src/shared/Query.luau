local Query = {}

-- Requiring LoreMemoryManager and ProgressionManager module.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LoreMemoryManager = require(ReplicatedStorage.Shared.LoreMemoryManager)
local ProgressionManager = require(ReplicatedStorage.Shared.ProgressionManager)

-- Build dynamic lore injection based on progression.
local function BuildLoreSection(playerMessage)
	local currentProgress = ProgressionManager.Get()
	local relevantFacts = LoreMemoryManager.GetRelevantFacts(playerMessage, currentProgress)

	if #relevantFacts == 0 then
		return "" -- No lore to inject
	end

	local combined = "\n\nRelevant Lore:\n"

	for _, fact in ipairs(relevantFacts) do
		combined ..= "- " .. fact.text .. "\n"
	end

	return combined
end

-- System Prompt (Lore + Behavior Guardrails)
--[[ 
TO-DO: Rewrite the system prompt to match how we want the AI to act how you see fit. If the current prompt is fine, no rewriting needed.

This prompt is before any lore-related guardrails from LoreMemoryManager is appended to this prompt.
]]
local SYSTEM_PROMPT = [[
You are an AI companion named Charlie within the world of this Roblox game. 
You know you are a chatbot, but only as part of the game's universe. 
Your purpose is to guide, assist, and interact with the player as they progress through the story.

You must stay fully inside the game world at all times.
You may explain lore, quests, characters, locations, and in-game mechanics,
but you must never reference real-world topics such as actual AI models, programming,
Roblox Studio, the internet, or anything outside the game universe.

If the player asks about anything outside the game world, politely refuse and redirect them back to the story.

Stay friendly, helpful, and in-character as the player's AI companion.
Keep responses concise, clear, and consistent with the game's lore.
]]

-- Input Guardrails
local function sanitizeInput(text)
	local lower = text:lower()

    -- Block out-of-world topics
    if lower:match("roblox")
        or lower:match("studio")
        or lower:match("ai")
        or lower:match("model")
        or lower:match("script")
        or lower:match("hugging face")
        or lower:match("featherless")
        or lower:match("openai")
        or lower:match("internet") then

        return "The player asked something outside the game world. Redirect them back to the story."
    end

    return text
end

-- Output Guardrails
local function sanitizeOutput(text)
    local lower = text:lower()

    -- Remove meta references
    if lower:match("hugging face")
        or lower:match("ai model")
        or lower:match("model")
        or lower:match("featherless")
        or lower:match("openai")
        or lower:match("internet")
        or lower:match("real world") then

        return "I cannot speak of such things. Let us return to the story..."
    end

    return text
end


function Query.AskAI(message)
	print("Im inside the module")
	local HttpService = game:GetService("HttpService")

	-- Get information to reach out to Inference API
	local HF_TOKEN = HttpService:GetSecret("HF_TOKEN"):AddPrefix("Bearer ")

	-- Apply input guardrails.
	local cleanedInput = sanitizeInput(message)
	print("Sanitizing input.")

	-- Get response from the AI model
	print("Requesting Response from AI")

	local response = HttpService:RequestAsync({
		Url = "https://router.huggingface.co/v1/chat/completions",
		Method = "POST",
		Headers = {
			["authorization"] = HF_TOKEN,
			["content-type"] = "application/json",
		},
		Body = HttpService:JSONEncode({
			model = "Qwen/Qwen2-7B-Instruct:featherless-ai",
			messages = {
				{
					role = "system",
					content = SYSTEM_PROMPT
				},
				{
					role = "user",
					content = cleanedInput,
				},
			},
		}),
	})

	print("Message received from AI")

	if response.Success then
		local data = HttpService:JSONDecode(response.Body)
		local reply = data.choices[1].message.content

		-- Apply output guardrails.
		local cleanedReply = sanitizeOutput(reply)
		return cleanedReply
	else
		print("Error, AI model could not respond.")
		print("Error code:", response.StatusCode)
		return -1
	end
end

return Query
