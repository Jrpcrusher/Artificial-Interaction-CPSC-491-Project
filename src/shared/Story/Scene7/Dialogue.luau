local Scene7 = {}

Scene7.Player = {
	start = {
		speaker = "You",
		text = "I got to school that morning and it was dark, colder than your normal day.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "The rain was coming down, it was peaceful bliss from the stress coming at home.",
		next = "dialogue3",
	},
	dialogue3 = {
		speaker = "You",
		text = "At times, going to school felt like a blessing compared to a curse.",
		next = "dialogue4",
	},
	dialogue4 = {
		speaker = "You",
		text = "Being away from home brings a wonderful sense of peace at times.",
		next = "dialogue5",
	},
	dialogue5 = {
		speaker = "You",
		text = "I ended up in math class, where something wasn’t sitting right with me.",
		next = "dialogue6",
	},
	dialogue6 = {
		speaker = "You",
		text = "Better sit down now.",
	},
}

Scene7.Conversation = {
	start = {
		speaker = "You",
		text = "Nothing was making sense, and the whiteboard looked like a foreign language.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "I was spacing out. I couldn’t concentrate on the board in front of me.",
		next = "dialogue3",
	},
	dialogue3 = {
		speaker = "You",
		text = "The numbers turned to fizzled lines, jumbled together making out almost coherent equations.",
		next = "dialogue4",
	},
	dialogue4 = {
		speaker = "You",
		text = "I was lost. I couldn’t find the solution.",
		next = "dialogue5",
	},
	dialogue5 = {
		speaker = "You",
		text = "Was I struggling? I thought about asking for help, but the thought slipped away.",
		next = "dialogue6",
	},
	dialogue6 = {
		speaker = "You",
		text = "Then I overheard something near me.",
		next = "dialogue7",
	},
	dialogue7 = {
		speaker = "Student",
		text = "Wow this new AI can solve anything can’t it!",
		next = "dialogue8",
	},
	dialogue8 = {
		speaker = "Student",
		text = "Wow that’s impressive, what was the app you downloaded?",
		next = "dialogue9",
	},
	dialogue9 = {
		speaker = "Student",
		text = "The app is called Charlie AI, it allows you to talk to it and do whatever you want.",
		next = "dialogue10",
	},
	dialogue10 = {
		speaker = "Student",
		text = "It’s helped me quite a few times now with the math homework. I’d be so lost without it!",
		next = "dialogue11",
	},
	dialogue11 = {
		speaker = "You",
		text = "Charlie AI? Something that can solve anything?",
		next = "dialogue12",
	},
	dialogue12 = {
		speaker = "You",
		text = "That sounded too good to be true.",
		next = "dialogue13",
	},
	dialogue13 = {
		speaker = "You",
		text = "No matter, I just have to solve the problem when I get home.",
		next = "dialogue14",
	},
	dialogue14 = {
		speaker = "You",
		text = "Despite my confidence, it was just ego talking.",
		next = "dialogue15",
	},
	dialogue15 = {
		speaker = "You",
		text = "Before I knew it, it was the end of the day and time to go home.",
	},
}

Scene7.Registry = {
	Player = {
		tree = Scene7.Player,
		defaultStartNode = "start",
	},
	Conversation = {
		tree = Scene7.Conversation,
		defaultStartNode = "start",
	},
}

return Scene7