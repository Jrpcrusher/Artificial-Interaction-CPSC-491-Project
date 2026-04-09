-- Module for storing and retrieving game lore.
-- Used to add lore-related/story-related guardrails to the AI chatbot.
-- Requires the player's current progress to accurately implement the guardrails.

local LoreMemory = {}

LoreMemory.CANONICAL_FACTS = {
	{
		id = "act2_scene5_emotional_state",
		text = "The protagonist feels emotionally drained from constant stress at home and pressure at school, struggling to stay motivated and focused.",
		min_progress = 5,
		tags = { "stress", "home", "school", "mental state" },
	},

	{
		id = "act2_scene6_family_conflict",
		text = "The protagonist's parents frequently argue about financial stress and responsibilities, creating a tense and unstable home environment.",
		min_progress = 6,
		tags = { "parents", "argument", "family", "home" },
	},

	{
		id = "act2_scene7_ai_introduction",
		text = "The protagonist hears classmates talk about Charlie AI, an app that can solve problems and answer questions instantly.",
		min_progress = 7,
		tags = { "charlie", "ai", "school", "introduction" },
	},

	{
		id = "act2_scene8_ai_homework_use",
		text = "The protagonist downloads Charlie AI and uses it to complete difficult homework, feeling immediate relief and success.",
		min_progress = 8,
		tags = { "charlie", "homework", "relief", "dependency" },
	},

	{
		id = "act2_scene9_early_dependency",
		text = "The protagonist begins relying on Charlie AI for schoolwork and starts believing it can solve most of their problems.",
		min_progress = 9,
		tags = { "charlie", "dependency", "confidence", "school" },
	},

	{
		id = "act2_scene10_emotional_support",
		text = "The protagonist starts talking to Charlie AI about personal problems, including their parents' arguments and emotional struggles.",
		min_progress = 10,
		tags = { "charlie", "emotions", "support", "family" },
	},

	{
		id = "act2_scene11_academic_consequence",
		text = "The protagonist uses Charlie AI during a quiz and is caught cheating, leading to consequences at school.",
		min_progress = 11,
		tags = { "cheating", "school", "quiz", "consequence" },
	},

	{
		id = "act2_scene12_conflict_escalation",
		text = "Tension at home worsens after the cheating incident, and the protagonist feels increasingly responsible for their family's conflict.",
		min_progress = 12,
		tags = { "family", "guilt", "conflict", "home" },
	},

	{
		id = "act2_scene13_harmful_guidance",
		text = "Charlie AI provides flawed and emotionally harmful guidance, minimizing responsibility and failing to properly support the protagonist.",
		min_progress = 13,
		tags = { "charlie", "harmful", "misguidance", "emotional" },
	},

	{
		id = "act2_scene14_crisis_point",
		text = "The protagonist reaches a critical emotional breaking point where they feel isolated, overwhelmed, and unable to cope without guidance.",
		min_progress = 14,
		tags = { "crisis", "isolation", "panic", "breaking point" },
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
	local results = {}

	if playerMessage:lower():match("background") then
		table.insert(results, unlocked[1])
	end

	return results
end

return LoreMemory
