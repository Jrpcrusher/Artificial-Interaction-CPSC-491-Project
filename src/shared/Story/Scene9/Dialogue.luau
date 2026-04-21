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

Scene9.PlayerDialogueTree = {
	scene9Fight = {
		speaker = "You",
		text = "What happened?",
		next = "momReply"
	},
	momReply = {
		speaker = "Mom",
		text = "Oh what does it matter this cup fell, and its failing like this household!",
		next = "dadReply",
	},
	dadReply = {
		speaker = "Dad",
		text = "See this is exactly why you can’t be trusted with handling our situation, I need to handle taking care of this house!",
		next = "momReply2"
	},
	momReply2 = {
		speaker = "Mom",
		text = "Oh so now that I dropped a simple cup that makes me incapable? What is so incapable is you at managing your time wisely and not being supportive to this family",
		next = "dadReply2"
	},
	dadReply2 = {
		speaker = "Dad",
		text = "There you go again with that stupid accusation, I wish you would just shut up and let me go about my day!",
		next = "userReply",
	},
	userReply = {
		speaker = "You",
		text = "(Sigh) I should tell Charlie about this, maybe it will help."
	}
}

Scene9.Registry = {
	Sister = {
		tree = Scene9.SisterDialogueTree,
		defaultStartNode = "scene9Start"
	},
	Player = {
		tree = Scene9.PlayerDialogueTree,
		defaultStartNode = "scene9Fight"
	}
}

return Scene9