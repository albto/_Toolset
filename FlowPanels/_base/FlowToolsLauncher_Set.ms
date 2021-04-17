	
	global launcherData = #()
	----------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
	global mainFPFolder
		
	----------------------------------------------------------------------------------------------------------------------------------
	global str = getThisScriptFilename()
	global imgfolder = getfilenamepath str
		
		
	global launcherFolder = getfilenamepath str  
	
	global toolFolder = substituteString launcherFolder "\FlowPanels\_base" ""
	
		
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
		
	--if mainFPFolder == undefined then 
-- 	(
		if launcherData == undefined then
		(
			launcherData = #()
			mainFPFolder = toolFolder
		)
		else
		(
			mainFPFolder = launcherData[1]
		)
-- 	)
	

		
		
	global FP_DataLocation 
	global FP_BaseLocation 
	global FP_RCLocation 
		
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
				menuItem myItem3 "Install Custom UI presets"		
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
		
	)

----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------

	rollout edt "Launcher"
	(
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
			
			
		Group "Project Manager"
		(
			dropdownlist ddl_proj "" 			items:#()
			button btn_crt "New"				width:75	height:24	across:4
			button btn_open "Open"				width:75	height:24
			button btn_edit	"Edit"				width:75	height:24
			button btn_swtc	"Switch"			width:75	height:24
		)
			
			
		--TICK-----------------------------------------------------------------------
		-----------------------------------------------------------------------------
		timer tick_LauncherUpdate "" 			interval:500
			
			
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
					btn_clos.enabled = false
						
				)
			)
			else 
			(
					lbl_title.text = "Welcome, " +( sysinfo.username as string) + "!"	
						
					--deactivate 'close' button 
					btn_clos.enabled = false
			)
		)
			
		on tick_LauncherUpdate tick do 
		(
			--update status 
			UpdateToolsetStatus()
		)
			
		on btn_crt pressed do 
		(
			local folder = getSavePath  caption:"Set Project Directory" filename:(GetDir #scripts)
				
			if folder != undefined then
			(
				macros.run "Tools" "CreateDefaultProject" 
				
				print folder
				pathConfig.doProjectSetupStepsUsingDirectory folder  
				pathConfig.setCurrentProjectFolder folder
				
			)
				
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
						
					print launcherData	
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
						
					print launcherData
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
				if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
				(
						
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
						
				)
					
				--update status 
				UpdateToolsetStatus() 
					
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
		
			
		--------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on edt open do 
		(
				
			--clean-up string name 
			(
				pth = pathConfig.getCurrentProjectFolderPath()
				str = filenameFromPath pth 
				ss1 = ".mxp"
				ss2 = ""
				
				str = substituteString str ss1 ss2 
				
				ddl_proj.items = #(str)
			)
				
				
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
					
				if launcherData == undefined then
				(		
					launcherData = #()
					mainFPFolder = toolFolder
				)
				else
				(
					mainFPFolder = launcherData[1]
				)
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
			--save 'mainFPFolder' 
			SaveLauncherData toolFolder	
		)
		
	)

	createDialog edt menu:LauncherSettingsMenu width:335 height:320 
	
	cui.registerDialogBar edt style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #style_resizing, #style_toolwindow) lockHeight:false lockWidth:false autoLayoutOnResize:true --bgColor:[rRed,bBlu,gGre] 

	