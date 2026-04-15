local Scene6 = {}
Scene6.Player = {
	start = {
		speaker = "You",
		text = "Im walking down the stairs as always.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "Everyday is such a challenge, theres never not one.",
		next = "dialogue3",
	},
	dialogue3 = {
		speaker = "You",
		text = "What is that soothing noise?",
		next = "dialogue4",
	},
	dialogue4 = {
		speaker = "You",
		text = "Could it be the rain?",
	},
}

Scene6.Rain = {
	start = {
		speaker = "You",
		text = "The rain has always felt calming to me.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "Im hopeful for today.",
	},
}

Scene6.Crash = {
	start = {
		speaker = "You",
		text = "What was that noise?!",
	},
}

Scene6.Mom = {
	start = {
		speaker = "Mom",
		text = "Oh, I did not see you there honey, I accidentally dropped the picture while cleaning.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "Mom",
		text = "This picture means nothing anyway.",
	},
}

Scene6.Thoughts = {
	start = {
		speaker = "You",
		text = "I don’t understand what mom and dad are fighting about.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "I did not like the look she was giving me, was breaking the picture on purpose?",
	},
}

Scene6.Eat = {
	start = {
		speaker = "You",
		text = "I should eat something.",
	},
}
Scene6.Fruit = {
	start = {
		speaker = "You",
		text = "I ate some fruit.",
	},
}
Scene6.Milk = {
	start = {
		speaker = "You",
		text = "I should grab cereal to go with the milk.",
	},
}
Scene6.Cereal = {
	start = {
		speaker = "You",
		text = "I made some cereal.",
	},
}
Scene6.OrangeJuice = {
	start = {
		speaker = "You",
		text = "I should make some toast to go with this.",
	},
}
Scene6.Toast = {
	start = {
		speaker = "You",
		text = "I made some toast.",
	},
}
Scene6.Coat = {
	start = {
		speaker = "You",
		text = "I grabbed my coat.",
	},
}
Scene6.NotReady = {
	start = {
		speaker = "You",
		text = "I should finish everything before leaving.",
	},
}
Scene6.Final = {
	start = {
		speaker = "You",
		text = "Alright, Im ready to go to school.",
	},
}

Scene6.Registry = {
	Player = {
		tree = Scene6.Player,
		defaultStartNode = "start",
	},
	Rain = {
		tree = Scene6.Rain,
		defaultStartNode = "start",
	},
	Crash = {
		tree = Scene6.Crash,
		defaultStartNode = "start",
	},
	Mom = {
		tree = Scene6.Mom,
		defaultStartNode = "start",
	},
	Thoughts = {
		tree = Scene6.Thoughts,
		defaultStartNode = "start",
	},
	Eat = {
		tree = Scene6.Eat,
		defaultStartNode = "start",
	},
	Fruit = {
		tree = Scene6.Fruit,
		defaultStartNode = "start",
	},
	Milk = {
		tree = Scene6.Milk,
		defaultStartNode = "start",
	},
	Cereal = {
		tree = Scene6.Cereal,
		defaultStartNode = "start",
	},
	OrangeJuice = {
		tree = Scene6.OrangeJuice,
		defaultStartNode = "start",
	},
	Toast = {
		tree = Scene6.Toast,
		defaultStartNode = "start",
	},
	Coat = {
		tree = Scene6.Coat,
		defaultStartNode = "start",
	},
	NotReady = {
		tree = Scene6.NotReady,
		defaultStartNode = "start",
	},
	Final = {
		tree = Scene6.Final,
		defaultStartNode = "start",
	},
}

return Scene6