local Scene12 = {}

Scene12.DadDialogueTree = {}

Scene12.MomDialogueTree = {}

Scene12.SisterDialogueTree = {}

Scene12.TeacherDialogueTree = {}

Scene12.BullyDialogueTree = {}

Scene12.MainCharacterDialogueTree = {}

Scene12.Registry = {
	Dad = {
		tree = Scene12.DadDialogueTree,
		defaultStartNode = "start",
	},
	
    Mom = {
		tree = Scene12.MomDialogueTree,
		defaultStartNode = "start",
	},
	
    Sister = {
		tree = Scene12.SisterDialogueTree,
		defaultStartNode = "start",
	},
	
    Teacher = {
		tree = Scene12.TeacherDialogueTree,
		defaultStartNode = "start",
	},
	
    Bully = {
		tree = Scene12.BullyDialogueTree,
		defaultStartNode = "start",
	},
	
    MainCharacter = {
		tree = Scene12.MainCharacterDialogueTree,
		defaultStartNode = "start",
	},
}

return Scene12