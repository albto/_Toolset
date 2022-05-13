
try DestroyDialog(AttrTerrainHelper) catch()

rollout AttrTerrainHelper "Terrain Helper" 
(
	group "Name Terrain Objects"
	(
		dropdownList ddl_letter_pre "" items:#("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P") 	pos:[10, 25]	width:40			across:5
		dropdownList ddl_number_pre "" items:#("01","02","03","04","05","06","07","08","09","10","11","12","13") 	pos:[60, 25]	width:40
		checkbutton chk_mesh_type "Mesh" 																			pos:[110, 25]	width:60
		checkbutton chk_terrain_type "Terrain" 																		pos:[180, 25]	width:60
		button btn_name_type "Name Terrain Sector" 																	pos:[250, 25]		
	)
	
	group "Terrain Creation Tools"
	(
		button btn_mark_terrain "Mark Terrain"																		width:120		across:3
		button btn_set_terrain "Set Terrain"																		width:120
		button btn_cleanup_data "Clean Terrain Data"																width:120
	)		
	--for val in arr2 where matchpattern val pattern:i
	
	button btn_test "test"
	
	on test pressed do 
	(
		
	)
		
	on chk_mesh_type changed state do 
	(
		chk_terrain_type.checked = not state
	)
	
	on chk_terrain_type changed state do 
	(
		chk_mesh_type.checked = not state
	)
	
	on btn_name_type pressed do 
	(
		str = ""
		
		
		for i in selection do 
		(
			if chk_mesh_type.checked then
			(
				str = "Mesh"
					
				--structure color
				i.wirecolor = color 5 5 5
					
				--structure ID
				modPanel.addModToSelection (Materialmodifier ()) ui:on
				for obj in selection as array do obj.modifiers[#Material].materialID = 2
					
				collapseStack i
				macros.run FlowPanels VertWeld
					
			)
			if chk_terrain_type.checked then 
			(
				--name
				str = "Terrain"				
					
				--terrain color
				i.wirecolor = color 153 228 153
					
				--terrain ID
				modPanel.addModToSelection (Materialmodifier ()) ui:on
				for obj in selection as array do obj.modifiers[#Material].materialID = 1
					
				collapseStack i
				macros.run FlowPanels VertWeld
					
			)
			
			i.name = (ddl_letter_pre.items[ddl_letter_pre.selection] as string + "-" + ddl_number_pre.items[ddl_number_pre.selection] as string + "_" + str + "_LOD0")
		)
		
	)	
	
	
	on btn_mark_terrain pressed do 
	(
		for i in selection do 
		(
			i.name = (uniqueName "Terrain_")
		)
	)
	
	
	on btn_set_terrain pressed do 
	(
		Undo on
			
		for i in selection do 
		(
-- 			if (matchpattern i.name pattern:"_LOD0") != undefined then
-- 			(
-- 				
-- 			)
-- 			else
			(
				Undo on
				macros.run FlowPanels VertWeld
					
				--resetXform i
				addModifier i (WeightedNormalsMod useSmoothingGroups:true displaynormals:true)
				collapseStack i
					
					
				Undo on
				i.scale = [20, 20, 20]
				
				i.pivot = [i.max.x, i.min.y, i.min.z]
				
				--macros.run "PolyTools" "CenterPivot"
			)
		)
		
	)
	
	
	on btn_cleanup_data pressed do
	(
		sels = #()
		cleanedList = #()
		
		
		Try 
		(
			delete (for o in helpers where matchpattern o.name pattern:"BOS_*" collect o)
		)catch()
		
		select (for i in objects where MatchPattern i.name pattern:"Mesh*" collect i)
		
		--macros.run FlowPanels CombineObj
		
	)
	
	
	
)

CreateDialog AttrTerrainHelper  width:400 height:200