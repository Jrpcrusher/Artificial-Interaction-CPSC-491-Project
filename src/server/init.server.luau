print("Hello world, from server!")

local Query = require(game.ReplicatedStorage.Shared.Query)

local reply = Query.AskAI("hi")
print("AI Responded with", reply)
