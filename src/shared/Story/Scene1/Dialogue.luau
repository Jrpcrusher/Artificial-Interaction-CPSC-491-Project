local Dialogue = {
	Start = {
		"The alarm clock chimed as I awoke for the first day back to school.",
		"It was obvious I was already running a little behind, so I needed to hurry and get my things together.",
		"I looked out the window. It was still slightly dark out.",
		"Was it raining...? Was it just overcast?",
		"Is it raining...?",
		"I couldn't tell from the glint of light coming through the window alone.",
		"There was no time to worry about that. I had to get my belongings."
	},

	NotReady = {
		"I should get everything I need before heading downstairs."
	},

	Stairs = {
		"As I walked down the stairs, I could hear the faint talking of my parents and sister.",
		"I could almost make out what they were saying."
	},

	Final = {
		"I should introduce myself first before proceeding.",
		"I am a high-achieving student.",
		"I've always gotten good grades, and I haven't had all that many problems at school.",
		"But recently, tension at home has started getting to me.",
		"My parents argue often about spending time together, and that my dad is never around for us as he should be.",
		"I understand he's busy, but my mom tends to think otherwise.",
		"Their fighting and arguing sometimes gets to me, despite how much I try to ignore it.",
		"It takes a mental toll handling things like that at home.",
		"Sometimes that's why I can't wait to go to school, to get away from it all."
	}
}

return Dialogue

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




-- FOR REFERENCE:
--[[ local Scene1 = {}

Scene1.DadDialogueTree = {
 	scene1Start = {
 		speaker = "Dad",
 		text = "You finally woke up.",
 		next = "scene1Reply"
 	},

	scene1Reply = {
		speaker = "You",
		text = "Where am I?",
	}
}

Scene1.MomDialogueTree = {}

Scene1.SisterDialogueTree = {}

Scene1.TeacherDialogueTree = {}

Scene1.BullyDialogueTree = {}

Scene1.MainCharacterDialogueTree = {}

Scene1.Registry = {
	Dad = {
		tree = Scene1.DadDialogueTree,
		defaultStartNode = "scene1Start",
	},

	Mom = {
		tree = Scene1.MomDialogueTree,
		defaultStartNode = "start",
	},

	Sister = {
		tree = Scene1.SisterDialogueTree,
		defaultStartNode = "start",
	},

	Teacher = {
		tree = Scene1.TeacherDialogueTree,
		defaultStartNode = "start",
	},

	Bully = {
		tree = Scene1.BullyDialogueTree,
		defaultStartNode = "start",
	},

	MainCharacter = {
		tree = Scene1.MainCharacterDialogueTree,
		defaultStartNode = "start",
	},
}

Scene1.SisterDialogueTree = {

}

Scene1.TeacherDialogueTree = {

}

Scene1.BullyDialogueTree = {

}

Scene1.MainCharacterDialogueTree = {

}

return Scene1
]]
