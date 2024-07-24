		
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------	
	
Try(cui.UnregisterDialogBar flowProjectHelper)catch()
try(destroydialog flowProjectHelper)catch()

global imgfolder =  (toolFolder + "\\FlowPanels\\_images\\") --getfilenamepath str	
global curProjectFolder = ""
global curCategoryFolder = ""
global curLevelFolder = ""
--Set Tool Image file
bitmapBannerFile = (imgfolder + "banner.jpg")
		
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------	

	
Rollout flowProjectHelper "Project Manager"  
(
		
	local newArr = #()
	local levels = #()
	local newLevels = #()
	local cleanArr = #()
	local clean_fold_arr = #()
	local clean_sfol_array = #()
	local subsfol_array = #()
	local refObjs = #()
		
	local areatag = #("_Art", "_Design", "_Inst", "_Prop", "_Vehicle", "_Weapon", "_Test", "")
	local areasuf = #("no_tag","_000", "_050", "_100","_150", "_200","_250", "_300","_350", "_400","_450", "_500","_550", "_600","_650", "_700","_750", "_800","_850", "_900","_950", "_Uni")
	local arealab = #("_Art", "_Design", "_Inst", "_Prop", "_Vehicle", "_Weapon", "_Test", "null")
	--create an empty select level
	local selLevel = 1
	--create an empty select category				
	local selCat = 1
	bitmap bitmapBannerUi 						width:340 height:68 fileName:bitmapBannerFile align:#center gamma:1.0 
		
		
	--subRollout sub_roll_a "" 
		
	Group "Current Project"
	(
		dropdownlist ddl_proj "" 				items:#()
		
	)
	Group "Project Helper"
	(
		edittext edt_proj_nam "Name:"			width:280						across:2
		colorpicker clr_prj_clr ""				align:#right
		button btn_crt "Create"					width:65	height:24	across:5
		button btn_open "Open"					width:65	height:24
		button btn_edit	"Refresh"				width:65	height:24
		button btn_dele	"Delete"				width:65	height:24
		button btn_swtc	"Switch"				width:65	height:24
	)
		
	Group "Directory Helper"
	(	
		checkbutton chk_sel_nam "Auto-Name"		width:65					align:#left			across:3
		edittext edt_dir_name ""				width:180 	height:20		align:#center
		dropdownList ddl_area_suf ""			width:62	height:20		items:areasuf				align:#right	
		label lbl_blank_01 "Asset Type:"		align:#left
		button btn_crt_cat "+ Category"			width:70	height:24 		offset:[2,0]		across:6
		button btn_crt_scn "+ Level"			width:45	height:24		offset:[7,0]
		button btn_crt_are "+ Area"				width:50	height:24		offset:[1,0]
		button btn_crt_prp "+ Prop"				width:45	height:24		offset:[-5,0]
		button btn_crt_veh "+ Vehicle"			width:60	height:24		offset:[-5,0]
		button btn_crt_wea "+ Weapon"			width:60	height:24		offset:[6,0]		
		label lbl_blank_02 "Asset Label:"		align:#left
		radiobuttons rad_are_type ""			default:8 	height:24		labels:arealab		columns:4 row:2 	offset:[5,0]
		label lbl_blank_03 ""					width:20 	height:5
	)
		
	Group "Directory Viewer"
	(		
		dropdownList ddl_folder "Categories" 						across:2
		dropdownList ddl_subfol "Levels" 			
		button btn_opn_cat "Open Categories"			width:125	height:15	offset:[15,0]	across:4	
		button btn_cat_del "Del"						width:25	height:15	offset:[25,0]
		button btn_opn_lvl "Open Level"					width:125	height:15	offset:[30,0]
		button btn_lvl_del "Del"						width:25	height:15	offset:[25,0]
		listbox lst_areas "Areas List - "	
		button btn_iso_lvl "Isolate Selected"	width:100	height:25	offset:[-30,0] across:2
		button btn_new_win "Delete Selected"	width:100	height:25	offset:[-80,0]
	)
		
	Group "Viewer Filters"
	(
		checkbutton chk_art "_Art" 			width:58	height:24	across:6
		checkbutton chk_dsn "_Design"		width:58	height:24
		checkbutton chk_inst "_Inst"		width:58 	height:24
		checkbutton chk_prop "_Prop"		width:58	height:24
		checkbutton chk_veh "_Vehicle"		width:58	height:24
		checkbutton chk_wea "_Weapon"		width:58	height:24	offset:[5,0]
	)
		
	Group "Reference Assets"
	(
		button btn_lod_pref "Open Pure Ref"						align:#left				across:3
		button btn_lod_pint "Open Pinterest Board"
		button btn_lod_ "Open " 
	)
	Group "XRef Scenes"
	(
		
		button btn_lod_ava "Avatar XRef"			width:100			across:3		
		button btn_lod_met "Metrics XRef"			width:100
		checkbutton chk_asObj "Import as Object"		width:100
			
		dropdownList ddl_refs ""	 			width:200 across:6
		label lbl_space ""
		label lbl_space2 ""
		label lbl_space3 ""
		button btn_rmv_ref "Remove"				align:#right 
		button btn_upd_ref "Update"				--align:#right
	)
		
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
			
	local filsList = #(chk_art.checked, chk_dsn.checked, chk_inst.checked, chk_prop.checked, chk_veh.checked, chk_wea.checked)
		
			
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
		
	--Toggle Reference Buttons
	fn ToggleRefButtons toggle = 
	(
		btn_lod_pref.enabled = toggle 
		btn_lod_pint.enabled = toggle 
		
	)	
		
	--toggle 'Open Level's DIrectory' Button 
	fn OpenLevelDirectory toggle = 
	(
		btn_opn_lvl.enabled = toggle
	)
		
	
	--update load pref buttons 
	fn CheckIfReferenceExists = 
	(
		pureRefLocation = pinterestLocation = ""
		
		if subsfol_array.count > 0 and ddl_folder.selection != 1 then 
		(			
			pureRefLocation = (subsfol_array[1] as string  + "pref\\_Ref.pur") 
			pinterestLocation = (subsfol_array[1] as string + "pref\\_Pinterest.url")
				
			if (doesFileExist pureRefLocation) then  
			(
				ToggleRefButtons true
					
-- 				print subsfol_array[1] as string
			)
			else
			(
				ToggleRefButtons false
-- 				print "Error - PureRef file was not found"
			)				
				
			if (doesFileExist pinterestLocation) then  
			(
				ToggleRefButtons true
					
-- 				print subsfol_array[1] as string
			)
			else
			(
				ToggleRefButtons false
					
-- 				print "Error - Pinterest Board file was not found"
			)	
					
		)
		else
		(
			pureRefLocation = pinterestLocation = ""
			ToggleRefButtons false
				
		)	
		
	)
		
	--Reload sub folders list
	fn GetProjectLevels = 
	(
			
		curProjectFolder =  getFilenamePath ddl_proj.items[ddl_proj.selection]
			
		levels = getFiles((curProjectFolder as string + "\\*.max"))
			
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
		dir_array = GetDirectories (curProjectFolder +"\scenes\Areas\\*")
			
		for d in dir_array do
		(
			join dir_array (GetDirectories (d+"\\*"))
			
		)
			
		--pass the sub folders to drop downlist 
		folders_array = GetDirectories (curProjectFolder +"\scenes\Areas\\*")
			
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
					
				--toggle dir button 
				OpenLevelDirectory false
				
			)
			
		)			
		else if ddl_folder.selection != 0 then 
		(
			
			--toggle state 
			ddl_subfol.enabled = true
				
			--toggle dir button 
			OpenLevelDirectory true
				
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
				folders_array = (GetDirectories (curProjectFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string))
					
				subsfol_array = (GetDirectories (curProjectFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string+"\\*"))
					
				for t in subsfol_array do 
				(
					join subsfol_array (GetDirectories (t+"\\"))
					
				)
					
				--create new sub folder array 
				--clean_sfol_array[1] = "All Levels"
					
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
			else(
				
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
				folders_array = (GetDirectories (curProjectFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string))
					
				subsfol_array = (GetDirectories (curProjectFolder + "\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string+"\*" ))
					
				for t in subsfol_array do 
				(
					join subsfol_array (GetDirectories (t+"\\"))
					
				)
					
				for o in subsfol_array do 
				(
					--filter level name
					str = filenameFromPath o
					--remove slashes -- it errors out otherwise
					str = substituteString str "\\" "" 
						
					--adding to new array
					appendIfUnique clean_sfol_array str as string 
				)
				
				if clean_sfol_array.count >= 1 then 
				(
					
					--pass sub folder names to the list 
					ddl_subfol.items = clean_sfol_array
					
					subsfol_array = (GetDirectories (curProjectFolder + "\\scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] as string + "\\" + clean_sfol_array[ddl_subfol.selection] as string))
					
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
				else( )
			)					
		)
		else
		(
			ddl_subfol.items = #("Levels List")
			ddl_subfol.selection = 1
			ddl_subfol.enabled = false
				
			--toggle dir button 
			OpenLevelDirectory false
			
		)
			
		for i in newLevels do 
		(	
			
			if not chk_art.checked and not chk_dsn.checked and not chk_inst.checked and not chk_prop.checked and not chk_veh.checked and not chk_wea.checked then 
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
			if chk_prop.checked then
			(						
				LevelFilter cleanArr newLevels "*_prop*"
			)	
			if chk_veh.checked then
			(						
				LevelFilter cleanArr newLevels "*_vehicle*"
			)		
			if chk_wea.checked then
			(						
				LevelFilter cleanArr newLevels "*_weapon*"
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
	fn XMLDataLoader = 
	(
		
	)
		
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
			ddl_refs.items = arr
		)
		else(
			arr = #("No Scenes Found")
			ddl_refs.items = arr
		)	
		
	)	
		
	
	
	fn CreateAssetDirectory newloc = 
	(				
		--create prop directory 
			
		makeDir (newloc + "\\_pref"  as string)
		makeDir (newloc + "\\models\\_max"  as string)
		makeDir (newloc + "\\models\\_painter"  as string)
-- 			makeDir (newloc + "\\models\\_painter\\high"  as string)
-- 			makeDir (newloc + "\\models\\_painter\\low"  as string)
		makeDir (newloc + "\\models\\_zbrush"  as string) 
		makeDir (newloc + "\\models"  as string)
		makeDir (newloc + "\\textures"  as string)	
		makeDir (newloc + "\\textures\\_painter"  as string)
		makeDir (newloc + "\\textures\\_designer"  as string)
		
		
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
		--filters list
		filsList = #(chk_art.state, chk_dsn.state, chk_inst.state, chk_prop.state, chk_veh.state, chk_wea.state)
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
		
	--remove XRef
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
		
	--update XRef
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
			
			--print lst_areas.items[i]
			--print levels
			--print i
		)
	)
		
		
	--Areas List -- when double clicked 
	on lst_areas doubleClicked i do 
	(
		loadMaxFile levels[i] useFileUnits:true quietmode:true
		--launch new max window 
		--print (levels[i] as string)  
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
	
	--Areas List - Buttons -------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------
		
	--new button tests 
	on btn_new_win pressed do 
	(
		if (querybox "Are you sure you want to Delete this {Area}?" beep:false) then 
		(		
			if ( querybox "Are you 100% you want to Delete this {Area}?" beep:false) then 			
			(
				try 
				(
						
					str = substituteString levels[lst_areas.selection] "\\" "\\\\"
					print str 
					deleteFile (str)
						
					--get Project levels and filter types 
					GetProjectLevels()
						
				)
				catch (messageBox "Unable to Delete, Folder is open or in use in another App")
			)
		)
		else()
	)
		--new button tests 
	on btn_iso_lvl pressed do 
	(	
		
		--filter string array 
		if levels.count != 0 do 
		(
		
-- 	 		print maxFileName
-- 			print levels[lst_areas.selection]
			if (lst_areas.selection >= 1) then
			(
				str = FilterString levels[lst_areas.selection] "\\" 
			)
			else 
			(
				str = #()
			)
-- 			for i = 1 to str.count do 
-- 			(
-- 				print (i as string + " - " + str[i])as string 
-- 			)
			
			--print ddl_folder.selected 
			
			if (ddl_folder.selected as string) != "Show All" then 
			(
				
-- 		 		for i =1 to str.count do 
-- 		 		(
-- 		 			print (i as string + " - " + str[i]) as string
-- 		 		)
				
-- 		 		print clean_sfol_array.count
				
				for i = 1 to clean_sfol_array.count where MatchPattern clean_sfol_array[i] pattern:str[10] do 
				(
-- 		 			print i 
					selLevel = i
				)
				--set subfolders list to selected area's Level
				ddl_subfol.selection = selLevel
				GetProjectLevels()
					
			)
			else if (ddl_folder.selected as string) == "Show All" then 
			(
				
				--print str[9]
				
				for i = 1 to clean_fold_arr.count where MatchPattern (clean_fold_arr[i]as string)  pattern:str[9] do 
				(
 		 			--print clean_fold_arr[i] as string 
					--print i
					selCat = i
				)
-- 					
				for i = 1 to clean_sfol_array.count where MatchPattern (clean_sfol_array[i]as string) pattern:str[10] do 
				(
					--print (clean_sfol_array[i]as string)
		 			--print i 
					selLevel = i
				)
					
-- 				--set subfolders list to selected area's Level
-- 				ddl_folder.enabled = true 
-- 				OpenLevelDirectory true
				ddl_folder.selection = selCat
				ddl_subfol.selection = selLevel
-- 					 				
				GetProjectLevels()
					
			)
				
		--set array
		SetLauncherData ddl_folder.selection 2
			
		--set array
		SetLauncherData ddl_subfol.selection 3
		
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
			
				
		)
	)
		
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
	-- UI COMMANDS -- DROPDOWNLISTS
		
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
	--project name selected 
	on ddl_proj selected i do 
	(
		subsfol_array = #()
		ddl_subfol.items = #()
			
		--get Project levels and filter types 
		GetProjectLevels()
			
		--reload pref button status 
		CheckIfReferenceExists()
		--reset drop down list
		ddl_folder.selection = 1
			
		--set array
		curProjectFolder = substituteString curProjectFolder "\\" "/"
		print curProjectFolder	
		
		--save launcher data 
		SetLauncherData curProjectFolder 10
		SetLauncherData ddl_proj.selection 11
			
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
		
	)
		
	--sub-folders list 
	on ddl_subfol selected i do
	(
			
		--get Project levels and filter types 
		GetProjectLevels()
			
		--reload pref button status 
		CheckIfReferenceExists()
			
		--set array
		SetLauncherData i 3
		
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
			
	)
		
	--folders list 
	on ddl_folder selected i do 
	(
		
		--reset drop down list
		ddl_subfol.selection = 1 
			
		--Reload sub folders list
		GetProjectLevels()
			
		--reload pref button status 
		CheckIfReferenceExists()
			
		--set array
		SetLauncherData i 2
			
		--set array
		SetLauncherData ddl_subfol.selection 3
		
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
		
	)
		
	
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
	-- UI COMMANDS -- BUTTONS
		
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
		
		
	-------------------------------------------------------------------------------------------------------------Directory Helper ----
	----------------------------------------------------------------------------------------------------------------------------------
		
	--create new category 
	on btn_crt_cat pressed do 
	(
		areaname = edt_dir_name.text		
		
		makeDir (curProjectFolder+ "scenes\Areas\\" + areaname as string)
		
		areaname = edt_dir_name.text			
		catDir = curProjectFolder+ "scenes\Areas\\" + areaname as string 
		
		makeDir (catDir)
			
		--create prop directory 
		makeDir (catDir + ("\\All " + areaname ) as string)
			
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
				--print rad_are_type.state
					
				--create 'type' folder
				dirname = (clean_sfol_array[ddl_subfol.selection] + "\\models\\" + areatag[rad_are_type.state] as string)
				makeDir (curProjectFolder+ "scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + dirname as string)
				
			)
		)
			
		--create and Label
		tagname = ""
		if (ddl_area_suf.selection != 1) then 
		(
			tagname = ddl_area_suf.items[ddl_area_suf.selection] as string
		)
			
		areaname = (edt_dir_name.text + areatag[rad_are_type.state] as string + tagname as string )
		loc = (curProjectFolder + "scenes\\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + clean_sfol_array[ddl_subfol.selection] + "\\" + "models\\" + areatag[rad_are_type.state] + "\\" + areaname as string + ".max") 
			
			--print areaname
		--print loc
				
		if selection.count > 0 then 
		(
			saveNodes selection loc --quiet:true
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
		
	--create new level
	on btn_crt_scn pressed do 
	(
		--create new level directory
		areaname = edt_dir_name.text
		makeDir (curProjectFolder + "scenes\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + areaname as string)
			
		--Reload Projects List
		ReloadProjectList()
			
		--get Project levels and filter types 
		GetProjectLevels()
			
	)
		
	--create new prop asset
	on btn_crt_prp pressed do 
	(	
		--Check and create Prop directory
		if ddl_folder.items[ddl_folder.selection] != "Prop" then 
		(
			messageBox "Can't Save Props into this Folder! Please select the { Props } - [ Category ]."
		)
		else if ddl_subfol.selection == 1 then 
		(
			messageBox "Please select the correct - [ Sub-Category // Level ]."
		)			
		else
		(
				
			--create and Label
			tagname = ""
			if (ddl_area_suf.selection != 1) then 
			(
				tagname = ddl_area_suf.items[ddl_area_suf.selection] as string
			)
				
			areaname = (edt_dir_name.text)
				
			newloc = (curProjectFolder + "scenes\\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + clean_sfol_array[ddl_subfol.selection] + "\\" + areaname as string) 
				
			areaname = (edt_dir_name.text + areatag[rad_are_type.state] as string + tagname as string )
				
			--create asset directory 
			CreateAssetDirectory newloc
				
			--save file 
			loc = (newloc + "\\models\\_max" + "\\" + areaname as string + ".max") 
				
				
			if selection.count > 0 then 
			(
				saveNodes selection loc --quiet:true
			)
			else 
			(
				print "Nothing is Selected"
			)
				
			--get Project levels and filter types 
			GetProjectLevels()
				
		)
	)		
		
	on btn_crt_veh pressed do  
	(
		
		--Check and create Prop directory
		if ddl_folder.items[ddl_folder.selection] != "Vehicle" then 
		(
			messageBox "Can't Save Props into this Folder! Please select the { Vehicle } - [ Category ]."
		)
		else if ddl_subfol.selection == 1 then 
		(
			messageBox "Please select the correct - [ Sub-Category // Level ]."
		)			
		else
		(
			--create and Label
			tagname = ""
			if (ddl_area_suf.selection != 1) then 
			(
				tagname = ddl_area_suf.items[ddl_area_suf.selection] as string
			)
				
			areaname = (edt_dir_name.text)
				
			newloc = (curProjectFolder + "scenes\\Areas\\" + clean_fold_arr[ddl_folder.selection] + "\\" + clean_sfol_array[ddl_subfol.selection] + "\\" + areaname as string) 
				
			areaname = (edt_dir_name.text + areatag[rad_are_type.state] as string + tagname as string )
				
			--create asset directory 
			CreateAssetDirectory newloc
				
			--save file 
			loc = (newloc + "\\models\\_max" + "\\" + areaname as string + ".max") 
				
				
			if selection.count > 0 then 
			(
				saveNodes selection loc --quiet:true
			)
			else 
			(
				print "Nothing is Selected"
			)
				
			--get Project levels and filter types 
			GetProjectLevels()	
		)
		
	)
		
	--open level's directory in windows 
	on btn_opn_lvl pressed do 
	(
		print subsfol_array as string 
		ShellLaunch "explorer.exe" (subsfol_array[1] as string ) 		
	) 
		
	--open category's directory in windows 
	on btn_opn_cat pressed do 
	(
		--Get the category's directory 
		catDir = ""
		dirname = (clean_fold_arr[ddl_folder.selection] as string)		
		if ddl_folder.selection == 1 then 
		(
			catDir = (GetDirectories (curProjectFolder + "\\scenes\\Areas"))
		)
		else
		(
			catDir = (GetDirectories (curProjectFolder + "\\scenes\\Areas\\" + dirname))
		)
		print (catDir) 
			
		ShellLaunch "explorer.exe" (catDir[1] as string ) 
			
			
	) 
		
	--delete selected category 
	on btn_cat_del pressed do 
	(
		
		if ddl_folder.selection == 1 then 
		(
			return false 
		)
		else
		(
			if (querybox "Are you sure you want to Delete this {Category}?" beep:false) then 
			(		
				if ( querybox "Are you 100% you want to Delete this {Category}?" beep:false) then 			
				(
					try 
					(
						delDir = dotNetClass "system.IO.directory"
						dirname = (clean_fold_arr[ddl_folder.selection] as string)		
						dirSel = (curProjectFolder + "\scenes\Areas\\" + dirname)  
						
						delDir.delete (dirSel) true
							
						--get Project levels and filter types 
						GetProjectLevels()
							
						ddl_folder.selection = 1
					)
					catch (messageBox "Unable to Delete, Folder is open or in use in another App")
				)
			)
			else()
			
		)
	)
	
	
	
	-----------------------------------------------------------------------------------------------------------Project Dir Helper ----
	----------------------------------------------------------------------------------------------------------------------------------
	
	
	--Create New Project Button 
	on btn_crt pressed do 
	(	
		--folder = getSavePath  caption:"Set Project Directory" filename:(GetDir #scripts)
		--project directory 
		--check if projet name is empty 
		if (edt_proj_nam.text == "") then 
		(
			Messagebox "Invalid Name - Please type something."
			
		)
		else
		(
			if (folder = getSavePath  caption:"Set Project Directory" filename:(GetDir #scripts)) != undefined  then 
			(
					
				--New Directory 
				newDir = "Prj_" + edt_proj_nam.text 
				
				--filter string name here 
				--take out spaces and replace them for _ 
				
				folder = (folder + "\\" + newDir as string)
					
				--macros.run "Tools" "CreateDefaultProject" 
				pathConfig.doProjectSetupStepsUsingDirectory folder 
				pathConfig.setCurrentProjectFolder folder
					
				--create the Areas Folder Structure
				makeDir (folder + "\\scenes\\Areas\\All" )
				makeDir (folder + "\\scenes\\Areas\\Characters" )
				makeDir (folder + "\\scenes\\Areas\\Characters\\All Characters" )
				makeDir (folder + "\\scenes\\Areas\\Exteriors" )
				makeDir (folder + "\\scenes\\Areas\\Exteriors\\All Exteriors" )
				makeDir (folder + "\\scenes\\Areas\\Interiors" )
				makeDir (folder + "\\scenes\\Areas\\Interiors\\All Interiors" )
				makeDir (folder + "\\scenes\\Areas\\Props" )
				makeDir (folder + "\\scenes\\Areas\\Props\\All Props" )
				makeDir (folder + "\\scenes\\Areas\\Vehicles" )
				makeDir (folder + "\\scenes\\Areas\\Vehicles\\All Vehicles" )
				makeDir (folder + "\\scenes\\Areas\\Weapons" )
				makeDir (folder + "\\scenes\\Areas\\Weapons\\All Weapons" )
				makeDir (folder + "\\scenes\\Areas\\zTestGrounds" )
				makeDir (folder + "\\scenes\\Areas\\zTestGrounds\\All Test Grounds" )
					
				--create new max start file and load it 
				loc = (folder + "\\scenes\\" + "maxstart.max") as string 
					
				if selection.count > 0 then 
				(
					saveNodes selection loc --quiet:true
				)
				else 
				(
					print "Nothing is Selected"
				)
					
			)
			else (print "No Project was Created. ")
			--clear 
			 edt_proj_nam.text = ""
				
			--Reload Projects List
			ReloadProjectList()
				
-- 				
-- 			--select new Project 
-- 			ddl_proj.selected = folder
-- 				
-- 			--save launcher data 
-- 			SetLauncherData folder 10
-- 			SetLauncherData ddl_proj.selection 11
				
		)				
			
	)
		
	--Open Project Button 
	on btn_open pressed do 
	(
		ShellLaunch curProjectFolder "explorer.exe"
		
	)
		
	--Delete Directory 
	on btn_dele pressed do 
	(
			
		if (querybox "Are you sure you want to Delete this Project?" beep:false) then 
		(		
			if ( querybox "Are you 100% you want to Delete this Project?" beep:false) then 			
			(
				delDir = dotNetClass "system.IO.directory"
				if delDir.exists(curProjectFolder) then 
				(							
					--release path 
					pth = curProjectFolder
								
					--reload // reset List
					ddl_proj.selection = 1
						
					try 
					(
						delDir.delete (pth) true
					)
					catch (messageBox "Unable to Delete, Folder is open or in use in another App")
						
					--reload // reset List
					ddl_proj.selection = 1	
					
					--set array
					curProjectFolder = substituteString curProjectFolder "\\" "/"
					print curProjectFolder	
						
					--save launcher data 
					SetLauncherData curProjectFolder 10
					SetLauncherData ddl_proj.selection 11
						
					--reload List
					ReloadProjectList()
				)
			)
		)
		else()
	)
		
	--refrsh list 
	on btn_edit pressed do 
	(
		--Reload Projects List
		ReloadProjectList()
	)
		
	--Switch Project  
	on btn_swtc pressed do 
	(
		--pathconfig.SaveTo(curProjectFolder)
			
		pathconfig.setCurrentProjectFolder curProjectFolder
		resetMaxFile() 
			
		--pathConfig.doProjectSetupStepsUsingDirectory curProjectFolder  
			
-- 			doesFolderExist = doesFileExist curProjectFolder allowDirectory:true
-- 			if(doesFolderExist and pathconfig.IsProjectFolder(curProjectFolder)) then 
-- 			(
-- 				-----------------------------------------------
-- 				-- backup the current config paths settings in the current working folder 
-- 				-- to not lose possible modifications that might have been done
-- 				-- before switching the working folder
-- 				-----------------------------------------------
-- 				pathconfig.SaveTo(pathconfig.getCurrentProjectFolderPath())

-- 				pathconfig.setCurrentProjectFolder curProjectFolder
-- 				pathConfig.doProjectSetupStepsUsingDirectory curProjectFolder  
-- 				
-- 				resetMaxFile 
-- 					
-- 					
-- 				--arStrFnames = getfiles (curProjectFolder + "\\*.mxp")
-- 			)
		
-- 			if (curProjectFolder = getSavePath  caption:"Set Project Directory" filename:(GetDir #scripts)) != undefined then
-- 			(
-- 				macros.run "Tools" "SetProjectFolder" 
-- 				
-- 				print curProjectFolder
-- 				pathConfig.doProjectSetupStepsUsingDirectory curProjectFolder  
-- 				pathConfig.setCurrentProjectFolder curProjectFolder
-- 				resetMaxFile 
-- 				
-- 			)
			
	)
	
	----------------------------------------------------------------------------------------------------------------Level Filters ----
	----------------------------------------------------------------------------------------------------------------------------------
	
	
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
		
	--level filter - prop 
	on chk_prop changed state do 
	(
		lst_areas.items = #()
		GetProjectLevels()
			
		filsList[4] = state
			
		--set array
		SetLauncherData filsList[4] 7
			
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
	)	
		
	--level filter - vehi 
	on chk_veh changed state do 
	(
		GetProjectLevels()
			
		filsList[5] = state
			
		--set array
		SetLauncherData filsList[5] 8
			
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
	)
		
	--level filter - weapon
	on chk_wea changed state do 
	(
		GetProjectLevels()
			
		filsList[6] = state
			
		--set array
		SetLauncherData filsList[6] 9
			
		--save 'mainFPFolder' 
		SaveLauncherData toolFolder	
	)	
		
	--load pure ref - button
	on btn_lod_pref pressed do 
	(
		pureRefLocation = (subsfol_array[1] as string  + "pref\\_Ref.pur") 
			
		print ("PureRef Location = "	+ pureRefLocation as string)
		if (doesFileExist pureRefLocation) then  
		(
			print pureRefLocation as string 
			ShellLaunch pureRefLocation ""
		)
		else
		(
			
		)
				
	)
		
	--load pinterest board -- 
	on btn_lod_pint pressed do 
	(
		if subsfol_array.count > 1 then 
		(
			
			pinterestLocation = (subsfol_array[1] + "pref\\_Pinterest.url")
					
			if (doesFileExist pinterestLocation) then  
			(
				print pinterestLocation as string 
				ShellLaunch pinterestLocation ""
			)
			else
			(
				
				print "invalid"
			)
			
		)
	)
		
	--XRef Avatar - Load 	
	on btn_lod_ava pressed do 
	(
		--temp load maxstart.max scene -- create a custom metrics scene 
		try
		(
			refObjs = #()
			Xrefobjs = getMAXFileObjectNames (getdir #scene + "\\maxstart.max")
						
			if chk_asObj.checked then 
			(
				Xrefobjs = xrefs.addNewXRefObject (getdir #scene + "\\maxstart.max") Xrefobjs
			)
			else 
			(
				Xrefobjs = xrefs.addNewXRefFile  (getdir #scene + "\\maxstart.max") modifiers:#xref manipulators:#xref dupMtlNameAction:#useXRefed 
			)
			--Xrefobjs.showFrozenInGray = false
			--freeze Xrefobjs
			--Xrefobjs.wirecolor = [88, 144, 225]
				
			append refObjs (filenameFromPath Xrefobjs.filename)
			
			ddl_refs.items = refObjs
					
		)
		catch()
		
		
		
	)
		
	--load metrics scene
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
		
	---------------------------------------------------------------------------------------------------------------TOOL OPEN / CLOSE -----
	--------------------------------------------------------------------------------------------------------------------------------------
		
	--on toolset open 
	on flowProjectHelper open do 
	(
		
		--chk_art.state = launcherdata[4]
		--chk_dsn.state = launcherdata[5]
		--chk_inst.state = launcherdata[6]
		--chk_veh.state = launcherdata[7]
		
		callbacks.addScript #filePostOpenProcess  "flowProjectHelper.UpdateXrefsList()" id:#MXSHelp
		arr = #()
		
		count = xrefs.getXRefFileCount()
		print ("count = " + count as string )
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
			
		--load filters 
		chk_art.state 	= launcherData[4]
		chk_dsn.state 	= launcherData[5]
		chk_inst.state	= launcherData[6]
		chk_prop.state 	= launcherData[7]
		chk_veh.state 	= launcherData[8]
		chk_wea.state 	= launcherData[9]
			
		--set Xref Scences list
		ddl_refs.items = arr
			
		--Reload Projects List
		ReloadProjectList()
			
		--Reload PureRef and Pinterest resources
		CheckIfReferenceExists()	
			
		--sets level selection for subfolder load
		--ddl_proj.selected = launcherData[10] --ddl_proj.items[1]
		ddl_proj.selection = launcherData[11]
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
					
				--Reload Projects List
				ReloadProjectList()
					
				--Reload PureRef and Pinterest resources
				CheckIfReferenceExists()	
					
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


CreateDialog flowProjectHelper width:360 height:840 style:#(#style_titlebar,  #style_border, #style_sysmenu, #style_resizing, #style_minimizebox, #style_maximizebox, #style_sunkenedge) autoLayoutOnResize:true 
	
-- addRollout  flowProjectToolsRO fPH



-- cui.registerDialogBar	flowProjectHelper	style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #style_resizing, #style_toolwindow) lockHeight:false lockWidth:false autoLayoutOnResize:true
