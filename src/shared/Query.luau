-- test
local Query = {}

function Query.AskAI(message)
	print("Im inside the module")
	local HttpService = game:GetService("HttpService")

	-- Get information to reach out to Inference API
	local HF_TOKEN = HttpService:GetSecret("HF_TOKEN"):AddPrefix("Bearer ")

	-- Get response from the AI model
	print("Requesting Response from AI")

	local response = HttpService:RequestAsync({
		Url = "https://router.huggingface.co/v1/chat/completions",
		Method = "POST",
		Headers = {
			["authorization"] = HF_TOKEN,
			["content-type"] = "application/json",
		},
		Body = HttpService:JSONEncode({
			model = "vicgalle/Roleplay-Llama-3-8B:featherless-ai",
			messages = {
				{
					role = "user",
					content = message,
				},
			},
		}),
	})

	print("Message received from AI")

	if response.Success then
		local data = HttpService:JSONDecode(response.Body)
		local reply = data.choices[1].message.content
		return reply
	else
		print("Error, AI model could not respond.")
		print("Error code:", response.StatusCode)
		return -1
	end
end

return Query
