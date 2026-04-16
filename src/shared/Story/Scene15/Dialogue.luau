local Scene15 = {}

Scene15.SisterDialogueTree = {
	scene15Start = {
		speaker = "Sister",
		text = "I could hear mom was furious from my room, it was hard to hear but I knew this wasn't okay. I knew my older sibling wasn't going to take this well.",
		next = "scene15Start2",
	},

	scene15Start2 = {
		speaker = "Sister",
		text = "They have so much on their plate and so I try to be there for them when I can. I knew with mom being destructive as she was, I had to go to them.",
	},

	scene15Task1Response = {
		speaker = "Sister",
		text = "WHAT ARE YOU DOING?!",
	},

	scene15Task2Response = {
		speaker = "Sister",
		text = "Why in the world would you do such a thing?",
		next = "scene15Task2MCReply1",
	},

	scene15Task2MCReply1 = {
		speaker = "You",
		text = "Thank you for being here for me sis. I'm sorry for letting you down.",
		next = "scene15Task2Response2",
	},

	scene15Task2Response2 = {
		speaker = "Sister",
		text = "If you were feeling bad, you should of told me. I am here for you. We are in this together.",
		next = "scene15end",
	},

	scene15end = {
		speaker = "You",
		text = "You're right. I should have gone to you, or mom, or someone who can actually relate to me.",
	},
}

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
