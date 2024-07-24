
	global launcherData = #()
		
	----------------------------------------------------------------------------------------------------------------------------------
-- 	global str = getThisScriptFilename()

-- 		
-- 		
-- 	global launcherFolder = getfilenamepath str  
-- 	
 	global toolFolder = mainFPFolder--substituteString launcherFolder "\FlowPanels\_base" ""
 	global imgfolder =  (toolFolder + "\\FlowPanels\\_images\\") --getfilenamepath str
		
	global strMyFolder = ""
	


	----------------------------------------------------------------------------------------------------------------------------------
		
	-----------------------------------------------------------------------------------------------------------LAUNCHER DATA -- SET --
	----------------------------------------------------------------------------------------------------------------------------------
	-- Auto-Load Lauincher Data on Start-up
		
	--this is redundant 
	if (doesFileExist(mainFPFolder + "\FlowPanels\savedata\LauncherData.fp")) then	
	(
		ld = openfile (mainFPFolder + "\FlowPanels\savedata\LauncherData.fp") 
		launcherData = execute (readLine ld)
		close ld
		print (	 "Launcher Data - " + launcherdata as string)
	)		
		
	if launcherData != undefined then
	(
		--grab data
		mainFPFolder = launcherData[1]
	)
	else 
	(
		launcherData = #("", 1, 1, false, false, false, false, false, false, "", 1)
	)
		
	-----------------------------------------------------------------------------------------------------------LAUNCHER DATA -- END --
	----------------------------------------------------------------------------------------------------------------------------------
		


--------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------// LOAD PRESET LIST
--------------------------------------------------------------------------------------------------------------------------------------

global savedData = Dictionary()
global impSavedData = Dictionary()
global scptsData = Dictionary()
global savedProjectData = #()


--------------------------------------------------------------------------------------------------------------------------------------
-- Auto-Load Export Preset Locations on Start-up
	if doesFileExist (mainFPFolder + "\FlowPanels\savedata\PresetLocations.fp") then	
	(
		ss = openfile (mainFPFolder + "\FlowPanels\savedata\PresetLocations.fp") mode:"r"
		savedData = execute (readLine ss)
		close ss
	)
	else
		savedData = Dictionary()
		
--------------------------------------------------------------------------------------------------------------------------------------
-- Auto-Load Export Preset Locations on Start-up

	if doesFileExist (mainFPFolder + "\FlowPanels\savedata\PresetImportLocations.fp") then
	(
		impss = openfile (mainFPFolder + "\FlowPanels\savedata\PresetImportLocations.fp") mode:"r"
		impSavedData = execute (readLine impss)
		close impss
	)
	else
		impSavedData = Dictionary()
		
--------------------------------------------------------------------------------------------------------------------------------------
-- Scripts Launch Preset Locations on Start-up
	if doesFileExist(mainFPFolder + "\FlowPanels\savedata\ScriptsLocations.fp") then
	(
		scpts = openfile (mainFPFolder + "\FlowPanels\savedata\ScriptsLocations.fp") mode:"r"
		scptsData = execute (readLine scpts)
		close scpts
	)
	else
		scptsData = Dictionary()

--------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------- // GLOBAL TOOL VARIABLES
--------------------------------------------------------------------------------------------------------------------------------------	
global SetGlobalFPData
global SetAutoSettings

global auto_FP_Settings = #()
global FP_Global_Settings = #()		
global use_SettingsRecorder
global use_AutoDocking
global use_AutoCollapse
global is_RolledUpOnStart
global use_StateSaving

-------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------

persistent global toolSetClosePos
global FP_Tools_Size

------------------------------------------------------------------------------------------------------------- 
--resets all settings from last session and distributes them to 
--the parameters set in memory intgrs.	--LOAD settings
------------------------------------------------------------------------------------------------------------- 

global useGlobalDotNam = (sysInfo.username as string)
		

--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------- // RECORDER VARIABLES
--------------------------------------------------------------------------------------------------------------------------------------

global set_noprompt_exp = false
global set_fbx_typ_checked = false
global set_obj_typ_checked = false
global set_autoType_checked = false
global set_use_ObjNam_checked = false
global set_Unity_Y_Up_checked = false
global set_typ_string = "."
global set_prefixText = "msh"
global set_exp_location = ""
global set_renamObjs = false
global set_list_last_sel = 1
global set_last_import_loc = ""
global set_import_array = #()
global set_import_file_type = 0
global set_imp_list_last_sel = 1
global set_primScale = 1.0
global set_Unit_Type = ""
global set_M_UT = true
global set_CM_UT = false
global set_INCH_UT = false
global set_lastExp_Fldr = ""
global set_bat_exp = false
global set_bypass_nam = false

global fps
global fpini
global ssLau

global 	newExpEntry = false

----------------------------------------------------------------------------------------------------------------------------------

global panFlowPan, panCreate, panModeling, panNormals, panPaint, panSubstance, panOrganize, panExporter, panImporter, panViewport

--------------------------------------------------------------------------------------------------------------------------------------
-- Flow Panels Toggles

global pOrgActive
global pCrtActive
global pModActive
global pNorActive
global pPaiActive
global pSubActive
global pExpActive
global pImpActive
global pVieActive
global pPreActive

----------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------- // GLOBAL TOOL SETTINGS
------------------------------------------------------------------------------------------------------------- 

--Sets the global tool settings 
if doesFileExist (mainFPFolder + "\FlowPanels\savedata\FPGlobals.fp")  then
(
	fpini = openfile (mainFPFolder + "\FlowPanels\savedata\FPGlobals.fp")
	FP_Global_Settings = execute (readLine fpini)
	close fpini
)
else
(
	------------------------01    02	03	  04       05      06    07    08    09    10    11    12    13    14    15		16
	FP_Global_Settings = #(true, true, true, true, [400,100], true, true, true, true, true, true, true, true, true, true, point2 260 300)		
)


------------------------------------------------------------------------------------------------------------- 
--Global Tool Settings
------------------------------------------------------------------------------------------------------------- 
	
use_SettingsRecorder 	= FP_Global_Settings[1]
use_AutoDocking			= FP_Global_Settings[2]
use_AutoCollapse 		= FP_Global_Settings[3]
is_RolledUpOnStart 		= FP_Global_Settings[4]
	
--remember position on close
toolSetClosePos 		= FP_Global_Settings[5]

pOrgActive 				= FP_Global_Settings[6]
pCrtActive 				= FP_Global_Settings[7]
pModActive 				= FP_Global_Settings[8]
pNorActive 				= FP_Global_Settings[9]
pPaiActive 				= FP_Global_Settings[10]
pSubActive 				= FP_Global_Settings[11]
pExpActive 				= FP_Global_Settings[12]
pImpActive 				= FP_Global_Settings[13]
pVieActive 				= FP_Global_Settings[14]
pPreActive 				= FP_Global_Settings[15]
	
--remember toolset size
FP_Tools_Size 			= FP_Global_Settings[16]

----------------------------------------------------------------------------------------------------------------------------------
		
global autoDockVal 			= use_AutoDocking
global SetautoRecorderOn 	= use_SettingsRecorder
global autoColPanels 		= use_AutoCollapse
global autoRolPanels 		= is_RolledUpOnStart
		

------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------- // RECORDER SETTINGS
------------------------------------------------------------------------------------------------------------- 

--Checks whether to load recorder settings or not
if (use_SettingsRecorder == true) then
(
	if doesFileExist (mainFPFolder + "\FlowPanels\savedata\\AutoSettings.fp") then
	(
		fps = openfile (mainFPFolder + "\FlowPanels\savedata\\AutoSettings.fp")
		auto_FP_Settings = execute (readLine fps)
		close fps
	)
	else 
	(
		auto_FP_Settings = #(false,false,false,false,false,false,".","msh","", false, 1, "", #(), 0, 1, 1.0, "", false, false, false, "", false, false)
	)
)
else 
(
	auto_FP_Settings = #(false,false,false,false,false,false,".","msh","", false, 1, "", #(), 0, 1, 1.0, "", false, false, false, "", false, false)
			
)

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------- // RECORDER PARAMETERS
----------------------------------------------------------------------------------------------------------------

	--set settings at start -- memory intgrs -- records settings
	set_noprompt_exp 		= auto_FP_Settings[1]
	set_fbx_typ_checked 	= auto_FP_Settings[2]
	set_obj_typ_checked 	= auto_FP_Settings[3]
	set_autoType_checked 	= auto_FP_Settings[4]
	set_use_ObjNam_checked 	= auto_FP_Settings[5]
	set_Unity_Y_Up_checked 	= auto_FP_Settings[6]
	set_typ_string 			= auto_FP_Settings[7]
	set_prefixText 			= auto_FP_Settings[8]
	set_exp_location 		= auto_FP_Settings[9]
	set_renamObjs			= auto_FP_Settings[10]
	set_list_last_sel		= auto_FP_Settings[11]
	set_last_import_loc		= auto_FP_Settings[12]
	set_import_array		= auto_FP_Settings[13]
	set_import_file_type    = auto_FP_Settings[14]
	set_imp_list_last_sel   = auto_FP_Settings[15]
	set_primScale			= auto_FP_Settings[16]
	set_Unit_Type			= auto_FP_Settings[17]
	set_M_UT				= auto_FP_Settings[18]
	set_CM_UT				= auto_FP_Settings[19]
	set_INCH_UT				= auto_FP_Settings[20]
	set_lastExp_Fldr		= auto_FP_Settings[21]
	set_bat_exp				= auto_FP_Settings[22]
	set_bypass_nam			= auto_FP_Settings[23]

------------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------------- 
global SaveRecorderSettings

--Saves Recorder Settings
fn SaveRecorderSettings = 
(
	--write to file
	fps = createFile (mainFPFolder + "\FlowPanels\savedata\\AutoSettings.fp")
		
	format (with printAllElements on auto_FP_Settings as string) to:fps
	--flush fps
	close fps
)

global SaveToolSettingsFP

--Saves Flow Panels Global Settings
fn SaveToolSettingsFP = 
(
		
	fpini = createFile (mainFPFolder + "\FlowPanels\savedata\\FPGlobals.fp")	
	format (with printAllElements on FP_Global_Settings as string) to:fpini
	flush fpini
	close fpini
		
)

------------------------------------------------------------------------------------------------------------- 

------------------------------------------------------------------------------------------------------------- 
-- sets the Global Tool Settings
fn SetGlobalFPData val intgr =
(
	FP_Global_Settings[intgr] = val
	print "Global Settings Saved"
	--print FP_Global_Settings
)
	
--sets the Settings to be saved
fn SetAutoSettings val intgr = 
(
	auto_FP_Settings[intgr] = val
)	




	global FP_DataLocation
	global FP_BaseLocation	
	global FP_RCLocation 
		
		
	--set locations
	FP_DataLocation	= (mainFPFolder as string + "\FlowPanels\_base\FlowSaveData.ms" ) as string
	FP_BaseLocation = (mainFPFolder as string + "\FlowPanels\_base\FlowToolsBase.ms") as string
	FP_RCLocation 	= (mainFPFolder as string + "\FlowPanels\_base\FlowRCMenu.ms") as string
	FP_Functions 	= (mainFPFolder as string + "\\FlowFunctions\\FlowFunctions.ms") as string
	FP_Create		= (mainFPFolder as string + "\\FlowFunctions\\FlowCreator.ms") as string
	FP_Attributes 	= (mainFPFolder as string + "\\FlowFunctions\\FlowObjectAttributes.ms") as string
		


-------------------------------------------------------------------------------------------------------------
-- Globals --------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------


global FlowDataStructure
global LoadLauncherDataFromXml
global ImportFlowSavedData
global 	PrimScale 	= set_primScale 

------------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------New Save System----
------------------------------------------------------------------------------------------------------------- 

--New Save System -- Create New Xml 
fn FlowDataStructure =  
(
	--Variables 
	LauncherDataNames = #("_root", "currentCategory", "currentLevel", "Art_Filter", "Design_Filter", 
		"Inst_Filter", "Prop_Filter", "Vehicle_Filter", "Weapon_Filter", "currentSelectedProject", "projectListSelection")
		
	FlowPanelsDataNames = #("quickExport", "fbxTypeExport", "objTypeExport", "autoTypeExport", "useSelectionsName", "UnityExport", 
		"exportTypeString", "prefixText", "exportLocation", "renameObjectsSetting", "lastExportSelection", "lastImportSelection", 
		"importList", "importFileType", "importListLastSelection", "pirmitiveScale", "unitType", "meterUnitType", "centimeterUnitType", 
		"inchUnitType", "lastExportFolder", "batchExportToggle", "bypassNaming")
		
	ToolsGlobalDataNames = #("settingsRecorder", "autoDock", "autoCollapse", "rolledUpOnStart", "toolsetClosePos", "OrganizePanel_Active", 
		"CreatePanel_Active", "ModelingPanel_Active", "NormalPanel_Active", "PaintingPanel_Active", "SubstancePanel_Active", "ExportPanel_Active", 
		"ImportPanel_Active", "ViewportPanel_Active", "PrefabPanel_Active", "toolsetSize")	
		
		
	--declare objects 	
	xmlDoc = dotNetObject "system.xml.xmlDocument"
	xmlWriter = dotNetClass "system.xml.xmlWriter"	
	xmlSettings = dotNetObject "system.xml.xmlWriterSettings"
	xmlEncoding = dotNetClass "system.Text.Encoding"
		
	-------------------------------------------------------
	-- XML WRITER DOC ---------------------------Begin-----	
	-------------------------------------------------------	
		
	xmlSettings.Encoding = xmlEncoding.UTF8
	xmlSettings.Indent = true
	xmlSettings.IndentChars = ("\t")
	xmlSettings.OmitXmlDeclaration = true
	xmlSettings.NewLineOnAttributes = true
		
	xmlWrtPath = (mainFPFolder+"\\FlowPanels\\savedata\\xmlDataWriter.xml" as string)
		
	--try 
	(
		--Create Writer Document --path		--settings 
		doc = xmlWriter.Create xmlWrtPath xmlSettings
			
		--Start Element -- Begin 
		doc.WriteStartElement "FlowToolsXMLData"
			
		--toolset data - Begin 
		-- Write an element (this one is the root).
        doc.WriteStartElement "Toolset_Data"
			
		-- Write the genre attribute.
		doc.WriteAttributeString "value" "SavedData"
		
		for i = 1 to launcherData.count do 
		(
			--Write the title.
			doc.WriteStartElement (LauncherDataNames[i] as string)
			doc.WriteAttributeString ("value") (launcherData[i] as string)
			
			--toolset data - End 
			doc.WriteEndElement()
		)		
			
		--Document - End 
		doc.WriteEndElement()
			
		--toolset data - Begin 
		-- Write an element (this one is the root).
        doc.WriteStartElement "Global_Settings_Data"
			
		-- Write the genre attribute.
		doc.WriteAttributeString "value" "GlobalData"
			
		for i = 1 to FP_Global_Settings.count do 
		(
			--Write the title.
			doc.WriteStartElement (ToolsGlobalDataNames[i] as string)
			doc.WriteAttributeString ("value") (FP_Global_Settings[i] as string)
			
			--toolset data - End 
			doc.WriteEndElement()
		)
			
		--Document - End 
		doc.WriteEndElement()
			
		--toolset data - Begin 
		-- Write an element (this one is the root).
        doc.WriteStartElement "Auto_Settings_Data"
			
		-- Write the genre attribute.
		doc.WriteAttributeString "value" "FlowPanelsAuto-Data"
			
		for i = 1 to auto_FP_Settings.count do 
		(
			--Write the title.
			doc.WriteStartElement (FlowPanelsDataNames[i] as string)
			doc.WriteAttributeString ("value") (auto_FP_Settings[i] as string)
			
			--toolset data - End 
			doc.WriteEndElement()
		)
			
		--Document - End 
		doc.WriteEndElement()
			
			
		--showMethods xmlEncoding
		--showProperties xmlEncoding
			
		doc.Flush()
		doc.Close()
	)
	--Catch("Failed to Save Data")
	-- XML WRITER DOC -----------------------------End-----
	-------------------------------------------------------		
			
	--
					
)	
	
--Create Xml File 
FlowDataStructure()


------------------------------------------------------------------------------------------------
--Load data from XML 
------------------------------------------------------------------------------------------------
fn LoadLauncherDataFromXml root = 
(
	TagsList = #()
	childNodes=root.childNodes
		
	for i = 0 to childNodes.Count-1 do 
	(
		ele = childNodes.ItemOf[i]
		eleName = ele.getAttribute "value"
			
		if eleName == "SavedData" then
		(
			eleChildren = ele.childNodes
				
			for i = 0 to eleChildren.count-1 do 
			(
				child = eleChildren.ItemOf[i]
				print (child.name as string + " = " + (child.getAttribute "value") as string)
			)
		)
			
	)
		
)


------------------------------------------------------------------------------------------------
--IMPORT XML AND LOAD DATA  
------------------------------------------------------------------------------------------------		
	
fn ImportFlowSavedData = 
(
		
	--load unity layers xml file
	struct flowData
	(
		public
			
		xmlDoc = dotNetObject "system.xml.xmlDocument",
			
		fn Constructor = 
		(
			
			return xmlDoc	
		),
		
		function LoadXml = 
		(
			--load XML
			xmlDoc.load (mainFPFolder+"\\FlowPanels\\savedata\\xmlDataWriter.xml" as string)
						
			--PLACE THIS IN THE STARTUP FOLDER
			if xmlDoc != undefined then
			(
				print ("Xml " + xmlDoc.name + " - Loaded")
			)
		),
			
		Initialize = Constructor()
			
	)
		
	flowDat = flowData()
	flowDat.LoadXml()
		
	--Load data 
	LoadLauncherDataFromXml flowDat.xmlDoc.DocumentElement name:"SavedData"
		
		
	--print ("Layers List - " + LayersList as string)
	--print ("Tags List - " + TagsList as string)
	--print ("Attributes List - " + AttrList as string)
		
)

--load data 
ImportFlowSavedData()








	