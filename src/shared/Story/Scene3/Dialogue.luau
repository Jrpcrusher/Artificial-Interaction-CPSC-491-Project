local Scene3 = {}

Scene3.Player = {
	-- phase 1: entering school/locker scene
	start = {
		speaker = "You",
		text = "Just... stay calm. It doesn't matter.",
		next = "friend_intro",
	},

	friend_intro = {
		speaker = "Friend",
		text = "Hey, what are you doing today?",
		next = "reply_to_friend",
	},

	reply_to_friend = {
		speaker = "You",
		text = "...Nothing much. I'm going to get to class now, once you let me put my stuff away...",
		next = "friend_reply_back"
	},

	friend_reply_back = {
		speaker = "Friend",
		text = "...Alright man. Catch you later."
	},

	-- phase 2: in class
	teacher_intro = {
		speaker = "Teacher",
		text = "Alright class. Today we will be doing something different.",
		next = "teacher_intro_2"
	},

	teacher_intro_2 = {
		speaker = "Teacher",
		text = "We will be going to the library to study. So please, grab a worksheet from the front of class, and head over to the library!"
	},

	-- phase 3: in library
	friend_notice = {
		speaker = "Friend",
		text = "Oh what are you watching this time? Is this another one of those romance ones I've caught you watching before?",
		choices = {
			{
				text = "▸ I am allowed to like the things I like.",
				next = "player_choice_1",
			},
			{
				text = "▸ Why should it matter to you?",
				next = "player_choice_2",
			},
			{
				text = "▸ Do you not have any hobbies of your own?",
				next = "player_choice_3",
			},
		},
	},

	player_choice_1 = {
		speaker = "You",
		text = "I am allowed to like the things I like, just because it doesn't align with you doesn't make it bad.",
		next = "friend_response_1",
	},

	player_choice_2 = {
		speaker = "You",
		text = "So what, why should it matter to you? Don't you have your own life to worry about?",
		next = "friend_response_2",
	},

	player_choice_3 = {
		speaker = "You",
		text = "Do you not have any hobbies other than trying to get me to conform to your standards? I don't need to be what you perceive as acceptable.",
		next = "friend_response_3",
	},

	friend_response_1 = {
		speaker = "Friend",
		text = "Just because that may be the case doesn't mean I have to accept you for it my guy. You really need to grow up a bit and realize everything you do people judge you for, including me.",
		next = "friend_exit",
	},

	friend_response_2 = {
		speaker = "Friend",
		text = "Which is exactly why I am telling you something. It's hard to relate to you when all you want to talk about is that stuff you keep watching.",
		next = "friend_exit",
	},

	friend_response_3 = {
		speaker = "Friend",
		text = "Standards are the norm. In the real world if you don't conform to what people want, you won't find anything. People want normal, so just be normal.",
		next = "friend_exit",
	},

	friend_exit = {
		speaker = "You",
		text = "...",
	},
}

Scene3.Registry = {
	Player = {
		tree = Scene3.Player,
		defaultStartNode = "start",
	},
}

return Scene3
