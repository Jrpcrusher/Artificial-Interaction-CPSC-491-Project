local Scene11 = {}

Scene11.DadDialogueTree = {
	scene11Fight = {
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
	},

	-- separate dialogue for phone call
	phoneCall = {
		speaker = "Dad",
		text = "I wonder who that could be?",
		next = "monologue1",
	},
	speaker = "You",
	text = "Oh no, could that be school..?",
}

Scene11.PlayerDialogueTree = {
	scene11discussion = {
		speaker = "You",
		text = "(Internal) Mom and dad almost look happy..? I wonder whats happened.",
		next = "scene11discussion2"
	},
	scene11discussion2 = {
		speaker = "You",
		text = "Is everything okay?",
		next = "momReply"
	},
	momReply = {
		speaker = "Mom",
		text = "Yeah we’re okay right now, we had a good discussion about things and we are moving forward a little with everything.",
		next = "dadReply"
	},
	dadReply = {
		speaker = "Dad",
		text = "Yeah we talked about a few things, about work, and our arguing and we managed to make a little progress.",
		next = "monologue"
	},
	monologue = {
		speaker = "You",
		text = "(Internal) Wow mom and dad are getting along for once."
	}
}

Scene11.Registry = {
	Dad = {
		tree = Scene11.DadDialogueTree,
		defaultStartNode = "scene11Start"
	},
	Player = {
		tree = Scene11.PlayerDialogueTree,
		defaultStartNode = "scene11discussion"
	}
}

return Scene11