
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
	
