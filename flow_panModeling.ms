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
		Group "Pivot Tools"	
		( 
				
-- 			Label	lbl_dash1_label "------------- Pivot Axis -------------"	align:#center 
				
			checkbutton chk_crd_spa "Local"					width: 55	across:4
			checkbutton chk_X_axis  "X"						width: 55	offset:[0,0]
			checkbutton chkbtn_Y	"Y"						width: 55
			checkbutton chkbtn_Z	"Z"						width: 55	
-- 			Label	lbl_dash2_label "------------- Pivot Tools -------------"	align:#center
				
			button btn_ngrd_axis "-Grid"					width: 35	across:6
			button btn_pgrd_axis "Grid"						width: 35	offset:[-2, 0]
			button btn_zer_axis "Zero"						width: 35	offset:[1, 0]
			button btn_min_axis "Min"						width: 35
			button btn_cen_axis "Cntr"						width: 35	offset:[2, 0]
			button btn_max_axis "Max"						width: 35	offset:[2.5, 0]
			edittext edt_unt_amt "Increment: "	 			width:160	offset:[0, 2]					across:3	
			button btn_unt_min 	"-"							width: 20	offset:[68, 0]	
			button btn_unt_plus "+"							width: 20	offset:[22, 0]
			
-- 			Label	lbl_dash3_label "------------ Pivot Actions ------------"	align:#center
				
			button btn_piv_orig "To Origin" 				width:90					tooltip: "Pivot to World Origin"			across:2
			button btn_piv_cnt "To Center" 					width:90					tooltip: "Pivot to Object Center"	
			button btn_piv_sel "From Selection"				width:90	align:#center	tooltip: "Pivot to Sub-Object Selection"	across:2
			pickbutton pb_ps 	"From Target" 				width:90	align:#center	tooltip: "Pivot to Object Center"	
		)
		
		Group "Modeling Tools"
		(
			 
			button btn_setFlow "Set Flow" 					width: 70 	across:3		tooltip: "Adjust Edge Flow of Selected Edges"  
			button btn_delLoop "Delete Loop" 				width: 70					tooltip: "Cleanly Remove Edge Loop from Selected Edge"
			button btn_weldVerts "Weld Verts"				width: 70					tooltip: "Welds all verts on a single mesh.\n Only works on verts that are on top of each other. Use this as clean up."					 
		)
		Group "Unwrap Tools"
		(
			button btn_UVW_map "UVW Map"					width: 70	across:3
			button btn_texChk "Normalize" 					width: 70 			
			button btn_Uv_Tls "UV Tools"					width: 70 			
		)
		Group "Object Tools"
		(
			button btn_comObj "Combine"						width: 70	across:3		tooltip: "Insets and Collapses a Face" 
			button btn_quick_copy "Quick Copy" 				width: 70	
			button btn_qck_dtach "Detach"					width: 70	
			button btn_reset_trans "Set Xform"				width: 70   across:3
			button btn_dubSmt "Smoothing"					width: 70 					tooltip: "Insets and Collapses a Face" 
			button btn_cull_tog "Culling" 					width: 70 
		)
			
		Group "Transform Tools"
		(
			button btn_snd2_orig "To Origin"				width: 70	across:3		tooltip: "Send to Center of World"
			button btn_snd2_grid "To Grid"					width: 70					tooltip: "Send to Grid Space"
			button btn_zerObj "Reset"						width: 70
		)
			
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS to MIN		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_zer_axis pressed do 
		(
			undo on
				
			selObjs = selection
				
			case chk_X_axis.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							if chk_crd_spa.checked then 
							(
								in coordsys #local i.pos = [0, i.pivot.y, i.pivot.z]
							)
							else(
								i.pos = [0, i.pivot.y, i.pivot.z]
							)
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pos = [i.pivot.x, 0, i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pos = [i.pivot.x, i.pivot.y, 0]
						)
					)
			)
		)
			
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS to MIN		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_min_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chk_X_axis.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(	
							if chk_crd_spa.checked then 
							(
								in coordsys #local i.pivot.x = in coordsys #local i.min.x
							)
							else(
								i.pivot = [i.min.x, i.pivot.y, i.pivot.z]
							)
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
		--positive grid align
		on btn_pgrd_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chk_X_axis.state of 
			(
				true: 
					( 	
						increment = -getGridSpacing()
							
						-- grid align Objects 
						for i in selection do 
						(
							print ("value = "+ (((floor (1.0*i.pos.x/increment+increment)*increment) as float*10)/10) as string )
							
							print ("pos = " + ((i.pos.x*10)/10) as string )
							
							if (((floor (1.0*i.pos.x/increment+increment)*increment) as float*10)/10) == ((i.pos.x*10)/10) then
							(
								print "all aligned"
							)
							else(
								i.pos = [(floor (1.0*i.pos.x/increment)*increment) as float, i.pos.y, i.pos.z]
							)
						)

					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						increment = -getGridSpacing()
							
						-- grid align Objects 
						for i in selection do 
						(
							print ("value = "+ (((floor (1.0*i.pos.x/increment+increment)*increment) as float*10)/10) as string )
							
							print ("pos = " + ((i.pos.y*10)/10) as string )
							
							if (((floor (1.0*i.pos.y/increment+increment)*increment) as float*10)/10) == ((i.pos.y*10)/10) then
							(
								print "all aligned"
							)
							else(
								i.pos = [i.pos.x, (floor (1.0*i.pos.y/increment)*increment) as float, i.pos.z]
							)
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						increment = -getGridSpacing()
							
						-- grid align Objects 
						for i in selection do 
						(
							print ("value = "+ (((floor (1.0*i.pos.z/increment+increment)*increment) as float*10)/10) as string )
							
							print ("pos = " + ((i.pos.z*10)/10) as string )
							
							if (((floor (1.0*i.pos.z/increment+increment)*increment) as float*10)/10) == ((i.pos.z*10)/10) then
							(
								print "all aligned"
							)
							else(
								i.pos = [i.pos.x, i.pos.y, (floor (1.0*i.pos.z/increment)*increment) as float]
							)
						)
					)
			)
				
		)
		--negative grid align
		on btn_ngrd_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chk_X_axis.state of 
			(
				true: 
					( 	
						increment = getGridSpacing()
						--grid align Objects 
						for i in selection do 
						(
							print ("value = "+ (((floor (1.0*i.pos.x/increment)*increment) as float*10)/10) as string )
							
							print ("pos x = " + ((i.pos.x*10)/10) as string )
							
							if (((floor (1.0*i.pos.x/increment)*increment) as float*10)/10) == ((i.pos.x*10)/10) then
							(
								print "all aligned"
							)
							else(
								i.pos = [(floor (1.0*i.pos.x/increment)*increment) as float, i.pos.y, i.pos.z]
							)
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						increment = getGridSpacing()
						--grid align Objects 
						for i in selection do 
						(
							print ("value = "+ (((floor (1.0*i.pos.y/increment)*increment) as float*10)/10) as string )
							
							print ("pos y  = " + ((i.pos.y*10)/10) as string )
							
							if (((floor (1.0*i.pos.y/increment)*increment) as float*10)/10) == ((i.pos.y*10)/10) then
							(
								print "all aligned"
							)
							else(
								i.pos = [i.pos.x, (floor (1.0*i.pos.y/increment)*increment) as float, i.pos.z]
							)
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						increment = getGridSpacing()
						--grid align Objects 
						for i in selection do 
						(
							print ("value = "+ (((floor (1.0*i.pos.y/increment)*increment) as float*10)/10) as string )
							
							print ("pos y  = " + ((i.pos.y*10)/10) as string )
							
							if (((floor (1.0*i.pos.z/increment)*increment) as float*10)/10) == ((i.pos.z*10)/10) then
							(
								print "all aligned"
							)
							else(
								i.pos = [i.pos.x, i.pos.y, (floor (1.0*i.pos.z/increment)*increment) as float]
							)
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
				
			case chk_X_axis.state of 
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
				
			case chk_X_axis.state of 
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
				
			case chk_X_axis.state of 
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
				
			case chk_X_axis.state of 
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
		
		