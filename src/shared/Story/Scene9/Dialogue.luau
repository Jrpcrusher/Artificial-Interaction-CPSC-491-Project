local Scene9 = {}

Scene9.SisterDialogueTree = {
	scene9Start = {
		speaker = "You",
		text = "What are you up to sis?",
		next = "scene9Reply",
	},
	scene9Reply = {
		speaker = "Sister",
		text = "I’m thinking about what I am going to have for lunch today at school, there’s two choices and I don’t know whether to go for the cheese pizza or the teriyaki chicken, what do you think?",
		choices = {
			{
				text = "You should choose the Pizza",
				next = "pizzaChoice"
			},
			{
				text = "You should choose the teriyaki chicken",
				next = "chickenChoice"
			}
		}
	},
	pizzaChoice = {
		speaker = "Sister",
		text = "That sounds yummy I was thinking that, Pizza is always delicious, I’ll go with that!"
	},
	chickenChoice = {
		speaker = "Sister",
		text = "That sounds like a good idea, I would normally go for the Pizza but I’ll spice it up today, thanks!"
	}
}

Scene9.Registry = {
	Sister = {
		tree = Scene9.SisterDialogueTree,
		defaultStartNode = "scene9Start"
	},
}

return Scene9