-- References to DataStoreService and creating a data store.
local DataStoreService = game:GetService("DataStoreService")
local save_datastore = DataStoreService:GetDataStore("save_datastore")

-- Container to hold game saves.
local GameSaveManager = {}
