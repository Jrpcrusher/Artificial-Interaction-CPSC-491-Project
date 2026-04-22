local Scene1 = {}

Scene1.Player = {
	start = {
		speaker = "You",
		text = "Is it raining...? (Click in this area to continue dialogue)",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "I should grab my things so I can get ready for school.",
	},
}

Scene1.Registry = {
	Player = {
		tree = Scene1.Player,
		defaultStartNode = "start",
	},
}

return Scene1
