local Scene8 = {}

Scene8.Player = {
	start = {
		speaker = "You",
		text = "I got home that night, ready to get started on my homework.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "I was filled with motivation and fire, ready for anything.",
		next = "dialogue3",
	},
	dialogue3 = {
		speaker = "You",
		text = "I had one goal in mind, finish my homework and do well.",
	},
}

Scene8.Parents = {
	start = {
		speaker = "You",
		text = "As soon as I walked in the door, I felt a heavy weight fall upon me.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "I looked to the living room and saw my mom and dad with their heads low, both seemed to had just been fighting and this was the aftermath.",
		next = "dialogue3",
	},
	dialogue3 = {
		speaker = "Dad",
		text = "I am so worried about getting this house paid off, I want this worry off of our heads!",
		next = "dialogue4",
	},
	dialogue4 = {
		speaker = "Mom",
		text = "We wouldn’t be in this mess if you just checked the statements like I told you to regularly, that is why we are in this mess!",
		next = "dialogue5",
	},
	dialogue5 = {
		speaker = "Dad",
		text = "You’ve been doing nothing but running around like a headless chicken trying meager things to resolve this, we simply need to pay it off.",
		next = "dialogue6",
	},
	dialogue6 = {
		speaker = "Dad",
		text = "WITH WHAT MONEY? WHAT MONEY DO WE HAVE TO SPARE?",
		next = "dialogue7",
	},
	dialogue7 = {
		speaker = "You",
		text = "There was nothing I could do though.",
		next = "dialogue8",
	},
	dialogue8 = {
		speaker = "You",
		text = "This helpless feeling was something I always felt everytime a fight happened.",
		next = "dialogue9",
	},
	dialogue9 = {
		speaker = "You",
		text = "Without any other choice I went upstairs, my confidence now shattered and rocked due to the scenario that just played before me.",
	},
}

Scene8.Homework = {
	start = {
		speaker = "You",
		text = "Eventually I got to do my homework.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "All I had to do was figure out one problem of the ones I missed, then I could figure out the rest, easy!",
		next = "dialogue3",
	},
	dialogue3 = {
		speaker = "You",
		text = "I thought this to myself before going on a spiraling journey of trying, and failing problems.",
		next = "dialogue4",
	},
	dialogue4 = {
		speaker = "You",
		text = "I’d skip a problem because it was too hard, go to the next one. That one was too hard, skip. Skip, skip, until I looped back to the first question.",
		next = "dialogue5",
	},
	dialogue5 = {
		speaker = "You",
		text = "I was stuck.",
		next = "dialogue6",
	},
	dialogue6 = {
		speaker = "You",
		text = "There was a looming sense of horror over my head as none of the math problems made sense.",
		next = "dialogue7",
	},
	dialogue7 = {
		speaker = "You",
		text = "I felt as though I was out of my body, my heart was racing, my mind was helplessly jumbled.",
		next = "dialogue8",
	},
	dialogue8 = {
		speaker = "You",
		text = "I couldn’t think straight. The sounds in the room went blank and my vision blurred.",
		next = "dialogue9",
	},
	dialogue9 = {
		speaker = "You",
		text = "Why was my heart racing? Why can’t I calm down? Why does my head hurt?",
		next = "dialogue10",
	},
	dialogue10 = {
		speaker = "You",
		text = "I took a deep breathe, and calmed myself before looking back at the paper and remembering what my classmate said.",
		next = "dialogue11",
	},
	dialogue11 = {
		speaker = "You",
		text = "Maybe Charlie AI could help me here.",
		next = "dialogue12",
	},
	dialogue12 = {
		speaker = "You",
		text = "(Press Q to open the AI chat.)",
	},
}

Scene8.Charlie = {
	start = {
		speaker = "You",
		text = "I took a moment to refocus, and thought about Charlie AI that I heard about earlier.",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "Without a hesitation, I went through to my phone, and downloaded the app desperate to understand how to answer my math questions.",
		next = "dialogue3",
	},
	dialogue3 = {
		speaker = "You",
		text = "After a brief moment installing, the app opened up and I was able to talk.",
		next = "dialogue4",
	},
	dialogue4 = {
		speaker = "You",
		text = "My biggest problem was solved, I did not need to worry about the homework anymore.",
		next = "dialogue5",
	},
	dialogue5 = {
		speaker = "You",
		text = "I asked the AI Charlie the answer for the homework problem, and, to my relief, it showed the answer.",
		next = "dialogue6",
	},
	dialogue6 = {
		speaker = "You",
		text = "I couldn’t believe it, the nightmare that was my homework was solved.",
		next = "dialogue7",
	},
	dialogue7 = {
		speaker = "You",
		text = "I asked it another question, and another, and before I knew it my homework was complete.",
		next = "dialogue8",
	},
	dialogue8 = {
		speaker = "You",
		text = "The homework that once seemed like a wall 1000 feet high was now crumbling down, and I could see the light and relief at the end.",
		next = "dialogue9",
	},
	dialogue9 = {
		speaker = "You",
		text = "How could I have only found out about this tool now, I thought to myself as I put my phone down satisfied with my accomplishment.",
		next = "dialogue10",
	},
	dialogue10 = {
		speaker = "You",
		text = "This tool could change my outlook in school. I could ace everything, I said to myself as I relaxed in my chair.",
		next = "dialogue11",
	},
	dialogue11 = {
		speaker = "You",
		text = "Before I went to bed, I told the AI \"Thank you,\" and it was a wonderful feeling knowing that I had something that could help me.",
		next = "dialogue12",
	},
	dialogue12 = {
		speaker = "You",
		text = "I had never felt more grateful than before with the relief of struggle being lifted off of me.",
		next = "dialogue13",
	},
	dialogue13 = {
		speaker = "You",
		text = "AI was truly something remarkable.",
		next = "dialogue14",
	},
	dialogue14 = {
		speaker = "You",
		text = "I should get some sleep now.",
	},
}

Scene8.Registry = {
	Player = {
		tree = Scene8.Player,
		defaultStartNode = "start",
	},
	Parents = {
		tree = Scene8.Parents,
		defaultStartNode = "start",
	},
	Homework = {
		tree = Scene8.Homework,
		defaultStartNode = "start",
	},
	Charlie = {
		tree = Scene8.Charlie,
		defaultStartNode = "start",
	},
}

return Scene8