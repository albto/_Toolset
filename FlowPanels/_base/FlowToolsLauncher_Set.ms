

	global launcherData = #()
	----------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
	global mainFPFolder = getThisScriptFilename()
		
	----------------------------------------------------------------------------------------------------------------------------------
	global str = getThisScriptFilename()
	global imgfolder = getfilenamepath str
		
		
	global launcherFolder = getfilenamepath str  
	
	global toolFolder = substituteString launcherFolder "\FlowPanels\_base" ""
	
		
	global strMyFolder = ""
	----------------------------------------------------------------------------------------------------------------------------------
		
	----------------------------------------------------------------------------------------------------------------------------------
	-- Auto-Load Lauincher Data on Start-up
		
	--this is redundant 
	if (doesFileExist(toolFolder + "\FlowPanels\savedata\LauncherData.fp")) then	
	(
		ld = openfile (toolFolder + "\FlowPanels\savedata\LauncherData.fp") 
		launcherData = execute (readLine ld)
		close ld
			
	)	
	
	print (	 "Launcher Data - " + launcherdata as string)
	
	if launcherData != undefined then
	(
		--grab data
		mainFPFolder = launcherData[1]
	)
	
	global FP_DataLocation 
	global FP_BaseLocation 
	global FP_RCLocation 
		
	--set locations
	FP_DataLocation	= (mainFPFolder + "\FlowPanels\_base\FlowSaveData.ms")
	FP_BaseLocation = (mainFPFolder + "\FlowPanels\_base\FlowToolsBase.ms")
	FP_RCLocation 	= (mainFPFolder + "\FlowPanels\_base\FlowRCMenu.ms")
		
		
	--Set Tool Image file
	bitmapBannerFile = (imgfolder + "banner.jpg")
		
		
		
		
		
		
		
		
	Try(cui.UnregisterDialogBar edt)catch()
	try(destroydialog edt)catch()
		
		
	----------------------------------------------------------------------------------------------------------------------------------
	rcMenu LauncherSettingsMenu
	----------------------------------------------------------------------------------------------------------------------------------
	(	

		submenu "- Options -"
		(
				
			menuitem itmDEBUG "Debug Settings Recorder"
			submenu "Start-Up Options"
			(		
				
				menuItem itmChkDock "Auto-Dock" 
				separator sp2	
				menuItem itmRecorder "Remember Settings" 
			)
				
			submenu "Systems Setup"
			(
				menuItem itmDock "Install Object Attributes"
				separator sp3
				menuItem itmQuads "Install Custom UI presets"				
			)
				
			separator sp4
				
		)
			
		submenu "- Help -"
		(
			menuItem itmLoadAbout "About" 
				separator sp5	
			menuItem itmLoadHelp "Help Manual" 
				separator sp12	
		)	
		submenu "!"
		(
			menuItem itmReloadTool "Reload Tool"
				separator sp11	
			menuItem itmUpdateTool "Update Tool"
				separator sp10	
		) 
		
		--Reset toolset
		on itmUpdateTool picked do 
		(
			if queryBox "would you like to download tools directly?" title:"Download Option" beep:false then
			(
				ShellLaunch "https://github.com/albto/_Toolset/archive/master.zip" ""
			)
			else
			(
				ShellLaunch "https://github.com/albto/_Toolset" ""
			)
		)
		
		on itmReloadTool picked do 
		(
			filein (getThisScriptFilename() as string)
		)
			
		on itmDock picked do 
		(
			filein (mainFPFolder + "\FlowFunctions\FlowObjectAttributes.ms")
		)
		
		on itmQuads picked do 
		(
			try 
			(
				--load quad menus
				menuMan.loadMenuFile  (mainFPFolder + "\\FlowPanels\\savedata\\ui\\MaxStartUI.mnux")
					
				--load hotkeys 
				actionman.loadKeyboardFile (mainFPFolder + "\\FlowPanels\\savedata\\ui\keys.hsx")
					
				print "Successfully loaded Quad-Menus and Hotkeys!"
			)
			catch(print "custom ui preset files not found")
		)
		
		
	)

----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
	
	rollout edt "Launcher"
	(
			
		local newArr = #()
		local levels = #()
		local newLevels = #()
		local cleanArr = #()
		local clean_fold_arr = #()
		local clean_sfol_array = #()
		local subsfol_array = #()
		local refObjs = #()
			
		bitmap bitmapBannerUi 						width:335 height:64 fileName:bitmapBannerFile align:#center gamma:1.0
			
		Group "Status"
		(
			label lbl_title  ""					align:#center	height:20	
		)
			
			
		Group "Toolset"
		(
			edittext edt_find "" 				 	align:#left 			height:20 	fieldwidth:280  	enalbed:false			multiline:false											 across:2
			button btn_find "Find" 					align:#right height:20 	width:20	images:#("UVWUnwrapOption_24i.bmp", "UVWUnwrapOption_24i.bmp",30,7,8,1,1) 		ToolTip: "Find Toolset Folder"	
			button btn_lau "Launch"					height:24	width:75 	across:4	--images:#("Maxscript_24i.bmp", "Maxscript_24i.bmp",5,1,1,3,4) 				ToolTip: "Launch Toolset"
			button btn_clos "Close"					height:24	width:75				--images:#("Maxscript_24i.bmp", "Maxscript_24i.bmp",5,4,1,1,4) 				ToolTip: "Close Toolset"
			button btn_rest "Reset"					height:24	width:75 				--images:#("Maxscript_24i.bmp", "Maxscript_24i.bmp",5,3,1,1,4) 				ToolTip: "Reset Toolset"
			button btn_empt "Empty"					height:24	width:75 				--images:#("Maxscript_24i.bmp", "Maxscript_24i.bmp",5,3,1,1,4) 				ToolTip: "Reset Toolset"
		)	
			
			
		Group "Project Directory"
		(
			dropdownlist ddl_proj "" 			items:#()
			button btn_crt "New"				width:75	height:24	across:4
			button btn_open "Open"				width:75	height:24
			button btn_edit	"Refresh"				width:75	height:24
			button btn_swtc	"Switch"			width:75	height:24
		)
			
		Group "Directory Helper"
		(	
			checkbutton chk_sel_nam "Auto-Name"			width:65					align:#left			across:3
			edittext edt_dir_name ""					width:180 	height:20		align:#center
			dropdownList ddl_area_suf ""				width:62					align:#right		items:#("no_tag", "_100", "_200", "_300", "_400", "_500", "_600", "_700", "_800", "_900")
				
			button btn_crt_cat "New Category"		width:80	height:24 							across:4
			button btn_crt_scn "New Level"			width:75	height:24	
			button btn_crt_are "New Area"			width:75	height:24
			button btn_crt_prp "New Prop"			width:75	height:24
		)
			
		Group "Directory Viewer"
		(		
			dropdownList ddl_folder "Categories" 					across:2
			dropdownList ddl_subfol "Levels" 			
						
			listbox lst_areas "Areas List"	
			checkbutton chk_art "_Art" 			width:75	height:24	across:4
			checkbutton chk_dsn "_Design"		width:75	height:24
			checkbutton chk_inst "_Inst"		width:75	height:24
			checkbutton chk_veh "_Vehicle"		width:75	height:24
		)
			
		Group "XRef Scenes"
		(
			dropdownList ddl_refs ""	 			width:200 across:6
			label lbl_space ""
			label lbl_space2 ""
			label lbl_space3 ""
			button btn_rmv_ref "Remove"				align:#right 
			button btn_upd_ref "Update"				--align:#right
		)
			
			
		--TICK-----------------------------------------------------------------------
		-----------------------------------------------------------------------------
		timer tick_LauncherUpdate "" 			interval:500
			
		--Filter levels list
		fn LevelFilter arr1 arr2 i = 
		(
			for val in arr2 where matchpattern val pattern:i do 
			(
				--filter level name 
				str = filenameFromPath val 
					
				--adding to new array
				appendIfUnique arr1 str as string 
				appendIfUnique levels val
					
			)		
		)
			
		--Reload sub folders list
		fn GetProjectLevels = 
		(
			strMyFolder =  getFilenamePath ddl_proj.items[ddl_proj.selection]
			
			levels = getFiles((strMyFolder as string + "\\*.max"))
				
			newArr = #()
			newLevels = #()
			cleanArr = #()
				
			--create directories array 
			dir_array = GetDirectories (strMyFolder +"\scenes\Areas\\*")
				
			for d in dir_array do
			(
				join dir_array (GetDirectories (d+"\\*"))
				
			)
				
			--pass the sub folders to drop downlist 
			folders_array = GetDirectories (strMyFolder +"\scenes\Areas\\*")
				
			--loop through categories and create the list 
			for i = 1 to folders_array.count do 
			(
				newArr[i] = filenameFromPath folders_array[i]
				--clean up Name 
				str = substituteString newArr[i] "\\" ""
				newArr[i] = str
				
			)		
				
			--clean string to display as folder//category 
			newArr[1] = "Show All"
			

				
			ddl_folder.items = newArr
				
			--finds .mxp files and then filters out the sub-folder location 
			
				
			--Folder filter
			if ddl_folder.selection == 1 then 
			(
					
				for f in dir_array do
				(
					join newLevels (getFiles (f+ "\\*.max"))
					ddl_subfol.items = #("Levels List")
					ddl_subfol.selection = 1
					ddl_subfol.enabled = false
					
				)
				
			)			
			else if ddl_folder.selection == ddl_folder.selection then 
			(
				
				ddl_subfol.enabled = true
				
				--create new folder array 
				clean_fold_arr = #()
					
				--create new sub folder array 
				clean_sfol_array = #()
				
					
				if ddl_subfol.selection == 1 then
				(			
					newLevels = #()
					
					for i in folders_array do
					(
						--filter level name
						str = filenameFromPath i
						--remove slashes -- it errors out otherwise
						str = substituteString str "\\" "" 
							
						--adding to new array
						appendIfUnique clean_fold_arr str as string 
							
					)
						
					--Set Sub folders
					folders_array = (GetDirectories (strMyFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string))
						
					subsfol_array = (GetDirectories (strMyFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string+"\*"))
						
					for t in subsfol_array do 
					(
						join subsfol_array (GetDirectories (t+"\\"))
						
					)
						
					--create new sub folder array 
					clean_sfol_array[1] = "All Levels"
						
					for o in subsfol_array do 
					(
						--filter level name
						str = filenameFromPath o
						--remove slashes -- it errors out otherwise
						str = substituteString str "\\" "" 
							
						--adding to new array
						appendIfUnique clean_sfol_array str as string 
					)
					
					--pass sub folder names to the list 
					ddl_subfol.items = clean_sfol_array
						
					--grab all sub folders 
					for f in folders_array do 
					(
						join folders_array (GetDirectories (f+"*"))
						
					)
						
					--find all max files in sub folders
					for l in folders_array do 
					(
						join newLevels (getFiles (l+ "\\*.max"))
					)
				)
				else if ddl_subfol.selection > 1 then
				(
					
					for i in folders_array do
					(
						--filter level name
						str = filenameFromPath i
						--remove slashes -- it errors out otherwise
						str = substituteString str "\\" "" 
							
						--adding to new array
						appendIfUnique clean_fold_arr str as string 
							
					)
						
					--Set Sub folders
					folders_array = (GetDirectories (strMyFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string))
						
						
					subsfol_array = (GetDirectories (strMyFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string+"\*" ))
						
					for t in subsfol_array do 
					(
						join subsfol_array (GetDirectories (t+"\\"))
						
					)
					
					
					--create new sub folder array 
					clean_sfol_array[1] = "All Levels"
						
					for o in subsfol_array do 
					(
						--filter level name
						str = filenameFromPath o
						--remove slashes -- it errors out otherwise
						str = substituteString str "\\" "" 
							
						--adding to new array
						appendIfUnique clean_sfol_array str as string 
					)
					
					--pass sub folder names to the list 
					ddl_subfol.items = clean_sfol_array
					
					subsfol_array = (GetDirectories (strMyFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string + "\\" + clean_sfol_array[ddl_subfol.selection]))
					
					if subsfol_array.count >= 1 then 
					(
						--grab all sub folders 
						for f in subsfol_array do 
						(
							join subsfol_array (GetDirectories (f +"*"))
							
						)
							
						--find all max files in sub folders
						for l in subsfol_array do 
						(
							join newLevels (getFiles (l + "\\*.max"))
						)
						
					)
				)					
			)
				
			for i in newLevels do 
			(	
				
				if not chk_art.checked and not chk_dsn.checked and not chk_inst.checked and not chk_veh.checked then 
				(
					LevelFilter cleanArr newLevels "**"
				)				
					
				if chk_art.checked then
				(						
					LevelFilter cleanArr newLevels "*_art*"
				)		
				if chk_dsn.checked then
				(						
					LevelFilter cleanArr newLevels "*_design*"
				)		
				if chk_inst.checked then
				(						
					LevelFilter cleanArr newLevels "*_inst*"
				)		
				if chk_veh.checked then
				(						
					LevelFilter cleanArr newLevels "*_vehicle*"
				)		
					
			)
				
			--pass to the list 
			lst_areas.items = cleanArr
				
		)
			
		--Reload Projects ListBoxControl
		fn ReloadProjectList = 
		(
			pth = "G:\Dropbox\[main access]\3ds_Max_Source\_3ds Max - Projects" --pathConfig.removePathLeaf (pathConfig.getCurrentProjectFolderPath())
				
			files = getFiles((pth as string + "\\*.mxp"))
				
			dir_array = GetDirectories (pth +"\\*")
			for d in dir_array do
			(
				join dir_array (GetDirectories (d+"\\*"))
			)
				
			newFiles = #()
			cleanArr = #()
				
			--finds .mxp files and then filters out the sub-folder location 
			for f in dir_array do
			(
				join newFiles (getFiles (f+ "\\*.mxp"))
					
				for i in newFiles do 
				(
					str = getFilenamePath i
					appendIfUnique cleanArr str as string 
				)
					
				files = cleanArr
					
			)
				
			--updates list ui
			ddl_proj.items = files					
				
		)
			
		--Saves Flow Panels Global Settings
		fn SaveLauncherData location = 
		(		
				
			--save data
			lauIni = createFile (location + "\FlowPanels\savedata\LauncherData.fp")
				
			format (with printAllElements on launcherData as string) to:lauIni
			flush lauIni
			close lauIni
				
		)
			
		--sets the Settings to be saved
		fn SetLauncherData val intgr = 
		(
			launcherData[intgr] = val
		)	
			
		--update status 
		fn UpdateToolsetStatus = 
		(
			if panFlowPan != undefined then 
			(
				if panFlowPan.inDialog then 
				(
					lbl_title.text = ":Toolset is Active:"
						
				)
				else if not panFlowPan.inDialog then 
				(
					if mainFPFolder != undefined then
					(
							
						if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
						(
							lbl_title.text = "Toolset Ready to Launch!"
						)
						else
						(
							lbl_title.text = "::WARNING::Toolset not Found::"
						)
					)
				)				
				else
				(
					lbl_title.text = "Welcome, " +( sysinfo.username as string) + "!"	
						
					--deactivate 'close' button 
					
						
				)
			)
			else 
			(
					lbl_title.text = "Welcome, " +( sysinfo.username as string) + "!"	
						
					if mainFPFolder != undefined then
					(
							
						if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
						(
							lbl_title.text = "Toolset Ready to Launch!"
						)
						else
						(
							lbl_title.text = "::WARNING::Toolset not Found::"
						)
					)
				
-- 					--deactivate 'close' button 
-- 					btn_clos.enabled = false
			)
		)
		
		fn UpdateXrefsList = 
		(
			--create array
			arr = #()
			--clear items
			ddl_refs.items = arr
			
			count = xrefs.getXRefFileCount()
			
			if count > 0 then
			(
				for i = 1 to count do 
				(
					xs = xrefs.getXRefFile i
					arr[i] = filenameFromPath xs.filename
				)
			)
			else(
				arr = #("No Scenes Found")
			)	
			ddl_refs.items = arr
		)
		
		----------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------
		
		
		-- UI COMMANDS -- BELOW
		
		
		----------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------
		
		on tick_LauncherUpdate tick do 
		(
			--update status 
			UpdateToolsetStatus()		
			
			if chk_sel_nam.checked then 
			(
				edt_dir_name.enabled = false
				sel = selection as array
				if  sel.count > 0 then 
				(
					for i in selection as array do 
					(
						edt_dir_name.text = i.name
					)
				)
				else ( edt_dir_name.text = "...")
			)
			else (edt_dir_name.enabled = true )
		)
			
		on chk_sel_nam changed state do 
		(			
			if chk_sel_nam.checked then 
			(
				edt_dir_name.enabled = false
				sel = selection as array
				if  sel.count > 0 then 
				(
					for i in selection as array do 
					(
						edt_dir_name.text = i.name
					)
				)
				else ( edt_dir_name.text = "...")
			)
			else (edt_dir_name.enabled = true )		
		)
			
			
		on btn_rmv_ref pressed do 
		(
			
			try(
				xs = xrefs.getXRefFile ddl_refs.selection
			
				--delete xScene ref
				delete xs
				
				--remove item from list 
				arr = #()
				arr = ddl_refs.items
				
				deleteItem arr ddl_refs.selection
				ddl_refs.items = arr
				
				print "removed"
				
				if ddl_refs.items.count == 0 then 
				(arr = #("No Scenes Found"); ddl_refs.items = arr)
			
			)
			catch( print "unable to remove item"; arr = #("No Scenes Found"); ddl_refs.items = arr)
		)
			
		on btn_upd_ref pressed do 
		( 
				
			if ddl_refs.items.count > 1 then
			(				
				
				xs = xrefs.getXRefFile ddl_refs.selection
				
				updateXRef xs
				print "updated"
			)			
-- 			hiddenNodes = #()
-- 			hiddenLayers = #()
-- 			
-- 			for o in objects where not o.ishidden and not o.isSelected do 
-- 			(
-- 				hide o
-- 				append hiddenNodes o
-- 			)
-- 			
-- 			local nxrefs = xrefs.getXRefFileCount()
-- 			for i = 1 to nxrefs do
-- 			(
-- 				local xref_f = xrefs.getXRefFile i
-- 				if not xref_f.hidden do (xref_f.hidden = true; append hiddenLayers xref_f)
-- 			)
-- 			ok
-- 			for o in hiddenNodes where isvalidnode o do unhide o
-- 			hiddenNodes = #()
-- 			hiddenLayers = #()
		)
		--Areas List -- when double clicked 
		on lst_areas selected i do 
		(
			--print lst_areas.items[i]
		)
			
			
		--Areas List -- when double clicked 
		on lst_areas doubleClicked i do 
		(
			loadMaxFile levels[i] useFileUnits:true quietmode:true
		)
			
		
		--Areas List -- when right clicked 
		on lst_areas rightClick i do 
		(
			 
			try
			(
				refObjs = #()
				Xrefobjs = getMAXFileObjectNames levels[i]
				
				Xrefobjs = xrefs.addNewXRefFile  levels[i] modifiers:#xref manipulators:#xref dupMtlNameAction:#useXRefed 
				
				--Xrefobjs.showFrozenInGray = false
				--freeze Xrefobjs
				--Xrefobjs.wirecolor = [88, 144, 225]
					
				append refObjs (filenameFromPath Xrefobjs.filename)
				
				ddl_refs.items = refObjs
						
			)
			catch()
			
			
			
		)
			
		--level filter - art 
		on chk_art changed state do 
		(
			GetProjectLevels()
		)
			
		--level filter - design 
		on chk_dsn changed state do 
		(
			GetProjectLevels()
		)
		
		--level filter - inst 
		on chk_inst changed state do 
		(
			GetProjectLevels()
		)
			
		--level filter - veh 
		on chk_veh changed state do 
		(
			GetProjectLevels()
		)
		
		on ddl_proj selected i do 
		(
			--get Project levels and filter types 
			GetProjectLevels()
			
		)
		
		on ddl_subfol selected i do
		(
				
			--get Project levels and filter types 
			GetProjectLevels()
				
		)
			
		on ddl_folder selected i do 
		(
			--reset drop down list
			ddl_subfol.selection = 1 
				
			--Reload sub folders list
			GetProjectLevels()
				
		)
			
		on btn_crt_cat pressed do 
		(
			areaname = edt_dir_name.text		
			
			makeDir (@"G:\Dropbox\[main access]\3ds_Max_Source\_3ds Max - Projects\Prj_Buho_BathHouse\scenes\Areas\\" + areaname as string)
			
			areaname = edt_dir_name.text			
			
			makeDir (@"G:\Dropbox\[main access]\3ds_Max_Source\_3ds Max - Projects\Prj_Buho_BathHouse\scenes\Areas\\" + areaname as string)
			
			
			--Reload Projects List
			ReloadProjectList()
				
			--get Project levels and filter types 
			GetProjectLevels()
			
			
		)
			
		on btn_crt_scn pressed do 
		(
			area_tag = ""
				
			if chk_art.checked then
			(
				area_tag = "_Art"
			)
				
			if chk_dsn.checked then(
				area_tag = "_Design"
			)
			
			areaname = edt_dir_name.text + "_Main" 	+ "\models\Art"
			
			makeDir (@"G:\Dropbox\[main access]\3ds_Max_Source\_3ds Max - Projects\Prj_Buho_BathHouse\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + areaname as string)
		
			areaname = edt_dir_name.text + "_Main" 	+ "\models\Design"
			
			makeDir (@"G:\Dropbox\[main access]\3ds_Max_Source\_3ds Max - Projects\Prj_Buho_BathHouse\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + areaname as string)
			
			--Reload Projects List
			ReloadProjectList()
				
			--get Project levels and filter types 
			GetProjectLevels()
			
			
		)
		
		on btn_crt_are pressed do 
		(
				
			area_tag = ""
				
			if chk_art.checked then
			(
				area_tag = "_Art"
			)
				
			if chk_dsn.checked then(
				area_tag = "_Design"
			)
				
-- 			if chk_sel_nam.checked then 
-- 			(
-- 				edt_dir_name.text
-- 			)
-- 			else 
-- 			( ) 
			areaname = edt_dir_name.text + area_tag + ".max"			
				
			loc =  (strMyFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + clean_sfol_array[ddl_subfol.selection] + "\\" + "models\\" + area_tag + "\\" + areaname as string)
				
			saveNodes selection loc quiet:true
				
			--Reload Projects List
			ReloadProjectList()
				
			--get Project levels and filter types 
			GetProjectLevels()
				
				
		)
		
		on btn_crt pressed do 
		(
				
			if (folder = getSavePath  caption:"Set Project Directory" filename:(GetDir #scripts)) != undefined then
			(
				--macros.run "Tools" "CreateDefaultProject" 
				pathConfig.doProjectSetupStepsUsingDirectory folder  
				pathConfig.setCurrentProjectFolder folder
				
				--Reload Projects List
				ReloadProjectList()
				
			)
				
		)
		
		on btn_edit pressed do 
		(
			--Reload Projects List
			ReloadProjectList()
		)
		
		on btn_swtc pressed do 
		(
			--pathconfig.SaveTo(strMyFolder)
				
			pathconfig.setCurrentProjectFolder strMyFolder
			resetMaxFile() 
				
			--pathConfig.doProjectSetupStepsUsingDirectory strMyFolder  
				
-- 			doesFolderExist = doesFileExist strMyFolder allowDirectory:true
-- 			if(doesFolderExist and pathconfig.IsProjectFolder(strMyFolder)) then 
-- 			(
-- 				-----------------------------------------------
-- 				-- backup the current config paths settings in the current working folder 
-- 				-- to not lose possible modifications that might have been done
-- 				-- before switching the working folder
-- 				-----------------------------------------------
-- 				pathconfig.SaveTo(pathconfig.getCurrentProjectFolderPath())

-- 				pathconfig.setCurrentProjectFolder strMyFolder
-- 				pathConfig.doProjectSetupStepsUsingDirectory strMyFolder  
-- 				
-- 				resetMaxFile 
-- 					
-- 					
-- 				--arStrFnames = getfiles (strMyFolder + "\\*.mxp")
-- 			)
			
-- 			if (strMyFolder = getSavePath  caption:"Set Project Directory" filename:(GetDir #scripts)) != undefined then
-- 			(
-- 				macros.run "Tools" "SetProjectFolder" 
-- 				
-- 				print strMyFolder
-- 				pathConfig.doProjectSetupStepsUsingDirectory strMyFolder  
-- 				pathConfig.setCurrentProjectFolder strMyFolder
-- 				resetMaxFile 
-- 				
-- 			)
				
		)
		
			
		--------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_find pressed do 
		(
			try 
			(
				str = (GetDir #scripts)
					
				mainFPFolder  = getSavePath  caption:"Open A Test File:" filename:str
					
					
				if mainFPFolder != undefined then 
				(
						
					edt_find.text = filenameFromPath mainFPFolder
					edt_find.tooltip = mainFPFolder
						
				)
				else 
				(
					if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
					(

					)
					else
					(
						mainFPFolder = GetDir (#scripts)
					)
				)	
					
				if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
				(
					--set locations
					FP_DataLocation	= (mainFPFolder + "\FlowPanels\_base\FlowSaveData.ms")
					FP_BaseLocation = (mainFPFolder + "\FlowPanels\_base\FlowToolsBase.ms")
					FP_RCLocation 	= (mainFPFolder + "\FlowPanels\_base\FlowRCMenu.ms")
						
					edt_find.enabled = true
					btn_lau.enabled = true
						
					bitmapBannerFile = (imgfolder + "banner.jpg")
					bitmapBannerUi.filename = bitmapBannerFile
						
					edt_find.text += " -- { Toolset Found }"
						
					--set array
					SetLauncherData mainFPFolder 1
						
					--print launcherData	
				)
				else
				(
						
					edt_find.enabled = false
					btn_lau.enabled = false
						
					bitmapBannerFile = (imgfolder + "banner_fail.jpg")
					bitmapBannerUi.filename = bitmapBannerFile
						
					edt_find.text += " -- { wrong folder } -- { No Toolset }"			
						
					--set array
					SetLauncherData mainFPFolder 1
						
					--print launcherData
				)	
					
			--update status 
			UpdateToolsetStatus()
				
			--save 'mainFPFolder' 
			SaveLauncherData toolFolder	
				
			)
			catch()
		)
			
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_lau pressed do 
		(
			try 
			(	
				--update status 
				UpdateToolsetStatus() 
					
				if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
				(
					print (mainFPFolder + "\FlowPanels_v8.ms")
						
					filein (mainFPFolder + "\FlowFunctions\FlowAttributes.ms")
					filein (mainFPFolder + "\FlowFunctions\FlowCreator.ms")
					filein (mainFPFolder + "\FlowFunctions\FlowFunctions.ms")
					filein (mainFPFolder + "\FlowFunctions\FlowObjectAttributes.ms")
					filein (mainFPFolder + "\FlowPanels_v8.ms")
						
					btn_clos.enabled = true
				)
				else
				(				
					lbl_title.text = "::WARNING::Unable to Launch::"
					btn_clos.enabled = false
						
				)					
				--save 'mainFPFolder' 
				SaveLauncherData toolFolder	
					
				
			)
			catch()
				
		)					
				
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_clos pressed do 
		(
			Try (cui.unRegisterDialogBar panFlowPan) catch()
			Try (destroydialog panFlowPan) catch()
				
			btn_clos.enabled = false
				
			--update status 
			UpdateToolsetStatus()
				
				
		)
			
		--------------------------------------------------------------------------------------------------------------------------------------
		on btn_rest pressed do 
		(
			
			if querybox "Are you sure you want to Reset the Toolset?\nThis will erase all data" title:"Reset Toolset" beep:false then
			(		
				
				Try (cui.unRegisterDialogBar panFlowPan) catch()
				Try (destroydialog panFlowPan) catch()
				
				
				local usedotNam = sysInfo.username as string
				--DELETE PRESET LOCATIONS 
				if querybox "Do you want to delete preset Locations Data?\nThis will erase all locations saved for [Export, Import and Launcher] Panels" title:"Data-Loss Prevention" beep:false then
				(	
						
					ss0 = (mainFPFolder + "\FlowPanels\savedata\ScriptsLocations.fp")
						
					if (doesFileExist ss0) then
					(
						deletefile (ss0)
					)
						
					--DELETE PRESET LOCATIONS 
					ss1 = (mainFPFolder + "\FlowPanels\savedata\PresetLocations.fp")
						
					if (doesFileExist ss1) then
					(			
						deletefile (ss1)		
					)
						
					--DELETE PRESET IMPORT LOCATIONS
					ss2 = (mainFPFolder + "\FlowPanels\savedata\PresetImportLocations.fp")
						
					if (doesFileExist ss2) then
					(
						deletefile (ss2)
					)
						
				)
					
				--DELETE GLOBAL SETTINGS
				ss3 = (mainFPFolder + "\FlowPanels\savedata\FPGlobals.fp")
					
				if (doesFileExist ss3) then
				(
					deletefile (ss3)
				)	

				--DELETE AUTO SETTINGS
				ss4 = (mainFPFolder + "\FlowPanels\savedata\AutoSettings.fp")
					
				if (doesFileExist ss4) then
				(
					deletefile (ss4)
				)

				--reset settings
				auto_FP_Settings = #()
					
				--reset global settings
				FP_Global_Settings = #()
					
				messagebox "Flow Panels has been Reset!"
					
				if querybox "Do you want to relaunch the Toolset?" title:"Auto-Launcher" beep:false then
				(
						
					--Reload Toolset
					filein (mainFPFolder + "\FlowFunctions\FlowAttributes.ms")
					filein (mainFPFolder + "\FlowFunctions\FlowCreator.ms")
					filein (mainFPFolder + "\FlowFunctions\FlowFunctions.ms")
					filein (mainFPFolder + "\FlowFunctions\FlowObjectAttributes.ms")
					filein (mainFPFolder + "\FlowPanels_v8.ms")
						
					messagebox "Flow Panels has been Relaunched!" title:"Flow Warnings!"
						
				)
				else(
					
				)
					
			)
			Else
			(
				messagebox "No Risk, No Rewards!..." title:"Flow Warnings!"
			)
				
			--update status 
			UpdateToolsetStatus()
				
		)
		
			
		on btn_empt pressed do 
		(
			ShellLaunch "Unity3d.exe" ""
			
		)
		--------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on edt open do 
		(
						
			callbacks.addScript #filePostOpenProcess  " edt.UpdateXrefsList()" id:#MXSHelp
			arr = #()
			
			count = xrefs.getXRefFileCount()
			
			if count > 0 then
			(
				for i = 1 to count do 
				(
					xs = xrefs.getXRefFile i
					arr[i] = filenameFromPath xs.filename
				)
			)
			else(
				arr = #("No Scenes Found")
			)	
			ddl_refs.items = arr
			
				
			--Reload Projects List
			ReloadProjectList()
				
			ddl_proj.selected = ddl_proj.items[1]
				
			--get Project levels and filter types 
			GetProjectLevels()
				
			if mainFPFolder != undefined then
			(
					
				edt_find.text = filenameFromPath mainFPFolder
				edt_find.tooltip = mainFPFolder
					
				if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
				(
					
					edt_find.enabled = true
					btn_lau.enabled = true
						
					edt_find.text += " -- { Toolset Found }"
						
					--set image
					bitmapBannerFile = (imgfolder + "banner.jpg")
					bitmapBannerUi.filename = bitmapBannerFile
						
				)
				else
				(
						
					edt_find.enabled = false
					btn_lau.enabled = false
						
					edt_find.text += " -- { wrong folder } -- { No Toolset }"
						
					--set image
					bitmapBannerFile = (imgfolder + "banner_fail.jpg")
					bitmapBannerUi.filename = bitmapBannerFile
						
				)
					
			)	
			else
			(
				lbl_title.text = "Welcome, " +( sysinfo.username as string) + "!"
					
				--grab data
				mainFPFolder = launcherData[1] 
			)	
				
			--update status 
			UpdateToolsetStatus()				
				
		)
				
		on edt resized theSize do
		(
			--edt.width 	= theSize.x
			--edt.height 	= theSize.y
			
		)
		
		on edt close do 
		(
			callbacks.removeScripts id:#MXSHelp
			
			--save 'mainFPFolder' 
			SaveLauncherData toolFolder	
		)
		
	)

	createDialog edt menu:LauncherSettingsMenu width:340 height:680 
	
	cui.registerDialogBar edt style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #style_resizing, #style_toolwindow) lockHeight:false lockWidth:false autoLayoutOnResize:true --bgColor:[rRed,bBlu,gGre] 

	