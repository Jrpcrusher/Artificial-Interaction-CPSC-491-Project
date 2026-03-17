local dialogueGui = script.Parent
local dialogueBar = dialogueGui:WaitForChild("DialogueBar")
local npcNameLabel = dialogueBar:WaitForChild("NPCName")
local dialogueTextLabel = dialogueBar:WaitForChild("DialogueText")
local choicesPanel = dialogueGui:WaitForChild("ChoicesPanel")
local choice1 = choicesPanel:WaitForChild("Choice1")
local choice2 = choicesPanel:WaitForChild("Choice2")
local choice3 = choicesPanel:WaitForChild("Choice3")

dialogueBar.Visible = false
choicesPanel.Visible = false
-- example text to test before changing anything
local dialogueData = {
	start = {
		speaker = "Guard",
		text = "Pay up, or I'll show you what we do with scum like you.",
		choices = {
			{
				text = "▸ I'll pay the fine.",
				next = "payFine"
			},
			{
				text = "▸ I accept my punishment.",
				next = "acceptPunishment"
			},
			{
				text = "▸ Let me go, or else.",
				next = "threatenGuard"
			}
		}
	},

	payFine = {
		speaker = "Guard",
		text = "Smart choice. Hand it over and this ends here.",
		choices = {
			{
				text = "▸ Fine. Take it.",
				next = "end"
			},
			{
				text = "▸ On second thought, no.",
				next = "start"
			},
			{
				text = "▸ You're enjoying this too much.",
				next = "mockGuard"
			}
		}
	},

	acceptPunishment = {
		speaker = "Guard",
		text = "At least you know your place. That's rare.",
		choices = {
			{
				text = "▸ Just get it over with.",
				next = "end"
			},
			{
				text = "▸ I changed my mind.",
				next = "start"
			},
			{
				text = "▸ You don't scare me.",
				next = "threatenGuard"
			}
		}
	},

	threatenGuard = {
		speaker = "Guard",
		text = "Big words for someone standing alone.",
		choices = {
			{
				text = "▸ Then try me.",
				next = "end"
			},
			{
				text = "▸ Fine. Let's talk.",
				next = "start"
			},
			{
				text = "▸ This was a mistake.",
				next = "acceptPunishment"
			}
		}
	},

	mockGuard = {
		speaker = "Guard",
		text = "Careful. One more remark and this gets ugly.",
		choices = {
			{
				text = "▸ Understood.",
				next = "end"
			},
			{
				text = "▸ Make me.",
				next = "threatenGuard"
			},
			{
				text = "▸ Forget it.",
				next = "start"
			}
		}
	},

	["end"] = {
		speaker = "Guard",
		text = "This conversation is over.",
		choices = nil
	}
}

local currentNode = "start"

local function hideAllChoices()
	choice1.Visible = false
	choice2.Visible = false
	choice3.Visible = false
end

local function setChoiceButton(button, choiceData)
	button.Text = choiceData.text
	button.Visible = true
end

local function showNode(nodeName)
	local node = dialogueData[nodeName]
	if not node then
		warn("Dialogue node not found:", nodeName)
		return
	end

	currentNode = nodeName
	dialogueBar.Visible = true
	choicesPanel.Visible = true

	npcNameLabel.Text = node.speaker
	dialogueTextLabel.Text = node.text

	hideAllChoices()

	if node.choices then
		if node.choices[1] then
			setChoiceButton(choice1, node.choices[1])
		end
		if node.choices[2] then
			setChoiceButton(choice2, node.choices[2])
		end
		if node.choices[3] then
			setChoiceButton(choice3, node.choices[3])
		end
	else
		choicesPanel.Visible = false
	end
end

choice1.MouseButton1Click:Connect(function()
	local node = dialogueData[currentNode]
	if node and node.choices and node.choices[1] then
		showNode(node.choices[1].next)
	end
end)

choice2.MouseButton1Click:Connect(function()
	local node = dialogueData[currentNode]
	if node and node.choices and node.choices[2] then
		showNode(node.choices[2].next)
	end
end)

choice3.MouseButton1Click:Connect(function()
	local node = dialogueData[currentNode]
	if node and node.choices and node.choices[3] then
		showNode(node.choices[3].next)
	end
end)
-- to add highlights on the choices
local function addHoverHighlight(button)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.BackgroundTransparency = 1
	
	button.MouseEnter:Connect(function()
		button.BackgroundTransparency = 0.3
	end)
	
	button.MouseLeave:Connect(function()
		button.BackgroundTransparency = 1 
	end)
end

addHoverHighlight(choice1)
addHoverHighlight(choice2)
addHoverHighlight(choice3)
-- to test out if its working before implementing function where we talk to npcs
task.wait(1)
showNode("start")