local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local GuiMouseManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMouseManager)
local GuiMovementManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMovementManager)

local DialogueHandler = {}
DialogueHandler.__index = DialogueHandler

-- Sounds
local MaleSound = SoundService:WaitForChild("MaleSound")
local FemaleSound = SoundService:WaitForChild("FemaleSound")

function DialogueHandler.new(gui) -- Initialize our dialogue handler
	local self = setmetatable({}, DialogueHandler)

	-- Below we load all the different gui parts
	self.dialogueGui = gui
	self.dialogueBar = gui:WaitForChild("DialogueBar")
	self.npcNameLabel = self.dialogueBar:WaitForChild("NPCName")
	self.dialogueTextLabel = self.dialogueBar:WaitForChild("DialogueText")
	self.choicesPanel = gui:WaitForChild("ChoicesPanel")
	self.choice1 = self.choicesPanel:WaitForChild("Choice1")
	self.choice2 = self.choicesPanel:WaitForChild("Choice2")
	self.choice3 = self.choicesPanel:WaitForChild("Choice3")

	self.currentTree = nil -- Initially set up our current tree
	self.currentNode = nil -- Set up which node is the starting node
	self.isFinalNode = false
	self.canAdvanceLinear = false
	self.isTyping = false
	self.dialogueTextLabel.MaxVisibleGraphemes = -1

	self.dialogueBar.Visible = false -- Initially keep this hidden
	self.choicesPanel.Visible = false -- Initially keep the choices panel hidden as well

	self:_connectButtons()
	self:_connectDialogueClick()
	self:_addHoverHighlight(self.choice1) -- Make the buttons have a highlight
	self:_addHoverHighlight(self.choice2)
	self:_addHoverHighlight(self.choice3)

	return self
end

function DialogueHandler:_hideAllChoices() -- This function allows us to hide all choices
	self.choice1.Visible = false
	self.choice2.Visible = false
	self.choice3.Visible = false
end

function DialogueHandler:_setChoiceButton(button, choiceData) -- Function that sets the text inside the button
	button.Text = choiceData.text
	button.Visible = true
end

function DialogueHandler:_showNode(nodeName) -- Function that shows the nodes as needed
	local node = self.currentTree[nodeName]
	if not node then
		warn("Dialogue node not found:", nodeName)
		self:Stop()
		return
	end

	self.currentNode = nodeName
	self.isFinalNode = false
	self.canAdvanceLinear = false

	self.dialogueBar.Visible = true
	self.choicesPanel.Visible = true

	self.npcNameLabel.Text = node.speaker
	self:_hideAllChoices()

	if node.choices then -- Depending on what we need, show appropriate choice panels
		self.isFinalNode = false
		if node.choices[1] then
			self:_setChoiceButton(self.choice1, node.choices[1])
		end
		if node.choices[2] then
			self:_setChoiceButton(self.choice2, node.choices[2])
		end
		if node.choices[3] then
			self:_setChoiceButton(self.choice3, node.choices[3])
		end
	elseif node.next then
		self.choicesPanel.Visible = false
		self.canAdvanceLinear = true
	else -- Otherwise show none
		self.choicesPanel.Visible = false
		self.isFinalNode = true
	end

	self:_typewrite(node)
end

function DialogueHandler:Start(dialogueTree, startNode) -- Function to kick off the dialogue gui
	if self.isActive then
		return
	end

	self.isActive = true
	
	if self.currentTree then
		self:Stop()
	end

	if not dialogueTree then
		warn("DialogueHandler:Start called with nil dialogueTree")
		return
	end

	local initialNode = startNode or "start"
	if not dialogueTree[initialNode] then
		warn("Start node not found:", initialNode)
		return
	end

	self.currentTree = dialogueTree
	GuiMouseManager.OpenGui()
	GuiMovementManager.Lock()
	self:_showNode(initialNode)
end

function DialogueHandler:Stop() -- Stop the GUI
	if not self.isActive then
		return
	end

	self.isActive = false
	
	self.currentTree = nil
	self.currentNode = nil
	self.isFinalNode = false
	self.canAdvanceLinear = false
	self.dialogueBar.Visible = false
	self.choicesPanel.Visible = false
	GuiMouseManager.CloseGui()
	GuiMovementManager.Unlock()

	local player = Players.LocalPlayer
	if player then
		player.CameraMode = Enum.CameraMode.LockFirstPerson
	end
end

function DialogueHandler:_choose(index) -- Function to handle when a user picks an option
	if self.isTyping then
		self.isTyping = false
		return
	end

	if not self.currentTree or not self.currentNode then -- Check if we have nothing
		warn("Missing currentTree or currentNode")
		return
	end

	local node = self.currentTree[self.currentNode] -- get the current node we are at
	if node and node.choices and node.choices[index] then -- If we get a valid choice
		self:_showNode(node.choices[index].next)
	else
		warn("Choice missing for index", index)
	end
end

function DialogueHandler:_connectButtons() -- Connect buttons to choice (aka the actual clicking)
	self.choice1.MouseButton1Click:Connect(function()
		self:_choose(1)
	end)
	self.choice2.MouseButton1Click:Connect(function()
		self:_choose(2)
	end)
	self.choice3.MouseButton1Click:Connect(function()
		self:_choose(3)
	end)
end

function DialogueHandler:_connectDialogueClick()
	self.dialogueBar.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		if not self.currentTree or not self.currentNode then
			return
		end

		local node = self.currentTree[self.currentNode]
		if not node then
			return
		end

		if self.isTyping then
			self.isTyping = false
			return
		end

		if self.canAdvanceLinear and node.next then
			self:_showNode(node.next)
		elseif self.isFinalNode then
			self:Stop()
		end
	end)
end

function DialogueHandler:_addHoverHighlight(button)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.BackgroundTransparency = 1

	button.MouseEnter:Connect(function()
		button.BackgroundTransparency = 0.3
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundTransparency = 1
	end)
end

function DialogueHandler:_typewrite(node) -- Function that enables a typewriting effect of the NPC
	local label = self.dialogueTextLabel
	local text = node.text

	self.isTyping = true
	label.Text = text
	label.MaxVisibleGraphemes = 0
	local sound, pitch = self:_chooseTalker(node.speaker)
	for i = 1, #text do
		if not self.isTyping then
			label.MaxVisibleGraphemes = -1
			self.isTyping = false
			return
		end
		label.MaxVisibleGraphemes = i

		sound.PlaybackSpeed = pitch
		sound:Play()
		task.wait(0.02)
	end

	label.MaxVisibleGraphemes = -1
	self.isTyping = false
end

function DialogueHandler:_chooseTalker(character)
	if character == "Dad" then
		print("dad dialogue sound")
		return MaleSound, 0.9
	elseif character == "Teacher" then
		return MaleSound, 1
	elseif character == "Bully" then
		return MaleSound, 1.1
	elseif character == "Mom" then
		return FemaleSound, 0.8
	elseif character == "Sister" then
		return FemaleSound, 1.15
	elseif character == "You" then
		return FemaleSound, 1
	else
		print("other dialogue sound")
		return MaleSound, 1
	end
end

return DialogueHandler
