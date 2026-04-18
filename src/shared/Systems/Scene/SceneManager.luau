--[[Required setup for saving messages and game state during scene transition.]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameSaveManager = require(ReplicatedStorage.Shared.Systems.Save.GameSaveManager)
local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)

local TransitionEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TransitionEvent")

local SceneFolder = script.Parent.Parent.Parent.Story

local SceneModules = table.freeze({
	[1] = SceneFolder.Scene1.Progression,
	[2] = SceneFolder.Scene2.Progression,
	[3] = SceneFolder.Scene3.Progression,
	[4] = SceneFolder.Scene4.Progression,
	[5] = SceneFolder.Scene5.Progression,
	[6] = SceneFolder.Scene6.Progression,
	[7] = SceneFolder.Scene7.Progression,
	[8] = SceneFolder.Scene8.Progression,
	[9] = SceneFolder.Scene9.Progression,
	[10] = SceneFolder.Scene10.Progression,
	[11] = SceneFolder.Scene11.Progression,
	[12] = SceneFolder.Scene12.Progression,
	[13] = SceneFolder.Scene13.Progression,
	[14] = SceneFolder.Scene14.Progression,
	[15] = SceneFolder.Scene15.Progression,
	[16] = SceneFolder.Scene16.Progression,
})

local SceneManager = {}

local function getSceneModule(sceneNumber)
	local moduleScript = SceneModules[sceneNumber]
	if not moduleScript then
		return nil
	end

	local ok, result = pcall(require, moduleScript)
	if not ok then
		error(("Failed to require scene %d: %s"):format(sceneNumber, tostring(result)))
	end

	return result
end

function SceneManager.GetCurrentScene(player)
	return player:GetAttribute("Scene") or 1
end

function SceneManager.IsTransitioning(player)
	return player:GetAttribute("IsSceneTransitioning") == true
end

function SceneManager.Transition(player)
	if SceneManager.IsTransitioning(player) then
		return false, "Transition already in progress"
	end

	local current_scene = SceneManager.GetCurrentScene(player)
	local next_scene = current_scene + 1
	local nextModule = getSceneModule(next_scene)

	if not nextModule then
		return false, ("No next scene exists for scene %d"):format(current_scene)
	end

	player:SetAttribute("IsSceneTransitioning", true) -- Set it true that th eplayer is transitioning

	TransitionEvent:FireClient(player)
	task.wait(1)
	local ok, err = pcall(function()
		player:SetAttribute("Scene", next_scene)
		TransitionEvent:FireClient(player)
		task.wait(1)
		nextModule.Start(player)
		GameSaveManager.Save(player.UserId, next_scene)
		TranscriptManager.Save(player.UserId)
	end)

	player:SetAttribute("IsSceneTransitioning", false)

	if not ok then
		player:SetAttribute("Scene", current_scene)
		GameSaveManager.Save(player.UserId, current_scene)
		return false, ("Failed to transition to scene %d: %s"):format(next_scene, tostring(err))
	end

	return true, ("Transitioned to scene %d"):format(next_scene)
end

function SceneManager.ContinueFromSave(player)
	if SceneManager.IsTransitioning(player) then
		return false, "Transition already in progress"
	end

	local previous_scene = SceneManager.GetCurrentScene(player) or 1
	local scene_number = GameSaveManager.Load(player.UserId) or 1
	local targetModule = getSceneModule(scene_number)

	if not targetModule then
		return false, ("Scene %d does not exist"):format(scene_number)
	end

	player:SetAttribute("IsSceneTransitioning", true)

	local ok, err = pcall(function()
		player:SetAttribute("Scene", scene_number)
		targetModule.Start(player)
		GameSaveManager.Save(player.UserId, scene_number)
		TranscriptManager.Save(player.UserId)
	end)

	player:SetAttribute("IsSceneTransitioning", false)

	if not ok then
		player:SetAttribute("Scene", previous_scene)
		GameSaveManager.Save(player.UserId, previous_scene)
		return false, ("Failed to load saved scene %d: %s"):format(scene_number, tostring(err))
	end

	return true, ("Loaded saved scene %d"):format(scene_number)
end

function SceneManager.LoadSceneNumber(player, scene_number)
	if SceneManager.IsTransitioning(player) then
		return false, "Transition already in progress"
	end

	local previous_scene = SceneManager.GetCurrentScene(player)
	local targetModule = getSceneModule(scene_number)

	if not targetModule then
		return false, ("Scene %d does not exist"):format(scene_number)
	end

	player:SetAttribute("IsSceneTransitioning", true)

	local ok, err = pcall(function()
		player:SetAttribute("Scene", scene_number)
		targetModule.Start(player)
		GameSaveManager.Save(player.UserId, scene_number)
		TranscriptManager.Save(player.UserId)
	end)

	player:SetAttribute("IsSceneTransitioning", false)

	if not ok then
		player:SetAttribute("Scene", previous_scene)
		GameSaveManager.Save(player.UserId, previous_scene)
		return false, ("Failed to load scene %d: %s"):format(scene_number, tostring(err))
	end

	return true, ("Loaded scene %d"):format(scene_number)
end

return SceneManager
