local Scene1 = {}

Scene1.DialogueTree = {
	start = {
		speaker = "Guard",
		text = "Pay up, or I'll show you what we do with scum like you.",
		choices = {
			{
				text = "▸ I'll pay the fine.",
				next = "payFine",
			},
			{
				text = "▸ I accept my punishment.",
				next = "acceptPunishment",
			},
			{
				text = "▸ Let me go, or else.",
				next = "threatenGuard",
			},
		},
	},
	payFine = {
		speaker = "Guard",
		text = "Smart choice. Hand it over and this ends here.",
		next = "guardTakesMoney",
	},
	guardTakesMoney = {
		speaker = "You",
		text = "...Fine. Take it.",
		next = "guardResponse",
	},
	guardResponse = {
		speaker = "Guard",
		text = "Good. Now get out of my sight.",
	},
	acceptPunishment = {
		speaker = "Guard",
		text = "At least you know your place.",
	},
	threatenGuard = {
		speaker = "Guard",
		text = "Big words for someone standing alone.",
	},
}

function Scene1.Load()

end

function Scene1.Unload()

end
return Scene1
