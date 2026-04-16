local Scene14 = {}

Scene14.Mom = {
	scene14DialogueStart = {
		speaker = "You",
		text = "Mom...?",
		next = "scene14Response1",
	},

	scene14Response1 = {
		speaker = "Mom",
		text = "You're home. Why are you home so early? What happened? What did you do?",
		next = "scene14Reply1",
	},

	scene14Reply1 = {
		speaker = "You",
		text = "Never mind me. What happened here?",
		next = "scene14Response2",
	},

	scene14Response2 = {
		speaker = "Mom",
		text = "Your father decided that he had enough of me and stormed out. What became of that? Well, it's clear to see.",
		next = "scene14Response3",
	},

	scene14Response3 = {
		speaker = "Mom",
		text = "That sick man just walked up and left! He left this family and you and your sister. I can't handle this on my own.",
	},
}

Scene14.Player = {
	scene14IntroMonologue = {
		speaker = "You",
		text = "I went home, much earlier than ever before. Going home at this time would absolutely give my parents the wrong impression, but what could I do?",
		next = "scene14IntroMonologue2",
	},

	scene14IntroMonologue2 = {
		speaker = "You",
		text = "I needed a place of solitude. I needed to go home to my room and just wait everything out, talk to Charlie.",
		next = "scene14IntroMonologue3",
	},

	scene14IntroMonologue3 = {
		speaker = "You",
		text = "If I could rely on anything, I could talk to Charlie to make me feel better.",
	},

	scene14Task1Monologue = {
		speaker = "You",
		text = "As soon as I shut the door, I heard a loud scream from my mother before the crash of furniture and slamming of things on the floor.",
		next = "scene14Task1Monologue2",
	},

	scene14Task1Monologue2 = {
		speaker = "You",
		text = "There was nothing I could do but sit inside my room and let the storm pass. This was worse than I could ever imagine.",
		next = "scene14Task1Monologue3",
	},

	scene14Task1Monologue3 = {
		speaker = "You",
		text = "There was nothing that could be done. My sister was downstairs, out of reach. My dad was nowhere. My friend wasn't here.",
		next = "scene14Task1Monologue4",
	},

	scene14Task1Monologue4 = {
		speaker = "You",
		text = "My mom wasn't mine. My own mind wasn't mine anymore.",
	},

	scene14Task2Monologue = {
		speaker = "You",
		text = "Charlie, at this moment, talked in a way that confused me. Charlie responded in a much colder tone, almost as though it wasn't human.",
		next = "scene14Task2Monologue2",
	},

	scene14Task2Monologue2 = {
		speaker = "You",
		text = "But I couldn't feel the cold, I needed the warmth. I needed a solution. Answers, but Charlie would only give half-baked support and suggestions.",
		next = "scene14Task2Monologue3",
	},

	scene14Task2Monologue3 = {
		speaker = "You",
		text = "I need a suggestion! Give me an answer!",
	},

	scene14Task3Monologue = {
		speaker = "You",
		text = "That was it. Charlie had given me the perfect solution.",
	},
}

Scene14.Registry = {
	Mom = {
		tree = Scene14.Mom,
		defaultStartNode = "scene14DialogueStart",
	},

	Player = {
		tree = Scene14.Player,
		defaultStartNode = "scene14IntroMonologue",
	},
}

return Scene14
