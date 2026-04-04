local DataStoreService = game:GetService("DataStoreService")
local message_database = DataStoreService:GetDataStore("message_database")

local Transcript = {}

-- Per-player storage (Multiplayer Safe)
local message_store = {}     -- message_store[user_id] = {messages}
local active_user = {}       -- active_user[player] = user_id

function Transcript.Create(user_id) -- Method to save all messages
	active_user[user_id] = user_id
	message_store[user_id] = {}
	return true, "New transcript created."
end

function Transcript.Add(user_id, compiled_message) -- Method to add message after transcript made
	if not message_store[user_id] then
		message_store[user_id] = {}
	end
	table.insert(message_store[user_id], compiled_message)
	return message_store[user_id], "Message added successfully."
end

function Transcript.Load(user_id) -- Method to get all messages from database
	local data = message_database:GetAsync(user_id)
	message_store[user_id] = data or {}
	return message_store[user_id], "Messages retrieved from database."
end

function Transcript.Save(user_id) -- Handles saving to database
	message_database:SetAsync(user_id, message_store[user_id] or {})
	return message_store[user_id], "Messages saved to database."
end

function Transcript.Get(user_id) -- Retrieval method if loading already occurred
	return message_store[user_id]
end

function Transcript.Delete(user_id) -- Handles deleting from database
	message_database:RemoveAsync(user_id)
	message_store[user_id] = {}
	return {}, "Messages deleted from database."
end

return Transcript