local Scene12 = {}

Scene12.Player = {
	start = {
		speaker = "You",
		text = "(internal) I went up to my room, in tears and in horror of what I was hearing from downstairs.",
		next = "startmonologue2",
	},

	startmonologue2 = {
		speaker = "You",
		text = "(internal) The sounds of yelling and screaming. I could only imagine what my sister was thinking.",
		next = "startmonologue3",
	},

	startmonologue3 = {
		speaker = "You",
		text = "(internal) She is downstairs in her bedroom hearing the same commmotion I was. The sounds from downstairs is too much to bear.",
		next = "startmonologue4",
	},

	startmonologue4 = {
		speaker = "You",
		text = "(internal) I had to do something, say something. I need Charlie. It hadn't failed me in answering questions. I need to know what to do.",
	},

	task1monologue = {
		speaker = "You",
		text = "(internal) One by one, Charlie provided me suggestions for each. Each suggestion mostly made sense.",
		next = "task1monologue2",
	},

	task1monologue2 = {
		speaker = "You",
		text = "(internal) Everything from the cheating on the quiz, my parents arguing, and dragging my sister into this isn't my fault.",
		next = "task1monologue3",
	},

	task1monologue3 = {
		speaker = "You",
		text = "(internal) Charlie's suggestion of holding my breath to calm down and stop panicking is worth a shot considering I really need it.",
		next = "task1monologue4",
	},

	task1monologue4 = {
		speaker = "You",
		text = "(internal) And about being judged, it's something Charlie never has to go through, but his explanations about everyone being unique, having flaws, and accepting ourselves really helped.",
		next = "task1monologue5",
	},

	task1monologue5 = {
		speaker = "You",
		text = "(internal) But flaws... Perhaps, I should point out the flaws of my friend. Maybe that would get back at him for what he said to me.",
	},
}

Scene12.Registry = {
	Player = {
		tree = Scene12.Player,
		defaultStartNode = "start",
	},
}

return Scene12
