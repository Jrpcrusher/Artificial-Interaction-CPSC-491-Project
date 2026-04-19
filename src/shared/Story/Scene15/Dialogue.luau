local Scene15 = {}

Scene15.Sister = {
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
}

Scene15.Player = {
	scene15Task2Response = {
		speaker = "Sister",
		text = "Why... why would you do something like that? Do you have any idea how close I came to losing you?",
		next = "scene15Task2MCReply1",
	},

	scene15Task2MCReply1 = {
		speaker = "You",
		text = "I don't know anymore… everything just felt so heavy. Like no matter what I did, it wouldn't get better. I thought… I thought maybe it would just stop hurting.",
		next = "scene15Task2Response2",
	},

	scene15Task2Response2 = {
		speaker = "Sister",
		text = "You don't have to carry that alone. You never did. I'm right here. I've always been right here… you just had to let me in.",
		next = "scene15Task2MCReply2",
	},

	scene15Task2MCReply2 = {
		speaker = "You",
		text = "I didn't want to be a burden. Everyone already has so much going on… I thought if I kept it to myself, it wouldn't hurt anyone else.",
		next = "scene15Task2Response3",
	},

	scene15Task2Response3 = {
		speaker = "Sister",
		text = "Losing you would hurt more than anything. You're not a burden—you're my family. We figure things out together, even when it's messy, even when it's hard.",
		next = "scene15Task2MCReply3",
	},

	scene15Task2MCReply3 = {
		speaker = "You",
		text = "I was so scared… and I didn't think anyone could understand what was going on in my head.",
		next = "scene15Task2Response4",
	},

	scene15Task2Response4 = {
		speaker = "Sister",
		text = "Maybe I won't understand everything. But I'll sit with you through it. I'll listen. That's what matters. You don't have to make sense of it all tonight.",
		next = "scene15end",
	},

	scene15end = {
		speaker = "You",
		text = "…Thank you. I should have come to you. Or mom. Or anyone who actually cares about me. I don't want to feel like this anymore—and I don't want to face it alone.",
	},
}

Scene15.Registry = {
	Sister = {
		tree = Scene15.Sister,
		defaultStartNode = "scene15Start",
	},

	Player = {
		tree = Scene15.Player,
		defaultStartNode = "scene15Task2Response",
	},
}

return Scene15
