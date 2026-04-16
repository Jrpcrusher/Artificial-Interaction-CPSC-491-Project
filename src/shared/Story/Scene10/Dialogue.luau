local Scene10 = {}

Scene10.DadDialogueTree = {}

Scene10.MomDialogueTree = {}

Scene10.SisterDialogueTree = {}

Scene10.TeacherDialogueTree = {
	start = {
		speaker = "Teacher",
		text = "Please remember no cheating, if you are caught cheating then you will be in serious trouble. And especially no use of AI, this quiz is meant to test you, not your AI chatbot.",
	}
}

Scene10.FriendDialogueTree = {
	scene10Start = {
		speaker = "Friend",
		text = "Hey are you doing alright?",
		next = "scene10Reply",
	},
	scene10Reply = {
		speaker = "You",
		text = "I am doing alright, I got Charlie like normal to help me with the assignment today it was wonderful!",
		next = "scene10Reply2",
	},
	scene10Reply2 = {
		speaker = "Friend",
		text = "Are you using it to actually understand the material, or just tell you the answers.",
		next = "scene10Reply3",
	},
	scene10Reply3 = {
		speaker = "You",
		text = "I... well sometimes it just helps when I ...",
		next = "scene10Reply4",
	},
	scene10Reply4 = {
		speaker = "Friend",
		text = "How are you going to improve in school if you are just using it to give you the answers? You are going to know less than what you already know if you just have it tell you the answers. You need to learn how to genuinely study you are falling behind and you won’t know anything for the quiz we have today.",
	}
}

Scene10.MainCharacterDialogueTree = {}

Scene10.Registry = {
	Dad = {
		tree = Scene10.DadDialogueTree,
		defaultStartNode = "start",
	},
	Mom = {
		tree = Scene10.MomDialogueTree,
		defaultStartNode = "start",
	},
	Sister = {
		tree = Scene10.SisterDialogueTree,
		defaultStartNode = "start",
	},
	Teacher = {
		tree = Scene10.TeacherDialogueTree,
		defaultStartNode = "start",
	},
	Friend = {
		tree = Scene10.FriendDialogueTree,
		defaultStartNode = "scene10Start",
	},
	MainCharacter = {
		tree = Scene10.MainCharacterDialogueTree,
		defaultStartNode = "start",
	},
}

return Scene10