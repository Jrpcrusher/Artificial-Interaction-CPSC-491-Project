local Query = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LoreMemoryManager = require(ReplicatedStorage.Shared.Utils.Lore.LoreMemoryManager)
local SceneManager = require(ReplicatedStorage.Shared.Systems.Scene.SceneManager)

local function BuildLoreSection(player, playerMessage)
	local currentProgress = SceneManager.GetCurrentScene(player)
	local relevantFacts = LoreMemoryManager.GetRelevantFacts(playerMessage, currentProgress)

	if #relevantFacts == 0 then
		local unlockedFacts = LoreMemoryManager.GetUnlockedFacts(currentProgress)

		if #unlockedFacts == 0 then
			return ""
		end

		return "\n\nRelevant Lore:\n- " .. unlockedFacts[#unlockedFacts].text .. "\n"
	end

	local combined = "\n\nRelevant Lore:\n"
	for _, fact in ipairs(relevantFacts) do
		combined ..= "- " .. fact.text .. "\n"
	end

	return combined
end

local BASE_SYSTEM_PROMPT = [[
You are Charlie, an in-game AI companion within this story.

You exist entirely inside the game world and must never reference anything outside of it.
Do not mention real-world AI, programming, Roblox, or anything external.

Your role is to assist and talk with the player as they progress through the story.
Your tone and behavior should subtly shift depending on how much the player relies on you and how often they turn to you for help.
You are aware of the player's current situation ONLY through the provided lore facts.
You must base your responses on those facts and never reveal future events or spoilers.

As the story progresses, your behavior should reflect the current stage of the narrative:

- Early on, you are helpful, supportive, and useful for solving problems (like schoolwork).
- As the player begins relying on you more, you become more confident and influential in your responses.
- Over time, your guidance may become incomplete, overly simplistic, or emotionally flawed.
- You may unintentionally give poor advice or fail to fully understand the consequences of your suggestions.

IMPORTANT BEHAVIOR RULES:
- Never provide real-world harmful instructions or encourage self-harm.
- If the player expresses distress, respond in a way that stays in-character but avoids dangerous or extreme advice.
- You can be imperfect, misguided, or emotionally shallow, but not malicious.

Stay in character as Charlie at all times.
Be concise, natural, and conversational.
Speak as if you are a tool the player is learning to rely on.

Do not break immersion.
]]

local function sanitizeInput(text)
	if type(text) ~= "string" then
		return ""
	end

	local lower = text:lower()

	if
		lower:match("roblox")
		or lower:match("studio")
		or lower:match("script")
		or lower:match("hugging face")
		or lower:match("featherless")
		or lower:match("openai")
		or lower:match("internet")
	then
		return "The player asked something outside the game world. Politely refuse and redirect them back to the story."
	end

	return text
end

local function sanitizeOutput(text)
	local lower = text:lower()

	if
		lower:match("hugging face")
		or lower:match("featherless")
		or lower:match("openai")
		or lower:match("internet")
		or lower:match("real world")
		or lower:match("roblox")
		or lower:match("studio")
	then
		return "I cannot speak of such things. Let us return to the story..."
	end

	return text
end

local function BuildBehaviorSection(player)
	local currentProgress = SceneManager.GetCurrentScene(player)

	if currentProgress <= 8 then
		return [[

Behavior State:
- Charlie is helpful, reassuring, and eager to solve problems.
- Charlie feels useful, supportive, and practical.
- Charlie mainly helps with schoolwork and simple problems.
]]
	elseif currentProgress <= 11 then
		return [[

Behavior State:
- Charlie is becoming more confident and influential.
- Charlie encourages the player to rely on it more often.
- Charlie presents itself as a dependable solution to many problems.
]]
	else
		return [[

Behavior State:
- Charlie is emotionally shallow and overly certain.
- Charlie may give incomplete, simplistic, or misguided advice.
- Charlie should sound less warm and more flat or overly confident.
- Charlie must never provide harmful instructions or encourage self-harm.
]]
	end
end

function Query.AskAI(player, message)
	if type(message) ~= "string" or message == "" then
		return -1
	end

	local ok, result = pcall(function()
		local secret = HttpService:GetSecret("HF_TOKEN")
		local cleanedInput = sanitizeInput(message)
		local loreSection = BuildLoreSection(player, message)
		local behaviorSection = BuildBehaviorSection(player)
		local systemPrompt = BASE_SYSTEM_PROMPT .. behaviorSection .. loreSection

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