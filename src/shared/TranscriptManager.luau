local DataStoreService = game:GetService("DataStoreService")
local message_database = DataStoreService:GetDataStore("message_database")

local Transcript = {}

local message_store = {}

function Transcript.Create(user_id) -- Method to save all messages
	if message_store[user_id] then -- if already made, skip making again
		error("message storage already made")
		return false, "New transcript fail, one already exists."
	end

	message_store[user_id] = {} -- initialize the message store to be a dictionary, equal to a list
	return true, "New transcript created."
end

function Transcript.Add(user_id, compiled_message) -- Method to add message after transcript made
	table.insert(message_store[user_id], compiled_message)
	return message_store, "Message added successfully."
end

function Transcript.Reset(time) -- Method to reset messages to when the users last save point is
	return 0
end

function Transcript.Get(user_id) -- Method to get all messages from database
	return 0
end

function Transcript.Save(user_id) -- Handles saving to database
	return 0
end

function Transcript.Delete() -- Handles deleting from database
	return 0
end

return Transcript
