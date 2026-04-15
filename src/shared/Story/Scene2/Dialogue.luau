local Scene2 = {}

-- Dad dialogue for scene 2
Scene2.Player = {
	start = {
		speaker = "Sister",
		text = "I got a perfect score on my vocab quiz yesterday, look look!",
		next = "mom_response",
	},
	mom_response = {
		speaker = "Mom",
		text = "You take after your older sibling don't you sweetheart. We all could learn how to use words to communicate a little better now couldn't we.",
		next = "internal_dialogue1",
	},
	internal_dialogue1 = {
		speaker = "You",
		text = "(Internal) Please don't start ana rgument now. This is supposed to be a happy moment...",
		next = "dad_response",
	},
	dad_response = {
		speaker = "Dad",
		text = "Don't start with that again, I try very hard to communicate with you and how I feel, but sometimes you don't take the hint!",
		next = "internal_dialogue2",
	},
	internal_dialogue2 = {
		speaker = "You",
		text = "(Under Breath) Not again...",
	},
}

-- Mom dialogue for scene 2
Scene2.Mom = {
	start = {
		speaker = "Mom",
		text = "Off to school dear?",
		choices = {
			{
				text = "Are you okay mom, it's hard to hear you and dad talk like that.",
				next = "mom_response_1",
			},
			{
				text = "I'm proud of Sis getting such a wonderfuls core on her vocab test!",
				next = "mom_response_2",
			},
			{
				text = "I'm off to school now...",
				next = "mom_response_3",
			},
		},
	},
	mom_response_1 = {
		speaker = "Mom",
		text = "I am okay dear don't worry, we always sort out our differences right? I'm okay and hes okay, don't overthink it too much okay? I'm sorry for making you worry.",
	},
	mom_response_2 = {
		speaker = "Mom",
		text = "I know! She did a wonderful job and I am so proud of her, she takes after you it seems. You do so well at school it's no wonder she does so well. Shes aspiring to be like you!",
	},
	mom_response_3 = {
		speaker = "Mom",
		text = "Alright take care, love you okay?",
	},
}

-- Dad dialogue for scene 2
Scene2.Dad = {
	start = {
		speaker = "Dad",
		text = "Morning, kiddo.",
		choices = {
			{
				text = "▸ What doesn't mom communicate about? I don't understand.",
				next = "dad_choice_1",
			},
			{
				text = "▸ I'm off to school now...",
				next = "dad_choice_2",
			},
		},
	},

	dad_choice_1 = {
		speaker = "You",
		text = "What doesn't mom communicate about? I don't understand.",
		next = "dad_response_1",
	},

	dad_choice_2 = {
		speaker = "You",
		text = "I'm off to school now...",
		next = "dad_response_2",
	},

	dad_response_1 = {
		speaker = "Dad",
		text = "Sometimes your mom just doesn't seem to understand that I need to know how she feels. Its hard to guess what she's thinking if she doesn't tell me. But try not to worry about that okay, this is between you and your mom. Its not anything to worry about okay?",
	},

	dad_response_2 = {
		speaker = "Dad",
		text = "Alright kiddo be safe okay?",
	},
}

Scene2.Sister = {
	start = {
		speaker = "Sister",
		text = "Hey, are you heading out?",
		choices = {
			{
				text = "▸ I don't like how mom and dad talk to each other.",
				next = "sister_choice_1",
			},
			{
				text = "▸ I'm proud of you for doing so well on your quiz!",
				next = "sister_choice_2",
			},
			{
				text = "▸ I'm off to school now...",
				next = "sister_choice_3",
			},
		},
	},

	sister_choice_1 = {
		speaker = "You",
		text = "I don't like how mom and dad talk to each other.",
		next = "sister_response_1",
	},

	sister_choice_2 = {
		speaker = "You",
		text = "I'm proud of you for doing so well on your quiz!",
		next = "sister_response_2",
	},

	sister_choice_3 = {
		speaker = "You",
		text = "I'm off to school now...",
		next = "sister_response_3",
	},

	sister_response_1 = {
		speaker = "Sister",
		text = "I know, sometimes its hard to hear but I know they love each other. Its okay and we are okay, we have each other at anything!",
	},

	sister_response_2 = {
		speaker = "Sister",
		text = "It was insane to think that I did so well, thank you for helping me the other night in studying for it. You are a big help!",
	},

	sister_response_3 = {
		speaker = "Sister",
		text = "Alright bye bye, I'll see you after I get home from school as well.",
	},
}

Scene2.Registry = {
	Sister = {
		tree = Scene2.Sister,
		defaultStartNode = "start",
	},
	Player = {
		tree = Scene2.Player,
		defaultStartNode = "start",
	},
	Dad = {
		tree = Scene2.Dad,
		defaultStartNode = "start",
	},
	Mom = {
		tree = Scene2.Mom,
		defaultStartNode = "start",
	},
}

return Scene2
