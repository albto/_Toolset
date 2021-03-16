try (DestroyDialog objManager) catch()

rollout objManager "Layer Controller"
(
		
	local mainLayerName = "0 (default)"
		
		
	Group "Controls:"
	(
		dropdownList ddl_objects "Objects"		items:#("models", "helpers", "lights", "shapes")
	)
		
	Group "Actions:"
	(
		checkbutton chk_tog "Toggle"			checked:true 	width:70	across:3
		checkbutton chk_sele "Select" 			checked:false	width:70
		checkbutton chk_disp "Display" 			checked:true	width:70
	)
		
		
	timer tim "" 	interval:100
	
	
	on chk_tog changed state do
	(
		mainLayerName = ddl_objects.items[ddl_objects.selection]
		
		if (mainLayerName == "lights") then
		(
			mainLayer = LayerManager.getLayerFromName mainLayerName
			mainLayer.select true 
			
			sel = selection as array 
			
			for i in sel do 
			(
				i.on = state
			)
				
		)
		else
		(
			
		)
			
	)
	
	
	on ddl_objects selected i do 
	(
			
		mainLayerName = ddl_objects.items[i]
		mainLayer = LayerManager.getLayerFromName mainLayerName
			
		if mainLayer == undefined then
			return false
		else
		(
			chk_disp.checked = not mainLayer.ishidden
		)	
			
	)
	
	on tim tick do
	(
			
		if (selection.count == 0) then
		(
			chk_sele.checked = false
		)
			
	)	
		
		
	on chk_sele changed state do
	(
		
		--mainLayerName = ddl_objects.items[ddl_objects.selection]
		mainLayer = LayerManager.getLayerFromName mainLayerName
		
		if (state) then
		(
				
			mainLayer.select true 
				
		)	
		else
		(
			mainLayer.select false
		)
		
	)
	
	on chk_disp changed state do
	(
		
		mainLayerName = ddl_objects.items[ddl_objects.selection]
		mainLayer = LayerManager.getLayerFromName mainLayerName		
			
		if mainLayer == undefined then
			return false
		else
		(
			mainLayer.select true 
			mainLayer.ishidden = not state	
		)
	)
	
)

CreateDialog objManager width:250



	
	
	
	