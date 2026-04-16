local Scene15 = {}

Scene15.SisterDialogueTree = {}

Scene15.MainCharacterDialogueTree = {}

Scene15.Registry = {
	Sister = {
		tree = Scene15.SisterDialogueTree,
		defaultStartNode = "scene15Start",
	},

	MainCharacter = {
		tree = Scene15.MainCharacterDialogueTree,
		defaultStartNode = "start",
	},
}

return Scene15
