local Scene1 = {}

Scene1.DadDialogueTree = {
	scene1Start = {
		speaker = "Dad",
		text = "You finally woke up.",
		next = "scene1Reply",
	},

	scene1Reply = {
		speaker = "You",
		text = "Where am I?",
	}
}

Scene1.MomDialogueTree = {}

Scene1.SisterDialogueTree = {}

Scene1.TeacherDialogueTree = {}

Scene1.BullyDialogueTree = {}

Scene1.MainCharacterDialogueTree = {}

Scene1.Registry = {
	Dad = {
		tree = Scene1.DadDialogueTree,
		defaultStartNode = "scene1Start",
	},

	Mom = {
		tree = Scene1.MomDialogueTree,
		defaultStartNode = "start",
	},

	Sister = {
		tree = Scene1.SisterDialogueTree,
		defaultStartNode = "start",
	},

	Teacher = {
		tree = Scene1.TeacherDialogueTree,
		defaultStartNode = "start",
	},

	Bully = {
		tree = Scene1.BullyDialogueTree,
		defaultStartNode = "start",
	},

	MainCharacter = {
		tree = Scene1.MainCharacterDialogueTree,
		defaultStartNode = "start",
	},
}

return Scene1
