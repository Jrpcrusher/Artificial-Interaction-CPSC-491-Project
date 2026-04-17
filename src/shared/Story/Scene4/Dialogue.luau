local Scene4 = {}

Scene4.Player = {
	start = {
		speaker = "Dad",
		text = "I need to put more time into work. Things aren't stable right now and I can't just sit around while everything piles up.",
		next = "mom_response_1",
	},

	mom_response_1 = {
		speaker = "Mom",
		text = "And what about us? You don't listen to what I need from you. I can't keep doing all of this by myself.",
		next = "dad_response_2",
	},

	dad_response_2 = {
		speaker = "Dad",
		text = "I'm trying to keep everything together! If I don't push harder, things are going to fall apart.",
		next = "mom_response_2",
	},

	mom_response_2 = {
		speaker = "Mom",
		text = "And I'm already falling apart. I barely have time to breathe anymore.",
		next = "listen_end",
	},

	listen_end = {
		speaker = "You",
		text = "...",
		next = "go_to_room",
	},

	go_to_room = {
		speaker = "You",
		text = "I should just go lay down.",
	},
}

-- OPTIONAL SISTER DIALOGUE
Scene4.Sister = {
	start = {
		speaker = "Sister",
		text = "Oh, hey... you're back already.",
		next = "choice",
	},

	choice = {
		speaker = "You",
		text = "...",
		choices = {
			{
				text = "▸ What are you drawing?",
				next = "player_choice_1",
			},
			{
				text = "▸ I'll talk to you later.",
				next = "player_choice_2",
			},
		},
	},

	player_choice_1 = {
		speaker = "You",
		text = "What are you drawing?",
		next = "sister_response_1",
	},

	player_choice_2 = {
		speaker = "You",
		text = "I'll talk to you later.",
		next = "sister_response_2",
	},

	sister_response_1 = {
		speaker = "Sister",
		text = "Just something random... it helps me not think about everything else.",
		next = "sister_response_3",
	},

	sister_response_2 = {
		speaker = "Sister",
		text = "Okay... I'll be here.",
	},

	sister_response_3 = {
		speaker = "Sister",
		text = "You hear them too, right...?",
		next = "sister_response_4",
	},

	sister_response_4 = {
		speaker = "You",
		text = "...Yeah.",
	},
}

Scene4.Registry = {
	Player = {
		tree = Scene4.Player,
		defaultStartNode = "start",
	},
	Sister = {
		tree = Scene4.Sister,
		defaultStartNode = "start",
	},
}

return Scene4
