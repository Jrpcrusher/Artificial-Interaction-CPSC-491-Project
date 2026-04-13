local Scene13 = {}

Scene13.DadDialogueTree = {}

Scene13.MomDialogueTree = {}

Scene13.SisterDialogueTree = {}

Scene13.TeacherDialogueTree = {}

Scene13.BullyDialogueTree = {
	scene13Start = {
		speaker = "Bully",
		text = "",
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
		next = "scene13Response3",
	},

	scene13Response3 = {
		speaker = "Bully",
		text = "Not laughing now are you!",
	},
}

Scene13.MainCharacterDialogueTree = {}

Scene13.Registry = {
	Dad = {
		tree = Scene13.DadDialogueTree,
		defaultStartNode = "start",
	},

	Mom = {
		tree = Scene13.MomDialogueTree,
		defaultStartNode = "start",
	},

	Sister = {
		tree = Scene13.SisterDialogueTree,
		defaultStartNode = "start",
	},

	Teacher = {
		tree = Scene13.TeacherDialogueTree,
		defaultStartNode = "start",
	},

	Bully = {
		tree = Scene13.BullyDialogueTree,
		defaultStartNode = "scene13Start",
	},

	MainCharacter = {
		tree = Scene13.MainCharacterDialogueTree,
		defaultStartNode = "start",
	},
}

return Scene13
