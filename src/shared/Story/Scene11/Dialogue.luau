local Scene11 = {}

Scene11.DadDialogueTree = {
	start = {
		speaker = "Dad",
		text = "Yeah we talked about a few things, about work, and our arguing and we managed to make a little progress.",
	},
    scene11Continued = {
        speaker = "Dad",
        text = "You cheated, on a math quiz? What in the world were you thinking about cheating?! Why in the hell would you cheat! That is not the style of this household, are you out of your mind! ASDADASODASJDODJWIOADKWLEAW",
        next = "scene11Reply",
    },
    scene11Reply = {
        speaker = "Mom",
        text = "This is because you don’t spend time enough together! You shouldn’t be at work so much, if you were home you could help with the homework or more!",
        next = "scene11Reply2",
    },
    scene11Reply2 = {
        speaker = "Dad",
        text = "This is my fault now? How in the world is this my fault! This has NOTHING TO DO WITH WORK!",
        next = "scene11Reply3",
    },
    scene11Reply3 = {
        speaker = "Mom",
        text = "DO YOU NOT UNDERSTAND THAT THIS IS A SHOWCASE OF YOUR FAILURE AS A PARENT!",
        next = "scene11Reply4",
    },
    scene11Reply4 = {
        speaker = "Dad",
        text = "MY FAILURE? YOU COULD JUST AS EASILY HELP OUR CHILD OUT WITH THE HOMEWORK!",
        next = "scene11Reply5",
    },
    scene11Reply5 = {
        speaker = "You",
        text = "I’M SORRY!",
    }
}

Scene11.MomDialogueTree = {
	start = {
		speaker = "Mom",
		text = "Yeah we’re okay right now, we had a good discussion about things and we are moving forward a little with everything.",
	}
}

Scene11.SisterDialogueTree = {}

Scene11.TeacherDialogueTree = {}

Scene11.BullyDialogueTree = {}

Scene11.MainCharacterDialogueTree = {
    scene11Start = {
        speaker = "You",
        text = "Is everything okay?",
    }
}

Scene11.Registry = {
	Dad = {
		tree = Scene11.DadDialogueTree,
		defaultStartNode = "start",
	},
	Mom = {
		tree = Scene11.MomDialogueTree,
		defaultStartNode = "start",
	},
	Sister = {
		tree = Scene11.SisterDialogueTree,
		defaultStartNode = "start",
	},
	Teacher = {
		tree = Scene11.TeacherDialogueTree,
		defaultStartNode = "start",
	},
	Bully = {
		tree = Scene11.BullyDialogueTree,
		defaultStartNode = "start",
	},
	MainCharacter = {
		tree = Scene11.MainCharacterDialogueTree,
		defaultStartNode = "scene11Start",
	},
}

return Scene11