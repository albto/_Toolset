		
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------	
	
Try(cui.UnregisterDialogBar flowProjectHelper)catch()
try(destroydialog flowProjectHelper)catch()

global imgfolder =  (toolFolder + "\\FlowPanels\\_images\\") --getfilenamepath str	
global scnTypeFolder = "\scenes\Areas\\"

global unityProjectLocations = #("D:\\Projects\\Project3D\\Assets\\Art\\Geometry") 

global curProjectFolder = ""
global curCategoryFolder = ""
global curLevelFolder = ""
--Set Tool Image file
bitmapBannerFile = (imgfolder + "banner.jpg")
		
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------	

-----------------------------------------------------------------------------------------------------------------------------------------
	
	
--load unity layers xml file
filein ((mainFPFolder + "\\FlowPanels\\_base\\XMLGenerator.ms") as String ) 
flowIns = flowCore()
flowIns.LoadXml()






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
	local editorMode = #("3DSMax Project", "Asset Creation", "Global Mode", "Unity Projekt")	
	local origSel = integer


		
	--subRollout sub_roll_a "" 
		
	Group "Project Manager Settings"
	(
		dropdownlist ddl_proj "" 							items:#()
		dropdownList	ddl_viewerMode 	""					width:135	height:15	items:editorMode	across:4 	selection:2
		checkbutton 	chk_geoExport	"Geom Folder"		checked:true offset:[55,0]
		checkbutton 	chk_aniExport	"Anim Folder"		offset:[48,0]
		button 			btn_projSync	"Sync"				align:#right
		label 			lbl_uniProNam 	""
	)
	--Group "Project Helper"
	--(
		edittext edt_proj_nam "Name:"			width:280						across:2
		colorpicker clr_prj_clr ""				align:#right
		button btn_crt "Create"					width:65	height:24	across:5
		button btn_open "Open"					width:65	height:24
		button btn_edit	"Refresh"				width:65	height:24
		button btn_dele	"Delete"				width:65	height:24
		button btn_swtc	"Switch"				width:65	height:24
	
		button 		btn_fndLP "Find w/ Attributes"	width:110	height:25	offset:[2,-35]		across:3
		pickbutton 	btn_pckLP "Select Lowpoly"	width:110	height:25	offset:[2,-35]
		pickbutton 	btn_pckHP "Select Highpoly"	width:110	height:25	offset:[2,-35]
		button 		btn_clrBake	"Clear Bake Setup"	width:110	height:25	offset:[-110,00]
	
		GroupBox 	grp_prjHlpr "Project Helper"	width:350	height:80	offset:[-8,-80]
		
	
	--)
		
	--Group "Directory Helper"
	--(	
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
		radiobuttons rad_are_type ""			default:8 	height:24		labels:arealab		columns:5 row:2 	offset:[5,0]
		label lbl_blank_03 ""					width:20 	height:5
	
			
	--)
		
	--Group "Directory Viewer"
	--(		
			
		dropdownList 	ddl_folder "Categories" 			offset:[0,20]											across:3
		dropdownList 	ddl_subfol "Sub-Categories" 		offset:[0,20]		
		dropdownList 	ddl_clafol "Classification"        offset:[0,20]	
		button 			btn_opn_cat "Open Categories"			width:125	height:15	offset:[15,0]	across:4	
		button 			btn_cat_del "Del"						width:25	height:15	offset:[25,0]
		button 			btn_opn_lvl "Open Sub-Categories"		width:125	height:15	offset:[30,0]
		button 			btn_lvl_del "Del"						width:25	height:15	offset:[25,0]
		listbox 		lst_areas "Content List - "	
		button 			btn_iso_lvl "Isolate Selected"			width:100	height:25	offset:[-30,0]	across:2
		button			btn_new_win "Delete Selected"			width:100	height:25	offset:[-80,0]
			
		edittext		edt_lowMesh "LP Mesh: "				text:"...select a LP Mesh..." 	width:240	height:20	pos:[12,290]	across:3	enabled:false
		button 			btn_updLP 	"Update"					width:50	height:20	pos:[252,290]
		checkbutton 	chk_mulLP 	"Multiple"				width:50	height:20	pos:[302,290]		tooltip:"Check ON, if Multiple Lowpoly Objects exist."
			
		edittext 		edt_higMesh "HP Mesh: "				text:"...select a HP Mesh..." 	width:240	height:20	pos:[12,320]	across:3	enabled:false
		button 			btn_updHP 	"Update"					width:50	height:20	pos:[252,320]
		checkbutton 	chk_mulHP 	"Multiple"				width:50	height:20	pos:[302,320]		tooltip:"Check ON, if Multiple Lowpoly Objects exist."
			
		dropdownList 	ddl_lpDest "LP Destination:"		items:#("Painter", "Designer", "Zbrush", "Unity")		across:3
		dropdownList 	ddl_hpDest "HP Destination:"		items:#("Painter", "Designer", "Zbrush", "Unity")
		checkbutton 	chk_sySend	"Sync Send"				pos:[240,363]								--checked:true
			
		button 			btn_lpSend "Send to"				width:112				pos:[12,385]						across:5	
		button 			btn_hpSend "Send to"				width:112				pos:[124,385]
		checkbutton 	chk_fbxFmat ".fbx"					pos:[240,385]
		checkbutton 	chk_abcFmat ".abc"					pos:[277,385]
		checkbutton 	chk_usdFmat ".usd"					pos:[315,385]
			
		GroupBox 		grp_dirView "Viewer"					width:350	height:280	offset:[-8,-270]	
			
			
		dropdownList ddl_surType	"Surface Type:"		width:110	height:25	offset:[2,30]	across:3	
			items:#("Opaque", "Transparent")
		dropdownList ddl_shaType	"Shader Type:"		width:110	height:25	offset:[4,30]		
			items:#("Lit", "Lit Tessellation", "Layered", "Layered Lit Tessellation", "Decal", "Hair", "Eye", "Fabric", "Terrain Lit", "Unlit", "Water")
		dropdownList ddl_matType	"Material Type:"	width:110	height:25	offset:[6,30]		
			items:#("Standard", "Anisotropy", "Translucent", "Iridescence", "Subsurface Scattering", "Specular Color")
		button btn_setMats	 "Set to Selected"			width:110	height:30	offset:[0,-2]		across:3
		button btn_selMat	 "Select Material"			width:110	height:30	offset:[4,-2]		
		button btn_edtMats	 "Convert Selected"			width:110	height:30	offset:[5,-2]	
			
		listbox lst_matElem "Materials List:"			items:#(":01::Material_Name::Opa::Lit:Standard", ":02::Material_Name::Opa::Decal:Standard")
			
		GroupBox grp_matSetr "Material Settings"		width:350	height:280	offset:[-8,-262]	
		
		
		dropdownList ddl_objType "Object Type:"			selection:1			items:TypeList		offset:[5, 20]		across:3
		dropdownList ddl_objAttr "Attribute:"			selection:2			items:AttrList		offset:[5, 20]
		dropdownList ddl_objLayr "Layer:"			selection:1			items:LayersList	offset:[5, 20]
		
		dropdownList ddl_objComp "Object Interact:"			selection:1			items:CompList		offset:[5, 00]
		
		
		
		
		
		
		
		
		
		
		
		GroupBox grp_attSetr "Attribute Settings"		width:350	height:150	offset:[-8, -110]	
			
	--)
		
	--Group "Viewer Filters"
	--(
		checkbutton chk_art "_Art" 			width:58	height:24	across:6		pos:[0,	600]			
		checkbutton chk_dsn "_Design"		width:58	height:24					pos:[58,600]		
		checkbutton chk_inst "_Inst"		width:58 	height:24					pos:[116,600]		
		checkbutton chk_prop "_Prop"		width:58	height:24					pos:[174,600]		
		checkbutton chk_veh "_Vehicle"		width:58	height:24					pos:[232,600]		
		checkbutton chk_wea "_Weapon"		width:58	height:24					pos:[290,600]		
	--)
		
	--Group "Reference Assets"
	--(
		button btn_lod_pref "Open Pure Ref"						pos:[0,	700]	align:#left				across:3
		button btn_lod_pint "Open Pinterest Board"
		button btn_lod_ "Open " 
	--)
	--Group "Scene XRefs"
	--(
		
		button btn_lod_ava "Avatar XRef"			width:100			across:3		
		button btn_lod_met "Metrics XRef"			width:100
		checkbutton chk_asObj "Import as Object"		width:100
			
		dropdownList ddl_refs ""	 			width:200 across:6
		label lbl_space ""
		label lbl_space2 ""
		label lbl_space3 ""
		button btn_rmv_ref "Remove"				align:#right 
		button btn_upd_ref "Update"				--align:#right
	--)
		
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
			
	local filsList = #(chk_art.checked, chk_dsn.checked, chk_inst.checked, chk_prop.checked, chk_veh.checked, chk_wea.checked)
		
			
	--TICK-----------------------------------------------------------------------
	-----------------------------------------------------------------------------
	timer tick_LauncherUpdate "" 			interval:200
		
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

		if ddl_viewerMode.selection == 1 then 
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
		)
		else(
				
			curProjectFolder =  (getFilenamePath scnTypeFolder)
				
			if chk_geoExport.checked then
			(
				scnTypeFolder = (curProjectFolder+"Geometry")
			)
			else if chk_aniExport.checked then 
			(
				scnTypeFolder = (curProjectFolder+"Animations")
			)
				
			print ("NOTES -- "+curProjectFolder as string)
				
				
			levels = getFiles((curProjectFolder as string + "\\*.fbx"))
				
		)
				
			
		newArr = #()
		newLevels = #()
		cleanArr = #()
			
		if ddl_viewerMode.selection == 1 then 
		(
			--create directories array 
			dir_array = GetDirectories (curProjectFolder as string + scnTypeFolder as string+"*") 
		)
		else(
			--create directories array 
			dir_array = GetDirectories (scnTypeFolder as string+"*")
			print ("DIR ARRAY ------- "+dir_array as string )
		)
		
		for d in dir_array do
		(
			join dir_array (GetDirectories (d+"\\*"))
			
		)
			
		if ddl_viewerMode.selection == 1 then 
		(
			--pass the sub folders to drop downlist 
			folders_array = GetDirectories (curProjectFolder as string + scnTypeFolder as string + "*")
		)
		else(
			--pass the sub folders to drop downlist 
			folders_array = GetDirectories (scnTypeFolder as string + "*")
		)
			
		--loop through categories and create the list 
		for i = 1 to folders_array.count do 
		(
			newArr[i] = filenameFromPath folders_array[i]
			--clean up Name 
			str = substituteString newArr[i] "\\" ""
			newArr[i] = str
			
		)		
					
		if ddl_viewerMode.selection == 1  then 
		(
			--clean string to display as folder//category 
			newArr[1] = "Show All"
		)
		else(
			newArr[1] = "Show All"
			newArr[2] = "Geometry"
		)
		
			
		ddl_folder.items = newArr
			
		--finds .mxp files and then filters out the sub-folder location 			
		--Folder filter
		if ddl_folder.selection == 1 then 
		(
			
			if ddl_viewerMode.selection == 1  then 
			(
				
				for f in dir_array do
				(
					join newLevels (getFiles (f+ "\\*.max"))
					ddl_subfol.items = #("Show All")
					ddl_subfol.selection = 1
					ddl_subfol.enabled = false
						
					--toggle dir button 
					OpenLevelDirectory false
					
				)
				
			)
			else 
			(
				for f in dir_array do
				(
					join newLevels (getFiles (f+ "\\*.fbx"))
					ddl_subfol.items = #("Show All")
					ddl_subfol.selection = 1
					ddl_subfol.enabled = False
						
					--toggle dir button 
					OpenLevelDirectory false
					
				)
			)
			
			
			
		)			
		else --if ddl_folder.selection != 1 then 
		(
			
			--toggle state 
			ddl_subfol.enabled = true
				
			--toggle dir button 
			OpenLevelDirectory true
				
			--create new folder array 
			clean_fold_arr = #()
				
			--create new sub folder array 
			clean_sfol_array = #("All")
				
				
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
					
				if ddl_viewerMode.selection == 1 then 
				(
					--Set Sub folders
					folders_array = (GetDirectories (curProjectFolder + scnTypeFolder + clean_fold_arr[ddl_folder.selection] as string))
						
					subsfol_array = (GetDirectories (curProjectFolder + scnTypeFolder + clean_fold_arr[ddl_folder.selection] as string+"\\*"))
						
				)
				else
				(
					--Set Sub folders
					folders_array = (GetDirectories (scnTypeFolder as string))
						
					print folders_array 
					subsfol_array = (GetDirectories (scnTypeFolder +"\\*"))
					print subsfol_array 	
				)
					
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
					if ddl_viewerMode.selection == 1 then 
					(
						join newLevels (getFiles (l+ "\\*.max"))
					)
					else(
						join newLevels (getFiles (l+ "\\*.fbx"))
					)
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
				
				if ddl_viewerMode.selection == 1 then 
				(
					--Set Sub folders
					folders_array = (GetDirectories (curProjectFolder + scnTypeFolder + clean_fold_arr[ddl_folder.selection] as string))
						
					subsfol_array = (GetDirectories (curProjectFolder + scnTypeFolder + clean_fold_arr[ddl_folder.selection] as string+"\\*"))
						
				)
				else
				(
					--Set Sub folders
					folders_array = (GetDirectories (scnTypeFolder))
						
					subsfol_array = (GetDirectories (scnTypeFolder +"\\*"))
						
					print folders_array 
					print subsfol_array 
				)

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
					
					if ddl_viewerMode.selection == 1 then 
					(
						subsfol_array = (GetDirectories (curProjectFolder + scnTypeFolder + clean_fold_arr[ddl_folder.selection] as string + "\\" + clean_sfol_array[ddl_subfol.selection] as string))
					)
					else(
						subsfol_array = (GetDirectories (scnTypeFolder + "\\" + clean_sfol_array[ddl_subfol.selection] as string))	
					)				
						
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
							if ddl_viewerMode.selection == 1 then 
							(
								join newLevels (getFiles (l+ "\\*.max"))
							)
							else(
								join newLevels (getFiles (l+ "\\*.fbx"))
							)
						)
						
					)
				)
				else( )
				
				
			)					
		)
-- 		else
-- 		(
-- 			ddl_subfol.items = #("Show All")
-- 			ddl_subfol.selection = 1
-- 			ddl_subfol.enabled = false
-- 				
-- 			--toggle dir button 
-- 			OpenLevelDirectory false
-- 			
-- 		)
			
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
			
			
	
		--flip folders 
		case chk_geoExport.checked of
		(
			true:
			(			
				chk_geoExport.enabled = true
				chk_aniExport.checked = false
				chk_aniExport.enabled = false
			)
			false:
			(
				chk_geoExport.enabled = false
				chk_aniExport.enabled = true
			)
		)
		
		case chk_aniExport.checked of 
		(
			true:
			(
				chk_aniExport.enabled = true
				chk_aniExport.checked = true 				
				chk_geoExport.enabled = false
			)
			false:
			(
				chk_aniExport.checked = false	
				chk_geoExport.enabled = true
			)
		)
		
	)
	
	on btn_projSync pressed do 
	(
		loc = undefined 		
		
		if ((txt = getSavePath()) != undefined ) then 
		(
			loc = txt as string 
			
		)
		else(loc = undefined)
		
		
		if ((loc) != undefined) then 
		(
			lbl_uniProNam.caption =  "Unity Project - "+loc as string 
			pathConfig.SetDir #export loc
		)		
		else(
			
			lbl_uniProNam.caption =  "Unity Project - None"
			pathConfig.SetDir #export ".\export"		
		)

	)
	

	--autoname check
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
		
	on ddl_viewerMode selected i do 
	(
				
		case ddl_viewerMode.selection of 
		(
			1:
			(
				
				chk_art.visible = 	true
				chk_dsn.visible = 	true
				chk_inst.visible = 	true
				chk_prop.visible = 	true
				chk_veh.visible = 	true
				chk_wea.visible = 	true
					
				btn_lod_pref.visible = true 
				btn_lod_pint.visible = true 
				btn_lod_.visible = true 
				btn_crt.visible = true 
				btn_open.visible = true 
				btn_edit.visible = true 
				btn_dele.visible = true 
				btn_swtc.visible = true 
				edt_proj_nam.visible = 	true
				clr_prj_clr.visible = 	true				
					
					
					
				btn_fndLP.visible = 	false
				btn_pckLP.visible = 	false
				btn_pckHP.visible = 	false
				btn_clrBake.visible = 	false
				--grp_prjHlpr.visible = 	false
					
				edt_lowMesh.visible = 	false
				btn_updLP.visible = 	false
				chk_mulLP.visible = 	false
					
				edt_higMesh.visible = 	false
				btn_updHP.visible = 	false
				chk_mulHP.visible = 	false
					
				ddl_lpDest.visible = 	false
				ddl_hpDest.visible = 	false
				chk_sySend.visible = 	false
					
				btn_lpSend.visible = 	false
				btn_hpSend.visible = 	false
					
					
					
				grp_dirView.caption = "Directory View"
				
				rad_are_type.visible = 	true
				lbl_blank_02.visible = 	true
				chk_sel_nam.visible = 	true
				edt_dir_name.visible = 	true
				ddl_area_suf.visible = 	true
				lbl_blank_01.visible = 	true
				
				btn_crt_cat.visible = 	true
				btn_crt_scn.visible = 	true
				btn_crt_are.visible = 	true
				btn_crt_prp.visible = 	true
				btn_crt_veh.visible = 	true
				btn_crt_wea.visible = 	true
				
				ddl_folder.visible = 	true
				ddl_subfol.visible = 	true
				ddl_clafol.visible = 	true
				btn_opn_cat.visible = 	true
				btn_cat_del.visible = 	true
				btn_opn_lvl.visible = 	true
				btn_lvl_del.visible = 	true
				lst_areas.visible = 	true
					
				btn_iso_lvl.visible = 	true
				btn_new_win.visible = 	true				
					
				btn_lod_ava.visible = 	true
				btn_lod_met.visible =  	true
				chk_asObj.visible =    	true
				ddl_refs.visible =   	true
				lbl_space.visible = 	true
				lbl_space2.visible =  	true
				lbl_space3.visible = 	true
				btn_rmv_ref.visible = 	true
				btn_upd_ref.visible = 	true
			)
			2:
			(
				
				btn_lod_pref.visible = false 
				btn_lod_pint.visible = false 
				btn_lod_.visible = false 
				btn_crt.visible = false 
				btn_open.visible = false 
				btn_edit.visible = false 
				btn_dele.visible = false 
				btn_swtc.visible = false 
				edt_proj_nam.visible = 	false
				clr_prj_clr.visible = 	false
					
					
				btn_fndLP.visible = 	true
				btn_pckLP.visible = 	true
				btn_pckHP.visible = 	true
				btn_clrBake.visible = 	true
				grp_prjHlpr.visible = 	true
					
									
				edt_lowMesh.visible = 	true
				btn_updLP.visible = 	true
				chk_mulLP.visible = 	true
					
				edt_higMesh.visible = 	true
				btn_updHP.visible = 	true
				chk_mulHP.visible = 	true
					
				ddl_lpDest.visible = 	true
				ddl_hpDest.visible = 	true
				chk_sySend.visible = 	true
					
				btn_lpSend.visible = 	true
				btn_hpSend.visible = 	true
					
					
				grp_dirView.caption = "Asset Tools"
				grp_prjHlpr.caption = "Bake Setup"
				grp_dirView.pos = [5,265]
				grp_dirView.height = 160
					
				chk_art.visible = 	false
				chk_dsn.visible = 	false
				chk_inst.visible = 	false
				chk_prop.visible = 	false
				chk_veh.visible = 	false
				chk_wea.visible = 	false
					
					
				rad_are_type.visible = 	false
				lbl_blank_02.visible = 	false
				chk_sel_nam.visible = 	false
				edt_dir_name.visible = 	false
				ddl_area_suf.visible = 	false
				lbl_blank_01.visible = 	false
					
					
				btn_crt_cat.visible = 	false
				btn_crt_scn.visible = 	false
				btn_crt_are.visible = 	false
				btn_crt_prp.visible = 	false
				btn_crt_veh.visible = 	false
				btn_crt_wea.visible = 	false
					
					
				ddl_folder.visible = 	false
				ddl_subfol.visible = 	false
				ddl_clafol.visible = 	false
				btn_opn_cat.visible = 	false
				btn_cat_del.visible = 	false
				btn_opn_lvl.visible = 	false
				btn_lvl_del.visible = 	false
				lst_areas.visible = 	false
				
				btn_iso_lvl.visible = 	false
				btn_new_win.visible = 	false
				
				
				btn_lod_ava.visible = 	false
				btn_lod_met.visible =  	false
				chk_asObj.visible =    	false
				ddl_refs.visible =   	false
				lbl_space.visible = 	false
				lbl_space2.visible =  	false
				lbl_space3.visible = 	false
				btn_rmv_ref.visible = 	false
				btn_upd_ref.visible = 	false			
				
			)
			4:
			(
				
				grp_dirView.caption = "Unity View"
				
				rad_are_type.visible = 	true				
				lbl_blank_02.visible = 	true
				chk_sel_nam.visible = 	true
				edt_dir_name.visible = 	true
				ddl_area_suf.visible = 	true
				lbl_blank_01.visible = 	true
				
				btn_crt_cat.visible = 	true
				btn_crt_scn.visible = 	true
				btn_crt_are.visible = 	true
				btn_crt_prp.visible = 	true
				btn_crt_veh.visible = 	true
				btn_crt_wea.visible = 	true
				
				ddl_folder.visible = 	true
				ddl_subfol.visible = 	true
				ddl_clafol.visible = 	true
				btn_opn_cat.visible = 	true
				btn_cat_del.visible = 	true
				btn_opn_lvl.visible = 	true
				btn_lvl_del.visible = 	true
				lst_areas.visible = 	true
				btn_lvl_del.visible = 	true
				lst_areas.visible = 	true
					
				btn_iso_lvl.visible = 	true
				btn_new_win.visible = 	true				
				
				btn_lod_ava.visible = 	false
				btn_lod_met.visible =  	false
				chk_asObj.visible =    	false
				ddl_refs.visible =   	false
				lbl_space.visible = 	false
				lbl_space2.visible =  	false
				lbl_space3.visible = 	false
				btn_rmv_ref.visible = 	false
				btn_upd_ref.visible = 	false
			)
		)
		
				
		case ddl_viewerMode.selection of 
		(
			1:
			(
				--temp solution 
				ddl_folder.selection = 1
				ddl_subfol.selection = 1
				--project mode 
				print (ddl_viewerMode.items[i] ) 
				ddl_proj.enabled = true
				scnTypeFolder = "\scenes\Areas\\"
					
				chk_geoExport.enabled = false 
				chk_aniExport.enabled = false 
					
				--get Project levels and filter types 
				GetProjectLevels()
					
				--reload pref button status 
				CheckIfReferenceExists()
					
			)
			2:
			(
				--temp solution 
				ddl_folder.selection = 1
				ddl_subfol.selection = 1
				--export mode 				
				print (ddl_viewerMode.items[i] )
				ddl_proj.enabled = false
			)
			3:
			(
				--temp solution 
				ddl_folder.selection = 1
				ddl_subfol.selection = 1
				--import mode 
				print (ddl_viewerMode.items[i] )
				ddl_proj.enabled = false
			)
			4:(
				--temp solution 
				ddl_folder.selection = 1
				ddl_subfol.selection = 1
				--unity project mode 
				print (ddl_viewerMode.items[i] )
				ddl_proj.enabled = false
				--ddl_subfol.enabled = true
				scnTypeFolder = unityProjectLocations[1]
					
				chk_geoExport.enabled = true 
				chk_aniExport.enabled = true 
					
				--get Project levels and filter types 
				GetProjectLevels()
					
				--reload pref button status 
				CheckIfReferenceExists()
					
			)
			default:(
					
					
					
				--get Project levels and filter types 
				GetProjectLevels()
					
				--reload pref button status 
				CheckIfReferenceExists()
			)
		)
		
		
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
		
	--LP Destination 
	on ddl_lpDest selected i do 
	(
		if chk_sySend.checked then 
		(
			
			ddl_hpDest.selection = ddl_lpDest.selection
		)
		else(
			
			
			--ddl_hpDest.selection = ddl_hpDest.selection 
		)
		
		
		
	)
	
	
	
	
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
	-- UI COMMANDS -- BUTTONS
		
	----------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------
		
		
		
		
	-------------------------------------------------------------------------------------------------------------Check Buttons ----
	----------------------------------------------------------------------------------------------------------------------------------	

	on chk_sySend changed state do 
	(
		
		if state then 
		(
			origSel = ddl_hpDest.selection 
			ddl_hpDest.enabled = false 
			btn_hpSend.enabled = false
			
			ddl_hpDest.selection = ddl_lpDest.selection
						
		)
		else(
			
			ddl_hpDest.selection = origSel
			ddl_hpDest.enabled = true 
			btn_hpSend.enabled = true
			
		)
			
		
		
	)	
		
	-------------------------------------------------------------------------------------------------------------Directory Helper ----
	----------------------------------------------------------------------------------------------------------------------------------
		
	--create new category 
	on btn_crt_cat pressed do 
	(
		areaname = edt_dir_name.text		
		
		makeDir (curProjectFolder+ scnTypeFolder + areaname as string)
		
		areaname = edt_dir_name.text			
		catDir = curProjectFolder+ scnTypeFolder + areaname as string 
		
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
				makeDir (curProjectFolder+ scnTypeFolder + clean_fold_arr[ddl_folder.selection] + "\\" + dirname as string)
				
			)
		)
			
		--create and Label
		tagname = ""
		if (ddl_area_suf.selection != 1) then 
		(
			tagname = ddl_area_suf.items[ddl_area_suf.selection] as string
		)
			
		areaname = (edt_dir_name.text + areatag[rad_are_type.state] as string + tagname as string )
		loc = (curProjectFolder + scnTypeFolder + clean_fold_arr[ddl_folder.selection] + "\\" + clean_sfol_array[ddl_subfol.selection] + "\\" + "models\\" + areatag[rad_are_type.state] + "\\" + areaname as string + ".max") 
			
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
		makeDir (curProjectFolder + scnTypeFolder + clean_fold_arr[ddl_folder.selection] + "\\" + areaname as string)
			
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
				
			newloc = (curProjectFolder + scnTypeFolder + clean_fold_arr[ddl_folder.selection] + "\\" + clean_sfol_array[ddl_subfol.selection] + "\\" + areaname as string) 
				
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
		
		if ddl_viewerMode.selection == 1 then 
		(
			--Get the category's directory 
			catDir = ""
			dirname = (clean_fold_arr[ddl_folder.selection] as string)		
			if ddl_folder.selection == 1 then 
			(
				catDir = (GetDirectories (curProjectFolder + scnTypeFolder))
			)
			else
			(
				catDir = (GetDirectories (curProjectFolder + scnTypeFolder + dirname))
			)
			print (catDir) 
		)
		else
		(
			--Get the category's directory 
			catDir = GetDirectories (unityProjectLocations[1] as string)
			print unityProjectLocations[1] as string
			ShellLaunch "explorer.exe" (catDir[1] as string ) 
		)	
		
			
			
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
						dirSel = (curProjectFolder + scnTypeFolder + dirname)  
						
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


CreateDialog flowProjectHelper width:360 height:880 style:#(#style_titlebar,  #style_border, #style_sysmenu, #style_resizing, #style_minimizebox, #style_maximizebox, #style_sunkenedge) autoLayoutOnResize:true 
	
-- addRollout  flowProjectToolsRO fPH



-- cui.registerDialogBar	flowProjectHelper	style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #style_resizing, #style_toolwindow) lockHeight:false lockWidth:false autoLayoutOnResize:true
