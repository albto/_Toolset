
try DestroyDialog flowTexelTool catch()
rollout flowTexelTool "Texel Density tool" 
(
	button btn_setDensity 	"Set Texel Density"
	spinner sld_texelScale 	"Scale" 		range:[0,9999, 1]	type:#float 
	spinner sld_density 		"Density"		range:[0,9999, 1]	type:#float 
		
		
	fn setTexelDensity density =
	(
		-- Loop through selected objects
		for obj in selection do
		(
			-- Check if the object has a UVW map modifier
			
			uvwMod = obj.modifiers[#UnwrapUVW] 
			
			faceSel = uvwMod.GetSelectionFromFace() 
			
			---print uvMod.UVWScale 
			if (uvwMod != undefined) then
			(
				-- Get the current scale of the UVW mapping
				currentScale = uvwMod.scale
				
				-- Calculate the new scale factor based on desired texel density
				scaleFactor = 1 / density
				
				-- Apply the new scale to the UVW mapping
				uvwMod.scale = currentScale * scaleFactor
				
				format "Updated texel density for: %\n" obj.name
			)
			else
			(
				format "No UVWMapping modifier found for: %\n" obj.name
			)
		)
	)	
		
	on btn_setDensity pressed do 
	(
			
		-- Prompt for texel density input
		densityValue = 1.0
		if (densityValue != undefined) then
		(
			setTexelDensity (densityValue as float)
		)
			
	)
)


CreateDialog flowTexelTool width:200