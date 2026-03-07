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

function Transcript.Reset(delete_after, user_id) -- Method to reset messages to when the users last save point is
	local ordered_messages = message_store[user_id]
	for i = #ordered_messages, 1, -1 do -- For the time message dictionary
		if ordered_messages[i].time > delete_after then -- If the time is after the time of last save
			table.remove(ordered_messages, i) -- remove it
		end
	end
	return ordered_messages, "Messages after last save removed."
end

function Transcript.Get(user_id) -- Method to get all messages from database
	message_database:GetAsync(user_id)
	return message_store, "Messages retrieved from database."
end

function Transcript.Save(user_id) -- Handles saving to database
	message_database:SetAsync(user_id, message_store[user_id])
	return message_store, "Messages saved to database."
end

function Transcript.Delete(user_id) -- Handles deleting from database
	message_database:RemoveAsync(user_id)
	return message_store, "Messages deleted from database."
end

return Transcript
