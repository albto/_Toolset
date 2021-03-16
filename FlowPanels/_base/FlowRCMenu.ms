----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
fn ReloadTools = 
(
	fileIn toolLoc
)

----------------------------------------------------------------------------------------------------------------------------------
fn SetFlowPanelsActiveValue val ind = 
(
			--change value
		FP_Global_Settings[ind] = not FP_Global_Settings[ind]		
		val = FP_Global_Settings[ind] 
		
		--save settings
		SetGlobalFPData val ind
		
		--saves tool settings
		SaveToolSettingsFP()
		
		--reload toolset
		ReloadTools()	
)
		
global panelArray = #(pOrgActive, pCrtActive, pModActive, pNorActive, pPaiActive, pSubActive, pExpActive, pImpActive, pVieActive, pPreActive)

 

--All Active Mode
fn SetPanelsModeAll arr = 
(
		for i = 6 to 15 do 
		(
			--change value
			FP_Global_Settings[i] = true
			arr[i] = FP_Global_Settings[i] 		
				
			--save settings
			SetGlobalFPData arr[i] i
				
		)
			
		--saves tool settings
		SaveToolSettingsFP()
			
		--reload toolset
		ReloadTools()	
			
)

--Basic Mode
fn SetPanelsModeBasic arr = 
(
		for i = 6 to 15 do 
		(
			if (i == 6 or i == 7 or i == 10 or i == 11  ) then
			(
				--change value
				FP_Global_Settings[i] = false
				arr[i] = FP_Global_Settings[i] 		
					
				--save settings
				SetGlobalFPData arr[i] i					
			)
			else
			(
				--change value
				FP_Global_Settings[i] = true
				arr[i] = FP_Global_Settings[i] 		
					
				--save settings
				SetGlobalFPData arr[i] i
			)	
		)
			
		--saves tool settings
		SaveToolSettingsFP()
			
		--reload toolset
		ReloadTools()	
			
)

--Modeling Mode
fn SetPanelsModeMod arr = 
(
		for i = 6 to 15 do 
		(
			if (i == 6 or i == 10 or i == 11  or i == 12 or i == 13 or i == 15) then
			(
				--change value
				FP_Global_Settings[i] = false
				arr[i] = FP_Global_Settings[i] 		
					
				--save settings
				SetGlobalFPData arr[i] i					
			)
			else
			(
				--change value
				FP_Global_Settings[i] = true
				arr[i] = FP_Global_Settings[i] 		
					
				--save settings
				SetGlobalFPData arr[i] i
			)	
		)
			
		--saves tool settings
		SaveToolSettingsFP()
			
		--reload toolset
		ReloadTools()	
			
)


----------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------
rcMenu ToolSettingsMenu
----------------------------------------------------------------------------------------------------------------------------------
(	
	submenu "- Panels -" 
	(
		submenu "Active Panels:"
		(		
			menuItem itmPanOrg "Organize Panel" 	checked:FP_Global_Settings[6]
			separator sp14	
			menuItem itmPanCrt "Create Panel" 		checked:FP_Global_Settings[7]
			separator sp15
			menuItem itmPanMod "Modelling Panel" 	checked:FP_Global_Settings[8]
			separator sp16
			menuItem itmPanNor "Normals Panel" 		checked:FP_Global_Settings[9]
			separator sp17
			menuItem itmPanPai "Painting Panel" 	checked:FP_Global_Settings[10]
			separator sp18
			menuItem itmPanSub "Substance Panel" 	checked:FP_Global_Settings[11]
			separator sp19
			menuItem itmPanPre "Prefabs Panel" 		checked:FP_Global_Settings[15]
			separator sp20
			menuItem itmPanExp "Export Panel" 		checked:FP_Global_Settings[12]
			separator sp21
			menuItem itmPanImp "Import Panel" 		checked:FP_Global_Settings[13]
			separator sp22
			menuItem itmPanVie "Viewport Panel" 	checked:FP_Global_Settings[14]
			separator sp23
				
		)
		submenu "Panel Modes:"
		(		
				
			menuItem itmPanModeAll "All Active" 
			separator sp24	
			menuItem itmPanModeBas "Basic Mode" 
			separator sp25
			menuItem itmPanModeMod "Modeling Mode" 
			separator sp26
		)		
		submenu "Panel Behavior:"
		(		
			menuItem itmPinState "Save Current State" 
			separator sp8	
			menuItem itmCollapse "Auto-Collapse Panels" checked:autoColPanels
			separator sp9
			menuItem itmRolledStart "Rolled-Up on Start" checked:autoRolPanels
			separator sp13
		)
					
	)
	submenu "- Options -"
	(
			
		menuitem itmDEBUG "Debug Settings Recorder"
		submenu "Start-Up Options"
		(		
			
			menuItem itmChkDock "Auto-Dock" checked:autoDockVal enabled:true
			separator sp2	
			menuItem itmRecorder "Remember Settings" checked:SetautoRecorderOn
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
		menuItem itmResetTool "Reset Tool"
			separator sp10	
		menuItem itmCloseTool "Close Tool" 
			separator sp1
	) 
		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------- // RC MENU FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--modeling mode 
	on itmPanModeAll picked do 
	(
		--set All Mode
		SetPanelsModeAll panelArray
			
	)
	
	--basic mode 
	on itmPanModeBas picked do 
	(
		--set All Mode
		SetPanelsModeBasic panelArray
			
	)
	
	--modeling mode 
	on itmPanModeMod picked do 
	(
		--set All Mode
		SetPanelsModeMod panelArray
			
	)
	
	
	-- organize panels controls 
	on itmPanOrg picked do
	(
		--Set Panel Value 
		SetFlowPanelsActiveValue pOrgActive 6
		
	)
	-- create panels controls 
	on itmPanCrt picked do
	(
		--Set Panel Value 
		SetFlowPanelsActiveValue pCrtActive 7
		
	)
	-- modeling panels controls 	
	on itmPanMod picked do
	(
		--Set Panel Value 
		SetFlowPanelsActiveValue pModActive 8
		
	)
	-- normals panels controls 
	on itmPanNor picked do
	(
		--Set Panel Value 
		SetFlowPanelsActiveValue pNorActive 9
		
	)
	-- painting panels controls 
	on itmPanPai picked do
	(
		--Set Panel Value 
		SetFlowPanelsActiveValue pPaiActive 10
		
	)
	-- substance panels controls 
	on itmPanSub picked do
	(
		--Set Panel Value 
		SetFlowPanelsActiveValue pSubActive 11
		
	)
	-- export panels controls 
	on itmPanExp picked do
	(
		--Set Panel Value 
		SetFlowPanelsActiveValue pExpActive 12
			
	)
	-- import panels controls 
	on itmPanImp picked do
	(
		--Set Panel Value 
		SetFlowPanelsActiveValue pImpActive 13
			
	)	
	-- vireport panels controls 
	on itmPanVie picked do
	(
		
		--Set Panel Value 
		SetFlowPanelsActiveValue pVieActive 14
			
	)
	-- vireport panels controls 
	on itmPanPre picked do
	(
		
		--Set Panel Value 
		SetFlowPanelsActiveValue pPreActive 15
			
	)
		
		
	--debug test menuitem
	on itmDEBUG picked do 
	(
		
		--test functionality 
		------------------------------------------------------
		actionMan.executeAction 0 "40839"  -- MAX Script: MAXScript Editor
			
	)
		
	
	-- Help Archives 
	on itmLoadHelp picked do
	(
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		Try(destroydialog maxForm)catch()
		Try(destroydialog webBrowser)catch()
		
		
		-- Load MaxCustomControls assembly
		-- This assembly contains UI components built on the .NET Framework for use in 3ds Max
		dotNet.loadAssembly "MaxCustomControls.dll"
		
		-- Create WebBrowser
		webBrowser = dotNetObject "System.Windows.forms.WebBrowser"
		webBrowser.Location = dotNetObject "System.Drawing.Point" 10 10
		webBrowser.Width = 1000
		webBrowser.Height = 1000
		webBrowser.IsAccessible = dotNetObject "System.Boolean" True
		webBrowser.IsWebBrowserContextMenuEnabled = dotNetObject "System.Boolean" True
		webBrowser.Url = dotNetObject "System.Uri" "http://help.autodesk.com/view/3DSMAX/2021/ENU/"
		webBrowser.Parent = dotNetObject "System.Windows.Forms.Control"
		
		-- Create Max Form
		maxForm = dotNetObject "MaxCustomControls.MaxForm"
		maxForm.Size = dotNetObject "System.Drawing.Size" 1035 1000
		maxForm.Text = "Max Form with WebBrowser"
		maxForm.Controls.Add(webBrowser)
		maxForm.TopMost = true
		FormBorderStyle = dotNetClass "System.Windows.Forms.FormBorderStyle"
		--maxForm.FormBorderStyle = FormBorderStyle.FixedDialog
		maxForm.ShowInTaskbar = false
		maxForm.MinimizeBox = false
		maxForm.MaximizeBox = false
		
		-- Show MaxForm
		maxForm.ShowModeless()		
		
	)
		
	-- Allows the Tool to Dock Right 
	
	on itmDock picked do 
	(
		cui.registerDialogBar panFlowPan
		cui.dockDialogBar panFlowPan #cui_dock_left
	)
		
	-- Allows the Tool to Float
	on myItem3 picked do
	(
		cui.floatDialogBar panFlowPan
		cui.unregisterDialogBar panFlowPan
	)
		
	-- Close Tool
	on itmCloseTool picked do
	(
		Try (cui.unRegisterDialogBar panFlowPan) catch()
		Try (destroydialog panFlowPan) catch()
	)
		
	--Turn on Auto-Dock -- On by Default
	on itmChkDock picked do
	(
		autoDockVal = not autoDockVal
		use_AutoDocking = not use_AutoDocking
		
		--saves setting 
		SetGlobalFPData use_AutoDocking 2
		
		--saves tool settings
		SaveToolSettingsFP()
		
	)
		
	--Turn on recorder
	on itmRecorder picked do
	(
		SetautoRecorderOn = not SetautoRecorderOn
		use_SettingsRecorder = not use_SettingsRecorder
		
		--saves setting 
		SetGlobalFPData use_SettingsRecorder 1
		
		--saves tool settings
		SaveToolSettingsFP()
		
	)
	
	--Panel Options -- Rolled-up on Startup
	on itmRolledStart picked do
	(
		
		autoRolPanels = not autoRolPanels --On Start-up
		is_RolledUpOnStart = autoRolPanels --For Live Updating
		
		--saves setting 
		SetGlobalFPData autoRolPanels 4
		
		--saves tool settings
		SaveToolSettingsFP()
		
	)
		
	--Sets auto-collapse
	on itmCollapse picked do
	(
		autoColPanels = not autoColPanels --On Start-up
		use_AutoCollapse = autoColPanels --For Live Updating
		
		--saves setting 
		SetGlobalFPData autoColPanels 3
		
		--saves tool settings
		SaveToolSettingsFP()
		
	)
		
		
	--saves current state
	on itmPinState picked do 
	(
		if querybox "Are you sure you want to save the current State? \n
		Auto-Collapse will be turned-off, if currently Active." title:"Saving Panel State" beep:false then
		(		
			messagebox "State has been Saved."
			autoColPanels = false
		)
		Else
		(
			messagebox "good choice"
		)
	)
		
		
	--About Pop-Up
	on itmLoadAbout picked do 
	(
		str = filenameFromPath( getThisScriptFilename() as string)
		str = substituteString str ".ms" " "
		str = substituteString str "_" " "
		str = substituteString str "v5 5" "v5.5"
		str = substituteString str "Flow Panels" ""
			
		messagebox ( "About: Flow Panels Toolset \n" + "\n" + "Version: " + str + "\n" +  "\n Copyright �2020 Alberto Rodriguez")
	)
		
	--Reload toolset
	on itmReloadTool picked do
	(
		fileIn (mainFPFolder + "\FlowPanels_v8.ms")  
	)
	
	--Reset toolset
	on itmResetTool picked do 
	(
		local usedotNam = sysInfo.username as string
			
		--DELETE PRESET LOCATIONS 
			
-- 		ss1 = ("C:\\Users\\"+ usedotNam +"\\PresetLocations.fp")
-- 			
-- 		deletefile (ss1)		
		
		--DELETE PRESET IMPORT LOCATIONS
			
-- 		ss2 = ("C:\\Users\\"+ usedotNam +"\\PresetImportLocations.fp")
-- 			
-- 		deletefile (ss2)
		
		--DELETE GLOBAL SETTINGS
			
		ss3 = ("C:\\Users\\"+ usedotNam +"\\FPGlobals.fp")
			
		deletefile (ss3)
			
		--DELETE AUTO SETTINGS
			
		ss4 = ("C:\\Users\\"+ usedotNam +"\\AutoSettings.fp")
			
		deletefile (ss4)
			
		--reset settings
-- 		auto_FP_Settings = #()
		--auto_FP_Settings = #(false,false,false,false,false,false,".","msh","", false, 1, "", #(), 0, 1, 0.0, "", false, false, false, "", false)
			
		--reset global settings
-- 		FP_Global_Settings = #(true, true, true, true)
			
		--Reload Toolset
		fileIn (getThisScriptFilename() as string)
			
	)
	
	
	on ToolSettingsMenu update do (print "update")
	
	
	
)