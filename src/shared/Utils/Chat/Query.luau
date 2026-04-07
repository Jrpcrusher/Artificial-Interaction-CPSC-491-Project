local Query = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LoreMemoryManager = require(ReplicatedStorage.Shared.Utils.Lore.LoreMemoryManager)
local ProgressionManager = require(ReplicatedStorage.Shared.Systems.Progression.ProgressionManager)

local function BuildLoreSection(playerMessage)
	local currentProgress = ProgressionManager.Get()
	local relevantFacts = LoreMemoryManager.GetRelevantFacts(playerMessage, currentProgress)

	if #relevantFacts == 0 then
		return ""
	end

	local combined = "\n\nRelevant Lore:\n"
	for _, fact in ipairs(relevantFacts) do
		combined ..= "- " .. fact.text .. "\n"
	end

	return combined
end

local BASE_SYSTEM_PROMPT = [[
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

local function sanitizeInput(text)
	local lower = text:lower()

	if
		lower:match("roblox")
		or lower:match("studio")
		or lower:match("ai")
		or lower:match("model")
		or lower:match("script")
		or lower:match("hugging face")
		or lower:match("featherless")
		or lower:match("openai")
		or lower:match("internet")
	then
		return "The player asked something outside the game world. Redirect them back to the story."
	end

	return text
end

local function sanitizeOutput(text)
	local lower = text:lower()

	if
		lower:match("hugging face")
		or lower:match("ai model")
		or lower:match("model")
		or lower:match("featherless")
		or lower:match("openai")
		or lower:match("internet")
		or lower:match("real world")
	then
		return "I cannot speak of such things. Let us return to the story..."
	end

	return text
end

function Query.AskAI(message)
	print("Query.AskAI start")

	local ok, result = pcall(function()
		local secret = HttpService:GetSecret("HF_TOKEN")
		local cleanedInput = sanitizeInput(message)
		local loreSection = BuildLoreSection(cleanedInput)
		local systemPrompt = BASE_SYSTEM_PROMPT .. loreSection

		print("Sending request to Hugging Face")

		local response = HttpService:RequestAsync({
			Url = "https://router.huggingface.co/v1/chat/completions",
			Method = "POST",
			Headers = {
				["authorization"] = secret:AddPrefix("Bearer "),
				["content-type"] = "application/json",
			},
			Body = HttpService:JSONEncode({
				model = "Qwen/Qwen2-7B-Instruct:featherless-ai",
				messages = {
					{
						role = "system",
						content = systemPrompt,
					},
					{
						role = "user",
						content = cleanedInput,
					},
				},
			}),
		})

		print("HTTP finished", response.StatusCode, response.Success)

		if not response.Success then
			warn("AI request failed:", response.StatusCode, response.Body)
			return -1
		end

		local data = HttpService:JSONDecode(response.Body)
		local reply = data
			and data.choices
			and data.choices[1]
			and data.choices[1].message
			and data.choices[1].message.content

		if not reply or reply == "" then
			warn("AI response missing content")
			return -1
		end

		return sanitizeOutput(reply)
	end)

	if not ok then
		warn("Query.AskAI crashed:", result)
		return -1
	end

	return result
end

return Query
