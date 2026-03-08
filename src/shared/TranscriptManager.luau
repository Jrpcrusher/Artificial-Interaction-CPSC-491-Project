local DataStoreService = game:GetService("DataStoreService")
local message_database = DataStoreService:GetDataStore("message_database")

local Transcript = {}
__user_id = 0
local message_store = {}

function Transcript.Create(user_id) -- Method to save all messages
	__user_id = user_id
	if message_store[user_id] then -- if already made, skip making again
		error("message storage already made")
		return false, "New transcript fail, one already exists."
	end

	__user_id = user_id
	message_store[__user_id] = {} -- initialize the message store to be a dictionary, equal to a list
	return true, "New transcript created."
end

function Transcript.Add(compiled_message) -- Method to add message after transcript made
	table.insert(message_store[__user_id], compiled_message)
	return message_store, "Message added successfully."
end

function Transcript.Load() -- Method to get all messages from database
	return message_database:GetAsync(__user_id), "Messages retrieved from database."
end

function Transcript.Save() -- Handles saving to database
	message_database:SetAsync(__user_id, message_store[__user_id])
	return message_store, "Messages saved to database."
end

function Transcript.Get()
	return message_store
end

function Transcript.Delete() -- Handles deleting from database
	message_database:RemoveAsync(__user_id)
	return message_store, "Messages deleted from database."
end

return Transcript
