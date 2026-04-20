local Scene10 = {}

Scene10.DadDialogueTree = {}
Scene10.MomDialogueTree = {}
Scene10.SisterDialogueTree = {}
Scene10.BullyDialogueTree = {}
Scene10.MainCharacterDialogueTree = {}

Scene10.FriendDialogueTree = {
	scene10Start = {
		speaker = "Friend",
		text = "Hey are you doing alright?",
		next = "youReply1",
	},
	youReply1 = {
		speaker = "You",
		text = "I am doing alright, I got Charlie like normal to help me with the assignment today it was wonderful!",
		next = "friendReply1",
	},
	friendReply1 = {
		speaker = "Friend",
		text = "Are you using it to actually understand the material, or just tell you the answers.",
		next = "youReply2",
	},
	youReply2 = {
		speaker = "You",
		text = "I… well sometimes it just helps when I …",
		next = "friendReply2",
	},
	friendReply2 = {
		speaker = "Friend",
		text = "How are you going to improve in school if you are just using it to give you the answers? You need to learn how to genuinely study you are falling behind and you won’t know anything for the quiz we have today.",
	}
}

Scene10.TeacherDialogueTree = {
	scene10Start = {
		speaker = "Teacher",
		text = "Please remember no cheating. And especially no use of AI, this quiz is meant to test you, not your AI chatbot.",
	}
}

Scene10.Registry = {
	Dad = { tree = Scene10.DadDialogueTree, defaultStartNode = "start" },
	Mom = { tree = Scene10.MomDialogueTree, defaultStartNode = "start" },
	Sister = { tree = Scene10.SisterDialogueTree, defaultStartNode = "start" },
	Teacher = { tree = Scene10.TeacherDialogueTree, defaultStartNode = "scene10Start" },
	Friend = { tree = Scene10.FriendDialogueTree, defaultStartNode = "scene10Start" },
	Bully = { tree = Scene10.BullyDialogueTree, defaultStartNode = "start" },
	MainCharacter = { tree = Scene10.MainCharacterDialogueTree, defaultStartNode = "start" },
}

return Scene10