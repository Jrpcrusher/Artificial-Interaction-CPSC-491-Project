local DialogueController = {}

DialogueController.Handler = nil

function DialogueController.SetHandler(handler)
	DialogueController.Handler = handler
end

function DialogueController.Start(dialogueTree, startNode)
	if not DialogueController.Handler then
		warn("Dialogue handler has not been set yet.")
		return
	end

	DialogueController.Handler:Start(dialogueTree, startNode or "start")
end

function DialogueController.Stop()
	if DialogueController.Handler then
		DialogueController.Handler:Stop()
	end
end

return DialogueController
