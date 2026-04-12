local DataStoreService = game:GetService("DataStoreService")
local message_database = DataStoreService:GetDataStore("message_database")

local Transcript = {}

local message_store = {} -- message_store[user_id] = {messages}

function Transcript.Create(user_id) -- Method to save all messages
	message_store[user_id] = {}
	return true, "New transcript created."
end

function Transcript.Add(user_id, compiled_messages) -- Method to add message after transcript made
	if not message_store[user_id] then
		message_store[user_id] = {}
	end
	table.insert(message_store[user_id], compiled_messages)
	return message_store[user_id], "Message added successfully."
end

function Transcript.Load(user_id) -- Method to get all messages from database
	local success, result = pcall(function()
		return message_database:GetAsync(user_id)
	end)

	if not success then
		warn("Load failed:", result)
		return false, nil
	end

	if result == nil then
		return true, nil
	end

	message_store[user_id] = result
	return true, result
end

function Transcript.Save(user_id) -- Handles saving to database
	local success, result = pcall(function()
		message_database:SetAsync(user_id, message_store[user_id] or {})
	end)

	if not success then
		warn("Save failed:", result)
		return false, "Failed to save messages"
	end

	return true, "Messages saved to database"
end

function Transcript.Get(user_id) -- Retrieval method if loading already occurred
	return message_store[user_id]
end

function Transcript.Delete(user_id) -- Handles deleting from database
	local success, result = pcall(function()
		message_database:RemoveAsync(user_id)
	end)

	if not success then
		warn("Delete failed:", result)
		return false, "Failed to delete messages"
	end

	message_store[user_id] = {}
	return true, "Messages deleted from database."
end

return Transcript
