local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TaskService = require(ReplicatedStorage.Shared.Systems.Tasks.TaskService)

local Progression = {}

function Progression.Start()
    local player = Players:GetPlayers()[1]
    local sceneNumber = 14

    TaskService.ResetForScene(player, sceneNumber)

    -- Phase 1
    TaskService.LoadTasks(player, sceneNumber, {
        "go_to_room",
    })

    repeat
        task.wait()
    until TaskService.AreTasksComplete(player, {
        "go_to_room",
    })

    -- Phase 2
    TaskService.LoadTasks(player, sceneNumber, {
        "tell_charlie_mom_being_destructive",
        "tell_charlie_about_fight_at_school",
    })

    repeat
        task.wait()
    until TaskService.AreTasksComplete(player, {
        "tell_charlie_mom_being_destructive",
        "tell_charlie_about_fight_at_school",
    })

    -- Phase 3
    TaskService.LoadTasks(player, sceneNumber, {
        "ask_charlie_for_specific_solution",
    })

    repeat
        task.wait()
    until TaskService.AreTasksComplete(player, {
        "ask_charlie_for_specific_solution",
    })

    -- Phase 4
    TaskService.LoadTasks(player, sceneNumber, {
        "grab_computer_cord",
    })

    repeat
        task.wait()
    until TaskService.AreTasksComplete(player, {
        "grab_computer_cord",
    })

    -- Phase 5
    TaskService.LoadTasks(player, sceneNumber, {
        "go_to_chair",
    })

    repeat
        task.wait()
    until TaskService.AreTasksComplete(player, {
        "go_to_chair",
    })
end

return Progression