	--try(closeRolloutFloater newwind)catch()
	Try(cui.UnregisterDialogBar panFlowPan)catch()
	Try(destroydialog panFlowPan)catch()


--------------------------------------------------------------------------------------------------------------------------------------
--GLOBAL ACCESSIBLE 
--------------------------------------------------------------------------------------------------------------------------------------
---	include "startup/FlowFunctions.ms"

	global toolLoc = getThisScriptFilename() as string
	

--------------------------------------------------------------------------------------------------------------------------------------

	global scripts = getDir #scripts 

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

-- CALLBACKS - SUBSCRIPTIONS ---

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

--Remove any existing callbacks with this ID.
callbacks.removeScripts id:#MXSHelp
--Add a new callback script which will call --callbacks.notificationParam() before selected nodes are deleted --and thus will print the deleted objects to the Listener:
callbacks.addScript #nodeCreated " AutoLayer()" id:#MXSHelp






----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

--CALLBACK FUNCTIONS ---

----------------------------------------------------------------------------------------------------------------------------------

Global AutoLayer 
Global UnSubscribe
fn AutoLayer = 
(
	
	obj = callbacks.notificationParam();
	layerName = (superclassof obj) as string;

	if layerName == "GeometryClass" then
	(
		layerName = "model"
	)

	layerName = layerName + "s"
	
	layer = layerManager.GetLayerFromName layerName
	if layer == undefined then
	(
		layer = layerManager.newLayerFromName layerName
	)
	layer.addNode obj;
)


fn UnSubscribe = callbacks.removeScripts id:#MXSHelp
	
		
--------------------------------------------------------------------------------------------------------------------------------
-- rcMenu ToolSettingsMenu - Flow Panels Menu
--------------------------------------------------------------------------------------------------------------------------------
--Tools Options Menu
	--"G:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_Toolset\FlowPanels\_base\FlowRCMenu.ms"
	filein FP_RCLocation
------------------------------------------------------------------------------------------------------------------------	

---------------------------------------------------------------------------------------------------------------	
	
---------------------------------------------------------------------------------------------------------------- // Main GUI
-- Main GUI - Scripts and Tools
--------------------------------------------------------------------------------------------------------------------------------------
rollout panFlowPan ("Flow Panels Toolset - " + "Hi, " + useGlobalDotNam as string)
	
--------------------------------------------------------------------------------------------------------------------------------------
	
--------------------------------------------------------------------------------------------------------------------------------------	
(
	--------------------------------------------------------------------------------------------------------------------------------------
		
	--ROLLOUT CONTROLS
	subRollout scriptBin width:(panFlowPan.width as float -10) pos:[5,5] height:(FPHeight.y)
		
	fn switchRolls openedRoll =
	(
		for roll in panFlowPan.rolls where roll != openedRoll do 
		(
			roll.open = false
		)
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// SELECTION PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Selection Panel
		

	Rollout panOrganize "Organize Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
		
		include "flow_panOrganize.ms"
		
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// CREATE PANEL 
	--------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------- 
	-- Create Panel Controls 

	Rollout panCreate "Create - Launch Panel" 
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
		include "flow_panCreate.ms"
	)	
		
	--------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// MODELING PANEL 
	--------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Modelling Panel Controls 
		
	Rollout panModeling "Modelling Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
		include "flow_panModeling.ms"
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// PAINTING PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Painting Panel Controls 
		
	Rollout panPaint "Painting Panel"  
		
	--------------------------------------------------------------------------------------------------------------------------------------	
	(
		include "flow_panPainting.ms"
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// NORMALS PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Normals Panel Controls 	
		
	Rollout panNormals "Normals Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(	
		include "flow_panNormals.ms"
	)	
		
	-------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// SUBSTANCE PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Substance Panel Controls 
		
	Rollout panSubstance "Substance Panel"
		
	-------------------------------------------------------------------------------------------------------------------------------------	
	(
		include "flow_panSubstance.ms"
	)
		
	-------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// PREFABS PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Prefabs Panel Controls 
	
	Rollout panPrefabs "Prefabs Panel"
	(
		include "flow_panPrefabs.ms"
	)
		
	-------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// EXPORT PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Export Panel Controls 

	Rollout panExporter "Export Panel"

	-------------------------------------------------------------------------------------------------------------------------------------	
	(
		include "flow_panExporter.ms"
	)
		
	-------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// EXPORT PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Export Panel Controls 
		
	-------------------------------------------------------------------------------------------------------------------------------------
	Rollout panImporter "Import Panel"
	(
		include "flow_panImporter.ms"
	)
		
	-------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// VIEWPORT PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
	-- Viewport Panel Controls 
		
	-------------------------------------------------------------------------------------------------------------------------------------
	Rollout panViewport "Viewport Panel"
	(	
		include "flow_panViewport.ms"
	)
		
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	local rolls = #(panOrganize, panCreate, panModeling, panNormals, panPaint, panSubstance, panPrefabs, panExporter, panImporter, panViewport)
		
		
	--ON START
    on  panFlowPan open do
	(
		--CREATIION OF PANELS - Generate Flow Panels
		case pOrgActive of 
		(
			true: (print "Organize Panel Launched")
			false:( print "No Organize Panel"
					
				item = findItem rolls panOrganize
				
				deleteItem rolls item
				
				)
		)
		case pCrtActive of 
		(
			true: (print "Create Panel Launched")
				
			false: (print "No Create Panel"
					
				item = findItem rolls panCreate
				
				deleteItem rolls item
				
				)
		)
		case pModActive of 
		(
			true: (print "Modeling Panel Launched")
				
			false: 
				(
					print "No Modeling Panel"
					
					item = findItem rolls panModeling
					deleteItem rolls item
				)
		)
		case pNorActive of 
		(
			true: (print "Normals Panel Launched")
				
			false: (print "No Normals Panel"
					
				item = findItem rolls panNormals
				
				deleteItem rolls item
				
				)
		)		
		case pPaiActive of 
		(
			true: (print "Painting Panel Launched")
				
			false: (print "No Painting Panel"
					
				item = findItem rolls panPaint
				
				deleteItem rolls item
				
				)
		)
		case pSubActive of 
		(
			true: (print "Substance Panel Launched")
				
			false: (print "No Substance Panel"
					
				item = findItem rolls panSubstance
				
				deleteItem rolls item
				
				)
		)
		case pExpActive of 
		(
			true: (print "Exporter Panel Launched")
				
			false: (print "No Exporter Panel"
					
				item = findItem rolls panExporter
				
				deleteItem rolls item
				
				)
		)		
		case pImpActive of 
		(
			true: (print "Importer Panel Launched")
				
			false: (print "No Importer Panel"
					
				item = findItem rolls panImporter
				
				deleteItem rolls item
				
				)
		)		
		case pVieActive of 
		(
			true: (print "Viewport Panel Launched")
				
			false: 
			(
				print "No Viewport Panel"
					
				item = findItem rolls panViewport
				deleteItem rolls item
				
			)
		)		
		case pPreActive of 
		(
			true: (print "Prefabs Panel Launched")
				
			false: 
			(
				print "No Prefabs Panel"
					
				item = findItem rolls panPrefabs
				deleteItem rolls item
					
			)
		)		
			
		--rolledup on start	
		if FP_Global_Settings == undefined then
		(
			is_RolledUpOnStart = true
				
			--record Tool Position
			SetGlobalFPData is_RolledUpOnStart 4
				
		)			
		else
		(
			is_RolledUpOnStart = FP_Global_Settings[4]
		)
		
		--roll up panels
		for roll in rolls do 
		(
			addSubRollout scriptBin roll rolledup:is_RolledUpOnStart
		)
			
		qx_fldr = set_exp_location
			
		if use_AutoDocking then 
		(		
			cui.registerDialogBar panFlowPan
			registerRightClickMenu ToolSettingsMenu
			cui.dockDialogBar panFlowPan #cui_dock_left
		)
		else
		(
			--cui.registerDialogBar panFlowPan
			registerRightClickMenu ToolSettingsMenu
		)
		
		
	)
	
	on panFlowPan resized FPHeight do
	(
		print FPHeight
		
	)
	
		
	--ON CLOSE 
	on panFlowPan close do
	(
			
		toolSetClosePos = getdialogpos panFlowPan
			
		--record Tool Position
		SetGlobalFPData toolSetClosePos 5
			
		--save export location
		set_exp_location = auto_FP_Settings[9]
			
			
		if (use_SettingsRecorder) do
		(
			--saves recorder data
			SaveRecorderSettings()
			
		)
			
		--saves tool settings
		SaveToolSettingsFP()
			
			
	)
		
)


-------------------------------------------------------------------------------------------------------------------------------------	

---------------------------------------------------------------------------------------------------------------- // CreateU


createdialog panFlowPan   width:260 menu:ToolSettingsMenu --height:(FPHeight.y) 

-- scriptBin = newRolloutFloater "Floater" 280 200 300 450
-- addRollout panFlowPan scriptBin

cui.registerDialogBar panFlowPan style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #style_resizing, #style_toolwindow)  pos:toolSetClosePos lockHeight:false lockWidth:false autoLayoutOnResize:true --bgColor:[rRed,bBlu,gGre] 

--style:#(#style_titlebar, #style_sysmenu, #style_toolwindow, #style_resizing, #style_minimizebox)
--style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #cui_max_sized)	


