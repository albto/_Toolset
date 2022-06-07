------------------------------------------------------------------------------------------------------------------------------
			
		group "Viewport Canvas: "
		(
			button viewCanvas "Launch Viewport Canvas" width: 160 Height: 30
		)
			
		------------------------------------------------------------------------------------------------------------------------------
		on viewCanvas pressed do 
		(
			macros.run "Viewport Canvas" "ViewportCanvas"
		)
		------------------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------
			
		Group "Vertex Display: "
		(
			button btn_sho_vert "Show Color" 					width:32 	Height:32 	images:#("VertexPaint_i.bmp", "VertexPaint_i.bmp",23,4,5,1,0) 	ToolTip: "Show Vertex Colors"	across:5 
			button btn_sho_text "Show Texture" 					width:32 	Height:32 	images:#("VertexPaint_i.bmp", "VertexPaint_i.bmp",23,3,5,1,0) 	ToolTip: "Show Textures"
			button btn_sho_uv1 "Show UV1" 						width:32 	Height:32 	images:#("VertexPaint_i.bmp", "VertexPaint_i.bmp",23,1,5,1,0) 	ToolTip: "Show UV_1"
			button btn_sho_uv2 "Show UV2" 						width:32 	Height:32 	images:#("VertexPaint_i.bmp", "VertexPaint_i.bmp",23,1,5,1,0) 	ToolTip: "Show UV_2"
			button btn_sho_tint "Show Tint" 					width:32 	Height:32 	images:#("VertexPaint_i.bmp", "VertexPaint_i.bmp",23,7,5,1,0) 	ToolTip: "Show Mesh Tint Colors"
		)
		
		Group "Vertex Paint Layer Settings: "
		(
			dropdownList ddl_mode_state "Mode:" 				across:3 items:#("Normal", "Overlay", "Screen", "Multiply", "Add", "Subtract", "Lighten", "Darken")
			slider sld_opac_val "Opacity:"						width:125 	Height:20	range: [0, 100, 100]  type:#integer
			edittext edt_opac_read ""							width:45 	Height:20	offset:[35,20]		text:(sld_opac_val.value as string)
			
			button btn_vert_pnt_clr "Color" 					width: 55 	Height:30	across:4
			button btn_vert_pnt_tnt "Tint" 						width: 55 	Height:30
			button btn_vert_pnt_uv "UV1" 						width: 55 	Height:30
			button btn_vert_pnt_id "Mesh IDs" 					width: 55 	Height:30	align:#right	offset:[-1,0]
			
			colorpicker clr_paint_color ""						color:white across:2
			button chk_clr_1 "Black"							images:#("VertexPaint_i.bmp", "VertexPaint_i.bmp",23,4,5,1,0) 	ToolTip: "Show Vertex Colors"	
		)
			
		Group "Bake Vertex Paint: "
		(
			label lbl_brit "Brightness:"								align:#left		across:2
			spinner exp_brit ""							width: 90 		align:#right	range:[0, 100, 50] 	type:#float
			
			label lbl_contr "Contrast:"									align:#left		across:2
			spinner exp_contr ""						width: 90		align:#right	range:[0, 100, 50.0] 	type:#float
			
			label lbl_val "Exposure:"									align:#left		across:2
			spinner exp_val ""							width: 90		align:#right	range:[0, 5, 0]		type:#float
			checkbox chk_glo_sub "  Global Subdivision Settings"
			checkbox chk_inc_sky "  Include Skylight"
				
			button btn_bake_ao "Bake AO"				width:80 Height: 30				across:2
			button btn_app_bak "Bake Settings"				width:80 Height: 30	
				
		)
			
		------------------------------------------------------------------------------------------------------------------------------	
			
		on sld_opac_val changed val do 
		(
			edt_opac_read.text = val as string
		)
		
		
		on btn_vert_pnt_clr pressed do 
		(
			mdf = modpanel.getCurrentObject()
			sel = selection as array 
				
			for i in sel do 
			(
				
				if i.modifiers[#VextexPaint] == "VextexPaint - Color" then
				(
					print "Yes!"
				)
				
				
				addModifier i (PaintLayerMod ())
				
				i.VertexPaint.mapChannel = 0
				i.VertexPaint.layerIsolated = false
				i.VertexPaint.surviveCondense = true
				
				ChannelInfo.NameChannel i 3 1 "UV_1"
				ChannelInfo.NameChannel i 3 2 "UV_2"
				ChannelInfo.NameChannel i 3 3 "UV_Mesh_Tint"
					
				i.VertexPaint.name = "VextexPaint - Color"
				
				sel = i 
					
				deselect i
				select sel
					
			)
		)
		
		------------------------------------------------------------------------------------------------------------------------------	
			
		on btn_vert_pnt_tnt pressed do 
		(
			mdf = modpanel.getCurrentObject()
			sel = $ 
			
-- 			if (classof mdf) == VertexPaint then 
-- 			(
-- 				validmodifier $ VertexPaint 
-- 				
-- 				n =	$.modifiers[#VertexPaint] 
-- 				
-- 				--modPanel n
-- 				
-- 				--return false 
-- 			)
-- 			else 
			(
				addModifier $ (VertexPaint ())
				
				$.VertexPaint.mapChannel = 3
				$.VertexPaint.layerIsolated = false
				$.VertexPaint.surviveCondense = true
				
				ChannelInfo.NameChannel $ 3 1 "UV_1"
				ChannelInfo.NameChannel $ 3 2 "UV_2"
				ChannelInfo.NameChannel $ 3 3 "UV_Mesh_Tint"
					
				$.VertexPaint.name = "VextexPaint - Mesh Tint"
				
				sel = $ 
					
				deselect $
				select sel
					
			)
		)
			
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_vert_pnt_id pressed do 
		(
			macros.run FlowPanels RandElementClr
			completeReDraw()
		)
		
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_sho_vert pressed do 
		(

			v = VertexPaintTool()
			--ReferenceTarget:Vertex_Paint_Floater
			v.mapDisplayChannel = 0
			
			for i in selection as array do
			(
				
				if i.showVertexColors == off then
				(
					i.showVertexColors = on
				)
				else
					i.showVertexColors = off
					i.showVertexColors = on

			)
				
		)
			
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_sho_text pressed do 
		(

			for i in selection as array do
			(
				
				if i.showVertexColors == on then
				(
					i.showVertexColors = off
				)

			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_sho_uv1 pressed do 
		(
			v = VertexPaintTool()
			--ReferenceTarget:Vertex_Paint_Floater
			v.mapDisplayChannel = 1
						
			for i in selection as array do
			(
			if i.showVertexColors == off then
				(
					i.showVertexColors = on
				)
				else
					i.showVertexColors = off
					i.showVertexColors = on

			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_sho_uv2 pressed do 
		(
			v = VertexPaintTool()
			--ReferenceTarget:Vertex_Paint_Floater
			v.mapDisplayChannel = 2
						
			for i in selection as array do
			(
				if i.showVertexColors == off then
				(
					i.showVertexColors = on
				)
				else
					i.showVertexColors = off
					i.showVertexColors = on

			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_sho_tint pressed do 
		(
			v = VertexPaintTool()
			--ReferenceTarget:Vertex_Paint_Floater
			v.mapDisplayChannel = 3
						
			for i in selection as array do
			(
			if i.showVertexColors == off then
				(
					i.showVertexColors = on
				)
				else
					i.showVertexColors = off
					i.showVertexColors = on

			)
				
		)
			
		------------------------------------------------------------------------------------------------------------------------------	
		on exp_brit changed val do 
		(
			LinExp = Linear_Exposure_Control()
			SceneExposureControl.exposureControl = LinExp
			
			LinExp.active = true
			
			SceneExposureControl.exposureControl.brightess = val
		)
		------------------------------------------------------------------------------------------------------------------------------	
		on exp_contr changed val do 
		(
			LinExp = Linear_Exposure_Control()
			SceneExposureControl.exposureControl = LinExp
			
			LinExp.active = true
			
			SceneExposureControl.exposureControl.contrast = val
		)
		------------------------------------------------------------------------------------------------------------------------------		
		on btn_bake_ao pressed do 
		(
				
			obj = getCurrentSelection() 
			 
			Skylight pos:[0,0,0] isSelected:on
			$.name = "AmbientBake"
			$.castShadows = on 
				
			select obj 
				
				
			LinExp = Linear_Exposure_Control()
			SceneExposureControl.exposureControl = LinExp
			LinExp.active = true
-- 				
-- 			LinExp.contrast = exp_contr.value
-- 			LinExp.brightess = exp_brit.value
-- 			LinExp.exposureValue = exp_val.value
				
				
			SceneRadiosity.showPanel() 
			sceneRadiosity.radiosity = Radiosity()
				
			sceneRadiosity.radiosity.radProcessInRenderOnly = false 
			sceneRadiosity.radiosity.radInitialQuality = 95
				
				
			sceneRadiosity.radiosity.radFiltering = 5
				
				
			-- global Subdivision settings
			sceneRadiosity.radiosity.meshingEnabled = chk_glo_sub.state
			sceneRadiosity.radiosity.useAdaptiveMeshing = chk_glo_sub.state
			sceneRadiosity.radiosity.includeSkylight = chk_inc_sky.state
				
			sceneRadiosity.radiosity.initialMeshSize = 10.0
			sceneRadiosity.radiosity.contrastThreshold = 100.0
				
			sceneRadiosity.radiosity.Start () 
				
		)
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_app_bak pressed do 
		(
			mdf = modpanel.getCurrentObject()
			if (classof mdf) != VertexPaint then
			(
-- 					modPanel.addModToSelection (VertexPaint ()) ui:on
				macros.run "Modifiers" "Vertex_Paint"
				--modPanel.setCurrentObject $.modifiers[#VertexPaint]
				$.modifiers[#VertexPaint].lightingModel = 0
				$.modifiers[#VertexPaint].radiosityOption = 1
				$.modifiers[#VertexPaint].mapchannel = 0
				--$.modifiers[#VertexPaint].colorBy = 2
				--$.modifiers[#VertexPaint].radiosityOnly = true
				--rootScene[#Environment][#Advanced_Lighting].rmReuseDirectIllumination = on
				for i in selection do
				(						
					AssignVertexColors.ApplyNodes i vertexPaint:i.modifiers[#VertexPaint]
				)
				$.showVertexColors = on
			)
			else
			(
				AssignVertexColors.ApplyNodes $ vertexPaint:$.modifiers[#VertexPaint]
			)
			update $
			Select $
		)
			
		on BtnSendToSubstancePainter pressed do
		(
			-- Check if something is selected
			if $ !=undefined then (
				spVersion = ""
				-- Check if the user specified a path for SP1 or SP2
				if (doesFileExist (edittextSubstancePainterPath.text+"\\Substance Painter.exe")) then (
					print "Substance Painter 1 detected"
					substancePainterFullPath = "\""+edittextSubstancePainterPath.text as string+"\\Substance Painter.exe\""
					spVersion = 1
				)
				else if (doesFileExist (edittextSubstancePainterPath.text+"\\Substance Painter 2.exe")) then (
					print "Substance Painter 2 detected"
					substancePainterFullPath = "\""+edittextSubstancePainterPath.text as string+"\\Substance Painter 2.exe\""
					spVersion = 2
				)
				else (
					messageBox "Substance Painter executable cannot be detected in specified path"
				)
				
				-- Check if specified SP path is valid
				if (doesFileExist (execute(substancePainterFullPath))) then (
					if not (doesFileExist edittextFbxExportPath.text) do (
						try (
							makedir edittextFbxExportPath.text
						)
						catch(
							print "Cannot create dir at specified FBX export path"
						)
					)
					
					if (doesFileExist edittextFbxExportPath.text) then (
						getObjects(objectToExport)
						select objectToExport
						print "Object(s) to export: "
						for i = 1 to objectToExport.count do (
							print objectToExport[i].name
						)
						
						-- Use the fileName set by the user if available
						if (edittextFileName.text != "") then (
							fileName = edittextFileName.text
						)
						else(
						-- Use the first object name as filename
							fileName = ((objectToExport[1]).name)
						)
						
						-- Set the export path based on folder creation option
						if (checkboxCreateSubFolder.state == true) then (
							completeExportPath = (edittextFbxExportPath.text+"\\"+fileName) 
						)
						else (
							completeExportPath = edittextFbxExportPath.text
						)
						
						fbxPath = completeExportPath+"\\"+fileName+".FBX"
						substancePainterProjectPath = completeExportPath+"\\"+fileName+".spp"
						
						-- No "hot reload" possible, here is the workaround: kill SP if option is enabled to allow quick preview for the user
						if (checkboxKillSubstancePainter.state == true) and spVersion == 1 then (
							DOSCOMMAND("taskkill /f /im \"Substance Painter.exe\"")
						)
						else if (checkboxKillSubstancePainter.state == true) and spVersion == 2 then (
							DOSCOMMAND("taskkill /f /im \"Substance Painter 2.exe\"")
						)
						
						--Delete Substance painter project if it already exists (to replace it) based on the option
						if (replaceExistingSpProject.state == true) and (doesFileExist substancePainterProjectPath) do (
							try (
								-- Delay necessary to be sure the file is not "read only" anymore due to Substance Painter
								sleep 3
								deleteFile substancePainterProjectPath
							)
							catch (
								messageBox "Impossible to remove existing Substance Painter document."
							)
						)
						
						-- Check if the user specified a custom spp file
						if (doesFileExist edittextUseSpp.text) and edittextUseSpp.text != "" then (
							extension = substring edittextUseSpp.text (edittextUseSpp.text.count-3)  4
							if (extension == ".spp") then (
								if (copyFile edittextUseSpp.text (completeExportPath+"\\"+fileName+".spp")) then (
									print "Spp file successfully copied!"
								)
								else (
									messageBox ("Impossible to copy existing .spp file (can be related to administrator rights)."+
													"\nBe sure to enable \"Replace existing Substance Painter document\" if needed.\n\n"+
													"An empty Substance Painter document (or the already existing one) will be used instead."
									)
								)
							)
							else (
								messageBox "Please specify a path to a valid .spp file.\nAn empty Substance Painter document will be used instead."
							)
						)
						else if edittextUseSpp.text != "" do (
							messageBox "Spp file path is invalid.\nAn empty Substance Painter document will be used instead."
						)
						
						-- Create export folder if it doesn't exsist
						if doesFileExist completeExportPath  == false do (
							makedir completeExportPath
						)
						
						-- Exports the object as fbx with default settings. Display dialog depending on the option settings
						if (displayExporterDialog.checked == true or firstExport== true) then (
							exportFile fbxPath  selectedOnly:true 
						)
						else(
							exportFile fbxPath  #noPrompt selectedOnly:true 
						)
						
						-- Store the user path
						global userExportPath = edittextFbxExportPath.text
						
						if doesFileExist fbxPath == true do (
							local firstExport = false
							print ("Export path: "+completeExportPath)
							
							-- Export the normal maps used in objects' materials is option is enabled
							if (checkboxExportWithNormalMap.state  == true) do (
								copiedNormalMaps = #()
								for i = 1 to objectToExport.count do (
									copyNormal objectToExport[i] completeExportPath
								)
							)
							
							-- Store the user path
							global userSubstancePainterPath = edittextSubstancePainterPath.text
							
							-- Base command
							substancePainterCmd = " \""+substancePainterProjectPath+"\""+" --export-path "+"\""+completeExportPath+"\""+" --mesh "+" \""+fbxPath+"\""
							
							-- Add normal map inputs to the command if available
							if (checkboxExportWithNormalMap.state  == true and copiedNormalMaps != #()) do(
								for nrm = 1 to copiedNormalMaps.count do(
									substancePainterCmd += (" --mesh-map \""+copiedNormalMaps[nrm]+"\" ")
								)
							)
							
							print substancePainterCmd
							
							ShellLaunch substancePainterFullPath 	(substancePainterCmd)
						)
					)
				)
				else(
					messageBox "Please enter a valid path for Substance Painter"
				)
			)
			else(
				messageBox "Please select an object"
			)
		)

		------------------------------------------------------------------------------------------------------------------------------
		-- OPEN // CLOSED 
		------------------------------------------------------------------------------------------------------------------------------
		on panPaint rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panPaint
			)	
		)