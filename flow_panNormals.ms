	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// NORMALS PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
		
	--------------------------------------------------------------------------------------------------------------------------------------	
			
		Group "Set Weighted Normals"
		(
			Button btn_Sel_Cha "Select Chamfers" 	width:110 height:30			across:2
			checkbutton chk_Sho_Cha "Set Weighted On" 		width:110 height:30
			spinner 	 spn_Segs_Amn "Segments"		range:[0,100,1] 			type:#integer
			spinner 	 spnAmnt "Amount" 				range:[0,1,0.02]			type:#float
			spinner 	 spnDpth "Depth" 				range:[0.0,1.0,0.65]		type:#float
			spinner 	 spnThrs "Smooth Threshold" 	range:[0,360,65.0]			type:#float
			dropdownlist lstSmth "Smoothing" 			selection:3 items:#("Off", "Smoothed Edges", "Unsmoothed Edges")		across:2
			dropdownList lstMiTp "Mitering Type" 		items:#("Quad", "Uniform", "Patch", "Radial", "Tri")			
			dropdownList lstAmTp "Amount Type" 			items:#("Fixed", "By Crease Weight", "Legacy", "By Weight") across:2
			dropdownList lstDpTp "Depth Type" 			items:#("Fixed", "By Weight")
				
			Button cmdSetWeight "Set Weighted Chamfer" width:190 height:30
				
		)
			
		Group "Deprecated"
		(
			Button cmdCreate "Set Normals" 						align:#center across:2
			Button cmdLock "Lock Normals" 						align:#center
			Button cmdReset "Release Normals" 					align:#center across:2
			Button cmdAdjust "Adjust Face Normals"         		align:#center
		)	
			
		--------------------------------------------------------------------------------------------------------------------------------------
		
	on btn_Sel_Cha pressed do 
	(
		str = for o in geometry where ((findItem (for m in o.modifiers collect classOf m) chamfer) > 0)collect o
		
		for i in str do 
		(
			--print i
			selectmore i 
		)
				
		
	)

		
		On cmdReset pressed do 
		(
				
			if selection.count > 0 do
			(
				for i in selection as array do 
				(
					macros.run "Modifiers" "EditPolyMod"
					maxOps.CollapseNode i off
				)
			)
			
			if selection.count == 0 do
			(
				messagebox "WARNING!: Nothing is Selected" title:"Flow Panels"
			)
		)

		On cmdSetWeight pressed do 
		(
			
			start = timeStamp()
				
			undo on 
				
			--chache modifiers
			chmMod = Chamfer()
			wgtMod = Weighted_Normals()
				
				
			selcount = (selection as array)
				
			for i in selcount do 
			(
				if (i.modifiers[#Chamfer]) != undefined then
				(	
					for obj in i.modifiers do
					(
						--print obj.name
						ind = (modPanel.getModifierIndex i obj)
							
						i.chamfer.segments 	= (spn_Segs_Amn.value as float)
						i.chamfer.amount 	= (spnAmnt.value as float)
						i.chamfer.tension 	= (spnDpth.value as float)
						i.chamfer.smoothingoption = (lstSmth.selection-1) as integer
						i.chamfer.depthType = (lstDpTp.selection-1) as integer
						i.chamfer.smoothingoption = (lstSmth.selection-1) as integer
						i.chamfer.miteringType  = (lstMiTp.selection-1) as integer
						i.chamfer.amountType = (lstAmTp.selection-1) as integer
						--i.chamfer.depthType = (lstDpTp.selection-1)
					)					
						
				)
				else
				(
					--set chamfer modifier parameters
					chmMod.segments = (spn_Segs_Amn.value as float)
					chmMod.amount = (spnAmnt.value as float)
					chmMod.tension = (spnDpth.value as float)
					chmMod.depthType = (lstDpTp.selection-1) as integer
					chmMod.smoothingoption = (lstSmth.selection-1) as integer
					chmMod.miteringType  = (lstMiTp.selection-1) as integer
					chmMod.amountType = (lstAmTp.selection-1) as integer
						
					chmMod.smoothtype = 0
					chmMod.smooththreshold = 65.0
						
					--set weighted normals modifier parameters
					wgtMod.snapToLargestFace = on
					wgtMod.displayNormals = on
					wgtMod.normalLength = 0.1
						
					--add chamfer modifier 
					addModifier i (copy chmMod)
						
					if chk_Sho_Cha.checked then 
					(
						--add weighted normals
						addModifier i (copy wgtMod)			
					)						
				)
					
			)	
			
			end = timeStamp()

			format "Processing took % seconds\n" ((end - start) / 1000.0)
			CompleteRedraw()
		)
		
		
		On cmdCreate pressed do
		(
				
			-- copy selection (can't copy arrays in 3dsmax)
			local sel = #()
			for i=1 to selection.count do
			(
				sel[i] = selection[i]
			)
		  
			-- create selection list
			for i=1 to sel.count do
			(
				GenWeightedNormals sel[i]
				$.modifiers[#Set_Normals].displayLength = 1
			)
		)  
		On cmdLock pressed do 
		(
			-- copy selection (can't copy arrays in 3dsmax)
			local sel = #()
			for i=1 to selection.count do
			(
				sel[i] = selection[i]
			)
				
			-- create selection list
			for i=1 to sel.count do
			(
				GenWeightedNormals sel[i]
				macros.run "Modifier Stack" "Convert_to_Poly"
				
			)
				
			-- restore selection
			selection = sel
				
		 )
		 
		on cmdAdjust pressed do 
		(
			
			macros.run FlowPanels "SetNormals"
			
		)
		 
		------------------------------------------------------------------------------------------------------------------------------
		-- OPEN // CLOSED 
		------------------------------------------------------------------------------------------------------------------------------
			
		on panNormals rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panNormals
			)	
		)