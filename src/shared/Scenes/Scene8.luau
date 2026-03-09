local Scene8 = {}
local Success = 1

function Scene8.Load()
	-- Load the scene logic
	-- If scene loads successfully, then success = 1, otherwise change to 0
	if not Success then
		print("Error")
	end
end

function Scene8.Unload()
	if not Success then
		-- UnLoad the scene logic
		-- If scene loads successfully, then success = 1, otherwise change to 0
		print("Error")
	end
end

return Scene8
