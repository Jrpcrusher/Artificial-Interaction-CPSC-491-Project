local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local GuiMouseManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMouseManager)
local GuiMovementManager = require(ReplicatedStorage.Shared.Systems.Input.GuiMovementManager)

local DialogueHandler = {}
DialogueHandler.__index = DialogueHandler
<<<<<<< HEAD
=======

-- Sounds
local MaleSound = SoundService:WaitForChild("MaleSound")
local FemaleSound = SoundService:WaitForChild("FemaleSound")
>>>>>>> 8cc2e3d (AI-165 Added visual for text appearing letter per letter on dialogue interaction. Removed old files.)

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

	self:_typewrite(node.text)
end

function DialogueHandler:Start(dialogueTree, startNode) -- Function to kick off the dialogue gui
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
	self.currentTree = nil
	self.currentNode = nil
	self.isFinalNode = false
	self.canAdvanceLinear = false
	self.dialogueBar.Visible = false
	self.choicesPanel.Visible = false
	GuiMouseManager.CloseGui()
	GuiMovementManager.Unlock()
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

<<<<<<< HEAD
=======
function DialogueHandler:_typewrite(text, character_name) -- Function that enables a typewriting effect of the NPC
	local label = self.dialogueTextLabel

	self.isTyping = true
	label.Text = text
	label.MaxVisibleGraphemes = 0
	local sound = self._chooseTalker()
	for i = 1, #text do
		sound:Play()
		if not self.isTyping then
			label.MaxVisibleGraphemes = -1
			self.isTyping = false
			return
		end
		label.MaxVisibleGraphemes = i
		task.wait(0.02)
	end

	label.MaxVisibleGraphemes = -1
	self.isTyping = false
end

function DialogueHandler:_chooseTalker()
	if self.npcNameLabel == "Dad" or self.npcNameLabel == "Teacher" or self.npcNameLabel == "Bully" then
		return MaleSound
	else
		return FemaleSound
	end
end

>>>>>>> 8cc2e3d (AI-165 Added visual for text appearing letter per letter on dialogue interaction. Removed old files.)
return DialogueHandler
