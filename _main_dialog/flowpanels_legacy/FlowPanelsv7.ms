--------------------------------------------------------------------------------------------------------------------------------------
--GLOBAL ACCESSIBLE 
--------------------------------------------------------------------------------------------------------------------------------------
---	include "startup/FlowFunctions.ms"
		
	global toolIsOpen = true
	global toolLoc 	= getThisScriptFilename() as string
		
---------------------------------------------------------------------------------------------------------------- // Tool Settings
--Tool Settings 

--try(closeRolloutFloater newwind)catch()
Try(cui.UnregisterDialogBar panFlowPan)catch()
Try(destroydialog panFlowPan)catch()

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------- // GLOBAL SETTINGS
--------------------------------------------------------------------------------------------------------------------------------------

global panFlowPan, panCreate, panModeling, panNormals, panPaint, panOrganize, panExporter, panImporter panViewport

--------------------------------------------------------------------------------------------------------------------------------------

persistent global toolSetClosePos
global FPHeight = Point2 0 1100 

------------------------------------------------------------------------------------------------------------- 
--resets all settings from last session and distributes them to 
--the parameters set in memory intgrs.	--LOAD settings
------------------------------------------------------------------------------------------------------------- 

global useGlobalDotNam = (sysInfo.username as string)


--------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------// LOAD PRESET LIST
--------------------------------------------------------------------------------------------------------------------------------------

global savedData = Dictionary()
global impSavedData = Dictionary()
global scptsData = Dictionary()

global savedProjectData = #()

--------------------------------------------------------------------------------------------------------------------------------------
-- Auto-Load Export Preset Locations on Start-up
if savedData.count == 0 then 
(	
		
	if (ss = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\PresetLocations.fp") != undefined) then
	(
		ss = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\PresetLocations.fp") mode:"r"
		savedData = execute (readLine ss)
		close ss
	)
)
-- else
-- 	savedData = Dictionary()
		
--------------------------------------------------------------------------------------------------------------------------------------
-- Auto-Load Export Preset Locations on Start-up
if impSavedData.count == 0 then 
(	
		
	if (doesFileExist ("C:\\Users\\"+ useGlobalDotNam +"\\PresetImportLocations.fp")) then
	(
		impss = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\PresetImportLocations.fp") mode:"r"
		impSavedData = execute (readLine impss)
		close impss
	)
)
-- else
-- 	impSavedData = Dictionary()

--------------------------------------------------------------------------------------------------------------------------------------
-- Scripts Launch Preset Locations on Start-up
if scptsData.count == 0 then 
(	
	
	if (doesFileExist("C:\\Users\\"+ useGlobalDotNam +"\\ScriptsLocations.fp")) then
	(
		scpts = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\ScriptsLocations.fp") mode:"r"
		scptsData = execute (readLine scpts)
		close scpts
	)
)
-- else
-- 	scptsData = Dictionary()
		
--------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------- // GLOBAL TOOL VARIABLES
--------------------------------------------------------------------------------------------------------------------------------------
persistent global auto_FP_Settings
persistent global FP_Global_Settings
global use_SettingsRecorder
global use_AutoDocking
global use_AutoCollapse
persistent global is_RolledUpOnStart

--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------- // RECORDER VARIABLES
--------------------------------------------------------------------------------------------------------------------------------------
global set_noprompt_exp
global set_fbx_typ_checked
global set_obj_typ_checked
global set_autoType_checked
global set_use_ObjNam_checked
global set_Unity_Y_Up_checked
global set_typ_string
global set_prefixText
global set_exp_location
global set_renamObjs
global set_list_last_sel
global set_primScale
global set_Unit_Type
global set_M_UT
global set_CM_UT
global set_INCH_UT
global set_lastExp_Fldr
global set_bat_exp
global set_bypass_nam


global fps
global fpini

---------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------- // GLOBAL TOOL SETTINGS
---------------------------------------------------------------------------------------------------------------


--Sets the global tool settings 
-- if FP_Global_Settings == undefined then
-- (
	if (doesFileExist ("C:\\Users\\"+ useGlobalDotNam +"\\FPGlobals.fp") ) then
	(
		fpini = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\FPGlobals.fp")
		FP_Global_Settings = execute (readLine fpini)
		close fpini
	)
	else
	(
		FP_Global_Settings = #(true, true, true, true, [400,100])
	)
-- )


------------------------------------------------------------------------------------------------------------- 
--Global Tool Settings
------------------------------------------------------------------------------------------------------------- 
	
use_SettingsRecorder 	= FP_Global_Settings[1]
use_AutoDocking			= FP_Global_Settings[2]
use_AutoCollapse 		= FP_Global_Settings[3]
is_RolledUpOnStart 		= FP_Global_Settings[4]

--remember position on close
if FP_Global_Settings[5] == undefined then
(
	toolSetClosePos = [400,100]
)
else
(
	toolSetClosePos = FP_Global_Settings[5]
)

------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------- // RECORDER SETTINGS
------------------------------------------------------------------------------------------------------------- 

--Checks whether to load recorder settings or not
if (use_SettingsRecorder == true) then
(
	if ( doesFileExist ("C:\\Users\\"+ useGlobalDotNam +"\\AutoSettings.fp")) then
	(
		fps = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\AutoSettings.fp")
		auto_FP_Settings = execute (readLine fps)
		close fps
	)
	else
	(
		auto_FP_Settings = #(false,false,false,false,false,false,".","msh","", false, 1, "", #(), 0, 1, 50.0, "", false, false, false, "", false, false)
	)
)
else 
(
	auto_FP_Settings = #(false,false,false,false,false,false,".","msh","", false, 1, "", #(), 0, 1, 50.0, "", false, false, false, "", false, false)
)


------------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------------- 

--Saves Recorder Settings
fn SaveRecorderSettings = 
(
		
-- 	if (doesFileExist ("C:\\Users\\"+ useGlobalDotNam +"\\AutoSettings.fp")) then 
-- 	(
-- 		fps = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\AutoSettings.fp") mode:"w+"
-- 		
-- 		format (with printAllElements on auto_FP_Settings as string) to:fpini
-- 		--auto_FP_Settings = execute (readLine fps)
-- 		flush fps
-- 		close fps
-- 		
-- 	)
-- 	else
--	(
		--write to file
		fps = createFile ("C:\\Users\\"+ useGlobalDotNam +"\\AutoSettings.fp")
			
		format (with printAllElements on auto_FP_Settings as string) to:fps
		--flush fps
		close fps
--	)
)

--Saves Flow Panels Global Settings
fn SaveToolSettingsFP = 
(
		
	fpini = createFile ("C:\\Users\\"+ useGlobalDotNam +"\\FPGlobals.fp")	
	format (with printAllElements on FP_Global_Settings as string) to:fpini
	--flush fpini
	close fpini
		
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
-- sets the Global Tool Settings
fn SetGlobalFPData val intgr =
(
	FP_Global_Settings[intgr] = val
	print "SAVED THE DAMN SETTINGS"
	print FP_Global_Settings
)
		
--sets the Settings to be saved
fn SetAutoSettings val intgr = 
(
	auto_FP_Settings[intgr] = val
)	
		
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
		
global autoDockVal = use_AutoDocking
global SetautoRecorderOn = use_SettingsRecorder
global autoColPanels = use_AutoCollapse
global autoRolPanels = is_RolledUpOnStart
		
----------------------------------------------------------------------------------------------------------------------------------
rcMenu ToolSettingsMenu
----------------------------------------------------------------------------------------------------------------------------------
(	
	submenu "- Panels -" 
	(
		submenu "Collapse Options"
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
			
		submenu "Start-Up Options"
		(		
			menuItem itmChkDock "Auto-Dock" checked:autoDockVal --enabled:true
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
		webBrowser.Url = dotNetObject "System.Uri" "http://help.autodesk.com/view/3DSMAX/2018/ENU/"
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
			
		messagebox ( "About: Flow Panels Toolset \n" + "\n" + "Version: " + str + "\n" +  "\n Copyright ©2018 Alberto Rodriguez")
	)
		
	--Reload toolset
	on itmReloadTool picked do
	(
		fileIn (getThisScriptFilename() as string)
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
	
)
		
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------- // FUNCTIONS

-- UNITY EXPORTER
---------------------------------------------------------------------------------------------------------------
global unityYUp

fn unityYUp obj = 
(	
	rot = eulerToQuat(eulerAngles 90 0 0)
			
	Select obj
	ResetXForm obj
	modPanel.addModToSelection (XForm ()) ui:on
	obj.modifiers[#XForm].gizmo.rotation += rot as quat
	rotate obj (inverse rot as quat)
	for obj in (selection as array) do 
	( 
		convertToPoly obj
		
	) 	
		
)
		
-- SET NORMALS 
---------------------------------------------------------------------------------------------------------------
global wnmodname = "Set Normals"

-- returns angle between two vectors
fn AngleBetweenVectors v1 v2 =
(
	return (acos (dot (normalize v1) (normalize v2) ) )
)
		
-- get weighted normals modifier
fn GetModifier obj =
(
	for i=1 to obj.modifiers.count do
	(
		local mf = obj.modifiers[i]
		if (classof mf) == Edit_Normals do
		(
			if (mf.name == wnmodname) then 
			(
				return mf
			) 
			else 
			(
				return undefined
			)
		)
	)
		
	return undefined
		
)
		
-- generates weighted normals
fn GenWeightedNormals obj =
(
	-- filter
	if (superClassOf obj) != GeometryClass do return false
	 
	-- add mesh modifier
	if (classOf obj) != Editable_Mesh do
	(
		addModifier obj (Edit_Mesh())
	)
 
-- detect existing modifier
local mf = GetModifier obj

-- modifier not found, create one
if mf == undefined do
(
	addModifier obj (Edit_Normals())
	mf = obj.modifiers[#Edit_Normals]
	mf.name = wnmodname
)
 
-- workaround for 3dsmax bug
select obj
max modify mode
  
-- build face area array
local facearea = #()
facearea.count = obj.numFaces
for i=1 to obj.numFaces do
(
	facearea[i] = (meshop.getFaceArea obj i)
)
 
-- build face angle array
local faceangle = #()
faceangle.count = obj.numFaces
for i=1 to obj.numFaces do
(
	local f = getFace obj i
	local v1 = getVert obj f[1]
	local v2 = getVert obj f[2]
	local v3 = getVert obj f[3]
	local a1 = AngleBetweenVectors (v2-v1) (v3-v1) -- todo: optimize
	local a2 = AngleBetweenVectors (v1-v2) (v3-v2)
	local a3 = AngleBetweenVectors (v1-v3) (v2-v3)
	faceangle[i] = [a1,a2,a3]
)
 
-- get number of normals
local normNum = mf.GetNumNormals()

-- allocate array
local norms = #()
norms.count = normNum

for i=1 to normNum do
(
	norms[i] = [0,0,0]
)
 
-- loop faces
for i=1 to obj.numFaces do
(
	-- get face normal
	in coordsys local n = getFaceNormal obj i
		
	-- accumulate
	for j=1 to 3 do
	(
		local id = mf.GetNormalID i j
		norms[id] = norms[id] + (n * facearea[i] * faceangle[i][j])
	)
)
 
	-- set normals
	for i=1 to normNum do
	(
		-- make explicit
		mf.SetNormalExplicit i explicit:true
		
		-- set normal vector
		mf.SetNormal i (normalize norms[i])
		
	)
)
		
--------------------------------------------------------------------------------------------------------------------------------------
		
		
	--forgot what this does -- shit -- 
	if classOf roExample == RolloutClass do DestroyDialog roExample
		
---------------------------------------------------------------------------------------------------------------	
	
---------------------------------------------------------------------------------------------------------------- // Main GUI
-- Main GUI - Scripts and Tools
--------------------------------------------------------------------------------------------------------------------------------------
rollout panFlowPan ("Flow Panels Toolset - " + "Hi, " + useGlobalDotNam as string)
	
--------------------------------------------------------------------------------------------------------------------------------------
	
--------------------------------------------------------------------------------------------------------------------------------------	
(
	--ROLLOUT CONTROLS
	subRollout scriptBin width:(panFlowPan.width as float -10) pos:[5,5] height:(FPHeight.y)

	fn switchRolls openedRoll =
	(
		for roll in panFlowPan.rolls where roll != openedRoll do 
		(
			roll.open = false
		)
	)
		
	---------------------------------------------------------------------------------------------------------------- // Selection Panel 
	-- Selection Panel
		
	Rollout panOrganize "Organize Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
	---------------------------------------------------------------------------------------------------------------// Banner 	
		
	---------------------------------------------------------------------------------------------------------------// Selection
		
		
		group "Selection Type:" 	
		(
			button btn_selname "Name Select" 	width:80 height: 20 	across:2 	align:#center
			button btn_selsim "Select Similar" 	width:80 height: 20 				align:#center
			button btn_selclr "Select By Color" width:80 height: 20 	across:2	align:#center
			button btn_selset "Selection Sets" 	width:80 height: 20 				align:#center
		)
			
		group "Layers:"
		(
			Button btn_setLay "Create Layer from Selection" width:180 height: 30
			checkbox multiLay "Create Multiple Layers of Selection"	
		)
			
	---------------------------------------------------------------------------------------------------------------// Current Selection Function
		
		--create layer from selection 
		on btn_setLay pressed do 
		(
			if multiLay.checked then 
			(
				selGroup = selection as array
				
				for i in selGroup do
				(	
					lay = LayerManager.NewLayer()
						
					lay.addnode i
					lay.setname (i.name as string)
				)
			)
			else 
			(
				lay = LayerManager.NewLayer()
						
				selGroup2 = selection as array
						
				for i in selGroup2 do
				(	
					lay.addnode i
						
				)
						
				sel = selGroup2[1]
					
				lay.setname (sel.name as string)
			)					
		)
		
		
		on btn_selset pressed do
		(
			macros.run "Edit" "namedbtn_selsets"
		)
		
		
		on btn_selclr pressed do
		(
			max select by color
		)
			
		on btn_selsim pressed do
		(
			actionMan.executeAction 0 "40099" 
		)
			
		On btn_selname pressed do 
		(
			hitByNameDlg()
		)
			
			
	---------------------------------------------------------------------------------------------------------------// Clean Up Controls
		
		Group "Clean-Up:"
		(
			button selNQ "Sel. NGons" 		width:80 	height: 20	across:2 	align:#center
			button selOF "Sel. Open" 		width:80 	height: 20				align:#center
-- 			button selMCU "Mesh CleanUp" 	width:160 	height: 30				align:#center
		)


		On selNQ pressed do 
		(
			for i in selection do 
			(
				NQmod = edit_poly()
				NQMod.name = "CLEAN-UP: N-Gons"
				addModifier $ NQMod
				subobjectLevel = 4
				macros.run "PolyTools" "NonQuad"
			)
		)

		On selOF pressed do 
		(
			for i in selection do 
			(
				OFmod = edit_poly()
				OFMod.name = "CLEAN-UP: Open Faces"
				addModifier $ OFMod
				subobjectLevel = 3
				macros.run "PolyTools" "OpenSelect"
			)
		)
		
		On selMCU pressed do
		(
			macros.run "rapidTools" "rapidMeshCleanUp"
		)	
			
		-------------------------------------------------------------------------------------------------------------------------------------
		--OPEN // CLOSED
		-------------------------------------------------------------------------------------------------------------------------------------
			
		on panOrganize rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panOrganize
			)
		)
	)
	
	---------------------------------------------------------------------------------------------------------------- // Create Panel 
	-- Create Panel Controls 

	Rollout panCreate "Create - Launch Panel" 
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
		
	----------------------------------------------------------------------------------------------------------------
	--Variables 
		
		local 	PrimiPlaceOrigin 		= true
		local 	PrimiPlaceSelection 	= false
		local 	valueForPrims 			= set_primScale
		global 	PrimScale 				= set_primScale 
		
	----------------------------------------------------------------------------------------------------------------	
	--Primitives Group Controls
		group "Primitive Placement:"
		(
			radiobuttons rbtn_plc_prv ""default:1 labels:#("Origin", "Selection") tooltip:"" columns:2 
		)
		group "Primitive Scale"
		(
			spinner c_PrimText "Primitive Scale" range:[0,999999999, valueForPrims] 
		)
		group "Primitives:" 
		(
			button c_Box 		"Box" 			width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,1,1,1,1) 		ToolTip: "Create Box"  			across:5
			button c_Cylinder 	"Cylinder" 		width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,3,3,1,1) 		ToolTip: "Create a Cylinder"
			button c_Sphere 	"Sphere" 		width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,2,2,1,1) 		ToolTip: "Create Sphere"
			button c_Tube 		"Tube"  		width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,8,8,1,1) 		ToolTip: "Create Tube"
			button c_Plane 		"Plane"  		width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,10,10,1,1) 		ToolTip: "Create Plane"
			button c_Cone 		"Cone" 			width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,6,6,1,1) 		ToolTip: "Create Cone"  		across:5
			button c_Pyramid 	"Pyramid" 		width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,9,9,1,1) 		ToolTip: "Create Pyramid"  
			button c_Geosphere  "GeoSphere" 	width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,7,7,1,1) 		ToolTip: "Create GeoSphere"  
			button c_Torus 		"Torus" 		width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,4,4,1,1) 		ToolTip: "Create Torus" 
			button c_TxtPlus 	"Text Plus" 	width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,11,11,1,1) 		ToolTip: "Create Text+"  
		)
			
		--Primitive Scale
		on c_PrimText changed val do 
		(			
			--Create Value 
			PrimScale 	 		= val
			
			--Record Settings -- Primitve Scale Value
			SetAutoSettings PrimScale 16
			
		)
			
		--RadioButtons - Placement Position 
		on rbtn_plc_prv changed state do 
		(
			if rbtn_plc_prv.state == 2 do 
			(
				PrimiPlaceOrigin = false
				PrimiPlaceSelection = true
				print ("Primitive Place on selection is " + PrimiPlaceSelection as string )
			)
				
			if rbtn_plc_prv.state == 1 do 
			(
				PrimiPlaceOrigin = true
				PrimiPlaceSelection = false
				print ("Primitive Place on origin is " + PrimiPlaceOrigin as string )
			)
		)
		
		--Button Function - Create Box 
		on c_Box pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeBox
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeBoxSel
			)
		)
		
		--Button Function - Create Cylinder 
		on c_Cylinder pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeCyl
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeCylSel
			)
		)
			
		--Button Function - Create Sphere
		on c_Sphere pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeSph
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeSphSel
			)
		)
			
		--Button Function - Create Tube
		on c_Tube pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeTub
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeTubSel
			)
		)
			
		--Button Function - Create Plane
		on c_Plane pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makePlane
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makePlaneSel
			)
		)
			
		--Button Function - Create Cone
		on c_Cone pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeCone
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeConeSel
			)
		)
		
		--Button Function - Create Pyramid		
		on c_Pyramid pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makePyra
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makePyraSel
			)
		)
		
		--Button Function - Create GeoSphere
		on c_Geosphere pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeGeo
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeGeoSel
			)
		)
		
		--Button Function - Create Torus
		on c_Torus pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeTor
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeTorSel
			)
		)
		
		--Button Function - Create TextPlus
		on c_TxtPlus pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeTex
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeTexSel
			)
		)
		
	----------------------------------------------------------------------------------------------------------------
		
		Group "Shapes:"
		(
			button myBttn10 "Spline"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,1,1,1,1 ) 		ToolTip: "Create Spline" 	across: 5
			button myBttn15 "Circle"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,2,2,1,1 ) 		ToolTip: "Create Circle"
			button myBttn16 "Arc"  		width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,3,3,1,1 ) 		ToolTip: "Create Arc"
			button myBttn17 "NGon"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,4,4,1,1 ) 		ToolTip: "Create NGon"
			button myBttn18 "Text"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,5,5,1,1 ) 		ToolTip: "Create Text"
			button myBttn19 "Rectangle" width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,7,7,1,1 ) 		ToolTip: "Create Rectangle" across:5
			button myBttn20 "Ellipse"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,8,8,1,1 ) 		ToolTip: "Create Ellipse"
			button myBttn21 "Donut"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,9,9,1,1 ) 		ToolTip: "Create Donut"
			button myBttn22 "Star"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,10,10,1,1 ) 	ToolTip: "Create Star"
			button myBttn23 "Helix"  	width:32 align:#align_topleft  	images:#("Splines_24i.bmp", "Splines_24i.bmp",11,11,11,1,1 ) 	ToolTip: "Create Helix"
		)
		
		--Button Function - Create Spline
		on myBttn10 pressed do
		(
			startObjectCreation line		
		)
		--Button Function - Create Circle
		on myBttn15 pressed do
		(
			
			startObjectCreation circle	
			
		)
		--Button Function - Create Arc
		on myBttn16 pressed do
		(
			
			startObjectCreation arc	
			
		)	
		--Button Function - Create Ngon
		on myBttn17 pressed do
		(
			
			startObjectCreation ngon
			
		)	
		--Button Function - Create Text
		on myBttn18 pressed do
		(
			
			startObjectCreation text
			
		)	
		--Button Function - Create Rectangle
		on myBttn19 pressed do
		(
			
			startObjectCreation rectangle
			
		)	
		
		on myBttn20 pressed do
		(
			
			startObjectCreation ellipse
			
		)	
		--Button Function - Create  Donut
		on myBttn21 pressed do
		(
			
			startObjectCreation donut	
			
		)
		--Button Function - Create Star
		on myBttn22 pressed do
		(
			
			startObjectCreation star
			
		)
		--Button Function - Create Helix
		on myBttn23 pressed do
		(
			
			startObjectCreation helix
			
		)
		
	---------------------------------------------------------------------------------------------------------------- HELPERS
		
		group "Helpers:" 
		(
				
			button c_Point "Point" 							width:32 height: 32 align:#align_topcleft images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,2,2,1,1 ) ToolTip:"Create Point" across:5
			button c_Grid "Active Grid" 					width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,4,4,1,1 ) ToolTip:"Create Grid Helper" 
			button c_Container "Container" 					width:32 height: 32 align:#align_topleft  images:#("Containers_24i.bmp", "Containers_24i.bmp",17,2,2,1,1 ) ToolTip:"Create Container" 
			button c_Dummy "Dummy"  						width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,1,1,1,1 ) ToolTip:"Create Dummy Helper" 
			button c_TapeMeasure "Tape Measure"  			width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,5,5,1,1 ) ToolTip:"Create Dummy Helper" 
			
		)
			
		--Button Function - Create Point
		on c_Point pressed do
		(
			hlp_point = 0 
			Point pos:[0,0,0] size:PrimScale isSelected:on	
			$.name = "hlpr_point_" 	+ hlp_point as string
			$.name = uniquename("hlpr_point_")
		)
			
		--Button Function - Create Dummy
		on c_Grid pressed do
		(
			hlp_grid = 0 
			grid length:10 width:10 grid:50 pos:[0,0,0] isSelected:on
			$.name = "hlpr_grid_" + hlp_grid as string
			$.name = uniquename("hlpr_grid_")
			
		)
			
		--Button Function - Create Container
		on c_Container pressed do
		(
			-- place on origin of world
			if PrimiPlaceOrigin do 
			(
				macros.run FlowMaker makeCont
			)
			-- place on selection's pivot point
			if PrimiPlaceSelection and selection.count == 1 do 
			(
				macros.run FlowMaker makeContSel
			)
				
		)
			
		--Button Function - Create Spline
		on c_Dummy pressed do
		(
			
			hlp_dum = 0 
			Dummy pos:[0,0,0] isSelected:on
			$.name = "hlpr_node_" + hlp_dum as string
			$.name = uniquename("hlpr_node_")
			$.scale = [PrimScale/10, PrimScale/10, PrimScale/10]
			
		)
		
		--Button Function - Create Cone
		on c_TapeMeasure pressed do
		(
			
			hlp_dum = 0 
			Tape length:100 pos:[0,0,0] isSelected:on target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [100,0,0]))
			$.name = "hlpr_node_" + hlp_dum as string
			$.name = uniquename("hlpr_node_")
			
		)
			
		---------------------------------------------------------------------------------------------------------------- INSTANCES
		group "Instances:" 
		(
			button c_CreateContainers "Create Instance" 	width: 160
			button c_LoadContainer "Load Instance"  		width: 160
		)
		
		--Button Function - Load Instances
		on c_LoadContainer pressed do
		(		
			actionMan.executeAction -1172021248 "0"  -- Containers: Inherit Container
		)
			
		--Button Function - Create Container
		on c_CreateContainers pressed do
		(
			--selection variable
			selgroup = selection as array 
			
			undo on
			-- place on selection's pivot point
			for i in selgroup do 
			(					
					
				--position variable
				place = i.pos
					
				--places container on selection's pivot 
				myCont = Container isSelected:on allowInPlaceEditing:true pos:Place size:1 displayLabel:true
					
				--adds node to container
				myCont.AddNodeToContent i
					
				--names container
				myCont.name = "inst_" + i.name as string
				myCont.wirecolor = (color 13 229 155)
				myCont.size = PrimScale
					
				--Creates a layer for each selected container and names it accordingly			
				layer = LayerManager.newLayer()
				layer.setname (myCont.name as string)
				layer.addnode i
				layer.addnode myCont
					
			)
			completeRedraw() 
			forceCompleteRedraw doDisabled:true 
				
		)
		
		
	-------------------------------------------------------------------------------------MaxScripts Group Controls
			
		local lauFileNam 
			
		group "Launch MaxScripts" 
		(
			editText lau_Scp_Pth "Script:" 
			
			DropDownList lau_scripts "" items:#()
			button btn_scp_add "Add to List"			width:65	align:#left 	across:3
			button btn_scp_edt "Edit Entry"				width:60	align:#right
			button btn_scp_dlt "Delete List"			width:62	align:#right
			button btn_scp_lau "Launch Script"			width:190	align:#center
		)	
			
			
		-----------------------------------------------------------------------------------------------------------------------
		--SAVE SCRIPTS LIST
		-----------------------------------------------------------------------------------------------------------------------
			
		fn SaveLauScripts = 
		(
			local usedotNam = sysInfo.username as string
			
			if lau_scripts.items.count != 0 do
			(
				--write to file
				ssLau = createFile ("C:\\Users\\"+ usedotNam +"\\ScriptsLocations.fp") mode: "w"
				
				format "%\n" (with printAllElements on scptsData as string) to:ssLau
				--flush ssLau
				close ssLau
				
				--records settings
-- 				set_imp_list_last_sel = scptsData.selection
-- 				SetAutoSettings set_imp_list_last_sel 15
				
			)
		)
		
			
		on lau_scripts selected i do
		(
				
			local usedotNam = sysInfo.username as string
				
			--what happens when you select an item
			for i = 1 to lau_scripts.selection do
			(
				--adds item value to Export Folder Location
				str = ("#" + lau_scripts.selected as string)
				str2 = GetDictValue scptsData (execute str)	
				
				--grab folder path and set as item in array
				if str2 != undefined then
				(
					fldr = str2
						
					--tooltip 
					lau_Scp_Pth.tooltip = fldr as string
						
					--grab folder path and set as item in array
					lauFileNam = fldr
				)
					
				lau_Scp_Pth.text = lau_scripts.items[i]
					
				--records settings
				
			)
				
		)
			
		on btn_scp_add pressed do 
		(
			
			try destroyDialog lauWndw catch()
			rollout lauWndw "Add Script to List"
			(
				edittext entNam "Entry Name:" 		width:200	height:20								text:"#"  
				edittext valNam "Path:" 			width:500	height:30								text:""  
				button imp_Open "Find Script"		width:110	height:20		align:#center			across:1
				button btn_add_scpt "Add Script"	width:110	height:20		align:#center
				button imp_dlt_Entry "Close"  		width:110	height:20		align:#center
					
				----------------------------------------------------------------------------------
					
				on imp_Open pressed do 
				(
					str = getOpenFileName caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") --initialDir:
						
					if str != undefined then 
					(
						--clean up string for entry name
						strNew = str
						strNew = filenameFromPath str
						strNew = substituteString strNew ".mse" ""
						strNew = substituteString strNew ".ms" ""
						strNew = substituteString strNew ".mcr" ""
						strNew = substituteString strNew "." ""
						strNew = substituteString strNew "-" "_"	
						strNew = substituteString strNew " " "_"	
							
						entNam.text = strNew 
						valNam.text = str
						lauFileNam = str
					)
						
				)
					
				on btn_add_scpt pressed do
				(
						
					if entNam.text != "#" then 
					(
							
						local scptSter =  ("#"+filenameFromPath entNam.text) --("#" + lau_scripts.selected as string)
							
						local scptSter2 = GetDictValue scptsData (execute scptSter)
							
						lau_Scp_Pth.text = scptSter
							
						--adds Key value
						PutDictValue scptsData (execute scptSter) (valNam.text as string)  putOnlyIfNew:true
						--SetDictValue scptsData (execute scptSter) (valNam.text as string)
							
						lau_scripts.items = scptsData.keys
							
						destroyDialog lauWndw
							
						--Save The List
						SaveLauScripts()
						
					)
						
				)
					
				----------------------------------------------------------------------------------
					
				on imp_dlt_Entry pressed do 
				(
					
					destroyDialog lauWndw
				)
					
				----------------------------------------------------------------------------------
					
				on valNam entered val do
				(
						
					destroyDialog lauWndw
				)
					
				----------------------------------------------------------------------------------				
					
					
			)			
				
			createDialog lauWndw width:525
			
		)
			
		on btn_scp_dlt pressed do
		(
			local usedotNam = sysInfo.username as string
				
			ss = ("C:\\Users\\"+ usedotNam +"\\ScriptsLocations.fp")
				
			deletefile (ss)
			free scptsData
			lau_scripts.items = scptsData.keys
			
		)
		
			
		on btn_scp_lau pressed do 
		(
			if lauFileNam != undefined then
			(
				filein lauFileNam
			)
		)
			
		-----------------------------------------------------------------------------------------------------------------------
		--OPEN // CLOSED 
		-----------------------------------------------------------------------------------------------------------------------
		on panCreate rolledUp open do 
		(
				
			lau_scripts.items = scptsData.keys
				
				
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panCreate
			)	
		)
			
-- 		on panCreate rolledUp close do 
-- 		(
-- 			
-- 		)
			
	)	
		
	------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// MODELING PANELS 
	--------------------------------------------------------------------------------------------------------------------------------------
		
	------------------------------------------------------------------------------------------------------------------------------------
		
	Rollout panModeling "Modelling Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
		---------------------------------------------------------------------------MODELING TOOLS GROUP CONTROLS 
		-------------------------------------------------------------------------------------------------	
		
-- 		Group "Object Display"
-- 		(
-- 			
-- 		button laun_objprops "Object Properties" width: 160 Height: 30
-- 			
-- 		)
			
		-------------------------------------------------------------------------------------------------
		on laun_objprops pressed do 
		(
			filein "D:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_main_dialog\functions\object_props.ms" 
		)
			
		-------------------------------------------------------------------------------------Utilities Group Controls
		Group "Utilities"	
		( 
				
			Label	lbl_dash1_label "------------- Pivot Axis -------------"	align:#center 
				
			checkbutton chkbtn_X  	"X"						width: 50	across:3
			checkbutton chkbtn_Y	"Y"						width: 50
			checkbutton chkbtn_Z	"Z"						width: 50	
				
			Label	lbl_dash2_label "------------- Pivot Tools -------------"	align:#center
				
			button btn_min_axis "Min"						width: 50	across:3
			button btn_cen_axis "Cntr"						width: 50
			button btn_max_axis "Max"						width: 50	
			edittext edt_unt_amt "Increment Pivot:"			width:160		
			button btn_unt_min 	"-"							width: 50	across:2	
			button btn_unt_plus "+"							width: 50
			
			Label	lbl_dash3_label "------------ Pivot Actions ------------"	align:#center
				
			button btn_piv_orig "Pivot to World Origin" 	width:165			tooltip: "Pivot to Origin"		
			button btn_piv_cnt "Pivot to Center" 			width:165					tooltip: "Pivot to Center"	
			button btn_piv_sel "Pivot to Vert Selection"	width:165	align:#center
			pickbutton pb_ps 	"Grand Theft Pivot" 		width:165	align:#center
				
			Label	lbl_dash_label2 "----------- Modeling Tools -----------"	align:#center 
				
			button btn_snd2_orig "Send to Origin"			width: 80	across:2		tooltip: "Send to Center of World"
			button btn_snd2_grid "Send to Grid"				width: 80					tooltip: "Send to Grid Space"
			button btn_comObj "Combine"						width: 80	across:2		tooltip: "Insets and Collapses a Face" 
			button btn_cull_tog "Culling" 					width: 80 					 
			button btn_setFlow "Set Flow" 					width: 80 	across:2		tooltip: "Adjust Edge Flow of Selected Edges"  
			button btn_weldVerts "Weld Verts"				width: 80					tooltip: "Welds all verts on a single mesh.\n Only works on verts that are on top of each other. Use this as clean up."
			button btn_zerObj "Reset Object"					width: 80	across:2
			button btn_quick_copy "Quick Copy" 				width: 80	
			button btn_reset_trans "Reset Xform"			width: 80   across:2		 
			button btn_qck_dtach "Detach"					width: 80	
			button btn_UVW_map "UVW Map"					width: 80	across:2
			button btn_dubSmt "Double Smooth"				width: 80 					tooltip: "Insets and Collapses a Face" 
			button btn_delLoop "Delete Loop" 				width: 80	across:2 		tooltip: "Cleanly Remove Edge Loop from Selected Edge"
			button btn_texChk "Scale UVs" 						width: 80 							
				
		)
			
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS to MIN		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_min_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.min.x, i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.min.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.min.z]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS to CENTER		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_cen_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.center.x, i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.center.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.center.z]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS to MAX
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_max_axis pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.max.x, i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.max.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.max.z]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS - MINUS - UNIT		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_unt_min pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x - (edt_unt_amt.text as float), i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y - (edt_unt_amt.text as float), i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.pivot.z - (edt_unt_amt.text as float)]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT AXIS - PLUS - UNIT		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_unt_plus pressed do
		(
			undo on
				
			selObjs = selection
				
			case chkbtn_X.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x + (edt_unt_amt.text as float), i.pivot.y, i.pivot.z]
						)
					)
			)
			case chkbtn_Y.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y + (edt_unt_amt.text as float), i.pivot.z]
						)
					)
			)
			case chkbtn_Z.state of 
			(
				true: 
					( 	
						for i in selObjs do 
						(		
							i.pivot = [i.pivot.x, i.pivot.y, i.pivot.z + (edt_unt_amt.text as float)]
						)
					)
			)
				
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- GRAND THEFT PIVOT 	
		------------------------------------------------------------------------------------------------------------------------------------
			
		on pb_ps picked obj do 
		(
			sel = selection as array
			
			--steal's the pivot from the picked object
			if sel != undefined do 
			sel.pivot = obj.pivot
			
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- PLACE PIVOT ON SELECTION
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_piv_sel pressed do 
		(		
			macros.run FlowPanels PivtoVerts
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- SEND TO ORIGIN		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_snd2_orig pressed do
		(
			Undo on
			for i in selection do 
			(
				i.pos = [0,0,0]
			)
-- 			if selection.count == 0 do
-- 			(
-- 				messagebox "oops, you didn't select anything!" title:"Flow Panels"
-- 			)
			
		)
		------------------------------------------------------------------------------------------------------------------------------------
		-- SEND TO ORIGIN		
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_snd2_grid pressed do
		(
			Undo on
			for i in selection do 
			(
				i.pos = [i.pos.x,i.pos.y,0]
			)
-- 			if selection.count == 0 do
-- 			(
-- 				messagebox "oops, you didn't select anything!" title:"Flow Panels"
-- 			)
			
		)
		------------------------------------------------------------------------------------------------------------------------------------	
		-- PIVOT TO ORIGIN				
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_piv_orig pressed do
		(
			Undo on
			for i in selection do  
			(
				selection[1]
				$.pivot = [0,0,0]
			)
-- 			if selection.count == 0 do
-- 			(
-- 				messagebox "oops, you didn't select anything!" title:"Flow Panels"
-- 			)
			
		)	
		------------------------------------------------------------------------------------------------------------------------------------
		-- PIVOT TO CENTER			
		------------------------------------------------------------------------------------------------------------------------------------
			
		on btn_piv_cnt pressed do
		(
			Undo on
			for i in selection do  
			(
				selection[1]
				i.pivot = [i.center.x,i.center.y,i.center.z]
			)
-- 			if selection.count == 0 do
-- 			(
-- 				messagebox "oops, you didn't select anything!" title:"Flow Panels"
-- 			)
			
		)	
				
		-------------------------------------------------------------------------------------------------------------------------------------- 
		-- MODELING TOOLS 
		--------------------------------------------------------------------------------------------------------------------------------------
			
		----------------------------------------------------------------------------------------------------Double Smooth
		on btn_dubSmt pressed do 
		(
			macros.run FlowPanels DubSmooth 
			
		)
		----------------------------------------------------------------------------------------------------Delete Loop
		on btn_delLoop pressed do
		(
			Undo on
			macros.run FlowPanels DeleteLoop
		)			
		----------------------------------------------------------------------------------------------------Combine Objects	
		on btn_comObj pressed do 
		(
			Undo on
			macros.run FlowPanels CombineObj
		)
		----------------------------------------------------------------------------------------------------Weld Verts
		on btn_weldVerts pressed do 
		(
			Undo on
			macros.run FlowPanels VertWeld
		)
		----------------------------------------------------------------------------------------------------Reset Object
		on btn_zerObj pressed do 
		(
			Undo on
			macros.run FlowPanels ResetObj
		)
		----------------------------------------------------------------------------------------------------Quick Copy
		On btn_quick_copy pressed do 
		(
			Undo on
			macros.run FlowPanels CopyObj
		)
		----------------------------------------------------------------------------------------------------Reset Transformation
		on btn_reset_trans pressed do
		(
			undo on
			macros.run FlowPanels ResTransform
		)
		----------------------------------------------------------------------------------------------------Detach Object
		on btn_qck_dtach pressed do 
		(
			undo on
			macros.run FlowPanels ObjDetach
		)
		----------------------------------------------------------------------------------------------------Quick UVW Map
		on btn_UVW_map pressed do 
		(
			undo on
			macros.run FlowPanels QuickUV
		)
		
		----------------------------------------------------------------------------------------------------Object Culling
		on btn_cull_tog pressed do
		(
			Undo on
			macros.run FlowPanels Cull
		)
		
		----------------------------------------------------------------------------------------------------Symmetry Radial
		on symRadBtn pressed do
		(
-- 			
-- 			undo on
-- 			modPanel.addModToSelection (SymmetryRadial ()) ui:on
		)
		----------------------------------------------------------------------------------------------------Scale UVs
		on btn_texChk pressed do 
		(
			undo on
			macros.run FlowPanels RescaleUVs
			
		)
		----------------------------------------------------------------------------------------------------
		
		
-------------------------------------------------------------------------------------Cloners Group Controls
-- 			
-- 		Group "Cloners List"
-- 		(
-- 			
-- 			dropdownlist cloner_list "" items:#("...Pick Cloner...", "1. Clone Radial", "2. Clone on Curve", "3. Building Maker",  "4. CloneSpline Rad", "5. Path Cloner","6. Cloner Setup") width: 150	align:#center 
-- 			
-- 		)
			
			
		on cloner_list selected i do
		(
				
			if cloner_list.selection == 2 then 
			(
				--modPanel.addModToSelection (Vu_mcgCloneRadial ()) ui:on
			)
			
			if cloner_list.selection == 3 then 
			(
				--modPanel.addModToSelection (VA_CloneOnCurve ()) ui:on
			)
			
			if cloner_list.selection == 4 then
			(
				--fileIn "D:\Dropbox\[main access]\3ds_Scripts\HTM-PRJ_cityblks-BMscripts\BuildingMaker.ms"
			)
			
			if cloner_list.selection == 5 then
			(
				--startObjectCreation Vu_CloneSplRadial
			)
			
			if cloner_list.selection == 6 then
			(
				--Path_Cloner ()
			)
			
			if cloner_list.selection == 7 then
			(
				--modPanel.addModToSelection (Cloner_Transform ()) ui:on
				--modPanel.addModToSelection (Cloner_Mesher ()) ui:on
				--modPanel.addModToSelection (Stacker ()) ui:on	
			)
				
		)
		
		on panModeling rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panModeling
			)
			
		)
	)
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	Rollout panPaint "Painting Panel"  
		
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// PAINTING PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
		
	--------------------------------------------------------------------------------------------------------------------------------------	
	(
		------------------------------------------------------------------------------------------------------------------------------
			
		group "Viewport Canvas: "
		(
			button viewCanvas "Launch Viewport Canvas" width: 160 Height: 30
		)
			
		------------------------------------------------------------------------------------------------------------------------------
		on viewCanvas pressed do 
		(
			macros.run "Viewport Canvas" "ViewportCanvas"
		)
		------------------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------
			
		Group "Vertex Painting"
		(
			button btn_vert_pnt "Vertex Paint Pallet" 	width: 160 Height: 30
			button btn_sho_vert "Show Vertex Color" 	width: 160 Height: 30
		)
			
		Group "Bake Vertex Paint"
		(
			label lbl_brit "Brightness:"								align:#left		across:2
			spinner exp_brit ""							width: 90 		align:#right	range:[0, 100, 50]
			
			label lbl_contr "Contrast:"									align:#left		across:2
			spinner exp_contr ""						width: 90		align:#right	range:[0, 100, 50]
			
			label lbl_val "Exposure:"									align:#left		across:2
			spinner exp_val ""							width: 90		align:#right	range:[0, 5, 0]
			checkbox chk_glo_sub "  Global Subdivision Settings"
			checkbox chk_inc_sky "  Include Skylight"
				
			button btn_bake_ao "Bake AO"				width:80 Height: 30				across:2
			button btn_app_bak "Bake Settings"				width:80 Height: 30	
				
		)
			
		------------------------------------------------------------------------------------------------------------------------------	
			
		on btn_vert_pnt pressed do 
		(
			mdf = modpanel.getCurrentObject()
			
			if (classof mdf) == VertexPaint then 
			(
				return false 
			)
			else 
			(
				modPanel.addModToSelection (VertexPaint ()) ui:on
			)
		)
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_sho_vert pressed do 
		(
			obj = getCurrentSelection()
			
			for i in selection as array do
			(
				
				if i.showVertexColors == off then
				(
					i.showVertexColors = on
				)
				else if i.showVertexColors == on then
				(
					i.showVertexColors = off
				)
			)
				
		)
			
		------------------------------------------------------------------------------------------------------------------------------	
		on exp_brit changed val do 
		(
			LinExp = Linear_Exposure_Control()
			SceneExposureControl.exposureControl = LinExp
			LinExp.brightess = val
		)
		------------------------------------------------------------------------------------------------------------------------------	
		on exp_contr changed val do 
		(
			LinExp = Linear_Exposure_Control()
			SceneExposureControl.exposureControl = LinExp
			LinExp.contrast = val
		)
		------------------------------------------------------------------------------------------------------------------------------		
		on btn_bake_ao pressed do 
		(
			if $AmbientBake != undefined do 
			(
				select $AmbientBake
				delete $AmbientBake
			)
				
			obj = getCurrentSelection() 
			 
			Skylight pos:[0,0,0] isSelected:on
			$.name = "AmbientBake"
			$.castShadows = on 
				
			select obj 
				
				
			LinExp = Linear_Exposure_Control()
			SceneExposureControl.exposureControl = LinExp
			LinExp.active = true
				
			LinExp.contrast = exp_contr.value
			LinExp.brightess = exp_brit.value
			LinExp.exposureValue = exp_val.value
				
				
			SceneRadiosity.showPanel() 
			sceneRadiosity.radiosity = Radiosity()
				
			sceneRadiosity.radiosity.radProcessInRenderOnly = false 
			sceneRadiosity.radiosity.radInitialQuality = 95
				
				
			sceneRadiosity.radiosity.radFiltering = 5
				
				
			-- global Subdivision settings
			sceneRadiosity.radiosity.meshingEnabled = chk_glo_sub.state
			sceneRadiosity.radiosity.useAdaptiveMeshing = chk_glo_sub.state
			sceneRadiosity.radiosity.includeSkylight = chk_inc_sky.state
				
			sceneRadiosity.radiosity.initialMeshSize = 10.0
			sceneRadiosity.radiosity.contrastThreshold = 100.0
				
			sceneRadiosity.radiosity.Start () 
				
		)
		------------------------------------------------------------------------------------------------------------------------------	
		on btn_app_bak pressed do 
		(
			local obj = getCurrentSelection()
				
			--AssignVertexColors.ApplyNodes $ vertexPaint:$.modifiers[#VertexPaint]
			
			if obj.count > 0 do 
			(
				if $AmbientBake != undefined do 
				(
					select $AmbientBake
					delete $AmbientBake
				)
					
				Select obj
					
				LinExp = Linear_Exposure_Control()
				SceneExposureControl.exposureControl = LinExp
				LinExp.active = true
					
				LinExp.contrast = exp_contr.value
				LinExp.brightess = exp_brit.value
				LinExp.exposureValue = exp_val.value
					
				mdf = modpanel.getCurrentObject()
				if (classof mdf) != VertexPaint then
				(
-- 					modPanel.addModToSelection (VertexPaint ()) ui:on
					macros.run "Modifiers" "Vertex_Paint"
					--modPanel.setCurrentObject $.modifiers[#VertexPaint]
					$.modifiers[#VertexPaint].lightingModel = 0
					$.modifiers[#VertexPaint].radiosityOption = 1
					$.modifiers[#VertexPaint].mapchannel = 0
					--$.modifiers[#VertexPaint].colorBy = 2
					--$.modifiers[#VertexPaint].radiosityOnly = true
					--rootScene[#Environment][#Advanced_Lighting].rmReuseDirectIllumination = on
					for i in selection do
					(						
						AssignVertexColors.ApplyNodes i vertexPaint:i.modifiers[#VertexPaint]
					)
					$.showVertexColors = on
				)
				else
				(
					AssignVertexColors.ApplyNodes $ vertexPaint:$.modifiers[#VertexPaint]
				)
				update $
				Select $
			)
		)
		------------------------------------------------------------------------------------------------------------------------------
		-- OPEN // CLOSED 
		------------------------------------------------------------------------------------------------------------------------------
		on panPaint rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panPaint
			)	
		)
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	Rollout panNormals "Normals Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// NORMALS PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
		
	--------------------------------------------------------------------------------------------------------------------------------------	
		
		Group "Set Normals"
		(
			
			Button cmdCreate "Set Weighted Normals" width: 160 height: 40
			Button cmdLock "Set & Lock Normals" 	width: 160 height: 40
			Button cmdReset "Release Normals" 		width: 160 height: 40
			
			Button cmdAdjust "Adjust Faces"         width: 160 height: 40
		)
			
		--------------------------------------------------------------------------------------------------------------------------------------
			
		On cmdReset pressed do 
		(
			if selection.count > 0 do
			(
				for i in selection as array do 
				(
					macros.run "Modifiers" "EditPolyMod"
					maxOps.CollapseNode i off
				)
			)
			
			if selection.count == 0 do
			(
				messagebox "WARNING!: Nothing is Selected" title:"Flow Panels"
			)
		)
		
		
		 On cmdCreate pressed do
		(
				
			-- copy selection (can't copy arrays in 3dsmax)
			local sel = #()
			for i=1 to selection.count do
			(
				sel[i] = selection[i]
			)
		  
			-- create selection list
			for i=1 to sel.count do
			(
				GenWeightedNormals sel[i]
				$.modifiers[#Set_Normals].displayLength = 1
			)
		)  
		On cmdLock pressed do 
		(
			-- copy selection (can't copy arrays in 3dsmax)
			local sel = #()
			for i=1 to selection.count do
			(
				sel[i] = selection[i]
			)
				
			-- create selection list
			for i=1 to sel.count do
			(
				GenWeightedNormals sel[i]
				macros.run "Modifier Stack" "Convert_to_Poly"
				
			)
				
			-- restore selection
			selection = sel
				
		 )
		 
		on cmdAdjust pressed do 
		(
			
			macros.run FlowPanels "SetNormals"
			
		)
		 
		------------------------------------------------------------------------------------------------------------------------------
		-- OPEN // CLOSED 
		------------------------------------------------------------------------------------------------------------------------------
			
		on panNormals rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panNormals
			)	
		)
			
	)


	-------------------------------------------------------------------------------------------------------- // EXPORT PANEL
	-- Export Panel Controls 

	Rollout panExporter "Export Panel"

	-------------------------------------------------------------------------------------------------------------------------------------	
	(
	-------------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////////////// QUICK EXPORT
	-------------------------------------------------------------------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------------------------------------------------------- VARIABLES
			
		local	incr 		= #("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
		local	typ1 		= ".OBJ"
		local	typ2 		= ".FBX"
		local	typ_setr 	= set_typ_string
		local	initNam 	= "object_name"
		local	use_ObjNam 	= set_use_ObjNam_checked
		local	Unity_Y_Up 	= set_Unity_Y_Up_checked
 		local	main_db 	= "[main access]"
		local 	autoType 	= set_autoType_checked
		local 	qx_fldr 	= set_exp_location
		local 	lastExpFldr = set_lastExp_Fldr
		local	noPrompt 	= set_noprompt_exp
		local 	batchExp	= set_bat_exp
		local 	objTypeSet 	= set_obj_typ_checked
		local 	fbxTypeSet 	= set_fbx_typ_checked
		local   renamObjs 	= set_renamObjs
		local   offSwitch 	= false
		local 	bypassNam 	= set_bypass_nam
			
		global 	newExpEntry = false
			
	------------------------------------------------------------------------------------------------------------------------------------- EXPORT LOCATION
			
		Group "Export Location:"
		(
			edittext disp_fldr_nam ""					labelOnTop: true		height:20 		width: 170		align:#left				tooltip:""							fieldWidth:160 across:2  
			button btn_add_itm "+" 												width:18 		height:20 		align:#right 			tooltip:"add item to Presets"              
			button btn_exp_show_path "Show in Explorer"							width:100		height:20								tooltip: "Show in Explorer"						across:2
			button btn_exp_edt_path	"Edit Folder Path"							width:90		height:20		align:#right			tooltip:"Edit the Folder Path Manually"
			button btn_exp_clip_path "Paste From Clipboard"						width:190		height:20								tooltip: "Paste from Clipboard"
			button btn_fold_path "Set Export Location"							width:190		height:20								tooltip: "Manually"
		)
			
		Group "Export Name:"
		(
			edittext preNam   "Prefix:"						labelOnTop:false			align:#left 	width:100	height:20	across:1  fieldWidth: 5
			edittext multiNam "Name:"						labelOnTop:false			align:#left 	width:190	height:20   across:1
				
			checkbox btn_use_objNam "Use Selection Name"				width:114		checked:use_ObjNam				align:#left		Tooltip:"Toggle On, to Use Selection's name as 'Object Name'" across:2 	
			checkbox btn_renam_on "Rename Obj"							width:75		checked:renamObjs				align:#right	Tooltip:"Toggle On, to allow Renaming of Objects" 	
				
			edittext verNam   "Suffix:"						labelOnTop:false			align:#left 	width:100	height:20
			radioButtons radSufVal "Suffix Type:"			Labels:#("Letters","Numbers", "None")	align:#left  columns:3
			spinner btn_incr_vr "Use to Increment Suffix Value" 			type:#integer	align:#right	width: 30 	height:18	range:[-9999, 9999, 1]	tooltip:"increment suffix letter"
				
		)
			
	------------------------------------------------------------------------------------------------------------------------------------- PROPERTIES
			
		Group "Export Options:"
		(				
			checkBox btn_bypass_nam "Bypass Prefix/Suffix Naming" 			align:#left		checked: bypassNam				Tooltip:"Will use the name in the object name field and bypass prefix and suffix"
			checkBox btn_unity_exp "Export to Unity3D" 						align:#left		checked: Unity_Y_Up				Tooltip:"Sets Y-up instead of Z" 					
			checkBox autoTypeCheck "Auto-Match Type to Prefix" 				align:#left		checked: autoType				Tooltip:"Automatically sets the object export type based on prefix"
			checkBox noPromptCheck "No Prompt on Export" 					align:#left		checked: noPrompt				Tooltip:"Ignore all prompts and sends directly to folder"
			checkBox BtchExportChk "Batch Export" 							align:#left		checked: batchExp				Tooltip:"Batch Exports each individual mesh and sends it directly to folder  \n \n Warning: for Auto Export make sure to turn-on 'NoPrompt on Export'"
			label lbl_exp_prog "Batch Export Progress:"						align:#left		enabled: batchExp
			progressBar progBar "BatchExportProgressBar"					color:green		enabled: batchExp
		)
			
		Group "Export File Type:"
		(
				
			checkbutton btn_obj_typ "Export OBJ" 							align:#left		width: 90	checked:objTypeSet			across:2
			checkbutton btn_fbx_typ "Export FBX"							align:#right	width: 90 	checked:fbxTypeSet
				
		)
			
			
	------------------------------------------------------------------------------------------------------------------------------------- QUICK EXPORT
		Group "Export:"
		(
				
			button b_Quick_Export "Quick Export!" 				width: 180			height:40
		)
			
	------------------------------------------------------------------------------------------------------------------------------------- PRESETS
			
		Group "Preset Locations"
		(
			
			dropdownlist theList "" items:#() 		width:190		    height:20		align:#left			   	tooltip:""  									
			button btn_edt_item "Edit List" 		width:90 			height:20 		align:#center 			tooltip:"edit contents of selected item" 		across:2             
			button btn_dlt_preset "Delete List"		width:90			height:20		align:#center			tooltip:"delete presets file"
		)
			
	-------------------------------------------------------------------------------------------------------------------------------- TIMERS		
			
		--Selection Timer; update Object Name on selection
		timer checkSel "" interval:100 active:use_ObjNam
		timer typCheck "" interval:100 active:autoType
			
	--------------------------------------------------------------------------------------------------------------------------------------------------------FUNCTIONS	
			
		--------------------------------------------------------------------------------------------------------------------------------
		--save export list -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn SaveExportList = 
		(
			local usedotNam = sysInfo.username as string
			
			if theList.items.count != 0 do
			(
				--write to file
				ss = createFile ("C:\\Users\\"+ usedotNam +"\\PresetLocations.fp") mode: "w"
					
				format "%\n" (with printAllElements on savedData as string) to:ss
				--flush ss
				close ss
					
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--exports meshes -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn rdyForExport = 
		(
				
			--forces export - no prompt
			if noPrompt then
			(			
					
				--if batch export is false -- it will use the pivot of the first object selected
				if (batchExp == false) then
				(
					local dirName
						
					if btn_bypass_nam.checked == true  then
					(
						ObjNam = "\\" + multiNam.text + typ_setr
							
						--sets directory and object name
						dirName = qx_fldr + ObjNam
							
					)
					else if btn_bypass_nam.checked == false then 
					(
						if radSufVal.state <= 2 then
						(					
							ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
						)	
						else if radSufVal.state == 3 then				
						(
							ObjNam = "\\" + preNam.text + "_" + multiNam.text + typ_setr
						)
							
						--sets directory and object name
						dirName = qx_fldr + ObjNam
							
					)
						
					--sets directory and object name
					dirName = qx_fldr + ObjNam
						
					--sets pivot to first selection 
					--$.pivot = selection[1].pivot
						
					exportFile (dirName) #noPrompt selectedOnly:true	
						
				)
				else 
				(
					--sets directory and object name
					batDirName = (qx_fldr + "/" + $.name as string)
						
					exportFile (batDirName) #noPrompt selectedOnly:true	
						
				)		
					
			)
			else  --prompt on export 
			(
					
				--if batch export is false -- it will use the pivot of the first object selected
				if (batchExp == false) then 
				(
					local dirName
						
					if btn_bypass_nam.checked == true  then
					(
						ObjNam = "\\" + multiNam.text + typ_setr
							
						--sets directory and object name
						dirName = qx_fldr + ObjNam
							
					)
					else if btn_bypass_nam.checked == false then 
					(
						if radSufVal.state <= 2 then
						(					
							ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
						)	
						else if radSufVal.state == 3 then				
						(
							ObjNam = "\\" + preNam.text + "_" + multiNam.text + typ_setr
						)
							
						--sets directory and object name
						dirName = qx_fldr + ObjNam
							
					)
						
						
					--sets pivot to first selection 
					--$.pivot = selection[1].pivot
						
					exportFile (dirName) selectedOnly:true
						
				)
				else 
				(
					--sets directory and object name
					batDirName = (qx_fldr + "/" + $.name as string)
						
					exportFile (batDirName) selectedOnly:true
						
				)	
					
			)
				
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--check for type of export based on prefix -- FUNCTION	
		--------------------------------------------------------------------------------------------------------------------------------
		fn autoButtonTypeSwitcher btn1 btn2 btn3 =
		(
				
			--button switch
			btn1 = (preNam.text == "fbx" or preNam.text == "Fbx" or preNam.text == "FBX" or
				preNam.text == "FBx" or preNam.text == "FbX" or	preNam.text == "fBx")
					
			btn2 = (preNam.text == "obj" or preNam.text == "Obj" or preNam.text == "OBJ" or
				preNam.text == "OBj" or preNam.text == "ObJ" or preNam.text == "oBj")
					
			btn3 = (preNam.text == "msh" or preNam.text == "")
				
			--sets the buttons on and off
			if (btn2) then 
			(
				btn_fbx_typ.checked = false
				typ_setr = typ1
				btn_obj_typ.checked = true
			)
			else if (btn1) then 
			(
				btn_fbx_typ.checked = true
				typ_setr = typ2
				btn_obj_typ.checked = false
			)
			else if (btn3) then 
			(
				btn_fbx_typ.checked = false
				btn_obj_typ.checked = false
			)
				
			--records settings	
			set_prefixText = preNam.text
			SetAutoSettings set_prefixText 8
				
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--DOESNT DO CRAP -- EMPTY -- FUNCTION	
		--------------------------------------------------------------------------------------------------------------------------------
		fn SomeFunction type = 
		(
			
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--auto check type timer  toggle -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn checkAutoTypeCheck bool = 
		(
			typCheck.active = bool
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--'dynamically' changes tooltip based on selection -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn listTooltipUpdater list =
		(			
			if list.selection != 0 do
			(
				list.tooltip = (list.items[list.selection] as string)
			)
		)	
		--------------------------------------------------------------------------------------------------------------------------------
		--'Substutite slashes for backslashes -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn EXPSubPathString str inpStr sub1 sub2 = 
		(
			--substitutes slashes for backslashes
			str = substitutestring inpStr sub1 sub2
			return str	
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--Create New Export List Entry -- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn CreateNewExportListEntry = 
		(
			try destroyDialog boxes catch()
					
			rollout expDialog "New Entry Dialog"
			(
				
				label lbl_entry "Please do not Delete '#' "
				edittext itm_name "Name:" text:"#"
				button pressme "create"  		width:120	height:40
					
				----------------------------------------------------------------------------------
					
				on pressme pressed do 
				(
					newExpEntry = true
						
					if itm_name.text == "#" or itm_name.text == undefined  or itm_name.text != "" then 
					(
						messageBox "Please Type Something"
						return false
					)
						
					if itm_name.text != undefined then 
					(
						illegalChars = #(" ","!","=","+","-",")","(","&","^","%",",","$","@","?","/","\\","|","<",">",",",".",";",":","'")
						o = 0
						ssNam = itm_name.text
							
						for i = 1 to illegalChars.count do 
						(
							s1 = ssNam
							s2 = illegalChars[i] as string
							s3 = "_"
							ssNam = substitutestring s1 s2 s3	
							0+=1
						)
							
						if o == illegalChars.count then 
						(
							--adds Key value
							PutDictValue savedData (execute ssNam) (qx_fldr)  putOnlyIfNew:true
								
							--refresh list
							theList.items = savedData.keys
								
							--save list 
							SaveExportList()
								
							destroyDialog expDialog
								
						)
					)
				)
					
				----------------------------------------------------------------------------------
					
				on itm_name entered i do 
				(
					newExpEntry = true
					
					if i != undefined then 
					(
						--substitutes spaces for underscore
						s1 = itm_name.text
						s2 = " "
						s3 = "_"
						ssNam = substitutestring s1 s2 s3
							
						--adds Key value
						PutDictValue savedData (execute ssNam) (qx_fldr) putOnlyIfNew:true
							
						--refresh list
						theList.items = savedData.keys
							
						--save list 
						SaveExportList()
							
						destroyDialog expDialog
					)
				)
				
-- 				on expDialog close do 
-- 				(
-- 					
-- 					newExpEntry = false
-- 					
-- 				)
				
			)
				
			createDialog expDialog
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--Generate Export Location // Selection-- FUNCTION
		--------------------------------------------------------------------------------------------------------------------------------
		fn GenerateSelection = 
		(
			--what happens when you select an item
			for i = 1 to theList.selection do
			(
				--adds item value to Export Folder Location
				str = ("#" + theList.selected as string)
				str2 = GetDictValue savedData (execute str)	
				
				--grab folder path and set as item in array
				qx_fldr = str2
					
				--set folder path
				--multiNam.text = initNam
				--verNam.text = "a"
				folder_path = qx_fldr
					
				--displays folder name
				disp_fldr_nam.text = filenameFromPath folder_path
				--also sets the export location edit text box	
				disp_fldr_nam.tooltip = str2
				theList.tooltip = str2
				
				--records settings
				set_list_last_sel = theList.selection
				SetAutoSettings set_list_last_sel 11
					
				--records settings
				SetAutoSettings qx_fldr 9
				
				--'dynamically' changes tooltip based on selection
				--listTooltipUpdater theList  --------------------------------------FIX THIS FUNCTION
			)
		)
			
	--------------------------------------------------------------------------------------------------------------------------------------------------------CHECKBOXES
		--------------------------------------------------------------------------------------------------------------------------------
		--BYPASS PREFIX and SUFFIX ON EXPORT
		--------------------------------------------------------------------------------------------------------------------------------
			
		on btn_bypass_nam changed state do
		(
				
			if state == true then
			(
				verNam.enabled = false
				vernam.visible = false
				radSufVal.enabled = false
				radSufVal.visible = false
				preNam.enabled = false
				preNam.visible = false
				btn_incr_vr.enabled = false
				btn_incr_vr.visible = false
					
				bypassNam = true
					
				--record settings
				SetAutoSettings bypassNam 23 
					
			)	
			else			
			(
				
				if BtchExportChk.checked == true then
				(
					btn_use_objNam.enabled = false
					btn_renam_on.enabled = false
					multiNam.enabled = false
					verNam.enabled = false
					vernam.visible = true
					radSufVal.enabled = false
					radSufVal.visible = true
					preNam.enabled = false
					preNam.visible = true
					btn_incr_vr.enabled = false
					btn_incr_vr.visible = true
				)
				else
				(
					verNam.enabled = true
					vernam.visible = true
					radSufVal.enabled = true
					radSufVal.visible = true
					preNam.enabled = true
					preNam.visible = true
					btn_incr_vr.enabled = true
					btn_incr_vr.visible = true
						
				)	
					
				bypassNam = false
					
				--record settings
				SetAutoSettings bypassNam 23 
				
			)
				
				
		)			
			
		--------------------------------------------------------------------------------------------------------------------------------
		--NO PROMPT ON EXPORT
		--------------------------------------------------------------------------------------------------------------------------------
			
		on noPromptCheck changed state do
		(
			if noPrompt == undefined then
			(
				noPrompt = false
			)
			else
			(
				noPrompt = Not noPrompt
			)
			
			--records settings	
			SetAutoSettings noPrompt 1
		)
		-------------------------------------------------------------------------------------------------------------------------------- 
		--BATCH EXPORT SELECTED OBJECTS
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		on BtchExportChk changed state do
		(
			if batchExp == undefined then
			(
				batchExp = false
				
				lbl_exp_prog.enabled = batchExp
				progBar.enabled = batchExp
			)
			else
			(
				
				batchExp = Not batchExp
				lbl_exp_prog.enabled = batchExp
				progBar.enabled = batchExp
			)
			
			--turns on and off the naming fields
			if BtchExportChk.checked == true then
			(
				btn_use_objNam.checked = false
				use_ObjNam = false
				checkSel.active = false
				btn_use_objNam.enabled = false
				btn_renam_on.enabled = false
				multiNam.text = ""
				multiNam.enabled = false
				verNam.enabled = false
				radSufVal.enabled = false
				preNam.enabled = false
				btn_incr_vr.enabled = false
				
			)
			else
			(
				
				btn_use_objNam.enabled = true
				btn_renam_on.enabled = true
				multiNam.enabled = true
				verNam.enabled = true
				radSufVal.enabled = true
				preNam.enabled = true
				btn_incr_vr.enabled = true
			)
				
			if btn_bypass_nam.checked and batchExp == false then
			(
				use_ObjNam = false
				checkSel.active = false
				btn_use_objNam.enabled = true
				btn_renam_on.enabled = true
				multiNam.text = ""
				multiNam.enabled = true
				verNam.enabled = false
				radSufVal.enabled = false
				preNam.enabled = false
				btn_incr_vr.enabled = false
				
			)
				
			--records settings	
			SetAutoSettings batchExp 22
				
		)
		-------------------------------------------------------------------------------------------------------------------------------- 
		--AUTOMATCH PREFIX
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		on autoTypeCheck changed state do
		(
			if typCheck.active == true then 
			(
				autoType = state
				checkAutoTypeCheck autoType			
			)
			else
				autoType = state
				checkAutoTypeCheck autoType
			
			--records settings				
			SetAutoSettings autoType 4
		)
	--------------------------------------------------------------------------------------------------------------------------------------------------------TIMER TICKS	
		--------------------------------------------------------------------------------------------------------------------------------
		--CHECK FOR NAME OF SELECTION	
		--------------------------------------------------------------------------------------------------------------------------------
			
		on checkSel tick do 
		(
			if selection.count == 0 then 
			(			
				multiNam.enabled = offSwitch
				multiNam.text = "  Select Something"
				SetAutoSettings use_ObjNam 5
			) 
			else
			(
				multiNam.enabled = not offSwitch
				SetAutoSettings use_ObjNam 5
				if selection.count >= 1 then 
					multiNam.text = selection[selection.count].name 
			)			
			
		)	
		--------------------------------------------------------------------------------------------------------------------------------
		--CHECK FOR TYPE OF EXPORT BASED ON PREFIX
		--------------------------------------------------------------------------------------------------------------------------------
			
		on typCheck tick do 
		(
			--run function
			autoButtonTypeSwitcher fbxName objName blaName
				
		)
		--------------------------------------------------------------------------------------------------------------------------------
		-- RENAME LOOP
		--------------------------------------------------------------------------------------------------------------------------------
		on multiNam changed txt do 
		(
			if renamObjs do
			(
				for o in selection as array do 
					o.name = txt
			)
		)
	--------------------------------------------------------------------------------------------------------------------------------------------------------EDITING LIST
			
		-------------------------------------------------------------------------------------------------------------------------------- 	
		-- ADD - new item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_add_itm pressed do 
		(
			--Create Entry Function
			CreateNewExportListEntry()
				
			
			
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- 	
		-- EDIT LIST - selected item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_edt_item pressed do 
		(
			try (destroyDialog expWndw) catch()
			
			arrTemp = #()
			arrTemp = savedProjectData
			
			if (savedData.count > 0) do 
			(
				global ster = ("#" + theList.selected as string)
				global ster2 = GetDictValue savedData (execute ster)
				
				rollout expWndw "Edit List"
				(
					global itemList = #()					
						
					edittext valNam "Entry Name:" 			text:ster readOnly: true
						
					dropdownList lst_proj "Projects:"		
					button btn_crt_prj	"Create Project"	across:3
					button btn_nxt_prj	"Next Project"
					button btn_prv_prj	"Prev Project"
						
					listbox lst_itms "Entries:"	
					edittext chngVal "Current Value:" 		width:380 	height:60	labelontop: true text:ster2 fieldwidth:380
					button accpt "Accept"					width:90	height:30	across:4
					button btn_addEnt "Add Entry"			width:90	height:30
					button exp_Open "Open Directory"		width:90	height:30
					button dlt_Entry "Delete Entry"  		width:90	height:30
					timer updList ""						interval:200
					
					
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Turn off List Auto Update  - FUNCTION
					--------------------------------------------------------------------------------------------------------------------------------
					fn AutoUpdateOff sender evt=
					(
						-- important: don't repeat this timer event
						sender.enabled = false
						-- for sanity and cleanup
						dotnet.RemoveEventHandler sender "Elapsed" AutoUpdateOff        
							
						-- put all your tasks below
						newExpEntry = false
					)
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Generate List Item and its Contents - FUNCTION
					-------------------------------------------------------------------------------------------------------------------------------- 
					fn GenerateListItemContents sel = 
					(
						ster = ("#" + (lst_itms.items[sel] as string))
						ster2 = GetDictValue savedData (execute ster)
							
						valNam.text = ster
							
						if ster2 != undefined then
						(
							chngVal.text = ster2
						)
					)
						
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Timer Tick - Update Loop
					-------------------------------------------------------------------------------------------------------------------------------- 
					on updList tick do 
					(
						if newExpEntry == true then 
						(
							itemList = theList.items
							lst_itms.items = itemList
								
							delayTimer= dotnetobject "Windows.Forms.Timer"
							delayTimer.Interval=1000
								
							dotnet.AddEventHandler delayTimer "Tick" AutoUpdateOff
								
							delayTimer.enabled = true
							
						)
					)
						
					----------------------------------------------------------------------------------
						
					on btn_crt_prj pressed do
					(
						lst_proj.items = append lst_proj.items "New_Project"
						
					)
						
					----------------------------------------------------------------------------------
						
					on lst_itms selected i do 
					(
						if i != 0 then 
						(
							--Generate list item and contents   --selection
							GenerateListItemContents  i 
						)
					)
					----------------------------------------------------------------------------------
						
					on lst_itms rightClick i do 
					(
						if i != 0 then 
						(
							--set selection 
							theList.selection = i 
							lst_itms.selection = i
								
							--Generate list item and contents   --selection
							GenerateListItemContents  i 
						)
							
						--GenerateSelection
						GenerateSelection()
							
					)
						
					----------------------------------------------------------------------------------
						
					on btn_addEnt pressed do 
					(
						--Create Entry Function
						CreateNewExportListEntry()
					)
						
					----------------------------------------------------------------------------------
						
					on accpt pressed do
					(
						
						if ster != undefined then
						(
							theList.items = savedData.keys
								
							qx_fldr = chngVal.text
								
							--substitutes slashes for backslashes
							qx_fldr = EXPSubPathString qx_fldr qx_fldr "\r" "/r"
							qx_fldr = EXPSubPathString qx_fldr qx_fldr "\\" "/"
							
							-- filters path for displaying purposes 
							disp_fldr_nam.text = filenameFromPath qx_fldr
							disp_fldr_nam.tooltip = qx_fldr
							theList.tooltip = qx_fldr
								
							SetDictValue savedData (execute ster) (qx_fldr as string)	
								
							--save list 
							SaveExportList()
								
							destroyDialog expWndw
						)	
					)
						
					----------------------------------------------------------------------------------
						
					on dlt_Entry pressed do 
					(
						if lst_itms.selection > 0 then 
						(
							ster = ("#" + (lst_itms.items[lst_itms.selection] as string))
							ster2 = GetDictValue savedData (execute ster)
							
							if ster != undefined then 
							(
								RemoveDictValue savedData (execute ster)
								deleteItem itemList lst_itms.selection
									
								--refresh list
								theList.items = savedData.keys
								itemList = theList.items
								lst_itms.items = itemList
									
									
								--save list 
								SaveExportList()
								
								theList.selection = (savedData.count - (savedData.count-1))
								--destroyDialog expWndw
							)
						)
					)
						
					----------------------------------------------------------------------------------		
						
					on exp_Open pressed do 
					(
							
						str = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:ster2
							
						if str != undefined then 
						(
							chngVal.text = str
							
							qx_fldr = chngVal.text
								
							-- filters path for displaying purposes 
							disp_fldr_nam.text = filenameFromPath qx_fldr
							disp_fldr_nam.tooltip = qx_fldr
							theList.tooltip = qx_fldr
								
							SetDictValue savedData (execute ster) (chngVal.text as string)
								
							--save list 
							SaveExportList()
							
						)
						
					)
						
					----------------------------------------------------------------------------------
						
					on expWndw open do 
					(
						
						if theList.items.count != 0 do 
						(
							itemList = theList.items
							lst_itms.items = itemList
								
							if theList.selection != undefined then 
							(
								
								lst_itms.selection = findItem itemList theList.selection
									
							)
							--print itemList
						)
						
					)
						
					on expWndw close do 
					(
						updList.enabled = false
					)
						
					
				)			
				
				--valNam.text = ster
				
				createDialog expWndw width:400
			)
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- 
		-- CLEAR - the export list
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		on btn_clear_itm pressed do 
		(
			free savedData
			
			theList.items = savedData.keys
			
		)
		-------------------------------------------------------------------------------------------------------------------------------- 
		-- DELETE - the export list
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		on btn_dlt_preset pressed do 
		(		
			local usedotNam = sysInfo.username as string
				
			ss = ("C:\\Users\\"+ usedotNam +"\\PresetLocations.fp")
				
			deletefile (ss)
			free savedData
			theList.items = savedData.keys
			--messagebox "Presets Loaded!" title:"Flow Panels"
					
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--SET FOLDER PATH MANUALLY 
		--------------------------------------------------------------------------------------------------------------------------------
			
		on disp_fldr_nam changed txt do 
		(
			disp_fldr_nam.text = txt
			qx_fldr = txt
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--SHOW IN EXPLORER
		--------------------------------------------------------------------------------------------------------------------------------
			
		--show folder in explorer
		on btn_exp_show_path pressed do 
		(
			str = qx_fldr
			str = substituteString str "/" "\\"
			
			
			print qx_fldr
			print str
			shelllaunch "explorer.exe" str
			
		)
			
		--------------------------------------------------------------------------------------------------------------------------------
		--SET FOLDER PATH 	
		--------------------------------------------------------------------------------------------------------------------------------
			
		--set export location from clipboard
		on btn_exp_clip_path pressed do 
		(
			-- sets folder path location 
			folder_path = getClipboardText()
				
			--substitutes slashes for backslashes
			folder_path = EXPSubPathString folder_path folder_path "\r" "/r"
			folder_path = EXPSubPathString folder_path folder_path "\\" "/"
				
			--sets folder name
			qx_fldr = folder_path
				
			-- filters path for displaying purposes 
			disp_fldr_nam.text = filenameFromPath qx_fldr
			disp_fldr_nam.tooltip = qx_fldr
				
			--sets last opened folder
			lastExpFldr = folder_path
				
			-----------------------------------------------------------------------------------SAVING DATA
			--records settings
			SetAutoSettings qx_fldr 9
			
			--records settings
			SetAutoSettings lastExpFldr 21 --saves data --function
		)
			
			
		--set export location
		On btn_fold_path pressed do 
		(
			local usedotNam = sysInfo.username as string
				
			-- sets folder path location 
			folder_path = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:lastExpFldr	
				
				
			-- sets folder path name if undefined
			if folder_path == undefined then				
			(
				
				--checks if it has a location saved, before setting it to the default location
				if (lastExpFldr == undefined) then
				(
					--sets folder name
					folder_path = ("C:\\users\\"+ usedotNam as string +"\\Desktop")
				)
				else
				(
					--substitutes slashes for backslashes
					lastExpFldr = EXPSubPathString lastExpFldr lastExpFldr "\r" "/r"
					lastExpFldr = EXPSubPathString lastExpFldr lastExpFldr "\\" "/"
						
						
						
					--sets folder name
					folder_path = lastExpFldr
					
				)				
					
				--substitutes slashes for backslashes
				folder_path = EXPSubPathString folder_path folder_path "\r" "/r"
				folder_path = EXPSubPathString folder_path folder_path "\\" "/"
					
					
				--sets prefix name to 'pre' if its field is empty
				if preNam.text == undefined or preNam.text == "" do
				(
					preNam.text = "pre"
				)
					
				--sets obj name
				multiNam.text = initNam
				ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
					
				--sets folder name
				qx_fldr = folder_path
					
				-- filters path for displaying purposes 
				disp_fldr_nam.text = filenameFromPath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
				--sets last opened folder
				lastExpFldr = folder_path
					
				-----------------------------------------------------------------------------------SAVING DATA
				--records settings
				SetAutoSettings qx_fldr 9
				
				--records settings
				SetAutoSettings lastExpFldr 21 --saves data --function
				
			)
			else -- sets the folder textbox text, the same as folder path location 
			(
				--substitutes slashes for backslashes
				folder_path = EXPSubPathString folder_path folder_path "\r" "/r"
				folder_path = EXPSubPathString folder_path folder_path "\\" "/"
					
				print ("folder_path = " + folder_path as string)
					
					
				qx_fldr = folder_path
				
				disp_fldr_nam.text = filenameFromPath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
				--sets last opened folder
				lastExpFldr = qx_fldr
				
				-----------------------------------------------------------------------------------SAVING DATA				
				--records settings
				SetAutoSettings lastExpFldr 21 --saves data --function
				
				--records settings
				SetAutoSettings qx_fldr 9
			)		
				
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- 
		--EDIT FOLDER PATH MANUALLY - selected item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_exp_edt_path pressed do 
		(
			try destroyDialog expEdtPthWndw catch()
				
			rollout expEdtPthWndw "Edit Entry"
			(
				edittext valNam "Entry Name:" 				width:500	height:30							text:qx_fldr
				button exp_Accpt "Accept"					width:110	height:20		align:#center			across:3				
				button exp_Open "Open Directory"			width:110	height:20		align:#center
				button exp_dlt_Entry "Clear Path"  			width:110	height:20		align:#center
					
				----------------------------------------------------------------------------------
					
				on exp_Open pressed do 
				(

					str = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:qx_fldr
					
					
					if str != undefined then 
					(
						valNam.text = str
					)
						
					
					qx_fldr = valNam.text
						
					-- filters path for displaying purposes 
					disp_fldr_nam.text = filenameFromPath qx_fldr
					disp_fldr_nam.tooltip = qx_fldr
					theList.tooltip = qx_fldr
						
						
				)
					
				----------------------------------------------------------------------------------
					
				on exp_Accpt pressed do
				(
					qx_fldr = valNam.text
					-- filters path for displaying purposes 
					disp_fldr_nam.text = filenameFromPath qx_fldr
					disp_fldr_nam.tooltip = qx_fldr
					theList.tooltip = qx_fldr
						
					destroyDialog expEdtPthWndw
				)
					
				----------------------------------------------------------------------------------
					
				on exp_dlt_Entry pressed do 
				(
					qx_fldr = ""
					-- filters path for displaying purposes 
					disp_fldr_nam.text = ""
					disp_fldr_nam.tooltip = qx_fldr
					theList.tooltip = qx_fldr
						
					destroyDialog expEdtPthWndw
				)
					
				----------------------------------------------------------------------------------
					
				on valNam entered val do
				(
					qx_fldr = valNam.text
					-- filters path for displaying purposes 
					import_fldr_nam.text = filenameFromPath qx_fldr
					import_fldr_nam.tooltip = qx_fldr
					theList.tooltip = qx_fldr
						
					destroyDialog expEdtPthWndw
				)
					
				----------------------------------------------------------------------------------				
					
			)			
				
			createDialog expEdtPthWndw width:525
				
 			--records settings
			SetAutoSettings qx_fldr 9
				
		)
			
		--------------------------------------------------------------------------------------------------------------------------------	
		--LIST ITEM SELECTED 
		--------------------------------------------------------------------------------------------------------------------------------
			
		On theList selected i do
		(
			--Generate Selection
			GenerateSelection()
				
		)
	--------------------------------------------------------------------------------------------------------------------------------------------------------EXPORT PROPERTIES
			
		--------------------------------------------------------------------------------------------------------------------------------
		--QUICK EXPORT BUTTON		
		--------------------------------------------------------------------------------------------------------------------------------
			
		On b_Quick_Export  pressed do
		(   
			--selection arrays
			local selGroup = getCurrentSelection()
			local selArr = selGroup as array
				
			local sel = selection as array --for batch export
				
			if (batchExp) then 
			(
					
				if selection.count > 0 do
				(
						
					o = 1
					for i = o to sel.count do 
					(
						select sel[i]
							
						--export function
						rdyForExport()
							
						--Update progress bar after completion
						progBar.value = 100*i/sel.count
						lbl_exp_prog.text = "Batch Export Progress: " + progBar.value as string + "%" 
							
					)	
						
				)
				--Update progress bar after completion
				if progbar.value == 100 do
				(
					--messagebox "Export Completed"
					lbl_exp_prog.text = "Batch Export Progress:"
					progbar.value = 0
				)
			)
			else
			(
				if selection.count > 0 and btn_fbx_typ.checked or selection.count > 0 and btn_obj_typ.checked then 
				(	
					selGroup = getCurrentSelection()
						
					--If UNITY 3D is ON - do this - sets Y-up 
					if  selGroup.count > 0 do  
					(						
						if Unity_Y_Up == true do					
						(
							--ADD OPTION TO KEEP MULTIPLE MESHES UNIQUE
							macros.run FlowPanels CopyObj
							macros.run FlowPanels CombineObj
							
							selCur = selection
							
							for obj in selCur do 
							(	
								--Y-up  function
								unityYUp obj
							)
								
							--selects original
							select selCur
						)							
						--export function
						rdyForExport()
							
						--deletes exported copy 
						try (delete selCur) catch()
							
						--sets pivot to first selection 
						--$.pivot = selection[1].pivot
							
					)
				)
			)
			--ERROR CHECK 			
			if selection.count == 0 and btn_fbx_typ.checked == false or selection.count == 0 and btn_obj_typ.checked  do
			(
				messagebox "Please make sure that you have a [file type] and an [object] Selected.  \n\n --This is a FlowPanels friendly reminder!" title: "Flow Panels -- Warning!" beep: false
			)	
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--INCREMENTS SUFFIX LETTER
		--------------------------------------------------------------------------------------------------------------------------------
			
		on radSufVal changed state do
		(
			case of 
			(
				(radSufVal.state == 1): 
				(
					btn_incr_vr.value = 01
					verNam.text = "a"
					verNam.enabled = true
				)
					
				(radSufVal.state == 2):
				(
					btn_incr_vr.value = 01
					verNam.enabled = true
					verNam.text= "01"
				)
					
				(radSufVal.state == 3): (
					verNam.enabled = false
					verNam.text = "------"
				)
			)
		)			
			
			
		On btn_incr_vr changed val do
		(   
			
			if radSufVal.state == 1 then
			(
				a = btn_incr_vr.value < 1
				b = btn_incr_vr.value > incr.count
					
				if a then
				(
					btn_incr_vr.value = incr.count
				)
				else if b then
				(
					btn_incr_vr.value = 1
				)
				
				print b
				verNam.text = incr[btn_incr_vr.value]	
			)
			else if radSufVal.state == 2 then
			(
				if val < 10 and val >= 0 then
				(
					verNam.text = "0"+(val)as string
				)
				else if val < 0 then
				(
					val = 0
					btn_incr_vr.value = 0
					verNam.text = "0"+(val)as string
				)
				else if val > 9 then
					verNam.text = (val)as string
			)			
			
		)
		
		
		
		
		--------------------------------------------------------------------------------------------------------------------------------
		--EXPORTING TO UNITY, SETS Y UP 		
		--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_unity_exp changed state do
		(   
			Undo on
			if state == on then
			(
				Unity_Y_Up = true
				
				--records settings
				SetAutoSettings Unity_Y_Up 6
			)
			if state == off then
			(
				Unity_Y_Up = false	
				
				--records settings
				SetAutoSettings Unity_Y_Up 6
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--USE TO RENAME SELECTION 		
		--------------------------------------------------------------------------------------------------------------------------------
			
		on btn_renam_on changed state do
		(
			if state == on then
			(
				renamObjs = true
				set_renamObjs = renamObjs
				if selection.count > 0 do
				(
					multiNam.text = selection[1].name
				)
				--records settings
				SetAutoSettings set_renamObjs 10
				
				--turnoff selection name
				use_ObjNam = false
				checkSel.active = use_ObjNam
				
				btn_use_objNam.checked = false
				
				multiNam.enabled = not offSwitch
				
				--records settings
				SetAutoSettings use_ObjNam 5				
			)
			if state == off then
			(
				renamObjs = false
				set_renamObjs = renamObjs
				
				multiNam.text = ""
				
				--records settings
				SetAutoSettings set_renamObjs 10
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--USE SELECTION NAME		
		--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_use_objNam changed state do
		(   
			
			if state == on then
			(
				use_ObjNam = true
				checkSel.active = use_ObjNam
					
				btn_renam_on.checked = false
					
				--records settings
				SetAutoSettings use_ObjNam 5
			)
			else if state == off then
			(
				use_ObjNam = false
				checkSel.active = use_ObjNam
				
				multiNam.enabled = not offSwitch
				multiNam.text = ""
				
				--records settings
				SetAutoSettings use_ObjNam 5
			)
		)	
		--------------------------------------------------------------------------------------------------------------------------------	
		--SET OBJECT TYPE OBJ			
		--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_obj_typ changed state do 		
		(
			
			if state == on then
			(
				btn_fbx_typ.checked = false
					
				if set_typ_string == undefined or set_typ_string != undefined then
				(
					set_typ_string = typ1
					typ_setr = set_typ_string
						
					--records settings 
					SetAutoSettings set_typ_string 7
						
				)
				else 
				(
					typ_setr = typ1	
				)
					
				--records settings 
				SetAutoSettings true 3
				SetAutoSettings false 2
				
				if autoType then 
				(
					preNam.text = "obj"
				)
			)
			else if state == off then
			(
				--records settings 
				SetAutoSettings false 3
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--SET OBJECT TYPE FBX
		--------------------------------------------------------------------------------------------------------------------------------	
			
		On btn_fbx_typ changed state do 
		(
			
			if state == on then
			(
				btn_obj_typ.checked = false
				
				if set_typ_string == undefined or set_typ_string != undefined then
				(
					set_typ_string = typ2
					typ_setr = set_typ_string
						
					--records settings 
					SetAutoSettings set_typ_string 7
						
				)
				else 
				(
					typ_setr = typ1	
				)
				
				--records settings 
				SetAutoSettings true 2
				SetAutoSettings false 3
				
				if autoType then 
				(
					preNam.text = "fbx"
				)
			)
			else if state == off then
			(
				--records settings 
				SetAutoSettings false 2
			)
		)
			
			
		------------------------------------------------------------------------------------------------------------------------------
		-- OPEN // CLOSED 
		------------------------------------------------------------------------------------------------------------------------------
			
		-- get saved data on start up
		on panExporter rolledUp open do 
		(
				
			--populate List
			theList.items = savedData.keys -- change this to savedData
				
			--update export list's tooltip 
			--listTooltipUpdater theList
				
			--checks to set value of prefix
			if set_autoType_checked == true do
			(
				preNam.text = set_prefixText
			)
			--checks to set value of export location
			if set_exp_location != undefined do
			(
					
				--resets the list's last selected item
				if(theList.items.count > 0 and set_list_last_sel != undefined) do
				(
					theList.selection = set_list_last_sel
				)
					
				--displays folder name
				disp_fldr_nam.text = filenameFromPath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
			)	
				
			--sets BYPASS prefix and suffix value
			if bypassNam == true or btn_bypass_nam.checked == true then
			(
					verNam.enabled = false
					vernam.visible = false
					radSufVal.enabled = false
					radSufVal.visible = false
					preNam.enabled = false
					preNam.visible = false
					btn_incr_vr.enabled = false
					btn_incr_vr.visible = false
						
			)
			else
			(
				--sets prefix if undefined
				if (preNam.text == "") do (
					preNam.text = "msh"
				)			
				--sets suffix to 'a' 
				if(verNam.text == "") do (
					verNam.text = "a"
				)
			)				
				
			--turns on and off the naming fields
			if BtchExportChk.checked == true then
			(
				btn_use_objNam.enabled = false
				btn_renam_on.enabled = false
				multiNam.enabled = false
				verNam.enabled = false
				radSufVal.enabled = false
				preNam.enabled = false
				btn_incr_vr.enabled = false
			)
			else
			(
				if bypassNam == true or btn_bypass_nam.checked == true then
				(
					verNam.enabled = false
					radSufVal.enabled = false
					preNam.enabled = false
					btn_incr_vr.enabled = false
				)
				else
				(
					btn_use_objNam.enabled = true
					btn_renam_on.enabled = true
					multiNam.enabled = true
					verNam.enabled = true
					radSufVal.enabled = true
					preNam.enabled = true
					btn_incr_vr.enabled = true
				)
			)
				
			if use_AutoCollapse == true do 
			(
				--switches to this rollout
				if open do switchRolls panExporter
			)	
		)		
	)
-------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------
	Rollout panImporter "Import Panel"
	(
			
		local importItemsArray = #()--set_import_array
		local impFolderPath
		local lastOpenedFldr = set_last_import_loc
		local scrollToSelection = false	
		local forceImport = false	
		local loadFBXfiles = false
		local loadMAXfiles = false		
		local loadInstFiles= false --- RECORD SETTINGS !!
			
		Group "Import Folder"
		(
			edittext import_fldr_nam ""		text: "Import Location"			labelOnTop: true		height:20 		width: 170				align:#left		tooltip:""							fieldWidth:160 across:2
			button btn_add_imp_itm "+" 												width:18 		height:20 		align:#right 			tooltip:"add item to Presets"              
			button btn_imp_show_path "Show in Explorer"								width:100		height:20								tooltip:"Show in Explorer"							across:2
			button btn_edt_imp_fldph "Edit Folder Path"								width:90		height:20		align:#right			tooltip:"Edit the Folder Path Manually"
			button btn_imp_clip_path "Paste From Clipboard"							width:190		height:20								tooltip:"Paste path from clipboard"
			button btn_imp_fold_path "Set Import Location"							width:190		height:20								tooltip: "Manually"
		)
		Group "Object Info:"
		(
			label lbl_imp_obj_nam "Selected: " align:#left 
			label lbl_imp_obj_num "Number of Objects: " align:#left
		)
		
		Group "Import Options"
		(
			checkbutton loadFBXs     ".Fbx" 							checked:loadFBXfiles across:3				tooltip:"Loads All Available .FBX files"
			checkbutton loadMAXs     ".Max" 							checked:loadMAXfiles						tooltip:"Loads All Available .MAX files"
			checkbutton loadINSTs    ".MaxC" 							checked:loadInstFiles						tooltip:"Loads All Available 3dsMax Container files"
		)
		
		Group "Availble for Import:" 
		(
			button btn_ref_lst       "Refresh List"		width: 190		height: 20			align:#left				tooltip: "Refreshes List"
			listbox filesToImport 	""  									items:#() 		align:#right caption: "Double Click to Import"
			checkbox scrllToSel 	"Auto-Arrange Selection" 				checked:scrollToSelection
			checkbox forceImp 		"NoPrompt Import" 						checked:forceImport
			button btn_imp_sing      "Import Selected"		across:2		width: 100		height: 20				tooltip: "Imports Everything in the list [you have been warned]"
			button btn_imp_all       "Import All"							width: 90		height: 20				tooltip: "Imports Everything in the list [you have been warned]"			align:#right
		)		
			
		Group "Preset Locations:"
		(
			dropdownlist presetImportLoc ""  items:#() 	width:190		    height:20		align:#center			tooltip:""										
			button btn_imp_edit_item "Edit Entry" 		width:90 			height:20 		align:#center			tooltip:"remove item from Presets"      across:2
			--button btn_imp_save_itm "Save"				width:40			height:20 		align:#center			tooltip:"save presets to file"					across: 4
			--button btn_imp_load_itm "Load"				width:40			height:20		align:#center			tooltip:"load presets file"
			--button btn_imp_clear_itm "Clear"			width:40			height:20		align:#center			tooltip:"clear presets"
			button btn_imp_dlt_preset "Delete List" 	width:90			height:20		align:#center			tooltip:"delete presets save file"
		)
			
		--NO PROMPT IMPORT -- TOGGLE
		On forceImp changed state do
		(   
			Undo on
			forceImport = not forceImport			
		)
			
		On scrllToSel changed state do
		(   
			Undo on
			scrollToSelection = not scrollToSelection			
		)
			
			
		fn SubPathString str inpStr sub1 sub2 = 
		(
			--substitutes slashes for backslashes
			str = substitutestring inpStr sub1 sub2
			return str	
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------SAVE GENERATED LIST 
			
		fn SaveImpList = 
		(
			local usedotNam = sysInfo.username as string
			
			if presetImportLoc.items.count != 0 do
			(
					
				--write to file
				impss = createFile ("C:\\Users\\"+ usedotNam +"\\PresetImportLocations.fp") mode: "w"
					
				format "%\n" (with printAllElements on impSavedData as string) to:impss
				flush impss
				close impss
					
				--records settings
				set_imp_list_last_sel = presetImportLoc.selection
				SetAutoSettings set_imp_list_last_sel 15
					
			)	
			
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------GENERATE LIST TYPE
		-- function - - Filters import list for readability-
		fn GenerateDropDownList = 
		(
			--generates dropdownlist of fbx files in the selected folder
			local files = #()
			--files = getFiles((impFolderPath as string + "\\*.fbx"))
			
			--File Import Options
 			if loadFBXfiles do -- FBX
 			(
 				files = getFiles((impFolderPath as string + "\\*.fbx"))
				
 			)
				
 			if loadMAXfiles do --MAX
 			(
 				files = getFiles((impFolderPath as string + "\\*.max"))
				
 			)
				
			if loadInstFiles do --INSTANCE
 			(
 				files = getFiles((impFolderPath as string + "\\*.maxc"))
				
 			)			
				
			local tempArray = #()
			local cleanedArray = #()
			
			importItemsArray = files
			
			--SubstituteString for Array
			if importItemsArray.count > 0 do
			(				
				for i =1 to importItemsArray.count do
				(
					str = importItemsArray[i] as string
					
					--substitutes slashes for backslashes
					importItemsArray[i] = SubPathString str str "\r" "/r"
					importItemsArray[i] = SubPathString str str "\\" "/"
					
				)
			)
			
			print importItemsArray
			
			
			cleanedArray = importItemsArray
			
			for i = 1 to cleanedArray.count do
			(
				tempArray[i] = filenameFromPath cleanedArray[i]
				--tempArray[i] = substituteString tempArray[i] ".FBX"
				--tempArray[i] = ("\\\ " + tempArray[i] as string)
			)	
			--print (tempArray as array)
			filesToImport.items = tempArray
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------GENERATE // REFRESH LIST
			
		-- function - - creates import list - 
		fn ManifestImportList =
		(
			-- sets folder path name if undefined
			if (impFolderPath == undefined) then				
			(
				--checks if it has a location saved, before setting it to the default location
				if (lastOpenedFldr == undefined) then
				(
					--sets folder name
					impFolderPath = ("C:\\users\\"+ usedotNam as string +"\\Desktop")
				)
				else
				(
					--sets folder name
					impFolderPath = lastOpenedFldr
				)
					
				--substitutes slashes for backslashes
				impFolderPath = SubPathString impFolderPath impFolderPath "\r" "/r"
				impFolderPath = SubPathString impFolderPath impFolderPath "\\" "/"
					
					
				-- filters path for displaying purposes 
				import_fldr_nam.text = filenameFromPath impFolderPath
 				import_fldr_nam.tooltip = impFolderPath
 				filesToImport.tooltip = impFolderPath
					
				--generates dropdownlist of fbx files in the selected folder
				GenerateDropDownList()
					
				lbl_imp_obj_num.text = "Number of Objects: " + filesToImport.items.count as string 
				
				--sets last opened location
				lastOpenedFldr = impFolderPath
				-----------------------------------------------------------------------------------SAVING DATA
				
				--records settings
				SetAutoSettings lastOpenedFldr 12 --saves data --function
				
				--records array
				SetAutoSettings importItemsArray 13 --saves data --function
				
				--Save List 
				SaveImpList()
					
			)
			else 
			(
				-- sets the folder textbox text, the same as folder path location 
				import_fldr_nam.text = impFolderPath
					
					
				--substitutes slashes for backslashes
				impFolderPath = SubPathString impFolderPath impFolderPath "\r" "/r"
				impFolderPath = SubPathString impFolderPath impFolderPath "\\" "/"
					
					
				--generates dropdownlist of fbx files in the selected folder
				GenerateDropDownList()
					
				--updates the Info
				lbl_imp_obj_num.text = "Number of Objects: " + filesToImport.items.count as string 
				import_fldr_nam.text = filenameFromPath impFolderPath
 				import_fldr_nam.tooltip = impFolderPath
				filesToImport.tooltip = impFolderPath
				
				--sets last opened location
				lastOpenedFldr = impFolderPath	
					
				-----------------------------------------------------------------------------------SAVING DATA							
					
				--records settings
				SetAutoSettings lastOpenedFldr 12 --saves data --function
					
				--records array
				SetAutoSettings importItemsArray 13  --saves data --function
					
				--Save List 
				SaveImpList()
					
			)	
		)

		--------------------------------------------------------------------------------------------------------------------------------
		--SELECT -- IMPORT LIST -- ITEM
		--------------------------------------------------------------------------------------------------------------------------------
			
		On presetImportLoc selected state do
		(
				
			--what happens when you select an item
			for i = 1 to presetImportLoc.selection do
			(
				--adds item value to Export Folder Location
				str = ("#" + presetImportLoc.selected as string)
				str2 = GetDictValue impSavedData (execute str)	
				
				--grab folder path and set as item in array
				imp_fldr = str2
					
				--tooltip 
				import_fldr_nam.tooltip = imp_fldr as string
					
				--grab folder path and set as item in array
				impFolderPath = imp_fldr
				import_fldr_nam.text = filenameFromPath impFolderPath		
					
				--Refresh List
				ManifestImportList()
				
				--records settings
				set_imp_list_last_sel = presetImportLoc.selection
				SetAutoSettings set_imp_list_last_sel 15
				
			)
				
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- EDITING LIST  -- IMPORT
			
		--------------------------------------------------------------------------------------------------------------------------------
		-- ADD - new item
		--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_add_imp_itm pressed do 
		(
				
			try destroyDialog impDialog catch()
					
			rollout impDialog "New Entry Dialog"
			(
				label imp_lbl_entry "Please do not Delete '#' "
				edittext imp_itm_name "Name:" text:"#"
				button imp_pressme "create"  		width:120	height:40
					
				----------------------------------------------------------------------------------
					
				on imp_pressme pressed do 
				(
					--substitutes spaces for underscore
					impS1 = imp_itm_name.text
					impS2 = " "
					impS3 = "_"
					impSSNam = substitutestring impS1 impS2 impS3
						
					--adds Key value
					PutDictValue impSavedData (execute impSSNam) (impFolderPath)  putOnlyIfNew:true
						
					--refresh list
					presetImportLoc.items = impSavedData.keys
						
					destroyDialog impDialog
				)
					
				----------------------------------------------------------------------------------
					
				on imp_itm_name entered i do 
				(
					--substitutes spaces for underscore
					impS1 = imp_itm_name.text
					impS2 = " "
					impS3 = "_"
					impSSNam = substitutestring impS1 impS2 impS3
						
					--adds Key value
					PutDictValue impSavedData (execute impSSNam) (impFolderPath) putOnlyIfNew:true
						
					--refresh list
					presetImportLoc.items = impSavedData.keys
						
					destroyDialog impDialog
				)
				
			)
				
			createDialog impDialog
				
		)
		-------------------------------------------------------------------------------------------------------------------------------- 
		--EDIT - selected item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
-- 		On btn_imp_edit_item pressed do 
-- 		(
-- 			if (impSavedData.count > 0) do 
-- 			(
-- 				global impSter = ("#" + presetImportLoc.selected as string)
-- 				global impSter2 = GetDictValue impSavedData (execute impSter)
-- 					
-- 					
-- 				try destroyDialog impWndw catch()
-- 				rollout impWndw "Edit Entry"
-- 				(
-- 					edittext valNam "Entry Name:" 			text:impSter readOnly: true
-- 					edittext chngVal "Current Value:" 		width:380 	height:20	labelontop: true text:impSter2 fieldwidth:380
-- 					button imp_Accpt "Accept"					width:160	height:40	across:2
-- 					button imp_dlt_Entry "Delete Entry"  		width:160	height:40
-- 						
-- 					----------------------------------------------------------------------------------
-- 						
-- 					on imp_Accpt pressed do
-- 					(
-- 						SetDictValue impSavedData (execute impSter) (chngVal.text as string)
-- 							
-- 						presetImportLoc.items = impSavedData.keys
-- 							
-- 						destroyDialog impWndw
-- 					)
-- 						
-- 					----------------------------------------------------------------------------------
-- 						
-- 					on imp_dlt_Entry pressed do 
-- 					(
-- 						RemoveDictValue impSavedData (execute impSter)
-- 						
-- 						presetImportLoc.items = impSavedData.keys
-- 						presetImportLoc.selection = (impSavedData.count - (impSavedData.count-1))
-- 						destroyDialog impWndw
-- 					)
-- 						
-- 					on chngVal entered val do
-- 					(
-- 						str = val
-- 						
-- 						chngVal.text = str
-- 							
-- 						print "Entry Changed -- Not Saved!"
-- 					)
-- 						
-- 					----------------------------------------------------------------------------------				
-- 						
-- 				)			
-- 				
-- 				--valNam.text = impSter
-- 				
-- 				createDialog impWndw width:400
-- 			)
-- 				
--  			--records settings
-- 			set_imp_list_last_sel = presetImportLoc.selection
-- 			SetAutoSettings set_imp_list_last_sel 15
-- 				
-- 		)
			
			
			
		On btn_imp_edit_item pressed do 
		(
			try (destroyDialog impWndw) catch()
			
			arrTemp = #()
			arrTemp = savedProjectData
			
			if (impSavedData.count > 0) do 
			(
				global impSter = ("#" + presetImportLoc.selected as string)
				global impSter2 = GetDictValue impSavedData (execute impSter)
				
				rollout impWndw "Edit List"
				(
					global itemList = #()					
						
					edittext valNam "Entry Name:" 			text:impSter readOnly: true
						
					dropdownList lst_proj "Projects:"		
					button btn_crt_prj	"Create Project"	across:3
					button btn_nxt_prj	"Next Project"
					button btn_prv_prj	"Prev Project"
						
					listbox lst_itms "Entries:"	
					edittext chngVal "Current Value:" 		width:380 	height:60	labelontop: true text:impSter2 fieldwidth:380
					button accpt "Accept"					width:90	height:30	across:4
					button btn_addEnt "Add Entry"			width:90	height:30
					button exp_Open "Open Directory"		width:90	height:30
					button dlt_Entry "Delete Entry"  		width:90	height:30
					timer updList ""						interval:200
					
					
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Turn off List Auto Update  - FUNCTION
					--------------------------------------------------------------------------------------------------------------------------------
					fn AutoUpdateOff sender evt=
					(
						-- important: don't repeat this timer event
						sender.enabled = false
						-- for sanity and cleanup
						dotnet.RemoveEventHandler sender "Elapsed" AutoUpdateOff        
							
						-- put all your tasks below
						newExpEntry = false
					)
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Generate List Item and its Contents - FUNCTION
					-------------------------------------------------------------------------------------------------------------------------------- 
					fn GenerateListItemContents sel = 
					(
						impSter = ("#" + (lst_itms.items[sel] as string))
						impSter2 = GetDictValue impSavedData (execute impSter)
							
						valNam.text = impSter
							
						if ster2 != undefined then
						(
							chngVal.text = impSter2
						)
					)
						
					-------------------------------------------------------------------------------------------------------------------------------- 	
					-- Timer Tick - Update Loop
					-------------------------------------------------------------------------------------------------------------------------------- 
					on updList tick do 
					(
						if newExpEntry == true then 
						(
							itemList = presetImportLoc.items
							lst_itms.items = itemList
								
							delayTimer= dotnetobject "Windows.Forms.Timer"
							delayTimer.Interval=1000
								
							dotnet.AddEventHandler delayTimer "Tick" AutoUpdateOff
								
							delayTimer.enabled = true
							
						)
					)
						
					----------------------------------------------------------------------------------
						
					on btn_crt_prj pressed do
					(
						lst_proj.items = append lst_proj.items "New_Project"
						
					)
						
					----------------------------------------------------------------------------------
						
					on lst_itms selected i do 
					(
						if i != 0 then 
						(
							--Generate list item and contents   --selection
							GenerateListItemContents  i 
						)
					)
					----------------------------------------------------------------------------------
						
					on lst_itms rightClick i do 
					(
						if i != 0 then 
						(
							--set selection 
							presetImportLoc.selection = i 
							lst_itms.selection = i
								
							--Generate list item and contents   --selection
							GenerateListItemContents  i 
						)
							
						--GenerateSelection
						GenerateSelection()
							
					)
						
					----------------------------------------------------------------------------------
						
					on btn_addEnt pressed do 
					(
						--Create Entry Function
						CreateNewImportListEntry()
					)
						
					----------------------------------------------------------------------------------
						
					on chngVal entered i do 
					(
						if impSter != undefined then
						(
							presetImportLoc.items = impSavedData.keys
								
							impFolderPath = i
								
							--substitutes slashes for backslashes
							impFolderPath = SubPathString impFolderPath impFolderPath "\r" "/r"
							impFolderPath = SubPathString impFolderPath impFolderPath "\\" "/"
								
							-- filters path for displaying purposes 
							import_fldr_nam.text = filenameFromPath impFolderPath
							import_fldr_nam.tooltip = impFolderPath
							presetImportLoc.tooltip = impFolderPath
								
							SetDictValue impSavedData (execute impSter) (impFolderPath as string)
								
							--reapply it to current value
							chngVal.text = impFolderPath
								
							--save list 
							SaveImpList()
								
							destroyDialog impWndw
						)
					)
						
					----------------------------------------------------------------------------------
						
					on accpt pressed do
					(						
						if impSter != undefined then
						(
							presetImportLoc.items = impSavedData.keys
								
							impFolderPath = chngVal.text
								
							--substitutes slashes for backslashes
							impFolderPath = SubPathString impFolderPath impFolderPath "\r" "/r"
							impFolderPath = SubPathString impFolderPath impFolderPath "\\" "/"
								
							-- filters path for displaying purposes 
							import_fldr_nam.text = filenameFromPath impFolderPath
							import_fldr_nam.tooltip = impFolderPath
							presetImportLoc.tooltip = impFolderPath
								
							SetDictValue impSavedData (execute impSter) (impFolderPath as string)
								
							--reapply it to current value
							chngVal.text = impFolderPath
								
							--save list 
							SaveImpList()
								
							destroyDialog impWndw
						)	
					)
						
					----------------------------------------------------------------------------------
						
					on dlt_Entry pressed do 
					(
						if lst_itms.selection > 0 then 
						(
							impSter = ("#" + (lst_itms.items[lst_itms.selection] as string))
							impSter2 = GetDictValue impSavedData (execute impSter)
							
							if impSter != undefined then 
							(
								RemoveDictValue impSavedData (execute impSter)
								deleteItem itemList lst_itms.selection
									
								--refresh list
								presetImportLoc.items = impSavedData.keys
								itemList = presetImportLoc.items
								lst_itms.items = itemList
									
									
								--save list 
								SaveImpList()
								
								presetImportLoc.selection = (impSavedData.count - (impSavedData.count-1))
								destroyDialog impWndw
							)
						)
					)
						
					----------------------------------------------------------------------------------		
						
					on exp_Open pressed do 
					(
							
						str = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:impSter2
							
						if str != undefined then 
						(
							chngVal.text = str
								
							impFolderPath = chngVal.text
								
							--substitutes slashes for backslashes
							impFolderPath = SubPathString impFolderPath impFolderPath "\r" "/r"
							impFolderPath = SubPathString impFolderPath impFolderPath "\\" "/"
								
							--reapply it to current value
							chngVal.text = impFolderPath
							
							-- filters path for displaying purposes 
							import_fldr_nam.text = filenameFromPath impFolderPath
							import_fldr_nam.tooltip = impFolderPath
							presetImportLoc.tooltip = impFolderPath
								
							SetDictValue impSavedData (execute impSter) (impFolderPath as string)
								
							--save list 
							SaveImpList()
							
						)
						
					)
						
					----------------------------------------------------------------------------------
						
					on impWndw open do 
					(
						
						if presetImportLoc.items.count != 0 do 
						(
							itemList = presetImportLoc.items
							lst_itms.items = itemList
								
							if presetImportLoc.selection != undefined then 
							(
								
								lst_itms.selection = findItem itemList presetImportLoc.selection
									
							)
							--print itemList
						)
						
					)
						
					on impWndw close do 
					(
						updList.enabled = false
					)
						
					
				)			
				
				--valNam.text = ster
				
				createDialog impWndw width:400
			)	
				
		)	
		

		--------------------------------------------------------------------------------------------------------------------------------
		--CLEAR - the export list
		--------------------------------------------------------------------------------------------------------------------------------
			
		on btn_imp_clear_itm pressed do 
		(
			free impSavedData
			
			presetImportLoc.items = impSavedData.keys 
			
		)
		--------------------------------------------------------------------------------------------------------------------------------	
		--DELETE - the export list
		--------------------------------------------------------------------------------------------------------------------------------
			
		on btn_imp_dlt_preset pressed do 
		(		
			local usedotNam = sysInfo.username as string
				
			impss = ("C:\\Users\\"+ usedotNam +"\\PresetImportLocations.fp")
				
			deletefile (impss)
			free impSavedData
			presetImportLoc.items = impSavedData.keys
			--messagebox "Presets Loaded!" title:"Flow Panels"
				
		)
		--------------------------------------------------------------------------------------------------------------------------------	
		--SELECTED ITEM
		--------------------------------------------------------------------------------------------------------------------------------
			
		--when selected 
		On filesToImport selected i do 
		(
			if scrollToSelection do 
			(
				filesToImport.selection = i
			)
				
			--Sets the name of selection and filters name 
			lbl_imp_obj_nam.text = filenameFromPath (filesToImport.items[i]  as string )
			str = lbl_imp_obj_nam.text
			str = substituteString str ".FBX" ""
			str = substituteString str ".fbx" ""
			lbl_imp_obj_nam.text = str 
		)
		--------------------------------------------------------------------------------------------------------------------------------	
		--DOUBLED CLICK ITEM
		--------------------------------------------------------------------------------------------------------------------------------
			
		--when double clicked
		On filesToImport doubleClicked i do 
		(
			--BOOLS
 			if loadFBXfiles do -- FBX
 			(
				if forceImport then
				(	
					importFile (importItemsArray[filesToImport.selection] as string) #noPrompt
				)
				else
				(
					importFile (importItemsArray[filesToImport.selection] as string)
				)
 			)
			
 			if loadMAXfiles do --MAX
 			(
 				loadMaxFile (importItemsArray[filesToImport.selection] as string)
				print("OPEN MAX FILE")
 			)
				
			if loadInstFiles do --INSTANCE
			(
				Containers.CreateInheritedContainer (importItemsArray[filesToImport.selection] as string)				
				
 				--loadMaxFile (importItemsArray[filesToImport.selection] as string)
				--print("OPEN MAX FILE")
			)
		)
		--------------------------------------------------------------------------------------------------------------------------------	
		--IMPORT 
		--------------------------------------------------------------------------------------------------------------------------------
		on btn_imp_sing pressed do 
		(
			--BOOLS
 			if loadFBXfiles do -- FBX
 			(
				if forceImport then
				(	
					importFile (importItemsArray[filesToImport.selection] as string) #noPrompt
				)
				else
				(
					importFile (importItemsArray[filesToImport.selection] as string)
				)
 			)
			
 			if loadMAXfiles do --MAX
 			(
 				loadMaxFile (importItemsArray[filesToImport.selection] as string)
				print("MAX FILE Opened!")
 			)
				
			if loadInstFiles do --INSTANCE
			(
				Containers.CreateInheritedContainer (importItemsArray[filesToImport.selection] as string)				
				
 				--loadMaxFile (importItemsArray[filesToImport.selection] as string)
				--print("OPEN MAX FILE")
			)
			
		)	
			
		--------------------------------------------------------------------------------------------------------------------------------	
		--IMPORT ALL
		--------------------------------------------------------------------------------------------------------------------------------
			
		--when Import All is pressed
		On btn_imp_all pressed do 
		(
			tempArray = importItemsArray
				
			try destroyDialog imProg catch()
			rollout imProg "Import Progress"
			(
				ProgressBar impProgBar 		color:red				
			)
			createDialog imProg 
				
				
			if tempArray != undefined do 
			(
				o = 0
				if forceImport then		
				(	
					 
					if querybox "are you sure you want to import every object within folder?" then 						
						for i in tempArray do
						(
								
							importFile i #noPrompt
								
							o=o+1
								
							imProg.impProgBar.value = 100*o/temparray.count
							
						)
					else
					(	
						destroyDialog imProg
						return false
					)
				)
				else
				(
					if querybox "are you sure you want to import every object within folder?" then 
						
						if querybox "want to turn on automatic import?" then
							for i = o to tempArray.count do
							(
								importFile i #noPrompt
								imProg.impProgBar.vaue = 100*o/temparray.count
							)
						else
							for i in tempArray do
							(
								importFile i 
								imProg.impProgBar.vaue = 100*o/temparray.count
							)
					else
					(	
						destroyDialog imProg
						return false
					)
				)					
				
			)
			
			if imProg.impProgBar.value == 100 do
			(
				imProg.impProgBar.value = 0
				destroyDialog imProg
			)
			
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--IMPORT CHECKBUTTON - - FBX
		--------------------------------------------------------------------------------------------------------------------------------
			
		--LOAD FBX FILES -- TOGGLE
		On loadFBXs changed state do
		(   
			Undo on
			loadFBXfiles = state	
				
			--turn off FBX import
			loadMAXfiles = false
			loadMAXs.checked = false
				
			--turn off INST import
			loadInstFiles = false
			loadINSTs.checked = false
				
			--records file type bool
			if loadFBXfiles == true then
			(
				set_import_file_type = 1
			)
			else 
				set_import_file_type = 4
				
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--IMPORT CHECKBUTTON - - MAX
		--------------------------------------------------------------------------------------------------------------------------------
			
		--LOAD MAX FILES -- TOGGLE
		On loadMAXs changed state do
		(   
			Undo on
			loadMAXfiles = state	
				
			--turn off FBX import
			loadFBXfiles = false
			loadFBXs.checked = false
				
			--turn off INST import
			loadInstFiles = false
			loadINSTs.checked = false
				
			--records file type bool
			if loadMAXfiles == true then
			(
				set_import_file_type = 2
			)
			else 
				set_import_file_type = 4
				
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--IMPORT CHECKBUTTON - - INSTANCES
		--------------------------------------------------------------------------------------------------------------------------------
			
		--LOAD FBX FILES -- TOGGLE
		On loadINSTs changed state do
		(   
			Undo on
			loadInstFiles = state	
				
			--turn off MAX import
			loadMAXfiles = false
			loadMAXs.checked = false
				
			--turn off FBX import
			loadFBXfiles = false
			loadFBXs.checked = false
				
			--records file type bool
			if loadInstFiles == true then
			(
				set_import_file_type = 3
			)
			else 
				set_import_file_type = 4
				
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--REFRESH LIST
		--------------------------------------------------------------------------------------------------------------------------------
			
		--Refresh List 
		on btn_ref_lst pressed do 
		(
			-- function - - creates import list - 
			ManifestImportList()			
		)
		--------------------------------------------------------------------------------------------------------------------------------
		--SET FOLDER PATH 	
		--------------------------------------------------------------------------------------------------------------------------------
			
		--show folder in explorer
		on btn_imp_show_path pressed do 
		(
			str = impFolderPath
			str = substituteString str "/" "\\"
			
			
			print impFolderPath
			print str
			shelllaunch "explorer.exe" str
			
		)
			
		--paste from clipboard
		on btn_imp_clip_path pressed do 
		(
			--gets path from clipboard
			impFolderPath = getClipboardText()
				
			-- function - - creates import list - 
			ManifestImportList()
			
		)
			
			
		--set import location
		On btn_imp_fold_path pressed do 
		(
			local usedotNam = sysInfo.username as string
				
			--checks if there's a saved location, before opening
			if lastOpenedFldr != undefined then
			(
				impFolderPath = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:lastOpenedFldr
			)
			else
			(
				impFolderPath = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.")  
			)	
				
			-- function - - creates import list - 
			ManifestImportList()
				
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- 
		--EDIT FOLDER PATH MANUALLY - selected item
		-------------------------------------------------------------------------------------------------------------------------------- 
			
		On btn_edt_imp_fldph pressed do 
		(
			try destroyDialog edtPthWndw catch()
			rollout edtPthWndw "Edit Entry"
			(
				edittext valNam "Entry Name:" 				width:500	height:30							text:impFolderPath  
				button imp_Open "Open Directory"			width:110	height:20		align:#center			across:1
				button imp_Accpt "Accept"					width:110	height:20		align:#center
				button imp_dlt_Entry "Clear Path"  			width:110	height:20		align:#center
					
				----------------------------------------------------------------------------------
					
				on imp_Open pressed do 
				(

					str = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:impFolderPath
					
					
					if str != undefined then 
					(
						valNam.text = str
					)
						
					
					impFolderPath = valNam.text
						
					-- filters path for displaying purposes 
					import_fldr_nam.text = filenameFromPath impFolderPath
					import_fldr_nam.tooltip = impFolderPath
					filesToImport.tooltip = impFolderPath
						
					-- function - - creates import list - 
					ManifestImportList()
						
				)
					
				on imp_Accpt pressed do
				(
					impFolderPath = valNam.text
					-- filters path for displaying purposes 
					import_fldr_nam.text = filenameFromPath impFolderPath
					import_fldr_nam.tooltip = impFolderPath
					filesToImport.tooltip = impFolderPath
						
					-- function - - creates import list - 
					ManifestImportList()
						
					destroyDialog edtPthWndw
				)
					
				----------------------------------------------------------------------------------
					
				on imp_dlt_Entry pressed do 
				(
					impFolderPath = ""
					-- filters path for displaying purposes 
					import_fldr_nam.text = ""
					import_fldr_nam.tooltip = impFolderPath
					filesToImport.tooltip = impFolderPath
					
					-- function - - creates import list - 
					ManifestImportList()
					
					destroyDialog edtPthWndw
				)
					
				on valNam entered val do
				(
					impFolderPath = valNam.text
					-- filters path for displaying purposes 
					import_fldr_nam.text = filenameFromPath impFolderPath
					import_fldr_nam.tooltip = impFolderPath
					filesToImport.tooltip = impFolderPath
						
					-- function - - creates import list - 
					ManifestImportList()
						
					destroyDialog edtPthWndw
				)
					
				----------------------------------------------------------------------------------				
					
			)			
				
			--valNam.text = ster
			
			createDialog edtPthWndw width:525
				
 			--records settings
			set_imp_list_last_sel = presetImportLoc.selection
			SetAutoSettings set_imp_list_last_sel 15
				
		)
		
		--------------------------------------------------------------------------------------------------------------------------------
		-- OPEN // CLOSED -- 
		--------------------------------------------------------------------------------------------------------------------------------
		
		on panImporter rolledUp open do 
		(		
				
			--populate List
			presetImportLoc.items = impSavedData.keys
				
			--checks to set value of export location
-- 			if set_exp_location != undefined do
-- 			(
-- 					
-- 				--resets the list's last selected item
-- 				if(presetImportLoc.items.count > 0 and set_imp_list_last_sel != undefined) do
-- 				(
-- 					presetImportLoc.selection = set_imp_list_last_sel
-- 				)
-- 					
-- 			)	
				
			--resets import location from memory
			if set_last_import_loc != undefined do 
			(
				lastOpenedFldr = set_last_import_loc
			)
				
			--resets File to import from last settings set
			if set_import_file_type == 1 then  --sets .fbx type
			(
				loadFBXfiles = true
				loadFBXs.checked = true
					
				loadInstFiles = false
				loadMAXfiles = false
			)
			else if set_import_file_type == 2 then  --sets .max type 
			(
				loadMAXfiles = true	
				loadMAXs.checked = true
					
				loadInstFiles = false
				loadFBXfiles = false
			)
			else if set_import_file_type == 3 then  --sets .maxc type 
			(
				loadInstFiles = true	
				loadINSTs.checked = true
					
				loadMAXfiles = false
				loadFBXfiles = false
			)
			else 
			(
				loadMAXfiles = false
				loadFBXfiles = false
				loadInstFiles = false
				
				loadFBXs.checked = false
				loadMAXs.checked = false
				loadINSTs.checked = false
				
			)
				
				
-- 			if lastOpenedFldr != undefined do
-- 			(
-- 				-- filters path for displaying purposes 
-- 				import_fldr_nam.text = filenameFromPath lastOpenedFldr
-- 				import_fldr_nam.tooltip = lastOpenedFldr
-- 				
-- 				--sets initial dropdownlist items
-- 				filesToImport.tooltip = lastOpenedFldr
-- 				filesToImport.items = set_import_array
-- 			)
				
			-- function - - creates import list - 
			ManifestImportList()	
				
			--AutoCollapse
			if use_AutoCollapse == true do 
			(
				--switches to this rollout
				if open do switchRolls panImporter
			)
		)			
	)
	
	Rollout panViewport "Viewport Panel"
	(	
		
	--------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////////// VIEWPORT SETTINGS
	--------------------------------------------------------------------------------------------------------------------------------		
			
		Group "Viewport Settings" 
		(
			label FOVpre "Field of View Presets:" 		align:#left
			button btn_fov65 "65" 				width:40	across:4
			button btn_fov75 "75" 				width:40
			button btn_fov85 "85" 				width:40
			button btn_fov95 "95" 				width:40
			spinner fov " Set Field of View: " 		width:128  	range:[25,200,viewport.GetFOV()] type:#integer align:#left
			button btn_vie_real "Realistic" 	width:50 	across: 3
			button btn_vie_sha "Shaded" 		width:50
			checkbutton btn_vie_edg "Wires"  	width:50
			checkbox btn_vie_shad_tg "Shadows" 	checked:true triState:2 across: 2
			checkbox btn_vie_amb_tg "Occlusion" checked:true triState:2
		)
			
	--------------------------------------------------------------------------------------------------------------------------------FIELD OF VIEW PRESETS
		
		on btn_fov65 pressed do 
		(
			viewport.SetFOV 65.0
			completeReDraw()
		)
		
		on btn_fov75 pressed do 
		(
			viewport.SetFOV 75.0
			completeReDraw()
		)
		
		on btn_fov85 pressed do 
		(
			viewport.SetFOV 85.0
			completeReDraw()
		)
		
		on btn_fov95 pressed do 
		(
			viewport.SetFOV 95.0
			completeReDraw()
		)
	--------------------------------------------------------------------------------------------------------------------------------FIELD OF VIEW SET
			
		on fov changed val do
		(
			viewport.setFOV val
			completeReDraw()
			if val > 100  then
			(
				print ("FOV set to " + val as string + ", Son!" + ".....Um, Why tho!?")
			)
			else	
				print ("FOV set to " + val as string + ", Son!")
		)
			
		on btn_vie_real pressed do 	
		(
			undo on 
			actionMan.executeAction -844228238 "1"  -- Viewport Lighting and Shadows: Viewport Visual Style Realistic
		)
			
		on btn_vie_sha pressed do
		(
			undo on 
			actionMan.executeAction 0 "550"  -- Views: Viewport Visual Style Shaded
		)
			
		on btn_vie_edg changed state do
		(
			undo on 
			actionMan.executeAction 0 "557" -- Views: Viewport Visual Style Edged Faces Toggle 
		)
			
		on btn_vie_shad_tg changed state do
		(
			actionMan.executeAction -844228238 "5"  -- Viewport Lighting and Shadows: Viewport Shadows Toggle
		)
			
		on btn_vie_amb_tg changed state do
		(
			actionMan.executeAction -844228238 "0"  -- Viewport Lighting and Shadows: Viewport Shadows Ambient Occlusion Toggle
		)
			
	--------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////// GRID DISPLAY SETTINGS
	--------------------------------------------------------------------------------------------------------------------------------	
		Group "Grid Display"
		(
				
			checkbox grid_on "Grid Toggle" across: 2
			dropdownlist grid_active "Pick Grid Type:" items:#("Actvie Grid","Home Grid") 
				
		)
		
		on grid_on changed state do 
		(
			max grid toggle
		)
		
		on grid_active selected i do
		(
			if grid_active.selection == 1 then
			(
				macros.run "Objects Helpers" "ActivateGrid"
			)
			if grid_active.selection == 2 then
			(
				macros.run "Objects Helpers" "ActivateHomeGrid"
			)
		)
			
	--------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////// GRID SPACING SETTINGS
	--------------------------------------------------------------------------------------------------------------------------------
		local getGridSpa = getGridSpacing()
		local unitTypeLabel = set_Unit_Type
		local IsMeters = set_M_UT
		local IsCM = set_CM_UT
		local IsInches = set_INCH_UT
		
		group "Grid Dimensions:" 
		(
			label lbl_sep_grid ""		height: 5
			Spinner set_spacing 		"Set Grid Spacing:" 	type:#float 	range: [0,1000,getGridSpa]  width:100 	height: 20 			align: #left
			Spinner set_majorlines 		"Set Major Lines:  " 	type:#integer 	range: [0,1000,0]  			width:100 	height: 20 			align: #left
			Spinner set_persviewextent 	"Set Grid Extent:  " 	type:#integer 	range: [0,1000,0]  			width:100 	height: 20			align: #left
			label lbl_02 				"Preset Spacing:" 		across: 2
			dropdownlist scale_dd 		"" 						items:#("   10" + unitTypeLabel as string, "   8" + unitTypeLabel as string, "   6" + unitTypeLabel as string,  "   4" + unitTypeLabel as string,
				"   2" + unitTypeLabel as string,"   1" + unitTypeLabel as string, "   1/2" + unitTypeLabel as string, "   1/4" + unitTypeLabel as string, "   1/8" + unitTypeLabel as string) width: 80 align: #center
			
		)
		--------------------------------------------------------------------------------------------
			
		timer getViewportTimer "" interval:100
		timer getPresetSpace   "" interval:100	
			
		on getViewportTimer tick do 
		(
			set_spacing.range = [0,1000,getGridSpacing()]
			set_majorlines.range = [0,1000,getGridMajorLines()]
			set_persviewextent.range = [0,1000,gridPrefs.perspViewGridExtents]
			fov.range = [25,200,viewport.GetFOV()]
			
			
		)
			
		on getPresetSpace tick do 
		(
				
			if IsMeters then
			(
				--preset spacing unit scale label
				unitTypeLabel = " m"
					
				scale_dd.items = #("   10" + unitTypeLabel, "   8" + unitTypeLabel, "   6" + unitTypeLabel,  "   4" + unitTypeLabel, 
					"   2" + unitTypeLabel,"   1" + unitTypeLabel, "   1/2" + unitTypeLabel, "   1/4" + unitTypeLabel, "   1/8" + unitTypeLabel)
					
				--turn timer off
				getPresetSpace.active = false
			)
			else if IsCM then
			(
				--preset spacing unit scale label
				unitTypeLabel = " cm"
					
				scale_dd.items = #("   10" + unitTypeLabel, "   8" + unitTypeLabel, "   6" + unitTypeLabel,  "   4" + unitTypeLabel, 
					"   2" + unitTypeLabel,"   1" + unitTypeLabel, "   1/2" + unitTypeLabel, "   1/4" + unitTypeLabel, "   1/8" + unitTypeLabel)
					
				--turn timer off
				getPresetSpace.active = false
			)
			else if IsInches then
			(
				--preset spacing unit scale label
				unitTypeLabel = " in"
					
				scale_dd.items = #("   10" + unitTypeLabel, "   8" + unitTypeLabel, "   6" + unitTypeLabel,  "   4" + unitTypeLabel, 
					"   2" + unitTypeLabel,"   1" + unitTypeLabel, "   1/2" + unitTypeLabel, "   1/4" + unitTypeLabel, "   1/8" + unitTypeLabel)
					
				--turn timer off
				getPresetSpace.active = false
			)
		)
			
		--------------------------------------------------------------------------------------------	
		---------------------------------------------------------------------------Grid Spacing Controls
		on scale_dd selected i do
		(
			if scale_dd.selection == 1 then setGridSpacing 10
			if scale_dd.selection == 2 then setGridSpacing 8
			if scale_dd.selection == 3 then setGridSpacing 6
			if scale_dd.selection == 4 then setGridSpacing 4
			if scale_dd.selection == 5 then setGridSpacing 2
			if scale_dd.selection == 6 then setGridSpacing 1			
			if scale_dd.selection == 7 then setGridSpacing .5
			if scale_dd.selection == 8 then setGridSpacing .25
			if scale_dd.selection == 9 then setGridSpacing .125
		)
			
		on set_spacing changed spa do
		(
			spa = set_spacing.value
			setGridSpacing spa
		)
			
		on set_majorlines changed state do
		(
			state = set_majorlines.value
			SetGridMajorLines state
		)	
		
		on set_persviewextent changed state do
		(
			state = set_persviewextent.value
			gridPrefs.perspViewGridExtents = state
		)	
		--------------------------------------------------------------------------------------------------------------------------------	
		--//////////////////////////////////////////////////////////////////////////////////// UNIT SETUP SETTINGS
		--------------------------------------------------------------------------------------------------------------------------------
			
		group "Unit Setup:" 
		(
			Edittext edt_Unit 	"Unit Type:" 	labelOnTop:false	readOnly:true text:unitTypeLabel
				
			Button btn_un_M		"Meters"		width:40	align:#left 	across:3
			Button btn_un_CM	"Centimeters"	width:70	align:#center
			Button btn_un_IN	"Inches"		width:40	align:#right
		)
			
		on btn_un_CM pressed do 
		(
			--DISPLAYS UNIT TYPE 
			edt_Unit.text = "#Centimeters"
			
			--SETS SYSTEM UNIT TYPE 
			units.DisplayType = #Metric
			units.MetricType  = #Centimeters
			units.SystemType  = #Centimeters
				
			--preset spacing unit scale label
			IsMeters = false
			IsCM = true
			IsInches = false
				
			--turn timer on
			getPresetSpace.active = true
				
			--Record Settings -- Primitve Scale Value
			SetAutoSettings edt_Unit.text 17
				
			--Record Settings -- Unit Type Bool
			SetAutoSettings IsMeters 18
			SetAutoSettings IsCM 19
			SetAutoSettings IsInches 20
		)
		
		on btn_un_M pressed do 
		(
			--DISPLAYS UNIT TYPE 
			edt_Unit.text = "#Meters"
			
			--SETS SYSTEM UNIT TYPE 
			units.DisplayType = #Metric
			units.MetricType  = #Meters
			units.SystemType  = #Meters
				
			--preset spacing unit scale label
			IsMeters = true
			IsCM = false
			IsInches = false
				
			--turn timer on
			getPresetSpace.active = true
				
			--Record Settings -- Primitve Scale Value
			SetAutoSettings edt_Unit.text 17
				
			--Record Settings -- Unit Type Bool
			SetAutoSettings IsMeters 18
			SetAutoSettings IsCM 19
			SetAutoSettings IsInches 20
				
		)
		
		on btn_un_IN pressed do 
		(
			--DISPLAYS UNIT TYPE 
			edt_Unit.text = "#Inches"
			
			--SETS SYSTEM UNIT TYPE 
			units.DisplayType = #US
			units.USType  = #Dec_In
			units.SystemType  = #Inches
				
			--preset spacing unit scale label
			IsMeters = false
			IsCM = false
			IsInches = true
				
			--turn timer on
			getPresetSpace.active = true
				
			--Record Settings -- Primitve Scale Value
			SetAutoSettings edt_Unit.text 17
				
			--Record Settings -- Unit Type Bool
			SetAutoSettings IsMeters 18
			SetAutoSettings IsCM 19
			SetAutoSettings IsInches 20
				
		)
			
		--------------------------------------------------------------------------------------------------------------------------------	
		--//////////////////////////////////////////////////////////////////////////////////// OPEN // CLOSE SETTINGS
		--------------------------------------------------------------------------------------------------------------------------------
			
		on panViewport rolledUp open do 
		(
			if open do 
			(
				--AutoCollapse
				if use_AutoCollapse == true do 
				(
					--switches to this rollout
					if open do switchRolls panViewport
				)
					
					
				--Set Preset Spacing type
				if IsMeters then
				(
					--preset spacing unit scale label
					unitTypeLabel = " m"
						
					scale_dd.items = #("   10" + unitTypeLabel, "   8" + unitTypeLabel, "   6" + unitTypeLabel,  "   4" + unitTypeLabel, 
						"   2" + unitTypeLabel,"   1" + unitTypeLabel, "   1/2" + unitTypeLabel, "   1/4" + unitTypeLabel, "   1/8" + unitTypeLabel)
						
				)
				else if IsCM then
				(
					--preset spacing unit scale label
					unitTypeLabel = " cm"
						
					scale_dd.items = #("   10" + unitTypeLabel, "   8" + unitTypeLabel, "   6" + unitTypeLabel,  "   4" + unitTypeLabel, 
						"   2" + unitTypeLabel,"   1" + unitTypeLabel, "   1/2" + unitTypeLabel, "   1/4" + unitTypeLabel, "   1/8" + unitTypeLabel)
						
				)
				else if IsInches then
				(
					--preset spacing unit scale label
					unitTypeLabel = " in"
						
					scale_dd.items = #("   10" + unitTypeLabel, "   8" + unitTypeLabel, "   6" + unitTypeLabel,  "   4" + unitTypeLabel, 
						"   2" + unitTypeLabel,"   1" + unitTypeLabel, "   1/2" + unitTypeLabel, "   1/4" + unitTypeLabel, "   1/8" + unitTypeLabel)
						
				)
			)
				
		)
			
		on panViewport rolledUp close do 
		(
			if close do 
			(
				--AutoCollapse
				if use_AutoCollapse == true do 
				(
					--switches to this rollout
					if close do switchRolls panViewport
				)				
			)
			
			--turn off viewport timer
			getViewportTimer.active = not getViewportTimer.active
			--print ("Viewport Auto-Update is set to " + getViewportTimer.active as string)
		)
	)
		
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	local rolls = #(panOrganize, panCreate, panModeling, panNormals, panPaint, panExporter, panImporter, panViewport) 
		
	--ON START
    on  panFlowPan open do
	(
		is_RolledUpOnStart = FP_Global_Settings[4]
		
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
		
	--ON CLOSE 
	on panFlowPan close do
	(
		toolSetClosePos = getdialogpos panFlowPan
			
		--record Tool Position
		SetGlobalFPData toolSetClosePos 5
		
		
		
		set_exp_location = auto_FP_Settings[9]
		
		
		
		if (use_SettingsRecorder) do
		(
			--saves recorder data
			SaveRecorderSettings()
		)
			
		--saves tool settings
		SaveToolSettingsFP()
	)
	
-- 	on panFlowPan resized size do
-- 	(
-- 		print "RESIZING"
-- 		FPHeight = size -- save the new window size
-- 		
-- 		panFlowPan.height = FPHeight.y
-- 		--panFlowPan.width = FPHeight.x
-- 		scriptBin.height = FPHeight.y
-- 		--scriptBin.width = FPHeight.x
-- 		
-- 		
-- 	)

)


-------------------------------------------------------------------------------------------------------------------------------------	

---------------------------------------------------------------------------------------------------------------- // CreateU

createdialog panFlowPan  width:240 height:(FPHeight.y) style:#(#style_titlebar, #style_sysmenu, #style_toolwindow, #style_resizing, #style_minimizebox) pos:toolSetClosePos menu:ToolSettingsMenu  --bgColor:[rRed,bBlu,gGre] 




