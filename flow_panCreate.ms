	
	----------------------------------------------------------------------------------------------------------------
	--Variables 
		
		local 	PrimiPlaceOrigin 		= true
		local 	PrimiPlaceSelection 	= false
		local 	valueForPrims 			= 1.0
		global 	PrimScale 				= set_primScale 
		
	----------------------------------------------------------------------------------------------------------------	
	--Primitives Group Controls
	
		
		group "Primitive Placement:"
		(
			radiobuttons rbtn_plc_prv ""default:1 labels:#("Origin", "Selection") tooltip:"" columns:2 
		)

		group "Primitives:" 
		(
			button c_Box 		"Box" 			width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,1,1,1,1) 		ToolTip: "Create Box"  			across:5
			button c_Cylinder 	"Cylinder" 		width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,3,3,1,1) 		ToolTip: "Create a Cylinder"
			button c_Sphere 	"Sphere" 		width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,2,2,1,1) 		ToolTip: "Create Sphere"
			button c_Tube 		"Tube"  		width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,8,8,1,1) 		ToolTip: "Create Tube"
			button c_Plane 		"Plane"  		width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,10,10,1,1) 		ToolTip: "Create Plane"
			button c_Cone 		"Cone" 			width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,6,6,1,1) 		ToolTip: "Create Cone"  		across:5
			button c_Pyramid 	"Pyramid" 		width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,9,9,1,1) 		ToolTip: "Create Pyramid"  
			button c_Geosphere  "GeoSphere" 	width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,7,7,1,1) 		ToolTip: "Create GeoSphere"  
			button c_Torus 		"Torus" 		width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,4,4,1,1) 		ToolTip: "Create Torus" 
			button c_TxtPlus 	"Text Plus" 	width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,11,11,1,1) 		ToolTip: "Create Text+"  			
			
		)
			
		group "Primitive Scale"
		(
			spinner c_PrimText "Size" range:[0,999999999, PrimScale] 
		)
		----------------------------------------------------------------------------------------------------------------
		
		Group "Shapes:"
		(
			button c_Spline "Spline"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,1,1,1,1 ) 		ToolTip: "Create Spline" 	across: 5
			button c_Circle "Circle"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,2,2,1,1 ) 		ToolTip: "Create Circle"
			button myBttn16 "Arc"  		width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,3,3,1,1 ) 		ToolTip: "Create Arc"
			button myBttn17 "NGon"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,4,4,1,1 ) 		ToolTip: "Create NGon"
			button myBttn18 "Text"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,5,5,1,1 ) 		ToolTip: "Create Text"
			button myBttn19 "Rectangle" width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,7,7,1,1 ) 		ToolTip: "Create Rectangle" across:5
			button myBttn20 "Ellipse"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,8,8,1,1 ) 		ToolTip: "Create Ellipse"
			button myBttn21 "Donut"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,9,9,1,1 ) 		ToolTip: "Create Donut"
			button myBttn22 "Star"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,10,10,1,1 ) 	ToolTip: "Create Star"
			button myBttn23 "Helix"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,11,11,1,1 ) 	ToolTip: "Create Helix"
				
			
		)
	
		---------------------------------------------------------------------------------------------------------------- HELPERS
		
		group "Helpers:" 
		(
				
			button c_Point "Point" 							width:32 height: 32 align:#align_topcleft images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,2,2,1,1 ) ToolTip:"Create Point" across:5
			button c_Grid "Active Grid" 					width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,4,4,1,1 ) ToolTip:"Create Grid Helper" 
			button c_Container "Container" 					width:32 height: 32 align:#align_topleft  images:#("Containers_24i.bmp", "Containers_24i.bmp",17,2,2,1,1 ) ToolTip:"Create Container" 
			button c_Dummy "Dummy"  						width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,1,1,1,1 ) ToolTip:"Create Dummy Helper" 
			button c_TapeMeasure "Tape Measure"  			width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,5,5,1,1 ) ToolTip:"Create Dummy Helper" 
			
		)
			
		
	-------------------------------------------------------------------------------------MaxScripts Group Controls
			
		local lauFileNam 
		group "Launch MaxScripts" 
			
		(
			editText lau_Scp_Pth "Script:" 
				
			DropDownList lau_scripts "" items:#()
			button btn_scp_add "Add to List"			width:65		across:3
			button btn_scp_edt "Edit List"				width:65	
			button btn_scp_dlt "Delete List"			width:65	
				
			button btn_scp_lau "Launch Script"			width:100	height:30	across:2 --align:#center
			button btn_scp_all "Launch All"		width:100   	height:30
				
		)	
			
			
		-----------------------------------------------------------------------------------------------------------------------
		--SAVE SCRIPTS LIST
		-----------------------------------------------------------------------------------------------------------------------
			
		fn SaveLauScripts = 
		(
				
			--write to file
			ssLau = createFile (mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp")
			
			format "%\n" (with printAllElements on scptsData as string) to:ssLau
			close ssLau
				
		)

		fn setFileName item = 
		(
			--adds item value to Export Folder Location
			str = ("#" + lau_scripts.items[item] as string)
			str2 = GetDictValue scptsData (execute str)	
			
			--grab folder path and set as item in array
			if str2 != undefined then
			(
				fldr = str2
					
				--tooltip 
				lau_Scp_Pth.tooltip = fldr as string
					
				--grab folder path and set as item in array
				lauFileNam = fldr
			)
		)
			
		fn LoadLauScripts = 
		(
			-- Scripts Launch Preset Locations on Start-up
			if doesFileExist (mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp") then
			(
				print "LOAD DATA ATTEMPT"
				
				scpts = openfile (mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp") mode:"r"
				scptsData = execute (readLine scpts)
				close scpts
			)
			else
				scptsData = Dictionary()
				
		)
			
			
			
		--Primitive Scale
		on c_PrimText changed val do 
		(			
			--Create Value 
			PrimScale 	 		= val
			
			--Record Settings -- Primitve Scale Value
			SetAutoSettings val 16
			
		)
		
		--RadioButtons - Placement Position 
		on rbtn_plc_prv changed state do 
		(
			if rbtn_plc_prv.state == 2 do 
			(
				PrimiPlaceOrigin = false
				PrimiPlaceSelection = true
				print ("Primitive Place on selection is " + PrimiPlaceSelection as string )
			)
				
			if rbtn_plc_prv.state == 1 do 
			(
				PrimiPlaceOrigin = true
				PrimiPlaceSelection = false
				print ("Primitive Place on origin is " + PrimiPlaceOrigin as string )
			)
		)
		
		--Button Function - Create Box 
		on c_Box pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeBox
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeBoxSel
			)
		)
		
		--Button Function - Create Cylinder 
		on c_Cylinder pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeCyl
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeCylSel
			)
		)
			
		--Button Function - Create Sphere
		on c_Sphere pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeSph
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeSphSel
			)
		)
			
		--Button Function - Create Tube
		on c_Tube pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeTub
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeTubSel
			)
		)
			
		--Button Function - Create Plane
		on c_Plane pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makePlane
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makePlaneSel
			)
		)
			
		--Button Function - Create Cone
		on c_Cone pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeCone
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeConeSel
			)
		)
		
		--Button Function - Create Pyramid		
		on c_Pyramid pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makePyra
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makePyraSel
			)
		)
		
		--Button Function - Create GeoSphere
		on c_Geosphere pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeGeo
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeGeoSel
			)
		)
		
		--Button Function - Create Torus
		on c_Torus pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeTor
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeTorSel
			)
		)
		
		--Button Function - Create TextPlus
		on c_TxtPlus pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeTex
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeTexSel
			)
		)
		
		--Button Function - Create Spline
		on c_Spline pressed do
		(
			startObjectCreation line		
		)
		--Button Function - Create Circle
		on c_Circle pressed do
		(
			
			startObjectCreation circle	
			
		)
		--Button Function - Create Arc
		on myBttn16 pressed do
		(
			
			startObjectCreation arc	
			
		)	
		--Button Function - Create Ngon
		on myBttn17 pressed do
		(
			
			startObjectCreation ngon
			
		)	
		--Button Function - Create Text
		on myBttn18 pressed do
		(
			
			startObjectCreation text
			
		)	
		--Button Function - Create Rectangle
		on myBttn19 pressed do
		(
			
			startObjectCreation rectangle
			
		)	
		
		on myBttn20 pressed do
		(
			
			startObjectCreation ellipse
			
		)	
		--Button Function - Create  Donut
		on myBttn21 pressed do
		(
			
			startObjectCreation donut	
			
		)
		--Button Function - Create Star
		on myBttn22 pressed do
		(
			
			startObjectCreation star
			
		)
		--Button Function - Create Helix
		on myBttn23 pressed do
		(
			
			startObjectCreation helix
			
		)
		

		--Button Function - Create Point
		on c_Point pressed do
		(
			macros.run FlowMaker makePoint
		)
			
		--Button Function - Create Dummy
		on c_Grid pressed do
		(
			hlp_grid = 0 
			grid length:10 width:10 grid:50 pos:[0,0,0] isSelected:on
			$.name = "hlpr_grid_" + hlp_grid as string
			$.name = uniquename("hlpr_grid_")
			
		)
			
		--Button Function - Create Container
		on c_Container pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeCont
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeContSel
			)
				
		)
			
		--Button Function - Create Spline
		on c_Dummy pressed do
		(
			
			hlp_dum = 0 
			Dummy pos:[0,0,0] isSelected:on
			$.name = "hlpr_node_" + hlp_dum as string
			$.name = uniquename("hlpr_node_")
			$.scale = [PrimScale/10, PrimScale/10, PrimScale/10]
			
		)
		
		--Button Function - Create Cone
		on c_TapeMeasure pressed do
		(
			
			hlp_dum = 0 
			Tape length:100 pos:[0,0,0] isSelected:on target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [100,0,0]))
			$.name = "hlpr_node_" + hlp_dum as string
			$.name = uniquename("hlpr_node_")
			
		)
			
		
		on lau_scripts selected i do
		(
				
			--what happens when you select an item
			for i = 1 to lau_scripts.selection do
			(
				--adds item value to Export Folder Location
				str = ("#" + lau_scripts.selected as string)
				str2 = GetDictValue scptsData (execute str)	
				
				--grab folder path and set as item in array
				if str2 != undefined then
				(
					fldr = str2
						
					--tooltip 
					lau_Scp_Pth.tooltip = fldr as string
						
					--grab folder path and set as item in array
					lauFileNam = fldr
				)
					
				lau_Scp_Pth.text = lau_scripts.items[i]
					
				--records settings
				set_imp_list_last_sel = lau_scripts.selection
				SetAutoSettings set_imp_list_last_sel 15
					
				--save settings
				SaveLauScripts()
				
			)
				
		)
			
		on btn_scp_add pressed do 
		(
			
			try destroyDialog lauWndw catch()
			rollout lauWndw "Add Script to List"
			(
				edittext entNam "Entry Name:" 		width:200	height:20								text:"#"  
				edittext valNam "Path:" 			width:500	height:30								text:""  
				button imp_Open "Find Script"		width:110	height:20		align:#center			across:3
				button btn_add_scpt "Add Script"	width:110	height:20		align:#center
				button imp_dlt_Entry "Close"  		width:110	height:20		align:#center
					
				----------------------------------------------------------------------------------
					
					
				on imp_Open pressed do 
				(
					str = getOpenFileName caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") --initialDir:
						
					if str != undefined then 
					(
						--clean up string for entry name
						strNew = str
						strNew = filenameFromPath str
						strNew = substituteString strNew ".mse" ""
						strNew = substituteString strNew ".ms" ""
						strNew = substituteString strNew ".mcr" ""
						strNew = substituteString strNew "." ""
						strNew = substituteString strNew "-" "_"	
						strNew = substituteString strNew " " "_"	
							
						entNam.text = strNew 
						valNam.text = str
						lauFileNam = str
					)
						
				)
					
				on btn_add_scpt pressed do
				(
						
					if entNam.text != "#" then 
					(
							
						local scptSter =  ("#"+filenameFromPath entNam.text) --("#" + lau_scripts.selected as string)
						local scptSter2 = GetDictValue scptsData (execute scptSter)
							
						lau_Scp_Pth.text = scptSter
							
						--adds Key value
						PutDictValue scptsData (execute scptSter) (valNam.text as string)  putOnlyIfNew:true
						--SetDictValue scptsData (execute scptSter) (valNam.text as string)
							
						lau_scripts.items = scptsData.keys
							
						--records settings
						set_imp_list_last_sel = lau_scripts.selection
						SetAutoSettings set_imp_list_last_sel 15
							
						--destroyDialog lauWndw
						valNam.text = ""
						entNam.text = ""
							
							
						print "Added New Item to List!"
							
						--Save Settings 
						SaveLauScripts()
							
						print "Data Saved"
					)
						
				)
					
				----------------------------------------------------------------------------------
					
				on imp_dlt_Entry pressed do 
				(
					
					destroyDialog lauWndw
				)
					
				----------------------------------------------------------------------------------
					
				on valNam entered val do
				(
						
					destroyDialog lauWndw
				)
					
				----------------------------------------------------------------------------------				
					
					
			)			
				
			createDialog lauWndw width:525
			
		)
			
		on btn_scp_dlt pressed do
		(
			--local usedotNam = sysInfo.username as string
			
			if doesFileExist ("G:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_Toolset\FlowPanels\savedata\\ScriptsLocations.fp") then 
			(
				if	yesNoCancelBox  "Are you sure you want to delete this List?" == #yes then 
				(
						
					ss = ("G:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_Toolset\FlowPanels\savedata\\ScriptsLocations.fp")
						
					deletefile (ss)
					free scptsData 
					lau_scripts.items = scptsData.keys
				)
				else			
				(
					return false
				)
			)
			else
			(
				messageBox "Sorry, No List Available" title:"Flow Panels: !WARNING!" beep:false
			)
		)
		
			
		on btn_scp_lau pressed do 
		(
			if lauFileNam != undefined then
			(
				filein lauFileNam
			)
		)
		
		on btn_scp_all pressed do 
		(
			for i = 1 to lau_scripts.items.count do 
			(
				--set filename to item's path
				setFileName i

				--launch item
				if lauFileNam != undefined then
				(
					filein lauFileNam
				)

			)
			
		)
		
			
		-----------------------------------------------------------------------------------------------------------------------
		--OPEN // CLOSED 
		-----------------------------------------------------------------------------------------------------------------------
		on panCreate rolledUp open do 
		(
			--------------------------------------------------------------------------------------------------------------------------------------
			-- Scripts Launch Preset Locations on Start-up
			if doesFileExist(mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp") then
			(
				scpts = openfile (mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp") mode:"r"
				scptsData = execute (readLine scpts)
				close scpts
			)
			else (
				scptsData = Dictionary()
			)
				
			--pass data 
			lau_scripts.items = scptsData.keys
				
				
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panCreate
			)	
		)
			