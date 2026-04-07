local Message = {}

function Message.Create(sender, time, content)
	local compiled_message = {
		[time] = { sender, content },
	}
	return compiled_message
end

return Message
