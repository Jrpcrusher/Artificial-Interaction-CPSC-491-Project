local Query = {} -- Module function setup

-- This function takes input from the user, passes it to the AI for a response, and then returns the value
function Query.AskAI(message)
	local HttpService = game:GetService("HttpService")

	-- Get information to reach out to Inference API
	local HF_TOKEN = HttpService:GetSecret("HF_TOKEN"):AddPrefix("Bearer ")

	-- Get response from the AI model
	--print("Requesting Response from AI")

	local response = HttpService:RequestAsync({
		Url = "https://router.huggingface.co/v1/chat/completions",
		Method = "POST",
		Headers = {
			["authorization"] = HF_TOKEN,
			["content-type"] = "application/json",
		},
		Body = HttpService:JSONEncode({
			model = "vicgalle/Roleplay-Llama-3-8B:featherless-ai", -- Changing models might be a good idea
			messages = {
				{
					role = "user",
					content = message,
				},
			},
		}),
	})

	-- print("Message received from AI")

	if response.Success then -- If we get a response, take the body of the resposne and decode it
		local data = HttpService:JSONDecode(response.Body)
		local reply = data.choices[1].message.content
		return reply
	else -- Otherwise, say there was an error and return -1
		-- TODO: Make it so that there is default responses depending on the context in the story
		-- This TODO will be done later when the story fully takes shape
		print("Error, AI model could not respond.")
		print("Error code:", response.StatusCode)
		return -1
	end
end

return Query
