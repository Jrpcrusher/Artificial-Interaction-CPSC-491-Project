local Players = game:GetService("Players")
local Scene13 = {}

local player = Players:GetPlayers()[1]

Scene13.Teacher = {
	start = {
		speaker = "Teacher",
		text = "What is the matter here?",
		next = "Bully1",
	},

	Bully1 = {
		speaker = "Bully",
		text = player.DisplayName .. " made fun of my jacket and haircut so I punched him one!",
		next = "Teacher2",
	},

	Teacher2 = {
		speaker = "Teacher",
		text = "That is enough! Both of you to the principal's office now!",
		next = "scene13EndMonologue1",
	},

	scene13EndMonologue1 = {
		speaker = "You",
		text = "(internal) My teacher was furious at the situation, practically dragging us to the principal's office.",
		next = "scene13EndMonologue2",
	},

	scene13EndMonologue2 = {
		speaker = "You",
		text = "(internal) I had done nothing, not laid a single finger, but would I still get in trouble? My mind was worried.",
		next = "scene13EndMonologue3",
	},

	scene13EndMonologue3 = {
		speaker = "You",
		text = "(internal) I was nervous about punishment. What could I do? My head and face hurt so bad.",
		next = "scene13EndMonologue4",
	},

	scene13EndMonologue4 = {
		speaker = "You",
		text = "(internal) We got to the principal's office and got a stern talking to before getting sent home early for the day.",
	},
}

Scene13.Bully = {
	scene13Task1Start = {
		speaker = "Bully",
		text = "...",
		next = "scene13Reply1",
	},

	scene13Reply1 = {
		speaker = "You",
		text = "Hey are you doing good today friend?",
		next = "scene13Response1",
	},

	scene13Response1 = {
		speaker = "Bully",
		text = "What?",
		next = "scene13Reply2",
	},

	scene13Reply2 = {
		speaker = "You",
		text = "Nothing, I just noticed how that jacket of yours looks ugly. Why do you always wear that brown one? Do you not have any other clothes?",
		next = "scene13Response2",
	},

	scene13Response2 = {
		speaker = "Bully",
		text = "What, what are you talking about? My grandpa who passed away last year gave this jacket to me. This jacket is special to me you jerk!",
		next = "scene13Reply3",
	},

	scene13Reply3 = {
		speaker = "You",
		text = "And that haircut, what is with the way you style it, its literally the most abominable thing I've seen!",
		next = "scene13Task1Monologue",
	},

	scene13Task1Monologue = {
		speaker = "You",
		text = "(internal) In a split second, I was on the ground. I was staring at the sky. I was hurting. What had happened? I looked around to see my bully next to me.",
	},

	scene13Response3 = {
		speaker = "Bully",
		text = "Not laughing now are you!",
	},
}

Scene13.Player = {
	scene13IntroMonologue = {
		speaker = "You",
		text = "Charlie has given me some excellent suggestions. I could finally give my friend a taste of his own judgmental self.",
	},
}

Scene13.Registry = {
	Teacher = {
		tree = Scene13.Teacher,
		defaultStartNode = "start",
	},

	Bully = {
		tree = Scene13.Bully,
		defaultStartNode = "scene13Task1Start",
	},

	Player = {
		tree = Scene13.Player,
		defaultStartNode = "scene13intro",
	},
}

return Scene13
