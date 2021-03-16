	
	--
	global mainFPFolder 

	global FP_DataLocation 
	global FP_BaseLocation 
	global FP_RCLocation 
	
	global str = getThisScriptFilename()
	sname = filenameFromPath str
	ss1 = sname
	ss2 = ""
	imgfolder = substituteString str ss1 ss2
		
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
				
			submenu "Floating Options"
			(
				menuItem itmDock "Dock Tool"
				separator sp3
				menuItem myItem3 "Float Tool"		
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
				ShellLaunch "https://uc7d949d250f3227616703095e0d.dl.dropboxusercontent.com/zip_download_get/AuMv0dJAM5urYgGr4dkCzspT87O0cglgH-4dQxJQF4qt7-RH-1GB0upEMmb02yq0dgTg_8eyWwhrZqVhMQHQRW6EscIWhWMGyKpgH3WnmWxu6A?_download_id=02910990778530253666624853181831137746482396977599943695749664991&_notify_domain=www.dropbox.com&dl=1" ""
			)
			else(
				ShellLaunch "https://www.dropbox.com/sh/v7hfufcetg62r7x/AAC0U4g3vOUZp0id_F7g0Su5a?dl=0" ""
			)
		)
		
		on itmReloadTool picked do 
		(
			filein (getThisScriptFilename() as string)
		)
			
	)

----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------

	rollout edt "Launcher"
	(
		bitmap bitmapBannerUi 						width:335 height:64 fileName:bitmapBannerFile align:#center gamma:1.0
			
		Group "Status"
		(
			label lbl_title  ""					align:#center	height:20	--width:100
		)
			
			
		Group "Toolset"
		(
			edittext edt_find "" 				 	align:#center 			height:25 	width:315  	enalbed:false
			button btn_find "Find" 					height:25 	width:75	across:4
			button btn_lau "Launch"					height:25	width:75 	
			button btn_clos "Close"					height:25	width:75
			button btn_rest "Reset"					height:25	width:75
		)	
			
			
		Group "Project Manager"
		(
			dropdownlist ddl_proj "" 			items:#()
			button btn_crt "New"				width:60	height:24	across:3
			button btn_open "Open"				width:60	height:24
			button btn_edit	"Edit"				width:60	height:24
-- 			button btn_nxt	">>"				width:45	height:24
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
				
			mainFPFolder  = getSavePath  caption:"Open A Test File:" filename:(GetDir #scripts)
			
			if mainFPFolder != undefined then 
			(
							
				edt_find.text = mainFPFolder--filenameFromPath mainFPFolder
				edt_find.tooltip = mainFPFolder
			)
			else 
			(
				mainFPFolder = GetDir (#scripts)
			)	
				
			if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
			(
				--set locations
				FP_DataLocation	= (mainFPFolder + "\FlowPanels\_base\FlowSaveData.ms")
				FP_BaseLocation = (mainFPFolder + "\FlowPanels\_base\FlowToolsBase.ms")
				FP_RCLocation 	= (mainFPFolder + "\FlowPanels\_base\FlowRCMenu.ms")
					
				--lau_scripts.items = scptsData.keys			
				lbl_title.text = "Toolset Ready to Launch!"
				
				edt_find.enabled = true
				btn_lau.enabled = true
				
				bitmapBannerFile = (imgfolder + "banner.jpg")
				bitmapBannerUi.filename = bitmapBannerFile
				
			)
			else
			(
				lbl_title.text = "::WARNING::Toolset not Found::"
				
				edt_find.enabled = false
				btn_lau.enabled = false
				
				bitmapBannerFile = (imgfolder + "banner_fail.jpg")
				bitmapBannerUi.filename = bitmapBannerFile
				
			)
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
			)
			catch()
		)
			
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_clos pressed do 
		(
			Try (cui.unRegisterDialogBar panFlowPan) catch()
			Try (destroydialog panFlowPan) catch()
			
			btn_clos.enabled = false
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
		)
		
			
		--------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------
			
		on edt open do 
		(
			if pnaFlowPan != undefined then
			(
				
				if panFlowPan.inDialog then 
				(
					
				)
				else
				(
					btn_clos.enabled = false
				)
			)
				
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
					
				edt_find.text = mainFPFolder --filenameFromPath mainFPFolder
				edt_find.tooltip = mainFPFolder
					
				if (doesFileExist (mainFPFolder + "\FlowPanels_v8.ms") ) then
				(
					lbl_title.text = "Toolset Ready to Launch!"
					
					edt_find.enabled = true
					btn_lau.enabled = true
					
					--set image
					bitmapBannerFile = (imgfolder + "banner.jpg")
					bitmapBannerUi.filename = bitmapBannerFile
				)
				else
				(
					lbl_title.text = "::WARNING::Toolset not Found::"
						
					edt_find.enabled = false
					btn_lau.enabled = false
						
					--set image
					bitmapBannerFile = (imgfolder + "banner_fail.jpg")
					bitmapBannerUi.filename = bitmapBannerFile
				)
			)	
			else
			(
				lbl_title.text = "Welcome, " +( sysinfo.username as string) + "!"
			)	
				
			cui.registerDialogBar edt style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #style_resizing, #style_toolwindow) lockHeight:false lockWidth:false autoLayoutOnResize:true --bgColor:[rRed,bBlu,gGre] 
				
		)

	)

	createDialog edt menu:LauncherSettingsMenu width:340 height:300 
	
	

	