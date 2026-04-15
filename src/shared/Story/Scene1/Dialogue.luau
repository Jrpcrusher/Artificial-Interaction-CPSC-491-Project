-- NOTE: delete later...\/
--[[ Scene 1 inner dialogue: START
The alarm clock chimed as I awoken for the first day back to school.
It appeared evident to me that I was already running a little behind,
and so I needed to hurry in getting my things together.
I looked out the window to see that it was still slightly dark out,
was it raining, was  it overcast? “Is it raining…?” I asked myself,
unsure of the sight I was seeing from my window.
I couldn’t tell from the glint of light coming from my window alone.
There was no time to worry about such trivial matters, I had to get my belongings.
]]

-- user does tasks

--[[ Scene 1, stairs dialogue: OUT THE DOOR
As I walked down the stairs,
I could hear the faint talking of my parents and sister.
I could almost make out what they were saying. 
]]

--[[ Scene 1, final dialogue before scene 2
I should introduce myself first however before proceeding.
I, am a High Achieving student. I’ve always gotten good grades,
and I’ve not had all that many problems at school,
but recently tension at home has started getting to me.
My parents argue often about spending time together,
and that my dad is never around for us as he should be.
I Understand he's busy, but my mom tends to think otherwise.
Their fighting and arguing sometimes gets to me,
despite how much I try to ignore it.
It takes a mental toll handling such events at home.
Its sometimes why I can’t wait to go to school, get away from it all.
]]

local Scene1 = {}

Scene1.Player = {
	start = {
		speaker = "You",
		text = "Is it raining...?",
		next = "dialogue2",
	},
	dialogue2 = {
		speaker = "You",
		text = "I should grab my things so I can get ready for school.",
	},
}

Scene1.Registry = {
	Player = {
		tree = Scene1.Player,
		defaultStartNode = "start",
	},
}

return Scene1
