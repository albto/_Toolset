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
				menuItem itmIni "Initialize Tools (Required)"	
				separator sp15
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
			print "Successfully "
		)
		catch(print "ERROR: loading flow attributes script; file was not found")
	)
	
	on itmIni picked do 
	(
		try 
		(
			filein (mainFPFolder + "\\FlowFunctions\\FlowFunctions.ms") as string 
			filein (mainFPFolder + "\\FlowFunctions\\FlowCreator.ms") as string 
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
