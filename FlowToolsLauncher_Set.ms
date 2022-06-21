

	global launcherData = #()
	----------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
	global mainFPFolder = getThisScriptFilename()
		
	----------------------------------------------------------------------------------------------------------------------------------
	global str = getThisScriptFilename()

		
		
	global launcherFolder = getfilenamepath str  
	
	global toolFolder = substituteString launcherFolder "\FlowPanels\_base" ""
	global imgfolder =  (toolFolder + "\\FlowPanels\\_images\\") --getfilenamepath str
		
	global strMyFolder = ""
	----------------------------------------------------------------------------------------------------------------------------------
		
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
		
		
	----------------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------- // Tools Save Data
	--Tools Save Data 
		--"G:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_Toolset\FlowPanels\_base\FlowSaveData.ms"
		filein FP_DataLocation
			
			
	----------------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------- // Tool Settings
	--Tool Settings 
		--"G:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_Toolset\FlowPanels\_base\FlowToolsBase.ms"
		filein FP_BaseLocation		
			
			
	----------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
			
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

----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
	
	rollout edt "Tools Launcher"
	(
		local appImages = "UVWUnwrapView_24i.bmp"
		local appAlphas = "UVWUnwrapView_24a.bmp"
		local newArr = #()
		local levels = #()
		local newLevels = #()
		local cleanArr = #()
		local clean_fold_arr = #()
		local clean_sfol_array = #()
		local subsfol_array = #()
		local refObjs = #()
		local openHelpersList = #()
		
		local areatag = #("_Art", "_Design", "_Inst", "_Vehicle", "_Test")
		
		bitmap bitmapBannerUi 						width:335 height:64 fileName:bitmapBannerFile align:#center gamma:1.0
			
		Group "Status"
		(
			label lbl_title  ""					align:#center	height:20	
		)
			
			
		Group "Toolset"
		(
			edittext edt_find "" 				 	height:20 				align:#left 	fieldwidth:280  	enalbed:false				multiline:false											across:2
			button btn_find "Find" 					height:20 	width:20	align:#right 	images:#(appImages, appAlphas,30,7,8,1,1) 		ToolTip: "Find Toolset Folder"	
			button btn_lau "Launch"					height:24	width:75 																	ToolTip: "Find Toolset Folder"														across:4
			button btn_clos "Close"					height:24	width:75																	ToolTip: "Find Toolset Folder"
			button btn_rest "Reset"					height:24	width:75 																	ToolTip: "Find Toolset Folder"
			button btn_empt "Mini Launcher"			height:24	width:75 	align:#right													ToolTip: "Find Toolset Folder"
		)	
		
		Group "Open Dialogs List:"
		(
			listbox lst_opn_dlg ""
		)
			
		Group "Tool Helpers"
		(
				
			button btn_app_1 "Organize" 			height:52 	width:52	images:#(appImages, appAlphas,27,1,8,1,1) 		ToolTip: "Scene and Layer Organizer"						across:6
			button btn_app_2 "Create" 				height:52 	width:52	images:#(appImages, appAlphas,27,2,3,1,1) 		ToolTip: "Object Creation Helper and Script Launcher"
			button btn_app_3 "Model" 				height:52 	width:52	images:#(appImages, appAlphas,27,3,3,1,1) 		ToolTip: "Modeling Helper"
			button btn_app_4 "Chamfer" 				height:52 	width:52	images:#(appImages, appAlphas,27,4,8,1,1) 		ToolTip: "Vertex Normal and Chamfering Helper"
			button btn_app_5 "Paint" 				height:52 	width:52	images:#(appImages, appAlphas,27,5,8,1,1) 		ToolTip: "Vertex Painting Helper"
			button btn_app_6 "Texture" 				height:52 	width:52	images:#(appImages, appAlphas,27,6,8,1,1) 		ToolTip: "Substance Painter Helper"
				
			button btn_app_7 "Prefab" 				height:52 	width:52	images:#(appImages, appAlphas,27,9,8,1,1) 		ToolTip: "Prefabs Helper"									across:6
			button btn_app_8 "Export" 				height:52 	width:52	images:#(appImages, appAlphas,27,8,8,1,1) 		ToolTip: "Export Helper"
			button btn_app_9 "Import" 				height:52	width:52	images:#(appImages, appAlphas,27,11,8,1,1) 		ToolTip: "Import Helper"
			button btn_app_10 "Viewport"			height:52 	width:52	images:#(appImages, appAlphas,27,12,8,1,1) 		ToolTip: "Viewport Helper"
			button btn_app_11 "Manage" 				height:52 	width:52	images:#(appImages, appAlphas,27,10,8,1,1) 		ToolTip: "Project Directory Helper"
			button btn_app_12 "Tag" 				height:52 	width:52	images:#(appImages, appAlphas,27,7,8,1,1) 		ToolTip: "Attributes Helper"
				
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
			
		--Update status 
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
			
		fn closeToolHelper val = 
		(
			--visualize open dialogs 
			list = UIAccessor.GetPopupDialogs() 
			openDialogs = #()
			for i = 1 to list.count do 
			(
				--UIAccessor.CloseDialog i
				openDialogs[i] = UIAccessor.GetWindowText list[i]
				
				if openDialogs[i] == val do
				(
					UIAccessor.CloseDialog list[i]
				)
			)
		)
			
		fn GetOpenDialogsList = 
		(		
			--generate list items --
			--create list
			openHelpersList = UIAccessor.GetPopupDialogs()
			openDialogs = #()
			for i = 1 to openHelpersList.count do 
			(
				openDialogs[i] = UIAccessor.GetWindowText openHelpersList[i]
			)
				
			lst_opn_dlg.items = openDialogs
				
				
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
			GetOpenDialogsList()
		)
			
			
		--------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------
				
		on lst_opn_dlg selected i do 
		(
			
		)
			
		on lst_opn_dlg rightClick i do 
		(
			UIAccessor.CloseDialog openHelpersList[i]
		)
			
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
			try (filein "flow_MiniLauncher.ms") catch ()
			
		)
			
		--------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_app_8 pressed do 
		(
			nam = "Export Tools"
				
			--close if dialog is open 
			closeToolHelper nam
				
			Rollout panE nam 
			(
				include "flow_panExporter.ms"
				
				--button btn_save "Save Settings" 
				
				on btn_save pressed do
				(	
					--saves recorder data
					SaveRecorderSettings()
						
					--saves tool settings
					SaveToolSettingsFP()
					
				)
					
				on panE open do 
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
							vernam.visible = false
							radsufval.enabled = false
							radsufval.visible = false
							prenam.enabled = false
							prenam.visible = false
							btn_incr_vr.enabled = false
							btn_incr_vr.visible = false
								
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
						
				)
				
				on panE close do 
				(
						
					--saves recorder data
					SaveRecorderSettings()
						
					--saves tool settings
					SaveToolSettingsFP()
						
				)
					
			)	
				
			CreateDialog panE width:260 height:680
		)
			
		on btn_app_9 pressed do 
		(
			nam = "Import Tools"

			--close if dialog is open 
			closeToolHelper nam
				
			Rollout panI nam
			(
				include "flow_panImporter.ms"
				
				
				on panI close do 
				(
						
					--saves recorder data
					SaveRecorderSettings()
						
					--saves tool settings
					SaveToolSettingsFP()
						
				)
			)					
			
			CreateDialog panI width:260 height:600
		)
			
		--launch Viewport helper
		on btn_app_10 pressed do 
		(	
			nam = "Viewport Tools" 

			--close if dialog is open 
			closeToolHelper nam
			
			Rollout panV nam 
			(
				include "flow_panViewport.ms"
			)	
				
			CreateDialog panV width:260 height:532
		)
		
		on btn_app_11 pressed do 
		(
			try ( filein "FlowToolsProjectHelper.ms" ) catch()
			
			
		)
		
		
		
		--------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on edt open do 
		(
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
	
	
	
	
	createDialog edt menu:LauncherSettingsMenu width:340 height:530
	
	cui.registerDialogBar edt style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #style_resizing, #style_toolwindow) lockHeight:false lockWidth:false autoLayoutOnResize:true --bgColor:[rRed,bBlu,gGre] 

	
	
		
	
