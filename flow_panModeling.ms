---------------------------------------------------------------------------MODELING TOOLS GROUP CONTROLS 
		-------------------------------------------------------------------------------------------------	
		
-- 		Group "Object Display"
-- 		(
-- 			
-- 		button laun_objprops "Object Properties" width: 160 Height: 30
-- 			
-- 		)
			
		-------------------------------------------------------------------------------------------------
-- 		on laun_objprops pressed do 
-- 		(
-- 			filein "D:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_main_dialog\functions\object_props.ms" 
-- 		)
			
		-------------------------------------------------------------------------------------Utilities Group Controls
		Group "Utilities"	
		( 
				
			Label	lbl_dash1_label "------------- Pivot Axis -------------"	align:#center 
				
			checkbutton chkbtn_X  	"X"						width: 50	across:3
			checkbutton chkbtn_Y	"Y"						width: 50
			checkbutton chkbtn_Z	"Z"						width: 50	
				
			Label	lbl_dash2_label "------------- Pivot Tools -------------"	align:#center
				
			button btn_min_axis "Min"						width: 50	across:3
			button btn_cen_axis "Cntr"						width: 50
			button btn_max_axis "Max"						width: 50	
			edittext edt_unt_amt "Increment Pivot:"			width:160		
			button btn_unt_min 	"-"							width: 50	across:2	
			button btn_unt_plus "+"							width: 50
			
			Label	lbl_dash3_label "------------ Pivot Actions ------------"	align:#center
				
			button btn_piv_orig "Pivot to World Origin" 	width:165			tooltip: "Pivot to Origin"		
			button btn_piv_cnt "Pivot to Center" 			width:165					tooltip: "Pivot to Center"	
			button btn_piv_sel "Pivot to Vert Selection"	width:165	align:#center
			pickbutton pb_ps 	"Grand Theft Pivot" 		width:165	align:#center
				
			Label	lbl_dash_label2 "----------- Modeling Tools -----------"	align:#center 
				
			button btn_snd2_orig "Send to Origin"			width: 80	across:2		tooltip: "Send to Center of World"
			button btn_snd2_grid "Send to Grid"				width: 80					tooltip: "Send to Grid Space"
			button btn_comObj "Combine"						width: 80	across:2		tooltip: "Insets and Collapses a Face" 
			button btn_cull_tog "Culling" 					width: 80 					 
			button btn_setFlow "Set Flow" 					width: 80 	across:2		tooltip: "Adjust Edge Flow of Selected Edges"  
			button btn_weldVerts "Weld Verts"				width: 80					tooltip: "Welds all verts on a single mesh.\n Only works on verts that are on top of each other. Use this as clean up."
			button btn_zerObj "Reset Object"					width: 80	across:2
			button btn_quick_copy "Quick Copy" 				width: 80	
			button btn_reset_trans "Reset Xform"			width: 80   across:2		 
			button btn_qck_dtach "Detach"					width: 80	
			button btn_UVW_map "UVW Map"					width: 80	across:2
			button btn_dubSmt "Double Smooth"				width: 80 					tooltip: "Insets and Collapses a Face" 
			button btn_delLoop "Delete Loop" 				width: 80	across:2 		tooltip: "Cleanly Remove Edge Loop from Selected Edge"
			button btn_texChk "Scale UVs" 						width: 80 							
				
		)
			
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS to MIN		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_min_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.min.x, i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.min.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.min.z]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS to CENTER		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_cen_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.center.x, i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.center.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.center.z]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS to MAX
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_max_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.max.x, i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.max.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.max.z]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS - MINUS - UNIT		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_unt_min pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x - (edt_unt_amt.text as float), i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y - (edt_unt_amt.text as float), i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.pivot.z - (edt_unt_amt.text as float)]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS - PLUS - UNIT		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_unt_plus pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x + (edt_unt_amt.text as float), i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y + (edt_unt_amt.text as float), i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.pivot.z + (edt_unt_amt.text as float)]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- GRAND THEFT PIVOT 	
		------------------------------------------------------------------------------------------------------------------------------------
			
		on pb_ps picked obj do 
		(
			sel = selection as array
			
			--steal's the pivot from the picked object
			if sel != undefined do 
			sel.pivot = obj.pivot
			
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PLACE PIVOT ON SELECTION
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_piv_sel pressed do 
		(		
			macros.run FlowPanels PivtoVerts
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- SEND TO ORIGIN		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_snd2_orig pressed do
		(
			Undo on
			for i in selection do 
			(
				i.pos = [0,0,0]
			)
-- 			if selection.count == 0 do
-- 			(
-- 				messagebox "oops, you didn't select anything!" title:"Flow Panels"
-- 			)
			
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- SEND TO ORIGIN		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_snd2_grid pressed do
		(
			Undo on
			for i in selection do 
			(
				i.pos = [i.pos.x,i.pos.y,0]
			)
-- 			if selection.count == 0 do
-- 			(
-- 				messagebox "oops, you didn't select anything!" title:"Flow Panels"
-- 			)
			
		)
		------------------------------------------------------------------------------------------------------------------------------------	
		-- PIVOT TO ORIGIN				
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_piv_orig pressed do
		(
			Undo on
			for i in selection do  
			(
				selection[1]
				$.pivot = [0,0,0]
			)
-- 			if selection.count == 0 do
-- 			(
-- 				messagebox "oops, you didn't select anything!" title:"Flow Panels"
-- 			)
			
		)	
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT TO CENTER			
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_piv_cnt pressed do
		(
			Undo on
			for i in selection do  
			(
				selection[1]
				i.pivot = [i.center.x,i.center.y,i.center.z]
			)
-- 			if selection.count == 0 do
-- 			(
-- 				messagebox "oops, you didn't select anything!" title:"Flow Panels"
-- 			)
			
		)	
				
		-------------------------------------------------------------------------------------------------------------------------------------- 
		-- MODELING TOOLS 
		--------------------------------------------------------------------------------------------------------------------------------------
			
		----------------------------------------------------------------------------------------------------Double Smooth
		on btn_dubSmt pressed do 
		(
			macros.run FlowPanels DubSmooth 
			
		)
		----------------------------------------------------------------------------------------------------Delete Loop
		on btn_delLoop pressed do
		(
			Undo on
			macros.run FlowPanels DeleteLoop
		)			
		----------------------------------------------------------------------------------------------------Combine Objects	
		on btn_comObj pressed do 
		(
			Undo on
			macros.run FlowPanels CombineObj
		)
		----------------------------------------------------------------------------------------------------Weld Verts
		on btn_weldVerts pressed do 
		(
			Undo on
			macros.run FlowPanels VertWeld
		)
		----------------------------------------------------------------------------------------------------Reset Object
		on btn_zerObj pressed do 
		(
			Undo on
			macros.run FlowPanels ResetObj
		)
		----------------------------------------------------------------------------------------------------Quick Copy
		On btn_quick_copy pressed do 
		(
			Undo on
			macros.run FlowPanels CopyObj
		)
		----------------------------------------------------------------------------------------------------Reset Transformation
		on btn_reset_trans pressed do
		(
			undo on
			macros.run FlowPanels ResTransform
		)
		----------------------------------------------------------------------------------------------------Detach Object
		on btn_qck_dtach pressed do 
		(
			undo on
			macros.run FlowPanels ObjDetach
		)
		----------------------------------------------------------------------------------------------------Quick UVW Map
		on btn_UVW_map pressed do 
		(
			undo on
			macros.run FlowPanels QuickUV
		)
		
		----------------------------------------------------------------------------------------------------Object Culling
		on btn_cull_tog pressed do
		(
			Undo on
			macros.run FlowPanels Cull
		)
		
		----------------------------------------------------------------------------------------------------Symmetry Radial
		on symRadBtn pressed do
		(
-- 			
-- 			undo on
-- 			modPanel.addModToSelection (SymmetryRadial ()) ui:on
		)
		----------------------------------------------------------------------------------------------------Scale UVs
		on btn_texChk pressed do 
		(
			undo on
			macros.run FlowPanels RescaleUVs
			
		)
		----------------------------------------------------------------------------------------------------
		
		
-------------------------------------------------------------------------------------Cloners Group Controls
-- 			
-- 		Group "Cloners List"
-- 		(
-- 			
-- 			dropdownlist cloner_list "" items:#("...Pick Cloner...", "1. Clone Radial", "2. Clone on Curve", "3. Building Maker",  "4. CloneSpline Rad", "5. Path Cloner","6. Cloner Setup") width: 150	align:#center 
-- 			
-- 		)
			
			
		on cloner_list selected i do
		(
				
			if cloner_list.selection == 2 then 
			(
				--modPanel.addModToSelection (Vu_mcgCloneRadial ()) ui:on
			)
			
			if cloner_list.selection == 3 then 
			(
				--modPanel.addModToSelection (VA_CloneOnCurve ()) ui:on
			)
			
			if cloner_list.selection == 4 then
			(
				--fileIn "D:\Dropbox\[main access]\3ds_Scripts\HTM-PRJ_cityblks-BMscripts\BuildingMaker.ms"
			)
			
			if cloner_list.selection == 5 then
			(
				--startObjectCreation Vu_CloneSplRadial
			)
			
			if cloner_list.selection == 6 then
			(
				--Path_Cloner ()
			)
			
			if cloner_list.selection == 7 then
			(
				--modPanel.addModToSelection (Cloner_Transform ()) ui:on
				--modPanel.addModToSelection (Cloner_Mesher ()) ui:on
				--modPanel.addModToSelection (Stacker ()) ui:on	
			)
				
		)
		
		on panModeling rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panModeling
			)
			
		)