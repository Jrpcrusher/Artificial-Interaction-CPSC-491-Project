--[[Required setup for saving messages and game state during scene transition.]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameSaveManager = require(ReplicatedStorage.Shared.Systems.Save.GameSaveManager)
local TranscriptManager = require(ReplicatedStorage.Shared.Utils.Transcript.TranscriptManager)

local SceneFolder = script.Parent.Parent.Parent.Story

local SceneModules = table.freeze({
	[1] = require(SceneFolder.Scene1.Progression),
	[2] = require(SceneFolder.Scene2.Progression),
	[3] = require(SceneFolder.Scene3.Progression),
	[4] = require(SceneFolder.Scene4.Progression),
	[5] = require(SceneFolder.Scene5.Progression),
	[6] = require(SceneFolder.Scene6.Progression),
	[7] = require(SceneFolder.Scene7.Progression),
	[8] = require(SceneFolder.Scene8.Progression),
	[9] = require(SceneFolder.Scene9.Progression),
	[10] = require(SceneFolder.Scene10.Progression),
	[11] = require(SceneFolder.Scene11.Progression),
	[12] = require(SceneFolder.Scene12.Progression),
	[13] = require(SceneFolder.Scene13.Progression),
	[14] = require(SceneFolder.Scene14.Progression),
	[15] = require(SceneFolder.Scene15.Progression),
	[16] = require(SceneFolder.Scene16.Progression),
})

local SceneManager = {}

-- Helper function to get the currentScene from the player's attribute
function SceneManager.GetCurrentScene(player) -- Simple function to get the player's scene
	return player:GetAttribute("Scene") or 1 -- Return 1 on default if not set yet
end

function SceneManager.IsTransitioning(player) -- Helper function to get IsSceneTransitioning attribute
	return player:GetAttribute("IsSceneTransitioning") == true
end

function SceneManager.Transition(player) -- Main function to transition between scenes
	if SceneManager.IsTransitioning(player) then
		return false, "Transition already in progress"
	end

	local current_scene = SceneManager.GetCurrentScene(player) -- Variable number for current scene
	local next_scene = current_scene + 1 -- Variable number for next scene
	local nextModule = SceneModules[next_scene]

	if not nextModule then
		return false, ("No next scene exists for scene %d"):format(current_scene)
	end

	player:SetAttribute("IsSceneTransitioning", true) -- Set it true that th eplayer is transitioning


	local ok, err = pcall(function()
		player:SetAttribute("Scene", next_scene) -- Set player's attribute to the new scene value

		nextModule.Start() -- Start the next scene
		GameSaveManager.Save(player.UserId, next_scene) -- Save the game's state
		TranscriptManager.Save(player.UserId) -- save the user's messages with the AI so far
	end)

	player:SetAttribute("IsSceneTransitioning", false) -- We are done transitioning, continue on

	if not ok then
		player:SetAttribute("Scene", current_scene) -- if Scene loading fails, then reset the scene to the previous one
		GameSaveManager.Save(player.UserId, current_scene)
		return false, ("Failed to transition to scene %d: %s"):format(next_scene, tostring(err))-- return false if we failed transition
	end
	return true, ("Transitioned to scene %d"):format(next_scene) -- return true if we successfully transitioned
end

function SceneManager.ContinueFromSave(player)
	if SceneManager.IsTransitioning(player) then
		return false, "Transition already in progress"
	end

	local previous_scene = SceneManager.GetCurrentScene(player) or 1 -- If this fails, get 1
	local scene_number = GameSaveManager.Load(player.UserId) or 1 -- Get the scene number if we are going to a specific scene
	local targetModule = SceneModules[scene_number]

	if not targetModule then -- If we fail to get it, say the scene does not exist
		return false, ("Scene %d does not exist"):format(scene_number)
	end

	player:SetAttribute("IsSceneTransitioning", true) -- Set us to transitioning

	local ok, err = pcall(function() -- Try to start the scene
		player:SetAttribute("Scene", scene_number)

		targetModule.Start() -- Play the scene
		GameSaveManager.Save(player.UserId, scene_number) -- Save the scene they are at
		TranscriptManager.Save(player.UserId) -- Save the transcript
	end)

	player:SetAttribute("IsSceneTransitioning", false) -- we are done transitioning

	if not ok then -- if we dont succeed, then fall back and save
		player:SetAttribute("Scene", previous_scene)
		GameSaveManager.Save(player.UserId, previous_scene)
		return false, ("Failed to load saved scene %d: %s"):format(scene_number, tostring(err))
	end

	return true, ("Loaded saved scene %d"):format(scene_number) -- Successfully went to scene
end

return SceneManager
