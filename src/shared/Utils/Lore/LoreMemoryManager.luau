-- Module for storing and retrieving game lore.
-- Used to add lore-related/story-related guardrails to the AI chatbot.
-- Requires the player's current progress to accurately implement the guardrails.

local LoreMemory = {}

LoreMemory.CANONICAL_FACTS = {
	{
		id = "act2_scene5_emotional_state",
		text = "The protagonist feels emotionally drained from constant stress at home and pressure at school, struggling to stay motivated and focused.",
		min_progress = 5,
		tags = {
			"stress",
			"home",
			"school",
			"mental state",
			"struggle",
			"family",
			"issues",
			"cant focus",
			"tired",
			"overwhelmed",
			"anxious",
		},
	},

	{
		id = "act2_scene6_family_conflict",
		text = "The protagonist's parents frequently argue about financial stress and responsibilities, creating a tense and unstable home environment.",
		min_progress = 6,
		tags = {
			"parents",
			"argument",
			"family",
			"home",
			"unstable",
			"unsafe",
			"tired",
			"scared",
			"afraid",
			"stress",
		},
	},

	{
		id = "act2_scene7_ai_introduction",
		text = "The protagonist hears classmates talk about Charlie AI, an app that can solve problems and answer questions instantly.",
		min_progress = 7,
		tags = { "charlie", "ai", "school", "introduction", "classmates", "chatbot", "solve problems" },
	},

	{
		id = "act2_scene8_ai_homework_use",
		text = "The protagonist downloads Charlie AI and uses it to complete difficult homework, feeling immediate relief and success.",
		min_progress = 8,
		tags = {
			"charlie",
			"homework",
			"relief",
			"dependency",
			"help",
			"math",
			"difficult",
			"dont understand",
			"solve",
			"answer this",
		},
	},

	{
		id = "act2_scene9_early_dependency",
		text = "The protagonist begins relying on Charlie AI for schoolwork and starts believing it can solve most of their problems.",
		min_progress = 9,
		tags = {
			"charlie",
			"rely",
			"dependent",
			"school",
			"need charlie",
			"cant do it alone",
			"confidence",
			"need you",
			"please help",
			"help me with",
		},
	},

	{
		id = "act2_scene10_emotional_support",
		text = "The protagonist starts talking to Charlie AI about personal problems, including their parents' arguments and emotional struggles.",
		min_progress = 10,
		tags = { "charlie", "support", "family", "parents", "arguing", "sad", "upset", "personal problems" },
	},

	{
		id = "act2_scene11_academic_consequence",
		text = "The protagonist uses Charlie AI during a quiz and is caught cheating, leading to consequences at school.",
		min_progress = 11,
		tags = { "cheating", "cheated", "quiz", "test", "teacher", "caught", "school", "trouble" },
	},

	{
		id = "act2_scene12_conflict_escalation",
		text = "Tension at home worsens after the cheating incident, and the protagonist feels increasingly responsible for their family's conflict.",
		min_progress = 12,
		tags = { "family", "guilt", "home", "my fault", "conflict", "parents", "arguing", "blame" },
	},

	{
		id = "act2_scene13_harmful_guidance",
		text = "Charlie AI provides flawed and emotionally harmful guidance, minimizing responsibility and failing to properly support the protagonist.",
		min_progress = 13,
		tags = { "charlie", "bad advice", "wrong advice", "not helping", "cold", "misleading" },
	},

	{
		id = "act2_scene14_crisis_point",
		text = "The protagonist reaches a critical emotional breaking point where they feel isolated, overwhelmed, and unable to cope without guidance.",
		min_progress = 14,
		tags = {
			"panic",
			"alone",
			"isolated",
			"hopeless",
			"overwhelmed",
			"breaking point",
			"cant cope",
			"cant handle",
			"please help",
			"support",
		},
	},
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
	local scoredFacts = {}

	if not playerMessage or playerMessage == "" then
		return {}
	end

	local function normalizeText(text)
		text = text:lower()
		text = text:gsub("[%p]", "")
		text = text:gsub("%s+", " ")
		text = text:gsub("^%s+", "")
		text = text:gsub("%s+$", "")
		return text
	end

	local function buildWordSet(text)
		local words = {}
		for word in text:gmatch("%S+") do
			words[word] = true
		end
		return words
	end

	local normalizedMsg = normalizeText(playerMessage)
	local msgWords = buildWordSet(normalizedMsg)

	for _, fact in ipairs(unlocked) do
		local score = 0

		if fact.tags then
			for _, tag in ipairs(fact.tags) do
				local normalizedTag = normalizeText(tag)

				-- Strong score for full phrase match
				if normalizedMsg:find(normalizedTag, 1, true) then
					score = score + 2
				else
					-- Weaker score for word overlap
					for word in normalizedTag:gmatch("%S+") do
						if #word >= 4 and msgWords[word] then
							score = score + 1
							break
						end
					end
				end
			end
		end

		if score > 6 then
			table.insert(scoredFacts, {
				fact = fact,
				score = score,
			})
		end
	end

	table.sort(scoredFacts, function(a, b)
		if a.score == b.score then
			return a.fact.min_progress > b.fact.min_progress
		end
		return a.score > b.score
	end)

	local results = {}

	for i = 1, math.min(3, #scoredFacts) do
		table.insert(results, scoredFacts[i].fact)
	end

	-- Fallback if nothing matched
	if #results == 0 then
		for i = math.max(1, #unlocked - 1), #unlocked do
			table.insert(results, unlocked[i])
		end
	end

	return results
end

return LoreMemory
