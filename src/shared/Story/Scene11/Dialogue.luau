local Scene11 = {}

Scene11.MomDialogueTree = {
	scene11Start = {
		speaker = "Mom",
		text = "Yeah we’re okay right now, we had a good discussion about things and we are moving forward a little with everything."
	}
}

Scene11.DadDialogueTree = {
	scene11Start = {
		speaker = "Dad",
		text = "You cheated, on a math quiz? What in the world were you thinking about cheating?! That is not the style of this household!",
		next = "momArgue1",
	},
	momArgue1 = {
		speaker = "Mom",
		text = "This is because you don’t spend time enough together! You shouldn’t be at work so much!",
		next = "dadArgue2",
	},
	dadArgue2 = {
		speaker = "Dad",
		text = "This is my fault now? How in the world is this my fault! This has NOTHING TO DO WITH WORK!",
		next = "momArgue2",
	},
	momArgue2 = {
		speaker = "Mom",
		text = "DO YOU NOT UNDERSTAND THAT THIS IS A SHOWCASE OF YOUR FAILURE AS A PARENT!",
		next = "dadArgue3",
	},
	dadArgue3 = {
		speaker = "Dad",
		text = "MY FAILURE? YOU COULD JUST AS EASILY HELP OUR CHILD OUT WITH THE HOMEWORK!",
		choices = {
			{
				text = "I'M SORRY!",
				next = "youRun"
			}
		}
	},
	youRun = {
		speaker = "You",
		text = "I'M SORRY! (You run to your room)"
	}
}

Scene11.Registry = {
	Dad = {
		tree = Scene11.DadDialogueTree,
		defaultStartNode = "scene11Start"
	},
	Mom = {
		tree = Scene11.MomDialogueTree,
		defaultStartNode = "scene11Start"
	},
}

return Scene11