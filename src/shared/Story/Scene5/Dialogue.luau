local Scene5 = {}
Scene5.Player = {
	start = {
		speaker = "You",
		text = "I woke up, but today felt wrong.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "I was tired, tired of this routine.",
		next = "dialogue3",
	},
	dialogue3 = {
		speaker = "You",
		text = "Everyday I felt horrible, judged for my interests, piled with stress at home.",
		next = "dialogue4",
	},
	dialogue4 = {
		speaker = "You",
		text = "None of this pressure was good for me, and I knew it was building up inside.",
		next = "dialogue5",
	},
	dialogue5 = {
		speaker = "You",
		text = "Each passing day felt like a never ending torment, testing me at every passing moment.",
		next = "dialogue6",
	},
	dialogue6 = {
		speaker = "You",
		text = "There was no day I could wake up feeling excited and it was getting to me.",
		next = "dialogue7",
	},
	dialogue7 = {
		speaker = "You",
		text = "Despite this I had to get up like any other day unless I wanted to get lectured again by my parents.",
		next = "dialogue8",
	},
	dialogue8 = {
		speaker = "You",
		text = "So, I did what I always did in the morning.",
	},
}

Scene5.Backpack = {
	start = {
		speaker = "You",
		text = "I grabbed my backpack.",
	},
}

Scene5.Calculator = {
	start = {
		speaker = "You",
		text = "I grabbed my calculator.",
	},
}

Scene5.Keys = {
	start = {
		speaker = "You",
		text = "I grabbed my keys.",
	},
}

Scene5.Door = {
	start = {
		speaker = "You",
		text = "I should grab everything before leaving.",
	},
}

Scene5.Exit = {
	start = {
		speaker = "You",
		text = "Time to head out.",
	},
}

Scene5.Registry = {
	Player = {
		tree = Scene5.Player,
		defaultStartNode = "start",
	},
	Backpack = {
		tree = Scene5.Backpack,
		defaultStartNode = "start",
	},
	Calculator = {
		tree = Scene5.Calculator,
		defaultStartNode = "start",
	},
	Keys = {
		tree = Scene5.Keys,
		defaultStartNode = "start",
	},
	Door = {
		tree = Scene5.Door,
		defaultStartNode = "start",
	},
	Exit = {
		tree = Scene5.Exit,
		defaultStartNode = "start",
	},
}

return Scene5