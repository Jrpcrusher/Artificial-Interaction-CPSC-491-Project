local Scene14 = {}
local Success = 1

function Scene14.Load()
	-- Load the scene logic
	-- If scene loads successfully, then success = 1, otherwise change to 0
	if not Success then
		print("Error")
	end
end

function Scene14.Unload()
	if not Success then
		-- UnLoad the scene logic
		-- If scene loads successfully, then success = 1, otherwise change to 0
		print("Error")
	end
end

return Scene14
