local TaskConfig = {}

TaskConfig.Tasks = {
	{
		Id = "task_001",
		Title = "Find the Journal",
		Objective = "Look around the room for the missing journal.",
		Steps = "Search the desk near the window.",
		Type = "Required",
		Completed = true,
	},
	{
		Id = "task_002",
		Title = "Read the Side Note",
		Objective = "Read the note for extra context.",
		Steps = "Open the note after picking it up.",
		Type = "Optional",
		Completed = false,
	},
	{
		Id = "task_003",
		Title = "Talk to the NPC",
		Objective = "Speak to the NPC near the hall.",
		Steps = "Walk over and press interact.",
		Type = "Required",
		Completed = true,
	},
}

return TaskConfig