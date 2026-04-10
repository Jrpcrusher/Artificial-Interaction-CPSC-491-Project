local SceneData = {
    SceneId = "Scene1",
    RequiredTasks = {
        "grab_backpack",
        "grab_calculator",
        "grab_keys",
        "go_to_door",
    },

    Objects = {
        Backpack = "Backpack",
        Calculator = "Calculator",
        Keys = "Keys",
        BedroomDoor = "BedroomDoor",
    },

    DialogueIds = {
        IntroThought = "scene1_intro_thought",
        OutroThought = "scene1_outro_thought",
    }
}

return SceneData