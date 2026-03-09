-- Initial file to set everything up for the user
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Progression = require(ReplicatedStorage.Shared.ProgressionManager) -- Module to keep track of the progression in the story
local TranscriptManager = require(ReplicatedStorage.Shared.TranscriptManager)

-----------------------------------------------------------------------------------
-- Section 1: This section gets the information about the user, including player name and userID
-----------------------------------------------------------------------------------
local Players = game:GetService("Players")
local player = Players.PlayerAdded:Wait() -- get the player information when they join
local user_id = player.UserId
local _, message = TranscriptManager.Create(user_id)
print(message)
-----------------------------------------------------------------------------------
-- Section 1: End
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 2: This section will handle GUI logic for when main menu is turned off.
-- When main menu gui = disabled load the game based on what the user requested, either recent save or new save
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 2: End
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 3: Now that we know what to do, load the scene based on Section 2
-----------------------------------------------------------------------------------
local newGame = true -- Temporary variable, remove this later

if newGame then
	Progression.Reset()
	-- Todo: add method to reset the chat messages between the user and AI
	-- Todo: Make method to update datastoreservice to remove the information of the previous save
else
	local game_state = Progression.Get()
	--Scenes.Load(game_state)
end
-----------------------------------------------------------------------------------
-- Section 3: End
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 4: On user disconnect
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Section 4: End
-----------------------------------------------------------------------------------
