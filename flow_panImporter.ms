		
		local importItemsArray = #()--set_import_array
		local impFolderPath
		local lastOpenedFldr = set_last_import_loc
		local scrollToSelection = false	
		local forceImport 		= false	
		local loadFBXfiles 		= false
		local loadOBJfiles 		= false
		local loadMAXfiles 		= false		
		local loadInstFiles		= false --- RECORD SETTINGS !!
		local GetSubfolders		= true	
		
		Group "Import Folder"
		(
			edittext import_fldr_nam ""		text: "Import Location"			labelOnTop: true		height:20 		width: 170				align:#left		tooltip:""							fieldWidth:160 across:2
			button btn_add_imp_itm "+" 												width:18 		height:20 		align:#right 			tooltip:"add item to Presets"              
			button btn_imp_show_path "Show in Explorer"								width:100		height:20								tooltip:"Show in Explorer"							across:2
			button btn_edt_imp_fldph "Edit Folder Path"								width:90		height:20		align:#right			tooltip:"Edit the Folder Path Manually"
			button btn_imp_clip_path "Paste From Clipboard"							width:190		height:20								tooltip:"Paste path from clipboard"
			button btn_imp_fold_path "Set Import Location"							width:190		height:20								tooltip: "Manually"
		)
		
		Group "Object Info:"
		(
			label lbl_imp_obj_nam "Selected: " align:#left 
			label lbl_imp_obj_num "Number of Objects: " align:#left
		)
		
		Group "Import Options"
		(
			checkbox 	chk_subfldr	 "Get Subfolders"					checked:GetSubfolders
			checkbutton loadFBXs     ".Fbx" 							checked:loadFBXfiles across:4				tooltip:"Loads All Available .Fbx files"
			checkbutton loadOBJs     ".Obj" 							checked:loadOBJfiles 						tooltip:"Loads All Available .Obj files"
			checkbutton loadMAXs     ".Max" 							checked:loadMAXfiles						tooltip:"Loads All Available .Max files"
			checkbutton loadINSTs    ".MaxC" 							checked:loadInstFiles						tooltip:"Loads All Available 3dsMax Container files"
		)
		
		Group "Availble for Import:" 
		(
			button btn_ref_lst      "Refresh List"							width: 190		height: 20			align:#left				tooltip: "Refreshes List"
			listbox filesToImport 	""  									items:#() 		align:#right caption: "Double Click to Import"
			checkbox scrllToSel 	"Auto-Arrange Selection" 				checked:scrollToSelection
			checkbox forceImp 		"NoPrompt Import" 						checked:forceImport
			button btn_imp_sing     "Import Selected"		across:2		width: 100		height: 20				tooltip: "Imports Everything in the list [you have been warned]"
			button btn_imp_all      "Import All"							width: 90		height: 20				tooltip: "Imports Everything in the list [you have been warned]"			align:#right
		)		
			
		Group "Preset Locations:"
		(
			dropdownlist presetImportLoc ""  items:#() 	width:190		    height:20		align:#center			tooltip:""										
			button btn_imp_edit_item "Edit Entry" 		width:90 			height:20 		align:#center			tooltip:"remove item from Presets"      across:2
			--button btn_imp_save_itm "Save"				width:40			height:20 		align:#center			tooltip:"save presets to file"					across: 4
			--button btn_imp_load_itm "Load"				width:40			height:20		align:#center			tooltip:"load presets file"
			--button btn_imp_clear_itm "Clear"			width:40			height:20		align:#center			tooltip:"clear presets"
			button btn_imp_dlt_preset "Delete List" 	width:90			height:20		align:#center			tooltip:"delete presets save file"
		)
			
		--NO PROMPT IMPORT -- TOGGLE
		On forceImp changed state do
		(   
			Undo on
			forceImport = not forceImport			
		)
			
		On scrllToSel changed state do
		(   
			Undo on
			scrollToSelection = not scrollToSelection			
		)
			
		fn SubPathString str inpStr sub1 sub2 = 
		(
			--substitutes slashes for backslashes
			str = substitutestring inpStr sub1 sub2
			return str	
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------SAVE GENERATED LIST 
			
		fn SaveImpList = 
		(
			local usedotNam = sysInfo.username as string
			
			if presetImportLoc.items.count != 0 do
			(
					
				--write to file
				impss = createFile (mainFPFolder + "\FlowPanels\savedata\PresetImportLocations.fp") 
					
				format "%\n" (with printAllElements on impSavedData as string) to:impss
				flush impss
				close impss
					
				--records settings
				set_imp_list_last_sel = presetImportLoc.selection
				SetAutoSettings set_imp_list_last_sel 15
					
			)	
			
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------GENERATE LIST TYPE
		-- function - - Filters import list for readability-
		fn GenerateDropDownList = 
		(
			--generates dropdownlist of fbx files in the selected folder
			local files = #()
			--files = getFiles((impFolderPath as string + "\\*.fbx"))
				
				
			--GET ALL SUBFOLDERS ------- FUNCTION
			dir_array = GetDirectories (impFolderPath + "*")	
				
			--File Import Options
 			if loadFBXfiles do -- FBX
 			(
				--get subfolders else get parent folder
				if GetSubfolders then
				(
					for d in dir_array do
					(
						join dir_array (GetDirectories (d+"\\*"))
					)
						
					newFiles = #()
					files = getFiles((impFolderPath as string + "\\*.fbx"))
						
					for f in dir_array do
					(
						join newFiles (getFiles (f + "\\*.fbx"))
						files = newFiles
					)
					
				)
				else
					files = getFiles((impFolderPath as string + "\\*.fbx"))
				
 			)
				
			if loadOBJfiles do -- OBJ
 			(
				parentFolder = impFolderPath
				
				--get subfolders else get parent folder
				if GetSubfolders then
				(
					
					for d in dir_array do
					(
						join dir_array (GetDirectories (d+"\\*"))
					)
						
					newFiles = #()
						
					for f in dir_array do
					(
						join newFiles (getFiles (f + "\\*.obj"))
						files = newFiles
					)
					
				)
				else
					files = getFiles((impFolderPath as string + "\\*.obj"))
				
 			)
				
 			if loadMAXfiles do --MAX
 			(
				--get subfolders else get parent folder
				if GetSubfolders then
				(
					for d in dir_array do
					(
						join dir_array (GetDirectories (d+"\\*"))
					)
						
					newFiles = #()
						
					for f in dir_array do
					(
						join newFiles (getFiles (f + "\\*.max"))
						files = newFiles
					)
					
				)
				else
					files = getFiles((impFolderPath as string + "\\*.max"))
				
 			)
				
			if loadInstFiles do --INSTANCE
 			(
				--get subfolders else get parent folder
				if GetSubfolders then
				(
					
					dir_array = GetDirectories (impFolderPath +"\\*")
					for d in dir_array do
					(
						join dir_array (GetDirectories (d+"\\*"))
					)
					
					newFiles = #()
						
					for f in dir_array do
					(
						join newFiles (getFiles (f + "\\*.maxc"))
						files = newFiles
					)
					
				)
				else
					files = getFiles((impFolderPath as string + "\\*.maxc"))
				
 			)			
				
			local tempArray = #()
			local cleanedArray = #()
			
			importItemsArray = files
			
			--SubstituteString for Array
			if importItemsArray.count > 0 do
			(				
				for i =1 to importItemsArray.count do
				(
					str = importItemsArray[i] as string
					
					--substitutes slashes for backslashes
					importItemsArray[i] = SubPathString str str "\r" "/r"
					importItemsArray[i] = SubPathString str str "\\" "/"
					
				)
			)
			
			print importItemsArray
			
			
			cleanedArray = importItemsArray
			
			for i = 1 to cleanedArray.count do
			(
				tempArray[i] = filenameFromPath cleanedArray[i]
				--tempArray[i] = substituteString tempArray[i] ".FBX"
				--tempArray[i] = ("\\\ " + tempArray[i] as string)
			)	
			--print (tempArray as array)
			filesToImport.items = tempArray
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------GENERATE // REFRESH LIST
			
		-- function - - creates import list - 
		fn ManifestImportList =
		(
			-- sets folder path name if undefined
			if (impFolderPath == undefined) then				
			(
				--checks if it has a location saved, before setting it to the default location
				if (lastOpenedFldr == undefined) then
				(
					--sets folder name
					impFolderPath = ("C:\\users\\"+ usedotNam as string +"\\Desktop")
				)
				else
				(
					--sets folder name
					impFolderPath = lastOpenedFldr
				)
					
				--substitutes slashes for backslashes
				impFolderPath = SubPathString impFolderPath impFolderPath "\r" "/r"
				impFolderPath = SubPathString impFolderPath impFolderPath "\\" "/"
					
					
				-- filters path for displaying purposes 
				import_fldr_nam.text = filenameFromPath impFolderPath
 				import_fldr_nam.tooltip = impFolderPath
 				filesToImport.tooltip = impFolderPath
					
				--generates dropdownlist of fbx files in the selected folder
				GenerateDropDownList()
					
				lbl_imp_obj_num.text = "Number of Objects: " + filesToImport.items.count as string 
				
				--sets last opened location
				lastOpenedFldr = impFolderPath
				-----------------------------------------------------------------------------------SAVING DATA
				
				--records settings
				SetAutoSettings lastOpenedFldr 12 --saves data --function
				
				--records array
				SetAutoSettings importItemsArray 13 --saves data --function
				
				--Save List 
				SaveImpList()
					
			)
			else 
			(
				-- sets the folder textbox text, the same as folder path location 
				import_fldr_nam.text = impFolderPath
					
					
				--substitutes slashes for backslashes
				impFolderPath = SubPathString impFolderPath impFolderPath "\r" "/r"
				impFolderPath = SubPathString impFolderPath impFolderPath "\\" "/"
					
					
				--generates dropdownlist of fbx files in the selected folder
				GenerateDropDownList()
					
				--updates the Info
				lbl_imp_obj_num.text = "Number of Objects: " + filesToImport.items.count as string 
				import_fldr_nam.text = filenameFromPath impFolderPath
 				import_fldr_nam.tooltip = impFolderPath
				filesToImport.tooltip = impFolderPath
				
				--sets last opened location
				lastOpenedFldr = impFolderPath	
					
				-----------------------------------------------------------------------------------SAVING DATA							
					
				--records settings
				SetAutoSettings lastOpenedFldr 12 --saves data --function
					
				--records array
				SetAutoSettings importItemsArray 13  --saves data --function
					
				--Save List 
				SaveImpList()
					
			)	
		)
			
		fn CreateNewImportListEntry = 
		(
			try destroyDialog impDialog catch()
					
			rollout impDialog "New Entry Dialog"
			(
				label imp_lbl_entry "Please do not Delete '#' "
				edittext imp_itm_name "Name:" text:"#"
				button imp_pressme "create"  		width:120	height:40
					
				----------------------------------------------------------------------------------
					
				on imp_pressme pressed do 
				(
					--substitutes spaces for underscore
					impS1 = imp_itm_name.text
					impS2 = " "
					impS3 = "_"
					impSSNam = substitutestring impS1 impS2 impS3
						
					--adds Key value
					PutDictValue impSavedData (execute impSSNam) (impFolderPath)  putOnlyIfNew:true
						
					--refresh list
					presetImportLoc.items = impSavedData.keys
						
					--Refresh List
					ManifestImportList()

					destroyDialog impDialog
				)
					
				----------------------------------------------------------------------------------
					
				on imp_itm_name entered i do 
				(
					--substitutes spaces for underscore
					impS1 = imp_itm_name.text
					impS2 = " "
					impS3 = "_"
					impSSNam = substitutestring impS1 impS2 impS3
						
					--adds Key value
					PutDictValue impSavedData (execute impSSNam) (impFolderPath) putOnlyIfNew:true
						
					--refresh list
					presetImportLoc.items = impSavedData.keys
						
					destroyDialog impDialog
				)
				
			)
				
			createDialog impDialog
		)

		--GET ALL SUBFOLDERS -- TOGGLE
		On chk_subfldr changed state do 
		(
			Undo on
			GetSubfolders = not GetSubfolders
			
			--Refresh List
			ManifestImportList()
			
		)
		
		
		--------------------------------------------------------------------------------------------------------------------------------
		--SELECT -- IMPORT LIST -- ITEM
		--------------------------------------------------------------------------------------------------------------------------------
			
		On presetImportLoc selected state do
		(
				
			--what happens when you select an item
			for i = 1 to presetImportLoc.selection do
			(
				--adds item value to Export Folder Location
				str = ("#" + presetImportLoc.selected as string)
				str2 = GetDictValue impSavedData (execute str)	
				
				--grab folder path and set as item in array
				imp_fldr = str2
					
				--tooltip 
				import_fldr_nam.tooltip = imp_fldr as string
					
				--grab folder path and set as item in array
				impFolderPath = imp_fldr
				import_fldr_nam.text = filenameFromPath impFolderPath		
					
				--Refresh List
				ManifestImportList()
				
				--records settings
				set_imp_list_last_sel = presetImportLoc.selection
				SetAutoSettings set_imp_list_last_sel 15
				
			)
				
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- EDITING LIST  -- IMPORT
			
		--------------------------------------------------------------------------------------------------------------------------------
		-- ADD - new item
		--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_add_imp_itm pressed do 
		(
			--create new entry
			CreateNewImportListEntry()
				
		)
		-------------------------------------------------------------------------------------------------------------------------------- 
		--EDIT - selected item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_imp_edit_item pressed do 
		(
			if (impSavedData.count > 0) do 
			(

				global ster = ("#" + presetImportLoc.selected as string)
				global ster2 = GetDictValue impSavedData (execute ster)
				
				rollout impWndw "Edit List"
				(
					global itemList = #()					
						
					edittext valNam "Entry Name:" 			text:ster readOnly: true
						
					dropdownList lst_proj 	"Projects:"		
					button btn_crt_prj		"Create Project"	across:3
					button btn_nxt_prj		"Next Project"
					button btn_prv_prj		"Prev Project"
						
					listbox lst_prj_itms 	"Projects:"				across:2	
					listbox lst_itms 		"Entries:"				
					edittext chngVal 		"Current Value:" 		width:380 	height:60	labelontop:true	text:ster2	fieldwidth:380
					button btn_addEnt 		"Add Entry"				width:180	height:30	align:#center	across:2
					button exp_Open 		"Open Directory"		width:180	height:30	align:#center
					button btn_save			"Save Settings"			width:180	height:30	align:#center	across:2
					button dlt_Entry 		"Delete Entry"  		width:180	height:30	align:#center
					button accpt 			"Accept"				width:370	height:30	align:#center
					timer updList 			""						interval:200
						
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Turn off List Auto Update  - FUNCTION
					--------------------------------------------------------------------------------------------------------------------------------
					fn AutoUpdateOff sender evt=
					(
						-- important: don't repeat this timer event
						sender.enabled = false
						-- for sanity and cleanup
						dotnet.RemoveEventHandler sender "Elapsed" AutoUpdateOff        
							
						-- put all your tasks below
						newExpEntry = false
					)
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Generate List Item and its Contents - FUNCTION
					-------------------------------------------------------------------------------------------------------------------------------- 
					fn GenerateListItemContents sel = 
					(
						ster = ("#" + (lst_itms.items[sel] as string))
						ster2 = GetDictValue impSavedData (execute ster)
							
						valNam.text = ster
							
						if ster2 != undefined then
						(
							chngVal.text = ster2
						)
					)
						
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Timer Tick - Update Loop
					-------------------------------------------------------------------------------------------------------------------------------- 
					on updList tick do 
					(
						if newExpEntry == true then 
						(
							itemList = presetImportLoc.items
							lst_itms.items = itemList
								
							delayTimer= dotnetobject "Windows.Forms.Timer"
							delayTimer.Interval=1000
								
							dotnet.AddEventHandler delayTimer "Tick" AutoUpdateOff
								
							delayTimer.enabled = true
							
						)
					)
						
					----------------------------------------------------------------------------------
						
					on btn_crt_prj pressed do
					(
						lst_proj.items = append lst_proj.items "New_Project"
						lst_prj_itms.items = append lst_prj_itms.items "New_Project"
					)
						
					----------------------------------------------------------------------------------
						
					on lst_itms selected i do 
					(
						if i != 0 then 
						(
							--Generate list item and contents   --selection
							GenerateListItemContents  i 
						)
					)
					----------------------------------------------------------------------------------
						
					on lst_itms rightClick i do 
					(
						if i != 0 then 
						(
							--set selection 
							presetImportLoc.selection = i 
							lst_itms.selection = i
								
							--Generate list item and contents   --selection
							GenerateListItemContents  i 
						)

						--Refresh List
						ManifestImportList()
							
					)
						
					----------------------------------------------------------------------------------
						
					on btn_addEnt pressed do 
					(
						--create new entry
						CreateNewImportListEntry()
					)
						
					----------------------------------------------------------------------------------
						
					on accpt pressed do
					(
						SetDictValue impSavedData (execute ster) (chngVal.text as string)	
						
						if ster != undefined then
						(
							presetImportLoc.items = impSavedData.keys
								
							impFolderPath = chngVal.text
							-- filters path for displaying purposes 
							import_fldr_nam.text = filenameFromPath impFolderPath
							import_fldr_nam.tooltip = impFolderPath
							presetImportLoc.tooltip = impFolderPath
								
							--save list 
							SaveImpList()
								
							destroyDialog impWndw
						)	
					)
						
					----------------------------------------------------------------------------------
					
					on btn_save pressed do
					(
						SetDictValue impSavedData (execute ster) (chngVal.text as string)
							
						presetImportLoc.items = impSavedData.keys
							
						impFolderPath = chngVal.text
						-- filters path for displaying purposes 
						import_fldr_nam.text = filenameFromPath impFolderPath
						import_fldr_nam.tooltip = impFolderPath
						presetImportLoc.tooltip = impFolderPath
							
						--refresh list
						presetImportLoc.items = impSavedData.keys
						itemList = presetImportLoc.items
						lst_itms.items = itemList
							
						--save list 
						SaveImpList()						
							
						if presetImportLoc.items.count != 0 do 
						(
							itemList = presetImportLoc.items
							lst_itms.items = itemList
								
							if presetImportLoc.selection != undefined then 
							(
								
								lst_itms.selection = findItem itemList presetImportLoc.selection
									
							)
							--print itemList
						)
							
							
					)
						
					on dlt_Entry pressed do 
					(
						if lst_itms.selection > 0 then 
						(
							ster = ("#" + (lst_itms.items[lst_itms.selection] as string))
							ster2 = GetDictValue impSavedData (execute ster)
								
							if ster != undefined then 
							(
								RemoveDictValue impSavedData (execute ster)
								deleteItem itemList lst_itms.selection
									
								--refresh list
								presetImportLoc.items = impSavedData.keys
								itemList = presetImportLoc.items
								lst_itms.items = itemList
									
									
								--save list 
								SaveImpList()
									
								presetImportLoc.selection = (impSavedData.count - (impSavedData.count-1))
								--destroyDialog impWndw
							)
						)
					)
						 
					----------------------------------------------------------------------------------		
						
					on exp_Open pressed do 
					(
							
						str = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:ster2
							
						if str != undefined then 
						(
							chngVal.text = str
							
							impFolderPath = chngVal.text
								
							-- filters path for displaying purposes 
							import_fldr_nam.text = filenameFromPath impFolderPath
							import_fldr_nam.tooltip = impFolderPath
							presetImportLoc.tooltip = impFolderPath
								
							SetDictValue impSavedData (execute ster) (chngVal.text as string)
								
							--save list 
							SaveImpList()
							
						)
						
					)
						
					----------------------------------------------------------------------------------
						
					on impWndw open do 
					(
						
						if presetImportLoc.items.count != 0 do 
						(
							itemList = presetImportLoc.items
							lst_itms.items = itemList
								
							if presetImportLoc.selection != undefined then 
							(
								
								lst_itms.selection = findItem itemList presetImportLoc.selection
									
							)
							--print itemList
						)
						
					)
						
					on impWndw close do 
					(
						updList.enabled = false
					)
						
					
				)			
				
				--valNam.text = ster
				
				createDialog impWndw width:400



			)
				
 			--records settings
			set_imp_list_last_sel = presetImportLoc.selection
			SetAutoSettings set_imp_list_last_sel 15
				
		)	
		--------------------------------------------------------------------------------------------------------------------------------
		--CLEAR - the export list
		--------------------------------------------------------------------------------------------------------------------------------
			
		on btn_imp_clear_itm pressed do 
		(
			free impSavedData
			
			presetImportLoc.items = impSavedData.keys 
			
		)
		--------------------------------------------------------------------------------------------------------------------------------	
		--DELETE - the export list
		--------------------------------------------------------------------------------------------------------------------------------
			
		on btn_imp_dlt_preset pressed do 
		(		
			local usedotNam = sysInfo.username as string
			
			if doesFileExist (mainFPFolder + "\FlowPanels\savedata\PresetImportLocations.fp") then 
			(
				if	yesNoCancelBox  "Are you sure you want to delete this List?" == #yes then 
				(
						
					impss = (mainFPFolder + "\FlowPanels\savedata\PresetImportLocations.fp")
						
					deletefile (impss)
					free impSavedData
					presetImportLoc.items = impSavedData.keys
						
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
		--------------------------------------------------------------------------------------------------------------------------------	
		--SELECTED ITEM
		--------------------------------------------------------------------------------------------------------------------------------
			
		--when selected 
		On filesToImport selected i do 
		(
			if scrollToSelection do 
			(
				filesToImport.selection = i
			)
				
			--Sets the name of selection and filters name 
			lbl_imp_obj_nam.text = filenameFromPath (filesToImport.items[i]  as string )
			str = lbl_imp_obj_nam.text
			str = substituteString str ".FBX" ""
			str = substituteString str ".fbx" ""
			lbl_imp_obj_nam.text = str 
		)
		--------------------------------------------------------------------------------------------------------------------------------	
		--DOUBLED CLICK ITEM
		--------------------------------------------------------------------------------------------------------------------------------
			
		--when double clicked
		On filesToImport doubleClicked i do 
		(
			--BOOLS
 			if loadFBXfiles do -- FBX
 			(
				if forceImport then
				(	
					importFile (importItemsArray[filesToImport.selection] as string) #noPrompt
				)
				else
				(
					importFile (importItemsArray[filesToImport.selection] as string)
				)
 			)
			
			if loadOBJfiles do -- OBJ
 			(
				if forceImport then
				(	
					importFile (importItemsArray[filesToImport.selection] as string) #noPrompt
				)
				else
				(
					importFile (importItemsArray[filesToImport.selection] as string)
				)
 			)
			
 			if loadMAXfiles do --MAX
 			(
 				loadMaxFile (importItemsArray[filesToImport.selection] as string)
				print("OPEN MAX FILE")
 			)
				
			if loadInstFiles do --INSTANCE
			(
				Containers.CreateInheritedContainer (importItemsArray[filesToImport.selection] as string)				
				
 				--loadMaxFile (importItemsArray[filesToImport.selection] as string)
				--print("OPEN MAX FILE")
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------	
		--IMPORT 
		--------------------------------------------------------------------------------------------------------------------------------
		on btn_imp_sing pressed do 
		(
			--BOOLS
 			if loadFBXfiles do -- FBX
 			(
				if forceImport then
				(	
					importFile (importItemsArray[filesToImport.selection] as string) #noPrompt
				)
				else
				(
					importFile (importItemsArray[filesToImport.selection] as string)
				)
 			)
			
			if loadOBJfiles do -- OBJ
 			(
				if forceImport then
				(	
					importFile (importItemsArray[filesToImport.selection] as string) #noPrompt
				)
				else
				(
					importFile (importItemsArray[filesToImport.selection] as string)
				)
 			)
			
 			if loadMAXfiles do --MAX
 			(
 				loadMaxFile (importItemsArray[filesToImport.selection] as string)
				print("MAX FILE Opened!")
 			)
				
			if loadInstFiles do --INSTANCE
			(
				Containers.CreateInheritedContainer (importItemsArray[filesToImport.selection] as string)				
				
 				--loadMaxFile (importItemsArray[filesToImport.selection] as string)
				--print("OPEN MAX FILE")
			)
			
		)	
			
		--------------------------------------------------------------------------------------------------------------------------------	
		--IMPORT ALL
		--------------------------------------------------------------------------------------------------------------------------------
			
		--when Import All is pressed
		On btn_imp_all pressed do 
		(
			tempArray = importItemsArray
				
			try destroyDialog imProg catch()
			rollout imProg "Import Progress"
			(
				ProgressBar impProgBar 		color:red				
			)
			createDialog imProg 
				
				
			if tempArray != undefined do 
			(
				o = 0
				if forceImport then		
				(	
					 
					if querybox "are you sure you want to import every object within folder?" then 						
						for i in tempArray do
						(
								
							importFile i #noPrompt
								
							o=o+1
								
							imProg.impProgBar.value = 100*o/temparray.count
							
						)
					else
					(	
						destroyDialog imProg
						return false
					)
				)
				else
				(
					if querybox "are you sure you want to import every object within folder?" then 
						
						if querybox "want to turn on automatic import?" then
							for i = o to tempArray.count do
							(
								importFile i #noPrompt
								imProg.impProgBar.vaue = 100*o/temparray.count
							)
						else
							for i in tempArray do
							(
								importFile i 
								imProg.impProgBar.vaue = 100*o/temparray.count
							)
					else
					(	
						destroyDialog imProg
						return false
					)
				)					
				
			)
			
			if imProg.impProgBar.value == 100 do
			(
				imProg.impProgBar.value = 0
				destroyDialog imProg
			)
			
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--IMPORT CHECKBUTTON - - FBX
		--------------------------------------------------------------------------------------------------------------------------------
			
		--LOAD FBX FILES -- TOGGLE
		On loadFBXs changed state do
		(   
			Undo on
			loadFBXfiles = state	
				
			--turn off FBX import
			loadMAXfiles = false
			loadMAXs.checked = false
				
			--turn off INST import
			loadInstFiles = false
			loadINSTs.checked = false
				
			--turn off OBJ import
			loadOBJfiles = false
			loadOBJs.checked = false
				
			--records file type bool
			if loadFBXfiles == true then
			(
				set_import_file_type = 1
			)
			else 
				set_import_file_type = 5
				
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--IMPORT CHECKBUTTON - - OBJ
		--------------------------------------------------------------------------------------------------------------------------------
			
		--LOAD OBJ FILES -- TOGGLE
		On loadOBJs changed state do
		(   
			Undo on
			loadOBJfiles = state	
				
			--turn off MAX import
			loadMAXfiles = false
			loadMAXs.checked = false
				
			--turn off INST import
			loadInstFiles = false
			loadINSTs.checked = false
				
			--turn off FBX import
			loadFBXfiles = false
			loadFBXs.checked = false
				
			--records file type bool
			if loadOBJfiles == true then
			(
				set_import_file_type = 2
			)
			else 
				set_import_file_type = 5
				
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
		
		--------------------------------------------------------------------------------------------------------------------------------
		--IMPORT CHECKBUTTON - - MAX
		--------------------------------------------------------------------------------------------------------------------------------
			
		--LOAD MAX FILES -- TOGGLE
		On loadMAXs changed state do
		(   
			Undo on
			loadMAXfiles = state	
				
			--turn off FBX import
			loadFBXfiles = false
			loadFBXs.checked = false
				
			--turn off INST import
			loadInstFiles = false
			loadINSTs.checked = false
				
			--turn off OBJ import
			loadOBJfiles = false
			loadOBJs.checked = false
			
			--records file type bool
			if loadMAXfiles == true then
			(
				set_import_file_type = 3
			)
			else 
				set_import_file_type = 5
				
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--IMPORT CHECKBUTTON - - INSTANCES
		--------------------------------------------------------------------------------------------------------------------------------
			
		--LOAD FBX FILES -- TOGGLE
		On loadINSTs changed state do
		(   
			Undo on
			loadInstFiles = state	
				
			--turn off MAX import
			loadMAXfiles = false
			loadOBJfiles = false
			loadMAXs.checked = false
				
			--turn off FBX import
			loadFBXfiles = false
			loadFBXs.checked = false
				
			--turn off OBJ import
			loadOBJfiles = false
			loadOBJs.checked = false
			
			--records file type bool
			if loadInstFiles == true then
			(
				set_import_file_type = 4
			)
			else 
				set_import_file_type = 5
				
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--REFRESH LIST
		--------------------------------------------------------------------------------------------------------------------------------
			
		--Refresh List 
		on btn_ref_lst pressed do 
		(
			-- function - - creates import list - 
			ManifestImportList()			
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--SET FOLDER PATH 	
		--------------------------------------------------------------------------------------------------------------------------------
			
		--show folder in explorer
		on btn_imp_show_path pressed do 
		(
			str = impFolderPath
			str = substituteString str "/" "\\"
			
			
			print impFolderPath
			print str
			shelllaunch "explorer.exe" str
			
		)
			
		--paste from clipboard
		on btn_imp_clip_path pressed do 
		(
			--gets path from clipboard
			impFolderPath = getClipboardText()
				
			-- function - - creates import list - 
			ManifestImportList()
			
		)
			
			
		--set import location
		On btn_imp_fold_path pressed do 
		(
			local usedotNam = sysInfo.username as string
				
			--checks if there's a saved location, before opening
			if lastOpenedFldr != undefined then
			(
				impFolderPath = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:lastOpenedFldr
			)
			else
			(
				impFolderPath = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.")  
			)	
				
			-- function - - creates import list - 
			ManifestImportList()
				
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- 
		--EDIT FOLDER PATH MANUALLY - selected item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_edt_imp_fldph pressed do 
		(
			try destroyDialog edtPthWndw catch()
			rollout edtPthWndw "Edit Entry"
			(
				edittext valNam "Entry Name:" 				width:500	height:30							text:impFolderPath  
				button imp_Open "Open Directory"			width:110	height:20		align:#center			across:1
				button imp_Accpt "Accept"					width:110	height:20		align:#center
				button imp_dlt_Entry "Clear Path"  			width:110	height:20		align:#center
					
				----------------------------------------------------------------------------------
					
				on imp_Open pressed do 
				(

					str = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:impFolderPath
					
					
					if str != undefined then 
					(
						valNam.text = str
					)
						
					
					impFolderPath = valNam.text
						
					-- filters path for displaying purposes 
					import_fldr_nam.text = filenameFromPath impFolderPath
					import_fldr_nam.tooltip = impFolderPath
					filesToImport.tooltip = impFolderPath
						
					-- function - - creates import list - 
					ManifestImportList()
						
				)
					
				on imp_Accpt pressed do
				(
					impFolderPath = valNam.text
					-- filters path for displaying purposes 
					import_fldr_nam.text = filenameFromPath impFolderPath
					import_fldr_nam.tooltip = impFolderPath
					filesToImport.tooltip = impFolderPath
						
					-- function - - creates import list - 
					ManifestImportList()
						
					destroyDialog edtPthWndw
				)
					
				----------------------------------------------------------------------------------
					
				on imp_dlt_Entry pressed do 
				(
					impFolderPath = ""
					-- filters path for displaying purposes 
					import_fldr_nam.text = ""
					import_fldr_nam.tooltip = impFolderPath
					filesToImport.tooltip = impFolderPath
					
					-- function - - creates import list - 
					ManifestImportList()
					
					destroyDialog edtPthWndw
				)
					
				on valNam entered val do
				(
					impFolderPath = valNam.text
					-- filters path for displaying purposes 
					import_fldr_nam.text = filenameFromPath impFolderPath
					import_fldr_nam.tooltip = impFolderPath
					filesToImport.tooltip = impFolderPath
						
					-- function - - creates import list - 
					ManifestImportList()
						
					destroyDialog edtPthWndw
				)
					
				----------------------------------------------------------------------------------				
					
			)			
				
			--valNam.text = ster
			
			createDialog edtPthWndw width:525
				
 			--records settings
			set_imp_list_last_sel = presetImportLoc.selection
			SetAutoSettings set_imp_list_last_sel 15
				
		)
		
		--------------------------------------------------------------------------------------------------------------------------------
		-- OPEN // CLOSED -- 
		--------------------------------------------------------------------------------------------------------------------------------
		
		on panImporter rolledUp open do 
		(		
				
			--populate List
			presetImportLoc.items = impSavedData.keys
				
			--checks to set value of export location
-- 			if set_exp_location != undefined do
-- 			(
-- 					
-- 				--resets the list's last selected item
-- 				if(presetImportLoc.items.count > 0 and set_imp_list_last_sel != undefined) do
-- 				(
-- 					presetImportLoc.selection = set_imp_list_last_sel
-- 				)
-- 					
-- 			)	
				
			--resets import location from memory
			if set_last_import_loc != undefined do 
			(
				lastOpenedFldr = set_last_import_loc
			)
				
			
-- 			Case set_import_file_type of
-- 			(
-- 				1: 				
-- 				(
-- 					loadFBXfiles 		= true
-- 					loadFBXs.checked 	= true
-- 						
-- 					loadInstFiles	= false
-- 					loadMAXfiles	= false
-- 					loadOBJfiles	= false
-- 				)
-- 				2:
-- 				(
-- 					loadOBJfiles 		= true
-- 					loadFBXs.checked 	= true
-- 						
-- 					loadInstFiles	= false
-- 					loadMAXfiles	= false
-- 					loadFBXfiles	= false
-- 				)
-- 				3:
-- 				(
-- 					loadMAXfiles 		= true	
-- 					loadMAXs.checked 	= true
-- 					
-- 					loadInstFiles 	= false
-- 					loadFBXfiles 	= false
-- 					loadOBJfiles	= false
-- 				)
-- 				4:
-- 				(
-- 					loadInstFiles 		= true	
-- 					loadINSTs.checked 	= true
-- 						
-- 					loadMAXfiles	= false
-- 					loadFBXfiles	= false
-- 					loadOBJfiles	= false
-- 				)
-- 			)
				
			--resets File to import from last settings set
			if set_import_file_type == 1 then  --sets .fbx type
			(
				loadFBXfiles 		= true
				loadFBXs.checked 	= true
					
				loadInstFiles	= false
				loadMAXfiles	= false
				loadOBJfiles	= false
			)
			else if set_import_file_type == 2 then  --sets .max type 
			(
				loadOBJfiles 		= true
				loadOBJs.checked 	= true
					
				loadInstFiles	= false
				loadMAXfiles	= false
				loadFBXfiles	= false
			)
			else if set_import_file_type == 3 then  --sets .maxc type 
			(
				loadMAXfiles 		= true	
				loadMAXs.checked 	= true
				
				loadInstFiles 	= false
				loadFBXfiles 	= false
				loadOBJfiles	= false
			)
			else if set_import_file_type == 4 then  --sets .maxc type 
			(
				loadInstFiles 		= true	
				loadINSTs.checked 	= true
					
				loadMAXfiles	= false
				loadFBXfiles	= false
				loadOBJfiles	= false
			)			
			else 
			(
				loadMAXfiles = false
				loadFBXfiles = false
				loadInstFiles = false
				
				loadFBXs.checked = false
				loadMAXs.checked = false
				loadINSTs.checked = false
				
			)
-- 				
-- 				
			if lastOpenedFldr != undefined do
			(
				-- filters path for displaying purposes 
				import_fldr_nam.text = filenameFromPath lastOpenedFldr
				import_fldr_nam.tooltip = lastOpenedFldr
				
				--sets initial dropdownlist items
				filesToImport.tooltip = lastOpenedFldr
				filesToImport.items = set_import_array
			)
				
			-- function - - creates import list - 
			ManifestImportList()	
				
			--AutoCollapse
			if use_AutoCollapse == true do 
			(
				--switches to this rollout
				if open do switchRolls panImporter
			)
		)			