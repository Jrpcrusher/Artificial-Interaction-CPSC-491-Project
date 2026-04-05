local Scene1 = {}

Scene1.DadDialogueTree = {
	scene1Start = {
		speaker = "Dad",
		text = "You finally woke up.",
		next = "scene1Reply"
	},

	scene1Reply = {
		speaker = "You",
		text = "Where am I?"
	},

	scene2Start = {
		speaker = "Dad",
		text = "We do not have much time.",
		choices = {
			{
				text = "▸ What is going on?",
				next = "scene2Explain"
			},
			{
				text = "▸ I am ready.",
				next = "scene2Ready"
			}
		}
	},

	scene2Explain = {
		speaker = "Dad",
		text = "Then listen carefully."
	},

	scene2Ready = {
		speaker = "Dad",
		text = "Good."
	},

	afterTaskStart = {
		speaker = "Dad",
		text = "You found it?"
	}
}

function Scene1.Load()

end

function Scene1.Unload()

end
return Scene1
