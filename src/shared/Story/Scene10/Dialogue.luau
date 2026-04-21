local Scene10 = {}

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
	},
}

Scene10.TeacherDialogueTree = {
	teacherStart = {
		speaker = "Teacher",
		text = "Please remember no cheating, if you are caught cheating then you will be in serious trouble. And especially no use of AI, this quiz is meant to test you, not your AI chatbot.",
		next = "internalReply",
	},
	internalReply = {
		speaker = "You",
		text = "(Internal) I should be fine, no problem!",
	},

	catchCheating = {
		speaker = "Teacher",
		text = "...",
		next = "reply",
	},
	reply = {
		speaker = "You",
		text = "...",
		next = "ohno",
	},
	ohno = {
		speaker = "You",
		text = "(Internal) Oh no... I'm doomed...",
	},
}

Scene10.PlayerDialogueTree = {
	start = {
		speaker = "You",
		text = "Okay question 1, what is ... what?",
		next = "reread",
	},
	reread = {
		speaker = "You",
		text = "Okay, reread one more time, find the ... what is this even asking for?!",
		next = "panick",
	},
	panick = {
		speaker = "You",
		text = "Oh no... this is the thing I used AI on and I didn't actually study that night, I don't know what to do..!",
		next = "solution",
	},
	solution = {
		speaker = "You",
		text = "Wait, I have my phone on me, maybe I can use Charlie real quick to help...",
	},

	relief = {
		speaker = "You",
		text = "Thank goodness, I did it!",
	},
}

Scene10.Registry = {
	Bully = {
		tree = Scene10.FriendDialogueTree,
		defaultStartNode = "scene10Start",
	},
	Teacher = {
		tree = Scene10.TeacherDialogueTree,
		defaultStartNode = "teacherStart",
	},
	Player = {
		tree = Scene10.PlayerDialogueTree,
		defaultStartNode = "start",
	},
}

return Scene10
