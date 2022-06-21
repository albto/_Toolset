
-- global launcherData = #()
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- global mainFPFolder = getThisScriptFilename()
	
----------------------------------------------------------------------------------------------------------------------------------
-- global str = getThisScriptFilename()

-- 	
-- 	
-- global launcherFolder = getfilenamepath str  

-- global toolFolder = substituteString launcherFolder "\FlowPanels\_base" ""

-- 	
-- global strMyFolder = ""
----------------------------------------------------------------------------------------------------------------------------------
	
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Auto-Load Lauincher Data on Start-up
	
--this is redundant 
-- if (doesFileExist(toolFolder + "\FlowPanels\savedata\LauncherData.fp")) then	
-- (
-- 	ld = openfile (toolFolder + "\FlowPanels\savedata\LauncherData.fp") 
-- 	launcherData = execute (readLine ld)
-- 	close ld
-- 		
-- )	

-- print (	 "Launcher Data - " + launcherdata as string)

-- if launcherData != undefined then
-- (
-- 	--grab data
-- 	mainFPFolder = launcherData[1]
-- )
	
-- global FP_DataLocation 
-- global FP_BaseLocation 
-- global FP_RCLocation 
	
--set locations
-- FP_DataLocation	= (mainFPFolder + "\FlowPanels\_base\FlowSaveData.ms")
-- FP_BaseLocation = (mainFPFolder + "\FlowPanels\_base\FlowToolsBase.ms")
-- FP_RCLocation 	= (mainFPFolder + "\FlowPanels\_base\FlowRCMenu.ms")
-- 	
global imgfolder =  (toolFolder + "\\FlowPanels\\_images\\") --getfilenamepath str	
--Set Tool Image file
bitmapBannerFile = (imgfolder + "banner.jpg")
	
	
----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------- // Tools Save Data
--Tools Save Data 
	--"G:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_Toolset\FlowPanels\_base\FlowSaveData.ms"
-- 	filein FP_DataLocation
		
		
----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------- // Tool Settings
--Tool Settings 
	--"G:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_Toolset\FlowPanels\_base\FlowToolsBase.ms"
-- 	filein FP_BaseLocation		
		
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------	
	
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
			submenu "System Intallation"
			(
				menuItem itmErthng "Install Every Available System"	
				separator sp14
				menuItem itmDock "Install Object Attributes"
				separator sp3
				menuItem itmQuads "Install Custom UI presets"	
				separator sp13
				menuItem itmXmlGen "Install Xml Generator (required)"	
			)
			
			submenu "System Removal"
			(
-- 					menuItem itmErthng "Install Every Available System"	
-- 					separator sp14
-- 					menuItem itmDock "Install Object Attributes"
-- 					separator sp3
-- 					menuItem itmQuads "Install Custom UI presets"	
-- 					separator sp13
-- 					menuItem itmXmlGen "Install Xml Generator"	
			)
			
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
	
	on itmErthng picked do 
	(
		currentMaxVersion = maxversion()		
		
		try 
		(
			source_file = (" \"C:\\Users\\albto\\Documents\\_Toolset\\FlowPanels\\_base\\XmlGenerator" + ".ms" + "\"")  
			dest_folder = (" \"C:\\Program Files\\Autodesk\\3ds Max " + currentMaxVersion[8] as string +"\\scripts\\Startup\\XmlGenerator" + ".ms" + "\"") -- "%ProgramFiles%\Autodesk\scripts\startup\XMLGenerator.ms") 
				
			txt = ("copy" + " " + source_file + " " + dest_folder) as string 
			f = (createFile (mainFPFolder + "\\FlowPanels\\_base\\Install_XmlGenerator.bat"))
			format "%\n" txt to:f
			format "pause\n" to:f
				
			close f
				
			bat = (mainFPFolder + "\\FlowPanels\\_base\\Install_XmlGenerator.bat")
				
			--run batch file
			ShellLaunch bat ""
		)
		catch(print "Could not find 'Install_XmlGenerator.bat' file")	
			
			
		try 
		(
			filein (mainFPFolder + "\FlowFunctions\FlowObjectAttributes.ms")
			print "Successfully Installed Flow Attributes"
		)
		catch(print "ERROR: loading flow attributes script; file was not found")
			
			
		try 
		(
			--load quad menus
			menuMan.loadMenuFile  (mainFPFolder + "\\FlowPanels\\savedata\\ui\\MaxStartUI.mnux")
				
			--load hotkeys 
			actionman.loadKeyboardFile (mainFPFolder + "\\FlowPanels\\savedata\\ui\keys.hsx")
				
			print "Successfully loaded Quad-Menus and Hotkeys!"
		)
		catch(print "ERROR: loading custom ui presets; files not found")
			
		
		
	)
	
		
	on itmDock picked do 
	(
		try 
		(
			filein (mainFPFolder + "\FlowFunctions\FlowObjectAttributes.ms")
			print "Successfully Installed Flow Attributes"
		)
		catch(print "ERROR: loading flow attributes script; file was not found")
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
	
	on itmXmlGen picked do 
	(
		currentMaxVersion = maxversion()		
		
		try 
		(
			source_file = (" \"C:\\Users\\albto\\Documents\\_Toolset\\FlowPanels\\_base\\XmlGenerator" + ".ms" + "\"")  
			dest_folder = (" \"C:\\Program Files\\Autodesk\\3ds Max " + currentMaxVersion[8] as string +"\\scripts\\Startup\\XmlGenerator" + ".ms" + "\"") -- "%ProgramFiles%\Autodesk\scripts\startup\XMLGenerator.ms") 
				
			txt = ("copy" + " " + source_file + " " + dest_folder) as string 
			f = (createFile (mainFPFolder + "\\FlowPanels\\_base\\Install_XmlGenerator.bat"))
			format "%\n" txt to:f
			format "pause\n" to:f
				
			close f
				
			bat = (mainFPFolder + "\\FlowPanels\\_base\\Install_XmlGenerator.bat")
				
			--run batch file
			ShellLaunch bat ""
		)
		catch(print "Could not find 'Install_XmlGenerator.bat' file")			
	)
	

)

		
Try(cui.UnregisterDialogBar flowProjectHelper)catch()
try(destroydialog flowProjectHelper)catch()

Rollout flowProjectHelper "Project Helper"
(
		
	local newArr = #()
	local levels = #()
	local newLevels = #()
	local cleanArr = #()
	local clean_fold_arr = #()
	local clean_sfol_array = #()
	local subsfol_array = #()
	local refObjs = #()
		
	local areatag = #("_Art", "_Design", "_Inst", "_Vehicle", "_Test")
		
	bitmap bitmapBannerUi 						width:335 height:64 fileName:bitmapBannerFile align:#center gamma:1.0
		
		
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
		radiobuttons rad_are_type ""			labels:#("_Art", "_Design", "_Isnt", "_Vehicle", "_Test")
		button btn_crt_cat "New Category"		width:80	height:24 							across:4
		button btn_crt_scn "New Level"			width:75	height:24	
		button btn_crt_are "New Area"			width:75	height:24
		button btn_crt_prp "New Prop"			width:75	height:24
	)
		
	Group "Directory Viewer"
	(		
		dropdownList ddl_folder "Categories" 						across:2
		dropdownList ddl_subfol "Levels" 			
		button btn_opn_cat "Open"			width:155	height:15	across:2	
		button btn_opn_lvl "Open"			width:155	height:15
		listbox lst_areas "Areas List"	
		
	)
		
	Group "Filter Viewer"
	(
		checkbutton chk_art "_Art" 			width:75	height:24	across:4
		checkbutton chk_dsn "_Design"		width:75	height:24
		checkbutton chk_inst "_Inst"		width:75	height:24
		checkbutton chk_veh "_Vehicle"		width:75	height:24
		
	)
		
	Group "XRef Scenes"
	(
		button btn_lod_ava "XRef Avatar Scene"						across:2
		button btn_lod_met "XRef Metrics Scene"
		
		
		dropdownList ddl_refs ""	 			width:200 across:6
		label lbl_space ""
		label lbl_space2 ""
		label lbl_space3 ""
		button btn_rmv_ref "Remove"				align:#right 
		button btn_upd_ref "Update"				--align:#right
	)
		
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
			
	local filsList = #(chk_art.checked, chk_dsn.checked, chk_inst.checked, chk_veh.checked)
		
			
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
			
		for i = 1 to levels.count do 
		(
			
			print (filenameFromPath levels[i])
			if filenameFromPath levels[i] == "scenes.max" then
			(
				deleteItem levels i 
			)
		)
		
		
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
		
	--Load Flow Panels Data
		
	--sets the Settings to be saved
	fn SetLauncherData val intgr = 
	(
		launcherData[intgr] = val
	)	
		
	--Update XRef lists 
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
	
	on rad_are_type changed state do 
	(
		print areatag[rad_are_type.state]
	)
		
		
	on tick_LauncherUpdate tick do 
	(
		filsList = #(chk_art.state, chk_dsn.state, chk_inst.state, chk_veh.state)
		--update status 
		--UpdateToolsetStatus()		
		
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
		if i != 0 then 
		(
			print lst_areas.items[i]
			print levels
			print i
		)
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
		
	on ddl_subfol selected i do
	(
			
		--get Project levels and filter types 
		GetProjectLevels()
			
		--set array
		SetLauncherData i 3
		
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
			
	)
		
	on ddl_folder selected i do 
	(
		--reset drop down list
		ddl_subfol.selection = 1 
			
		--Reload sub folders list
		GetProjectLevels()
			
		--set array
		SetLauncherData i 2
			
		--set array
		SetLauncherData ddl_subfol.selection 3
		
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
		
		
	)
		
	--create new category 
	on btn_crt_cat pressed do 
	(
		areaname = edt_dir_name.text		
		
		makeDir (strMyFolder+ "scenes\Areas\\" + areaname as string)
		
		areaname = edt_dir_name.text			
		
		makeDir (strMyFolder+ "scenes\Areas\\" + areaname as string)
			
			
		--Reload Projects List
		ReloadProjectList()
			
		--get Project levels and filter types 
		GetProjectLevels()
			
			
	)
		
	--create new level
	on btn_crt_scn pressed do 
	(
		--create new level directory
		areaname = edt_dir_name.text + "_Main" 
		makeDir (strMyFolder + "scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + areaname as string)
		
		--Reload Projects List
		ReloadProjectList()
			
		--get Project levels and filter types 
		GetProjectLevels()
		
		
	)
		
	--create new area 
	on btn_crt_are pressed do 
	(
		
		case rad_are_type.state of 
		(
			default:
			(					
				print rad_are_type.state
					
				--create 'type' folder
				dirname = (clean_sfol_array[ddl_subfol.selection] + "\\models\\" + areatag[rad_are_type.state] as string)
				makeDir (strMyFolder+ "scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + dirname as string)
				
			)
		)
			
		--create 
		areaname = (edt_dir_name.text + areatag[rad_are_type.state] as string + ddl_area_suf.items[ddl_area_suf.selection] as string)
		loc = (strMyFolder + "scenes\\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + clean_sfol_array[ddl_subfol.selection] + "\\" + "models\\" + areatag[rad_are_type.state] + "\\" + areaname as string + ".max") 
			
			print areaname
		print loc
				
		if selection.count > 0 then 
		(
			saveNodes selection[1] loc --quiet:true
		)
		else 
		(
			print "Nothing is Selected"
		)
			
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
	
	
	--level filter - art 
	on chk_art changed state do 
	(
		GetProjectLevels()
			
		filsList[1] = state
			
		--set array
		SetLauncherData filsList[1] 4
			
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
	)
		
		
	--level filter - design 
	on chk_dsn changed state do 
	(
		GetProjectLevels()
			
		filsList[2] = state
			
		--set array
		SetLauncherData filsList[2] 5	
			
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
	)
		
	--level filter - inst 
	on chk_inst changed state do 
	(
		GetProjectLevels()
			
		filsList[3] = state
			
		--set array
		SetLauncherData filsList[3] 6
			
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
	)
		
	--level filter - veh 
	on chk_veh changed state do 
	(
		GetProjectLevels()
			
		filsList[4] = state
			
		--set array
		SetLauncherData filsList[4] 7
			
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
	)
		
		
	--project name selected 
	on ddl_proj selected i do 
	(
		--get Project levels and filter types 
		GetProjectLevels()
		
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
		
	)
	
	
	on btn_lod_ava pressed do 
	(
		--temp load maxstart.max scene -- create a custom metrics scene 
		try
		(
			refObjs = #()
			Xrefobjs = getMAXFileObjectNames (getdir #scene + "\\maxstart.max")
			
			Xrefobjs = xrefs.addNewXRefFile  (getdir #scene + "\\maxstart.max") modifiers:#xref manipulators:#xref dupMtlNameAction:#useXRefed 
			
			--Xrefobjs.showFrozenInGray = false
			--freeze Xrefobjs
			--Xrefobjs.wirecolor = [88, 144, 225]
				
			append refObjs (filenameFromPath Xrefobjs.filename)
			
			ddl_refs.items = refObjs
					
		)
		catch()
		
		
		
	)
		
	on btn_lod_met pressed do 
	(
		--temp load maxstart.max scene -- create a custom metrics scene 
		try
		(
			refObjs = #()
			Xrefobjs = getMAXFileObjectNames (getdir #scene + "\\texel.max")
			
			Xrefobjs = xrefs.addNewXRefFile  (getdir #scene + "\\texel.max") modifiers:#xref manipulators:#xref dupMtlNameAction:#useXRefed 
			
			--Xrefobjs.showFrozenInGray = false
			--freeze Xrefobjs
			--Xrefobjs.wirecolor = [88, 144, 225]
				
			append refObjs (filenameFromPath Xrefobjs.filename)
			
			ddl_refs.items = refObjs
					
		)
		catch()
		
		
		
	)
	
	--------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------
		
	on flowProjectHelper open do 
	(
			
		chk_art.state = launcherdata[4]
		chk_dsn.state = launcherdata[5]
		chk_inst.state = launcherdata[6]
		chk_veh.state = launcherdata[7]
		
		callbacks.addScript #filePostOpenProcess  "flowProjectHelper.UpdateXrefsList()" id:#MXSHelp
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
			
		--set Xref Scences list
		ddl_refs.items = arr
			
			
		--Reload Projects List
		ReloadProjectList()
			
		--sets level selection for subfolder load
		ddl_proj.selected = ddl_proj.items[1]
			
		--get Project levels and filter types 
		GetProjectLevels()
			
		--set selection 
		ddl_subfol.selection = launcherData[3]
		--set selection 
		ddl_folder.selection = launcherData[2]		
			
		--get Project levels and filter types 
		GetProjectLevels()
		if mainFPFolder != undefined then
		(
			if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
			(
					
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
			
	)
			
	on flowProjectHelper resized theSize do
	(
		--edt.width 	= theSize.x
		--edt.height 	= theSize.y
		
	)
	
	on flowProjectHelper close do 
	(
		callbacks.removeScripts id:#MXSHelp
		
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
	)

)	



CreateDialog flowProjectHelper	menu:LauncherSettingsMenu width:340 height:650 
	
cui.registerDialogBar	flowProjectHelper	style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #style_resizing, #style_toolwindow) lockHeight:false lockWidth:false autoLayoutOnResize:true
