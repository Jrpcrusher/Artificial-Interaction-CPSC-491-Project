return {
	{
		Id = "pick_up_apple",
		Title = "Find the Apple",
		Objective = "Look around the room for the Apple.",
		Steps = "Search the floor next to Spawn.",
		Type = "Required",
		Completed = false,
	},
	{
		Id = "talk_to_dad",
		Title = "Talk to Dad",
		Objective = "Speak with Dad.",
		Steps = "Walk over to Dad and press E.",
		Type = "Required",
		Completed = false,
	},
	{
		Id = "talk_to_mom",
		Title = "Talk to Mom",
		Objective = "Speak with Mom.",
		Steps = "Walk over to Mom and press E.",
		Type = "Required",
		Completed = false,
	},

	{ -- if all tasks are done, we use this task to go to next scene
		Id = "go_to_door",
		Title = "Go to the Door",
		Objective = "Head to the door and leave.",
		Steps = "Walk to the door and press interact.",
		Type = "Required",
		Completed = false,
	},
}