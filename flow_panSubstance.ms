		
--------------------------------------------------------------------------
			
		Group "Substance Painter: "
		(
		
			--GUI
			bitmap bitmapBannerUi 						width:200 height:52 fileName:bitmapBannerFile align:#center gamma:1.0
			edittext edittextSubstancePainterPath "" 	width:185 text:defaultSubstancePainterPath tooltip:"Substance Painter application folder path." fieldWidth:160 align:#center
			button btnSubstancePainterPath "Substance Painter path: " width:200   --pos:[310,77,0] initialDir:defaultSubstancePainterPath 
			
			edittext edittextUseSpp "" text:defaultSppPath tooltip:"Path to an existing Substance Painter document. Will be used as source for the custom spp creation." --fieldWidth:140
			button btnSppPath "Use Existing Spp:"  width:200 --pos:[310,149,0]
			
		)
			
		Group "Spp Settings: "
		(
			edittext edittextFileName "Exported file name (optional):" 						labelontop:true tooltip:"Allow to use a custom name for the exported file. If none is specified, it will use the first object in alphabetic order." text:"" 
				
			button btnExportPath "Export path:"  		width:200 --pos:[310,102,0]
			edittext edittextFbxExportPath "" 			width:200 text:defaultExportPath 					tooltip:"Path where the meshes are exported/Substance documents are created." fieldWidth:160 align:#center
				
		)
			
		Group "Project Settings: "
		(
				
			checkbox checkboxCreateSubFolder			"Create Project Sub-Folder" 		checked:false 	tooltip:"Will create a dedicated folder in the specified export path"
			checkbox checkboxExportWithNormalMap 		"Export Normal map" 				checked:true 	tooltip:"Export with Normal map detected in the material"
			checkbox replaceExistingSpProject 			"Replace SPP" 						checked:false 	tooltip:"A new .spp file will be created (previous version of the document will be removed.)"
			checkbox displayExporterDialog 				"Quick Export" 						checked:false 	tooltip:"Display 3dsMax FBX export dialog, enable it to modify export settings"
			checkbox checkboxKillSubstancePainter 		"Close Open Painter Projects" 		checked:true 	tooltip:"Automatically close/relaunch Substance Painter to get file updates. Save SP current document before use!"
				
			button BtnSendToSubstancePainter 			"Send to Substance Painter" 						tooltip:"Export current selection as FBX and create SP document." width: 200 height: 40 --pos:[80,302,0]
				
		)
			
			
		-- Get Substance Painter path from button if input is valid
		on btnSubstancePainterPath pressed do 
		(
			getSubstancePainterPath = getSavePath ()
			SubstancePainterPath = getSubstancePainterPath as string
			if (doesFileExist SubstancePainterPath) do (
				edittextSubstancePainterPath.text = SubstancePainterPath
			)
		)
		
		-- Get export path from button if input is valid
		on btnExportPath pressed do 
		(
			getExportPath = getSavePath ()
			ExportPath = getExportPath as string
			if (doesFileExist ExportPath) do (
				edittextFbxExportPath.text = ExportPath
			)
		)
		
		on btnSppPath pressed do 
		(
			SppPath = getOpenFileName \ 
			caption:"Open a .spp File:" \ 
			types:"Spp files (*.spp)" \
			if (SppPath != undefined) then 
			(
				-- Check file extension to see if it is a .spp
				SppPathExtension = substring SppPath (SppPath.count-3) 4
				if SppPathExtension == ".spp" then (
					edittextUseSpp.text = SppPath
				)
				else (
					messageBox "Please select a .spp file"
					edittextUseSpp.text = ""
				)
			)
			else
			(
				edittextUseSpp.text = ""
			)
		)
		
		fn getObjects objectToExport=
		(
			-- Get selected objects
			objectsFromSelection = #()
			for obj in (selection as array) do (
				append objectsFromSelection obj
			)
			
			names = for i=1 to objectsFromSelection.count collect (objectsFromSelection[i].name)
			sort names
			
			objectsFromSelectionAlphabeticalOrder = #()
			
			-- Sort objects based on name
			for n=1 to names.count do(
				for s=1 to objectsFromSelection.count do (
					if (names[n] == objectsFromSelection[s].name) do (
						append objectsFromSelectionAlphabeticalOrder objectsFromSelection[s]
					)
				)
			)
			
			global objectToExport = objectsFromSelectionAlphabeticalOrder
		)
		
		fn copyNormal sourceObject completeExportPath =
		(
			materialsList = #()
			materialType = ""
			
			try(
				-- Check if the object use several materials
				if sourceObject.material.materialList != undefined do (
					materialType = "notClassic"
					for m = 1 to sourceObject.material.count do (
						append materialsList sourceObject.material[m]
					)
				)
			)
			catch (
				materialType = "classic"
				append materialsList sourceObject.material
			)
			
			-- Get Normal map(s) from listed material(s)
			for mat = 1 to materialsList.count do (
				try (
					materialName = materialsList[mat].name as string
				)
				catch()
				
				-- As Substance Painter automatically remove "#" characters in texture sets name we check if we have one
				try (
					if findString (materialName) "#" != undefined do (
						materialName = substituteString materialName "#" "_"
					)
				)
				catch ()
				
				if materialType == "classic" then (
					try (
						normalToCopy = sourceObject.material.bumpMap.normal_map.filename
						normalCopied = completeExportPath+"\\"+materialName+"_normal_base.png"
					)
					catch (
						print ("No normal to copy in " + materialsList[mat] as string)
					)
				)
				else if materialType == "notClassic" do (
					try (
						normalToCopy = sourceObject.material[mat].bumpMap.normal_map.filename
						normalCopied = completeExportPath+"\\"+materialName+"_normal_base.png"
					)
					catch (
						print ("No normal to copy in " + materialsList[mat] as string)
					)
				)
					
				if (normalToCopy != undefined) do (
					-- If the Normal already exist we remove it
					if doesFileExist normalCopied  == true do (
						try (
							deleteFile normalCopied
						)
						catch (
							print ("Can't remove existing Normal : " + normalCopied)
						)
					)
					if (copyFile normalToCopy normalCopied) do(
						append copiedNormalMaps normalCopied
					)
				)
			)
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
			
		-- get saved data on start up
		on panSubstance rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				--switches to this rollout
				if open do switchRolls panSubstance
			)	
		)
			