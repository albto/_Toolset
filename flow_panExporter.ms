	
	-------------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////////////// QUICK EXPORT
	-------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------- VARIABLES
			
		local	incr 		= #("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
		local	typ1 		= ".OBJ"
		local	typ2 		= ".FBX"
		local	typ_setr 	= set_typ_string
		local	initNam 	= "object_name"
		local	use_ObjNam 	= set_use_ObjNam_checked
		local	Unity_Y_Up 	= set_Unity_Y_Up_checked
 		local	main_db 	= "[main access]"
		local 	autoType 	= set_autoType_checked
		local 	qx_fldr 	= set_exp_location
		local 	lastExpFldr = set_lastExp_Fldr
		local	noPrompt 	= set_noprompt_exp
		local 	batchExp	= set_bat_exp
		local 	objTypeSet 	= set_obj_typ_checked
		local 	fbxTypeSet 	= set_fbx_typ_checked
		local   renamObjs 	= set_renamObjs
		local   offSwitch 	= false
		local 	bypassNam 	= set_bypass_nam
			
			
	------------------------------------------------------------------------------------------------------------------------------------- EXPORT LOCATION
			
		Group "Export Location:"
		(
			edittext disp_fldr_nam ""					labelOnTop: true		width:175		height:20 								tooltip:""						fieldWidth:160 	 across:2
			button btn_add_itm "Save" 											width:42 		height:20		offset:[35,0]			tooltip:"add item to Presets"              		
			button btn_fold_path "Set"											width:42		height:20								tooltip:"Set Export Location"					across:5
			button btn_exp_show_path "Show"										width:42		height:20								tooltip:"Show in Explorer"						
			button btn_exp_edt_path	"Edit"										width:42		height:20								tooltip:"Edit the Folder Path Manually" 							
			button btn_cop_clip_path "Copy"										width:42		height:20								tooltip:"Copy from Clipboard"					
			button btn_exp_clip_path "Paste"									width:42		height:20		offset:[2,0]			tooltip:"Paste from Clipboard"
		)
				
	------------------------------------------------------------------------------------------------------------------------------------- EXPORT NAMING		
			
		Group "Export Name:"
		(
			edittext preNam   ""											labelOnTop:false	width:40	height:20	fieldWidth:5	offset:[-4,0]	across:3
			edittext multiNam ""											labelOnTop:true		width:150	height:20   				offset:[-35,0]
			edittext verNam   ""											labelOnTop:false	width:38	height:20					offset:[40,0]
			radioButtons radSufVal ""										Labels:#("Letters","Numbers", "None")	columns:3
			spinner btn_incr_vr "" 			type:#integer		width:30 	height:18	range:[-9999, 9999, 1]	tooltip:"increment suffix letter"
				
		)
			
	------------------------------------------------------------------------------------------------------------------------------------- PROPERTIES
			
		Group "Export Options:"
		(	
			checkbutton btn_use_objNam "Use Name"					width: 70	align:#left		offset:[0,0]		checked:use_ObjNam			Tooltip:"Toggle On, to Use Selection's name as 'Object Name'" across:3 	
			checkbutton btn_renam_on "Rename"						width: 70					offset:[0,0]		checked:renamObjs			Tooltip:"Toggle On, to allow Renaming of Objects" 				
			checkButton btn_bypass_nam "Simple Naming" 				width: 80	align:#right	offset:[0,0]									Tooltip:"Will use the name in the object name field and bypass prefix and suffix" 	
			checkButton btn_unity_exp "Unity3D" 					width: 80					offset:[0,0]		checked: Unity_Y_Up			Tooltip:"Sets Y-up instead of Z" 								 
			
		)
			
		Group "Export File Type:"
		(
				
			checkbutton btn_obj_typ "Export OBJ" 							align:#left		width: 90	checked:objTypeSet			across:2
			checkbutton btn_fbx_typ "Export FBX"							align:#right	width: 90 	checked:fbxTypeSet
				
		)
			
			
	------------------------------------------------------------------------------------------------------------------------------------- QUICK EXPORT
		Group "Export:"
		(
			checkBox noPromptCheck "No Prompt" 										checked:noPrompt								Tooltip:"Ignore all prompts and sends directly to folder"			across:2
			checkBox BtchExportChk "Batch Export" 									checked:batchExp								Tooltip:"Batch Exports each individual mesh and sends it directly to folder  \n \n Warning: for Auto Export make sure to turn-on 'NoPrompt on Export'"
			label lbl_exp_prog "Batch Export Progress:"								enabled:batchExp
			progressBar progBar "BatchExportProgressBar"			color:green		enabled:batchExp
			button b_Quick_Export "Quick Export!" 				width: 180			height:40
		)
			
	------------------------------------------------------------------------------------------------------------------------------------- PRESETS
			
		Group "Preset Locations"
		(
			dropdownlist theList 	"" 		items:#() 	width:150		    height:20				   				tooltip:""  									across:3
			button btn_edt_item 	"Edit" 				width:30 			height:20 		offset:[58,0] 			tooltip:"edit contents of selected item" 		             
			button btn_dlt_preset 	"Delete"			width:42			height:20		offset:[22,0] 			tooltip:"delete presets file"
		)
			
	-------------------------------------------------------------------------------------------------------------------------------- TIMERS		
			
		--Selection Timer; update Object Name on selection
		timer checkSel "" interval:100 active:use_ObjNam
		timer typCheck "" interval:100 active:autoType
			
	--------------------------------------------------------------------------------------------------------------------------------------------------------FUNCTIONS	
			
		--------------------------------------------------------------------------------------------------------------------------------
		--save export list -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn SaveExportList = 
		(
			local usedotNam = sysInfo.username as string
			
			if theList.items.count != 0 do
			(
				--write to file
				ss = createFile (mainFPFolder + "\FlowPanels\savedata\PresetLocations.fp")
					
				format "%\n" (with printAllElements on savedData as string) to:ss
				--flush ss
				close ss
					
			)
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--exports meshes -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn rdyForExport = 
		(
				
			--forces export - no prompt
			if noPrompt then
			(			
					
				--if batch export is false -- it will use the pivot of the first object selected
				if (batchExp == false) then
				(
					local dirName
						
					if btn_bypass_nam.checked == true  then
					(
						ObjNam = "\\" + multiNam.text + typ_setr
							
						--sets directory and object name
						dirName = qx_fldr + ObjNam
							
					)
					else if btn_bypass_nam.checked == false then 
					(
						if radSufVal.state <= 2 then
						(					
							ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
						)	
						else if radSufVal.state == 3 then				
						(
							ObjNam = "\\" + preNam.text + "_" + multiNam.text + typ_setr
						)
							
						--sets directory and object name
						dirName = qx_fldr + ObjNam
							
					)
						
					--sets directory and object name
					dirName = qx_fldr + ObjNam
						
					--sets pivot to first selection 
					--$.pivot = selection[1].pivot
						
					exportFile (dirName) #noPrompt selectedOnly:true	
						
				)
				else 
				(
					--sets directory and object name
					batDirName = (qx_fldr + "/" + $.name as string)
						
					exportFile (batDirName) #noPrompt selectedOnly:true	
						
				)		
					
			)
			else  --prompt on export 
			(
					
				--if batch export is false -- it will use the pivot of the first object selected
				if (batchExp == false) then 
				(
					local dirName
						
					if btn_bypass_nam.checked == true  then
					(
						ObjNam = "\\" + multiNam.text + typ_setr
							
						--sets directory and object name
						dirName = qx_fldr + ObjNam
							
					)
					else if btn_bypass_nam.checked == false then 
					(
						if radSufVal.state <= 2 then
						(					
							ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
						)	
						else if radSufVal.state == 3 then				
						(
							ObjNam = "\\" + preNam.text + "_" + multiNam.text + typ_setr
						)
							
						--sets directory and object name
						dirName = qx_fldr + ObjNam
							
					)
						
						
					--sets pivot to first selection 
					--$.pivot = selection[1].pivot
						
					exportFile (dirName) selectedOnly:true
						
				)
				else 
				(
					--sets directory and object name
					batDirName = (qx_fldr + "/" + $.name as string)
						
					exportFile (batDirName) selectedOnly:true
						
				)	
					
			)
				
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--check for type of export based on prefix -- FUNCTION	
		--------------------------------------------------------------------------------------------------------------------------------
		fn autoButtonTypeSwitcher btn1 btn2 btn3 =
		(
				
			--button switch
			btn1 = (preNam.text == "fbx" or preNam.text == "Fbx" or preNam.text == "FBX" or
				preNam.text == "FBx" or preNam.text == "FbX" or	preNam.text == "fBx")
					
			btn2 = (preNam.text == "obj" or preNam.text == "Obj" or preNam.text == "OBJ" or
				preNam.text == "OBj" or preNam.text == "ObJ" or preNam.text == "oBj")
					
			btn3 = (preNam.text == "msh" or preNam.text == "")
				
			--sets the buttons on and off
			if (btn2) then 
			(
				btn_fbx_typ.checked = false
				typ_setr = typ1
				btn_obj_typ.checked = true
			)
			else if (btn1) then 
			(
				btn_fbx_typ.checked = true
				typ_setr = typ2
				btn_obj_typ.checked = false
			)
			else if (btn3) then 
			(
				btn_fbx_typ.checked = false
				btn_obj_typ.checked = false
			)
				
			--records settings	
			set_prefixText = preNam.text
			SetAutoSettings set_prefixText 8
				
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--DOESNT DO CRAP -- EMPTY -- FUNCTION	
		--------------------------------------------------------------------------------------------------------------------------------
		fn SomeFunction type = 
		(
			
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--auto check type timer  toggle -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn checkAutoTypeCheck bool = 
		(
			typCheck.active = bool
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--'dynamically' changes tooltip based on selection -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn listTooltipUpdater list =
		(			
			if list.selection != 0 do
			(
				list.tooltip = (list.items[list.selection] as string)
			)
		)	
		--------------------------------------------------------------------------------------------------------------------------------
		--'Substutite slashes for backslashes -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn EXPSubPathString str inpStr sub1 sub2 = 
		(
			--substitutes slashes for backslashes
			str = substitutestring inpStr sub1 sub2
			return str	
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--Create New Export List Entry -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn CreateNewExportListEntry = 
		(
			try destroyDialog boxes catch()
					
			rollout expDialog "New Entry Dialog"
			(
				
				label lbl_entry "Please do not Delete '#' "
				edittext itm_name "Name:" text:"#"
				button pressme "create"  		width:120	height:40
					
				----------------------------------------------------------------------------------
					
				on pressme pressed do 
				(
					newExpEntry = true
						
					if itm_name.text == "#" or itm_name.text == undefined  or itm_name.text != "" then 
					(
						messageBox "Please Type Something"
						return false
					)
						
					if itm_name.text != undefined then 
					(
						illegalChars = #(" ","!","=","+","-",")","(","&","^","%",",","$","@","?","/","\\","|","<",">",",",".",";",":","'")
						o = 0
						ssNam = itm_name.text
							
						for i = 1 to illegalChars.count do 
						(
							s1 = ssNam
							s2 = illegalChars[i] as string
							s3 = "_"
							ssNam = substitutestring s1 s2 s3	
							0+=1
						)
							
						if o == illegalChars.count then 
						(
							--adds Key value
							PutDictValue savedData (execute ssNam) (qx_fldr)  putOnlyIfNew:true
								
							--refresh list
							theList.items = savedData.keys
								
							--save list 
							SaveExportList()
								
							destroyDialog expDialog
								
						)
					)
				)
					
				----------------------------------------------------------------------------------
					
				on itm_name entered i do 
				(
					newExpEntry = true
					
					if i != undefined then 
					(
						--substitutes spaces for underscore
						s1 = itm_name.text
						s2 = " "
						s3 = "_"
						ssNam = substitutestring s1 s2 s3
							
						--adds Key value
						PutDictValue savedData (execute ssNam) (qx_fldr) putOnlyIfNew:true
							
						--refresh list
						theList.items = savedData.keys
							
						--save list 
						SaveExportList()
							
						destroyDialog expDialog
					)
				)
				
-- 				on expDialog close do 
-- 				(
-- 					
-- 					newExpEntry = false
-- 					
-- 				)
				
			)
				
			createDialog expDialog
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--Generate Export Location // Selection-- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn GenerateSelection = 
		( 
			--what happens when you select an item
			for i = 1 to theList.selection do
			(
				--adds item value to Export Folder Location
				str = ("#" + theList.selected as string)
				str2 = GetDictValue savedData (execute str)	
				
				--grab folder path and set as item in array
				qx_fldr = str2
					
				--set folder path
				--multiNam.text = initNam
				--verNam.text = "a"
				folder_path = qx_fldr
					
				--displays folder name
				disp_fldr_nam.text = filenameFromPath folder_path
				--also sets the export location edit text box	
				disp_fldr_nam.tooltip = str2
				theList.tooltip = str2
				
				--records settings
				set_list_last_sel = theList.selection
				SetAutoSettings set_list_last_sel 11
					
				--records settings
				SetAutoSettings qx_fldr 9
				
				--'dynamically' changes tooltip based on selection
				--listTooltipUpdater theList  --------------------------------------FIX THIS FUNCTION
			)
		)
			
	--------------------------------------------------------------------------------------------------------------------------------------------------------CHECKBOXES
		--------------------------------------------------------------------------------------------------------------------------------
		--BYPASS PREFIX and SUFFIX ON EXPORT
		--------------------------------------------------------------------------------------------------------------------------------
			
		on btn_bypass_nam changed state do
		(
				
			if state == true then
			(
				verNam.enabled = false
				--vernam.visible = false
				radSufVal.enabled = false
				--radSufVal.visible = false
				preNam.enabled = false
				--preNam.visible = false
				btn_incr_vr.enabled = false
				--btn_incr_vr.visible = false
					
				bypassNam = true
				set_bypass_nam = true
				
				--record settings
				SetAutoSettings set_bypass_nam 23 
					
			)	
			else			
			(
				
				if BtchExportChk.checked == true then
				(
					btn_use_objNam.enabled = false
					btn_renam_on.enabled = false
					multiNam.enabled = false
					verNam.enabled = false
					--vernam.visible = true
					radSufVal.enabled = false
					--radSufVal.visible = true
					preNam.enabled = false
					--preNam.visible = true
					btn_incr_vr.enabled = false
					--btn_incr_vr.visible = true
				)
				else
				(
					verNam.enabled = true
					--vernam.visible = true
					radSufVal.enabled = true
					--radSufVal.visible = true
					preNam.enabled = true
					--preNam.visible = true
					btn_incr_vr.enabled = true
					--btn_incr_vr.visible = true
						
				)	
					
				bypassNam = false
				set_bypass_nam	= false
				
				--record settings
				SetAutoSettings set_bypass_nam 23 
				
			)
				
				
		)			
			
		--------------------------------------------------------------------------------------------------------------------------------
		--NO PROMPT ON EXPORT
		--------------------------------------------------------------------------------------------------------------------------------
			
		on noPromptCheck changed state do
		(
			if noPrompt == undefined then
			(
				noPrompt = false
			)
			else
			(
				noPrompt = Not noPrompt
			)
			
			--records settings	
			SetAutoSettings noPrompt 1
		)
		-------------------------------------------------------------------------------------------------------------------------------- 
		--BATCH EXPORT SELECTED OBJECTS
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		on BtchExportChk changed state do
		(
			if batchExp == undefined then
			(
				batchExp = false
				
				lbl_exp_prog.enabled = batchExp
				progBar.enabled = batchExp
			)
			else
			(
				
				batchExp = Not batchExp
				lbl_exp_prog.enabled = batchExp
				progBar.enabled = batchExp
			)
			
			--turns on and off the naming fields
			if BtchExportChk.checked == true then
			(
				btn_use_objNam.checked = false
				use_ObjNam = false
				checkSel.active = false
				btn_use_objNam.enabled = false
				btn_renam_on.enabled = false
				multiNam.text = ""
				multiNam.enabled = false
				verNam.enabled = false
				radSufVal.enabled = false
				preNam.enabled = false
				btn_incr_vr.enabled = false
				
			)
			else
			(
				
				btn_use_objNam.enabled = true
				btn_renam_on.enabled = true
				multiNam.enabled = true
				verNam.enabled = true
				radSufVal.enabled = true
				preNam.enabled = true
				btn_incr_vr.enabled = true
			)
				
			if btn_bypass_nam.checked and batchExp == false then
			(
				use_ObjNam = false
				checkSel.active = false
				btn_use_objNam.enabled = true
				btn_renam_on.enabled = true
				multiNam.text = ""
				multiNam.enabled = true
				verNam.enabled = false
				radSufVal.enabled = false
				preNam.enabled = false
				btn_incr_vr.enabled = false
				
			)
				
			--records settings	
			SetAutoSettings batchExp 22
				
		)
		--------------------------------------------------------------------------------------------------------------------------------------------------------TIMER TICKS	
		--------------------------------------------------------------------------------------------------------------------------------
		--CHECK FOR NAME OF SELECTION	
		--------------------------------------------------------------------------------------------------------------------------------
			
		on checkSel tick do 
		(
			if selection.count == 0 then 
			(			
				multiNam.enabled = offSwitch
				multiNam.text = "  Select Something"
				SetAutoSettings use_ObjNam 5
			) 
			else
			(
				multiNam.enabled = not offSwitch
				SetAutoSettings use_ObjNam 5
				if selection.count >= 1 then 
					multiNam.text = selection[selection.count].name 
			)			
			
		)	
		--------------------------------------------------------------------------------------------------------------------------------
		--CHECK FOR TYPE OF EXPORT BASED ON PREFIX
		--------------------------------------------------------------------------------------------------------------------------------
			
		on typCheck tick do 
		(
			--run function
			autoButtonTypeSwitcher fbxName objName blaName
				
		)
		--------------------------------------------------------------------------------------------------------------------------------
		-- RENAME LOOP 
		--------------------------------------------------------------------------------------------------------------------------------
		on multiNam changed txt do 
		(
			if renamObjs do
			(
				for o in selection as array do 
					o.name = txt
			)
		)
	--------------------------------------------------------------------------------------------------------------------------------------------------------EDITING LIST
			
		-------------------------------------------------------------------------------------------------------------------------------- 	
		-- ADD - new item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_add_itm pressed do 
		(
			--Create Entry Function
			CreateNewExportListEntry()
			
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- 	
		-- EDIT LIST - selected item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_edt_item pressed do 
		(
			
			try (destroyDialog expWndw) catch()
			
			arrTemp = #()
			arrTemp = savedProjectData
			
			if (savedData.count > 0) then 
			(
				global ster = ("#" + theList.selected as string)
				global ster2 = GetDictValue savedData (execute ster)
				
				rollout expWndw "Edit List"
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
						ster2 = GetDictValue savedData (execute ster)
							
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
							itemList = theList.items
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
							theList.selection = i 
							lst_itms.selection = i
								
							--Generate list item and contents   --selection
							GenerateListItemContents  i 
						)
							
						--GenerateSelection
						GenerateSelection()
							
					)
						
					----------------------------------------------------------------------------------
						
					on btn_addEnt pressed do 
					(
						--Create Entry Function
						CreateNewExportListEntry()
					)
						
					----------------------------------------------------------------------------------
						
					on accpt pressed do
					(
						SetDictValue savedData (execute ster) (chngVal.text as string)	
						
						if ster != undefined then
						(
							theList.items = savedData.keys
								
							qx_fldr = chngVal.text
							-- filters path for displaying purposes 
							disp_fldr_nam.text = filenameFromPath qx_fldr
							disp_fldr_nam.tooltip = qx_fldr
							theList.tooltip = qx_fldr
								
							--save list 
							SaveExportList()
								
							destroyDialog expWndw
						)	
					)
						
					----------------------------------------------------------------------------------
					
					on btn_save pressed do
					(
						SetDictValue savedData (execute ster) (chngVal.text as string)
							
						theList.items = savedData.keys
							
						qx_fldr = chngVal.text
						-- filters path for displaying purposes 
						disp_fldr_nam.text = filenameFromPath qx_fldr
						disp_fldr_nam.tooltip = qx_fldr
						theList.tooltip = qx_fldr
							
						--refresh list
						theList.items = savedData.keys
						itemList = theList.items
						lst_itms.items = itemList
							
						--save list 
						SaveExportList()						
							
						if theList.items.count != 0 do 
						(
							itemList = theList.items
							lst_itms.items = itemList
								
							if theList.selection != undefined then 
							(
								
								lst_itms.selection = findItem itemList theList.selection
									
							)
							--print itemList
						)
							
							
					)
						
					on dlt_Entry pressed do 
					(
						if lst_itms.selection > 0 then 
						(
							ster = ("#" + (lst_itms.items[lst_itms.selection] as string))
							ster2 = GetDictValue savedData (execute ster)
								
							if ster != undefined then 
							(
								RemoveDictValue savedData (execute ster)
								deleteItem itemList lst_itms.selection
									
								--refresh list
								theList.items = savedData.keys
								itemList = theList.items
								lst_itms.items = itemList
									
									
								--save list 
								SaveExportList()
									
								theList.selection = (savedData.count - (savedData.count-1))
								--destroyDialog expWndw
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
							
							qx_fldr = chngVal.text
								
							-- filters path for displaying purposes 
							disp_fldr_nam.text = filenameFromPath qx_fldr
							disp_fldr_nam.tooltip = qx_fldr
							theList.tooltip = qx_fldr
								
							SetDictValue savedData (execute ster) (chngVal.text as string)
								
							--save list 
							SaveExportList()
							
						)
						
					)
						
					----------------------------------------------------------------------------------
						
					on expWndw open do 
					(
						
						if theList.items.count != 0 do 
						(
							itemList = theList.items
							lst_itms.items = itemList
								
							if theList.selection != undefined then 
							(
								
								lst_itms.selection = findItem itemList theList.selection
									
							)
							--print itemList
						)
						
					)
						
					on expWndw close do 
					(
						updList.enabled = false
					)
						
					
				)			
				
				--valNam.text = ster
				
				createDialog expWndw width:400
			)
			else
			(
				messageBox "No List Available" title:"Flow Panels: !WARNING!" beep:false
			)
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- 
		-- CLEAR - the export list
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		on btn_clear_itm pressed do 
		(
			free savedData
			
			theList.items = savedData.keys
			
		)
		-------------------------------------------------------------------------------------------------------------------------------- 
		-- DELETE - the export list
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		on btn_dlt_preset pressed do 
		(		
			
			local usedotNam = sysInfo.username as string
			
			if doesFileExist (mainFPFolder + "\FlowPanels\savedata\PresetLocations.fp") then 
			(
				if	yesNoCancelBox  "Are you sure you want to delete this List?" == #yes then 
				(
						
					ss = (mainFPFolder + "\FlowPanels\savedata\PresetLocations.fp")
						
					deletefile (ss)
					free savedData
					theList.items = savedData.keys
						
				)
				else			
				(
					return false
				)
			)
			else
			(
				messageBox "No List Available" title:"Flow Panels: !WARNING!" beep:false
			)
					
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--SET FOLDER PATH MANUALLY 
		--------------------------------------------------------------------------------------------------------------------------------
			
		on disp_fldr_nam changed txt do 
		(
			disp_fldr_nam.text = txt
			qx_fldr = txt
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--SHOW IN EXPLORER
		--------------------------------------------------------------------------------------------------------------------------------
			
		--show folder in explorer
		on btn_exp_show_path pressed do 
		(
			str = qx_fldr
			str = substituteString str "/" "\\"
			
			
			print qx_fldr
			print str
			shelllaunch "explorer.exe" str
			
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--SET FOLDER PATH 	
		--------------------------------------------------------------------------------------------------------------------------------
			
		--set export location from clipboard
		on btn_exp_clip_path pressed do 
		(
			-- sets folder path location 
			folder_path = getClipboardText()
				
			--substitutes slashes for backslashes
			folder_path = EXPSubPathString folder_path folder_path "\r" "/r"
			folder_path = EXPSubPathString folder_path folder_path "\\" "/"
				
			--sets folder name
			qx_fldr = folder_path
				
			-- filters path for displaying purposes 
			disp_fldr_nam.text = filenameFromPath qx_fldr
			disp_fldr_nam.tooltip = qx_fldr
				
			--sets last opened folder
			lastExpFldr = folder_path
				
			-----------------------------------------------------------------------------------SAVING DATA
			--records settings
			SetAutoSettings qx_fldr 9
			
			--records settings
			SetAutoSettings lastExpFldr 21 --saves data --function
		)
			
			
		--set export location
		On btn_fold_path pressed do 
		(
			local usedotNam = sysInfo.username as string
				
			-- sets folder path location 
			folder_path = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:lastExpFldr	
				
				
			-- sets folder path name if undefined
			if folder_path == undefined then				
			(
				
				--checks if it has a location saved, before setting it to the default location
				if (lastExpFldr == undefined) then
				(
					--sets folder name
					folder_path = ("C:\\users\\"+ usedotNam as string +"\\Desktop")
				)
				else
				(
					--substitutes slashes for backslashes
					lastExpFldr = EXPSubPathString lastExpFldr lastExpFldr "\r" "/r"
					lastExpFldr = EXPSubPathString lastExpFldr lastExpFldr "\\" "/"
						
						
						
					--sets folder name
					folder_path = lastExpFldr
					
				)				
					
				--substitutes slashes for backslashes
				folder_path = EXPSubPathString folder_path folder_path "\r" "/r"
				folder_path = EXPSubPathString folder_path folder_path "\\" "/"
					
					
				--sets prefix name to 'pre' if its field is empty
				if preNam.text == undefined or preNam.text == "" do
				(
					preNam.text = "pre"
				)
					
				--sets obj name
				multiNam.text = initNam
				ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
					
				--sets folder name
				qx_fldr = folder_path
					
				-- filters path for displaying purposes 
				disp_fldr_nam.text = filenameFromPath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
				--sets last opened folder
				lastExpFldr = folder_path
					
				-----------------------------------------------------------------------------------SAVING DATA
				--records settings
				SetAutoSettings qx_fldr 9
				
				--records settings
				SetAutoSettings lastExpFldr 21 --saves data --function
				
			)
			else -- sets the folder textbox text, the same as folder path location 
			(
				--substitutes slashes for backslashes
				folder_path = EXPSubPathString folder_path folder_path "\r" "/r"
				folder_path = EXPSubPathString folder_path folder_path "\\" "/"
					
				print ("folder_path = " + folder_path as string)
					
					
				qx_fldr = folder_path
				
				disp_fldr_nam.text = filenameFromPath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
				--sets last opened folder
				lastExpFldr = qx_fldr
				
				-----------------------------------------------------------------------------------SAVING DATA				
				--records settings
				SetAutoSettings lastExpFldr 21 --saves data --function
				
				--records settings
				SetAutoSettings qx_fldr 9
			)		
				
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- 
		--EDIT FOLDER PATH MANUALLY - selected item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_exp_edt_path pressed do 
		(
			try destroyDialog expEdtPthWndw catch()
				
			rollout expEdtPthWndw "Edit Entry"
			(
				edittext valNam "Entry Name:" 				width:500	height:30							text:qx_fldr
				button exp_Accpt "Accept"					width:110	height:20		align:#center			across:3				
				button exp_Open "Open Directory"			width:110	height:20		align:#center
				button exp_dlt_Entry "Clear Path"  			width:110	height:20		align:#center
					
				----------------------------------------------------------------------------------
					
				on exp_Open pressed do 
				(

					str = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:qx_fldr
					
					
					if str != undefined then 
					(
						valNam.text = str
					)
						
					
					qx_fldr = valNam.text
						
					-- filters path for displaying purposes 
					disp_fldr_nam.text = filenameFromPath qx_fldr
					disp_fldr_nam.tooltip = qx_fldr
					theList.tooltip = qx_fldr
						
						
				)
					
				----------------------------------------------------------------------------------
					
				on exp_Accpt pressed do
				(
					qx_fldr = valNam.text
					-- filters path for displaying purposes 
					disp_fldr_nam.text = filenameFromPath qx_fldr
					disp_fldr_nam.tooltip = qx_fldr
					theList.tooltip = qx_fldr
						
					destroyDialog expEdtPthWndw
				)
					
				----------------------------------------------------------------------------------
					
				on exp_dlt_Entry pressed do 
				(
					qx_fldr = ""
					-- filters path for displaying purposes 
					disp_fldr_nam.text = ""
					disp_fldr_nam.tooltip = qx_fldr
					theList.tooltip = qx_fldr
						
					destroyDialog expEdtPthWndw
				)
					
				----------------------------------------------------------------------------------
					
				on valNam entered val do
				(
					qx_fldr = valNam.text
					-- filters path for displaying purposes 
					import_fldr_nam.text = filenameFromPath qx_fldr
					import_fldr_nam.tooltip = qx_fldr
					theList.tooltip = qx_fldr
						
					destroyDialog expEdtPthWndw
				)
					
				----------------------------------------------------------------------------------				
					
			)			
				
			createDialog expEdtPthWndw width:525
				
 			--records settings
			SetAutoSettings qx_fldr 9
				
		)
			
		--------------------------------------------------------------------------------------------------------------------------------	
		--LIST ITEM SELECTED 
		--------------------------------------------------------------------------------------------------------------------------------
			
		On theList selected i do
		(
			--Generate Selection
			GenerateSelection()
				
		)
	--------------------------------------------------------------------------------------------------------------------------------------------------------EXPORT PROPERTIES
			
		--------------------------------------------------------------------------------------------------------------------------------
		--QUICK EXPORT BUTTON		
		--------------------------------------------------------------------------------------------------------------------------------
			
		On b_Quick_Export  pressed do
		(   
			--selection arrays
			local selGroup = getCurrentSelection()
			local selArr = selGroup as array
				
			local sel = selection as array --for batch export
				
			if (batchExp) then 
			(
					
				if selection.count > 0 do
				(
						
					o = 1
					for i = o to sel.count do 
					(
						select sel[i]
							
						--export function
						rdyForExport()
							
						--Update progress bar after completion
						progBar.value = 100*i/sel.count
						lbl_exp_prog.text = "Batch Export Progress: " + progBar.value as string + "%" 
							
					)	
						
				)
				--Update progress bar after completion
				if progbar.value == 100 do
				(
					--messagebox "Export Completed"
					lbl_exp_prog.text = "Batch Export Progress:"
					progbar.value = 0
				)
			)
			else
			(
				if selection.count > 0 and btn_fbx_typ.checked or selection.count > 0 and btn_obj_typ.checked then 
				(	
						
					--If UNITY 3D is ON - do this - sets Y-up 
					if  selArr.count > 0 do  
					(						
						if Unity_Y_Up == true do					
						(
								
							local helpr = #()
								
							if (superClassOf selArr[1] == helper) then
							(
								helpr[1] = selArr[1]
								--Select All Children
								macros.run FlowPanels GetChildren	
									
								selArr = selection as Array
								join helpr selArr 	
									
							)
								
							for obj in selArr do 
							(	
								--Y-up  function
								unityYUp obj
							)
								
							--selects all objects
							selectmore helpr
								
						)
							
							
						--export function
						rdyForExport()
							
							
						--sets pivot to first selection 							
						--deselect helpr
						--helpr = #()
							
					)
				)
			)
			--ERROR CHECK 			
			if selection.count == 0 and btn_fbx_typ.checked == false or selection.count == 0 and btn_obj_typ.checked  do
			(
				messagebox "Please make sure that you have a [file type] and an [object] Selected.  \n\n --This is a FlowPanels friendly reminder!" title: "Flow Panels -- Warning!" beep: false
			)	
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--INCREMENTS SUFFIX LETTER
		--------------------------------------------------------------------------------------------------------------------------------
			
		on radSufVal changed state do
		(
			case of 
			(
				(radSufVal.state == 1): 
				(
					btn_incr_vr.value = 01
					verNam.text = "a"
					verNam.enabled = true
				)
					
				(radSufVal.state == 2):
				(
					btn_incr_vr.value = 01
					verNam.enabled = true
					verNam.text= "01"
				)
					
				(radSufVal.state == 3): (
					verNam.enabled = false
					verNam.text = "------"
				)
			)
		)			
			
			
		On btn_incr_vr changed val do
		(   
			
			if radSufVal.state == 1 then
			(
				a = btn_incr_vr.value < 1
				b = btn_incr_vr.value > incr.count
					
				if a then
				(
					btn_incr_vr.value = incr.count
				)
				else if b then
				(
					btn_incr_vr.value = 1
				)
				
				print b
				verNam.text = incr[btn_incr_vr.value]	
			)
			else if radSufVal.state == 2 then
			(
				if val < 10 and val >= 0 then
				(
					verNam.text = "0"+(val)as string
				)
				else if val < 0 then
				(
					val = 0
					btn_incr_vr.value = 0
					verNam.text = "0"+(val)as string
				)
				else if val > 9 then
					verNam.text = (val)as string
			)			
			
		)
		
		
		
		
		--------------------------------------------------------------------------------------------------------------------------------
		--EXPORTING TO UNITY, SETS Y UP 		
		--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_unity_exp changed state do
		(   
			Undo on
			if state == on then
			(
				Unity_Y_Up = true
				
				--records settings
				SetAutoSettings Unity_Y_Up 6
			)
			if state == off then
			(
				Unity_Y_Up = false	
				
				--records settings
				SetAutoSettings Unity_Y_Up 6
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--USE TO RENAME SELECTION 		
		--------------------------------------------------------------------------------------------------------------------------------
			
		on btn_renam_on changed state do
		(
			if state == on then
			(
				renamObjs = true
				set_renamObjs = renamObjs
				if selection.count > 0 do
				(
					multiNam.text = selection[1].name
				)
				--records settings
				SetAutoSettings set_renamObjs 10
				
				--turnoff selection name
				use_ObjNam = false
				checkSel.active = use_ObjNam
				
				btn_use_objNam.checked = false
				
				multiNam.enabled = not offSwitch
				
				--records settings
				SetAutoSettings use_ObjNam 5				
			)
			if state == off then
			(
				renamObjs = false
				set_renamObjs = renamObjs
				
				multiNam.text = ""
				
				--records settings
				SetAutoSettings set_renamObjs 10
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--USE SELECTION NAME		
		--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_use_objNam changed state do
		(   
			
			if state == on then
			(
				use_ObjNam = true
				checkSel.active = use_ObjNam
					
				btn_renam_on.checked = false
					
				--records settings
				SetAutoSettings use_ObjNam 5
			)
			else if state == off then
			(
				use_ObjNam = false
				checkSel.active = use_ObjNam
				
				multiNam.enabled = not offSwitch
				multiNam.text = ""
				
				--records settings
				SetAutoSettings use_ObjNam 5
			)
		)	
		--------------------------------------------------------------------------------------------------------------------------------	
		--SET OBJECT TYPE OBJ			
		--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_obj_typ changed state do 		
		(
			
			if state == on then
			(
				btn_fbx_typ.checked = false
					
				if set_typ_string == undefined or set_typ_string != undefined then
				(
					set_typ_string = typ1
					typ_setr = set_typ_string
						
					--records settings 
					SetAutoSettings set_typ_string 7
						
				)
				else 
				(
					typ_setr = typ1	
				)
					
				--records settings 
				SetAutoSettings true 3
				SetAutoSettings false 2
				
				if autoType then 
				(
					preNam.text = "obj"
				)
			)
			else if state == off then
			(
				--records settings 
				SetAutoSettings false 3
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--SET OBJECT TYPE FBX
		--------------------------------------------------------------------------------------------------------------------------------	
			
		On btn_fbx_typ changed state do 
		(
			
			if state == on then
			(
				btn_obj_typ.checked = false
				
				if set_typ_string == undefined or set_typ_string != undefined then
				(
					set_typ_string = typ2
					typ_setr = set_typ_string
						
					--records settings 
					SetAutoSettings set_typ_string 7
						
				)
				else 
				(
					typ_setr = typ1	
				)
				
				--records settings 
				SetAutoSettings true 2
				SetAutoSettings false 3
				
				if autoType then 
				(
					preNam.text = "fbx"
				)
			)
			else if state == off then
			(
				--records settings 
				SetAutoSettings false 2
			)
		)
			
			
		------------------------------------------------------------------------------------------------------------------------------
		-- OPEN // CLOSED 
		------------------------------------------------------------------------------------------------------------------------------
			
			
		-- get saved data on start up
		on panExporter rolledUp open do 
		(		
				
			--populate list
			thelist.items = saveddata.keys -- change this to saveddata
				
			--update export list's tooltip 
			--listtooltipupdater thelist
				
			--checks to set value of prefix
			if set_autotype_checked == true do
			(
				prenam.text = set_prefixtext
			)
			--checks to set value of export location
			if set_exp_location != undefined do
			(
					
				--resets the list's last selected item
				if(thelist.items.count > 0 and set_list_last_sel != undefined) do
				(
					thelist.selection = set_list_last_sel
				)
					
				--displays folder name
				disp_fldr_nam.text = filenamefrompath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
			)	
				
			--sets bypass prefix and suffix value
			if bypassnam == true then
			(
					btn_bypass_nam.checked = true
					vernam.enabled = false
					--vernam.visible = false
					radsufval.enabled = false
					--radsufval.visible = false
					prenam.enabled = false
					--prenam.visible = false
					btn_incr_vr.enabled = false
					--btn_incr_vr.visible = false
						
			)
			else
			(
				--sets prefix if undefined
				if (prenam.text == "") do (
					prenam.text = "msh"
				)			
				--sets suffix to 'a' 
				if(vernam.text == "") do (
					vernam.text = "a"
				)
			)				
				
			--turns on and off the naming fields
			if btchexportchk.checked == true then
			(
				btn_use_objnam.enabled = false
				btn_renam_on.enabled = false
				multinam.enabled = false
				vernam.enabled = false
				radsufval.enabled = false
				prenam.enabled = false
				btn_incr_vr.enabled = false
			)
			else
			(
				if bypassnam == true or btn_bypass_nam.checked == true then
				(
					vernam.enabled = false
					radsufval.enabled = false
					prenam.enabled = false
					btn_incr_vr.enabled = false
				)
				else
				(
					btn_use_objnam.enabled = true
					btn_renam_on.enabled = true
					multinam.enabled = true
					vernam.enabled = true
					radsufval.enabled = true
					prenam.enabled = true
					btn_incr_vr.enabled = true
				)
			)
				
			
			if use_autocollapse == true do 
			(
				--switches to this rollout
				if open do switchrolls panexporter
			)
				
		)	
			