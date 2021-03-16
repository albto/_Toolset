
---------------------------------------------------------------------------------------------------------------- // Tool Settings
--Tool Settings 

--try(closeRolloutFloater newwind)catch()
Try(cui.UnregisterDialogBar myRoll)catch()
Try(destroydialog myRoll)catch()


--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------- // GLOBAL SETTINGS
--------------------------------------------------------------------------------------------------------------------------------------

global myRoll, panCreate, SubRollout3, SubRollout4, paintPan, panOrganize, panExporter, panImporter panViewport

--------------------------------------------------------------------------------------------------------------------------------------

persistent global toolSetClosePos
	

--------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------// LOAD PRESET LIST
--------------------------------------------------------------------------------------------------------------------------------------

global savedData
global impSavedData


-- Auto-Load Export Preset Locations on Start-up
if savedData == undefined do 
(	
	local usedotNam = sysInfo.username as string
	
	if (ss = openfile ("C:\\Users\\"+ usedotNam +"\\PresetLocations.fp") != undefined) then
	(
		ss = openfile ("C:\\Users\\"+ usedotNam +"\\PresetLocations.fp") mode:"r"
		savedData = execute (readLine ss)
		close ss
	)
	else
		savedData = #()
)

-- Auto-Load Export Preset Locations on Start-up
if impSavedData == undefined do 
(	
	local usedotNam = sysInfo.username as string
	
	if (impss = openfile ("C:\\Users\\"+ usedotNam +"\\PresetImportLocations.fp") != undefined) then
	(
		impss = openfile ("C:\\Users\\"+ usedotNam +"\\PresetImportLocations.fp") mode:"r"
		impSavedData = execute (readLine impss)
		close impss
	)
	else
		impSavedData = #()
)


	
--remember position on close
if toolSetClosePos == undefined do 
(
	toolSetClosePos = [400,100]
)

--------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------- // GLOBAL TOOL VARIABLES
--------------------------------------------------------------------------------------------------------------------------------------
persistent global auto_FP_Settings
persistent global FP_Global_Settings
global use_SettingsRecorder
global use_AutoDocking = true
global use_AutoCollapse = true
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


------------------------------------------------------------------------------------------------------------- 
--resets all settings from last session and distributes them to 
--the parameters set in memory intgrs.	--LOAD settings
------------------------------------------------------------------------------------------------------------- 

global useGlobalDotNam = sysInfo.username
global fps
global fpini

------------------------------------------------------------------------------------------------------------- 
-- UI COLOR Controls-----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------- 

global rRed = 50
global bBlu = 50
global gGre = 50

------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------- // GLOBAL TOOL SETTINGS
------------------------------------------------------------------------------------------------------------- 

--Sets the global tool settings 
if FP_Global_Settings == undefined do
(
	if ( doesFileExist ("C:\\Users\\"+ useGlobalDotNam +"\\FPGlobals.fp") ) then
	(
		fpini = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\FPGlobals.fp") mode:"r"
		FP_Global_Settings = execute (readLine fpini)
		close fpini
	)
	else 
	(
		FP_Global_Settings = #(true, false, true, true)
	)
)


--Global Tool Settings
use_SettingsRecorder 	= FP_Global_Settings[1]
use_AutoDocking			= FP_Global_Settings[2]
use_AutoCollapse 		= FP_Global_Settings[3]
is_RolledUpOnStart 		= FP_Global_Settings[4]

------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------- // RECORDER SETTINGS
------------------------------------------------------------------------------------------------------------- 

--Checks whether to load recorder settings or not
if (use_SettingsRecorder == true) then
(
	if ( doesFileExist ("C:\\Users\\"+ useGlobalDotNam +"\\AutoSettings.fp")) then
	(
		fps = openfile ("C:\\Users\\"+ useGlobalDotNam +"\\AutoSettings.fp") mode:"r"
		auto_FP_Settings = execute (readLine fps)
		close fps
	)
	else 
	(
		auto_FP_Settings = #(false,false,false,false,false,false,".","msh","", false, 1, "", #(), 0, 1, 0.0, "", false, false, false)
	)
)
else 
(
	auto_FP_Settings = #(false,false,false,false,false,false,".","msh","", false, 1, "", #(), 0, 1, 0.0, "", false, false, false)
)


------------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------------- 

--Saves Recorder Settings
fn SaveRecorderSettings = 
(
	--write to file
	fps = createFile ("C:\\Users\\"+ useGlobalDotNam +"\\AutoSettings.fp")
	
	format (with printAllElements on auto_FP_Settings as string) to:fps
	flush fps
	close fps
)

--Saves Flow Panels Global Settings
fn SaveToolSettingsFP = 
(
		
	fpini = createFile ("C:\\Users\\"+ useGlobalDotNam +"\\FPGlobals.fp")	
	format (with printAllElements on FP_Global_Settings as string) to:fpini
	flush fpini
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

------------------------------------------------------------------------------------------------------------- 
------------------------------------------------------------------------------------------------------------- 
-- sets the Global Tool Settings
fn SetGlobalFPData val intgr =
(
	FP_Global_Settings[intgr] = val
)

--sets the Settings to be saved
fn SetAutoSettings val intgr = 
(
	auto_FP_Settings[intgr] = val
)


--------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------
		
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
		
	-- Help Archives 
	on itmLoadHelp picked do
	(
		--actionMan.executeAction 0 "40036"
		--custom browser
-- 		Try(destroydialog webbrowser_rollout)catch()
		
-- 		rollout webbrowser_rollout "Help Manual" width:1000 height:1000 category:10
-- 		(
-- 			dotNetControl wb "System.Windows.Forms.WebBrowser" pos:[10,10] width:1000 height:1000
-- 		)
			
		--createdialog webbrowser_rollout
-- 			
-- 		webbrowser_rollout.wb.url = dotNetObject "System.Uri" "http://help.autodesk.com/view/3DSMAX/2018/ENU/"
-- 		webbrowser_rollout.wb.AllowNavigation = dotNetObject "System.Boolean" True
-- 		webbrowser_rollout.wb.AllowWebBrowserDrop = dotNetObject "System.Boolean" True
-- 		webbrowser_rollout.wb.IsAccessible = dotNetObject "System.Boolean" True
-- 		webbrowser_rollout.wb.IsWebBrowserContextMenuEnabled = dotNetObject "System.Boolean" True
-- 		webbrowser_rollout.wb.Parent = dotNetObject "System.Windows.Forms.Control"
-- 		
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		Try(destroydialog maxForm)catch()
		
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
		maxForm.Size = dotNetObject "System.Drawing.Size" 1000 1000
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
		cui.registerDialogBar myRoll
		cui.dockDialogBar myRoll #cui_dock_left
	)
		
	-- Allows the Tool to Float
	on myItem3 picked do
	(
		cui.floatDialogBar myRoll
	)
		
	-- Close Tool
	on itmCloseTool picked do
	(
		Try (cui.unRegisterDialogBar myRoll) catch()
		Try (destroydialog myRoll) catch()
	)
		
	--Turn on Auto-Dock -- On by Default
	on itmChkDock picked do
	(
		autoDockVal = not autoDockVal
		use_AutoDocking = not use_AutoDocking
		
		--saves setting 
		SetGlobalFPData use_AutoDocking 2
	)
		
	--Turn on recorder
	on itmRecorder picked do
	(
		SetautoRecorderOn = not SetautoRecorderOn
		use_SettingsRecorder = not use_SettingsRecorder
		
		--saves setting 
		SetGlobalFPData use_SettingsRecorder 1
		
	)
	
	--Panel Options -- Rolled-up on Startup
	on itmRolledStart picked do
	(
		
		autoRolPanels = not autoRolPanels --On Start-up
		is_RolledUpOnStart = autoRolPanels --For Live Updating
		
		--saves setting 
		SetGlobalFPData autoRolPanels 4
		
	)
		
	--Sets auto-collapse
	on itmCollapse picked do
	(
		autoColPanels = not autoColPanels --On Start-up
		use_AutoCollapse = autoColPanels --For Live Updating
		
		--saves setting 
		SetGlobalFPData autoColPanels 3
		
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
		messagebox "Copyright © 2017 by Alberto Rodriguez"
	)
		
	--Reload toolset
	on itmReloadTool picked do
	(
		fileIn "D:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_main_dialog\Flow_Panels_v4.ms"
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
rollout myRoll "Flow Panels Toolset"
	
--------------------------------------------------------------------------------------------------------------------------------------
(
	--ROLLOUT CONTROLS
	subRollout scriptBin width:(myRoll.width as float -10) pos:[5,5] height:(1100)

	fn switchRolls openedRoll =
	(
		for roll in myRoll.rolls where roll != openedRoll do 
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
			button selname "Name Select" 	width:80 height: 20 	across:2 	align:#center
			button selsim "Select Similar" 	width:80 height: 20 				align:#center
			button selclr "Select By Color" width:80 height: 20 	across:2	align:#center
			button selset "Selection Sets" 	width:80 height: 20 				align:#center
		)
			
	---------------------------------------------------------------------------------------------------------------// Current Selection Function
		
		on selset pressed do
		(
			macros.run "Edit" "namedSelSets"
		)
		
		
		on selclr pressed do
		(
			max select by color
		)
			
		on selsim pressed do
		(
			actionMan.executeAction 0 "40099" 
		)
			
		On selname pressed do 
		(
			hitByNameDlg()
		)
			
			
	---------------------------------------------------------------------------------------------------------------// Clean Up Controls
		
		Group "Clean-Up:"
		(
			button selNQ "Sel. NGons" 		width:80 	height: 20	across:2 	align:#center
			button selOF "Sel. Open" 		width:80 	height: 20				align:#center
			button selMCU "Mesh CleanUp" 	width:160 	height: 30				align:#center
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
		
		on panOrganize rolledUp open do if open do switchRolls panOrganize	
		
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
			
-- 			hlp_cont = 0 
-- 			myCont = Container isSelected:on
-- 			myCont.name = "cont_" + hlp_cont as string
-- 			myCont.name = uniquename("cont_")		
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
			
			-- place on selection's pivot point
			for i in selgroup do 
			(					
				Undo on 
					
				--position variable
				place = i.pos
					
				--places container on selection's pivot 
				myCont = Container isSelected:on allowInPlaceEditing:true pos:Place size:1 displayLabel:true
					
				--adds node to container
				myCont.AddNodeToContent i
					
				--names container
				myCont.name = "inst_" + i.name as string
				myCont.wirecolor = (color 13 229 155)
					
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
			
		group "Launch MaxScripts" 
		(
			
			DropDownList lau_scripts "" items:#("...Pick Scripts...", "1. Welder", "2. Bend of Bros", "3. Wire Mesh", "4. Pattern Maker", "5. Tycoon", "6. Weave Mesh" /*, "7. refGuides" */  )
			
		)
			
		on lau_scripts selected i do
		(
				
			--------------Button Function - Welder
			if lau_scripts.selection == 2 then 
			(
				fileIn "D:\Dropbox\[main access]\3ds_Scripts\Welder2\Welder.mse"
			)
			
			--------------Button Function - Bend of Brothers
			if lau_scripts.selection == 3 then 
			(
				fileIn "D:\Dropbox\[main access]\3ds_Scripts\BendOfBrothers-AlexanderDelagrange\BendOfBrothers.mse"
			)
			
			--------------Button Function - Wire Mesh
			if lau_scripts.selection == 4 then
			(
				fileIn "D:\Dropbox\[main access]\3ds_Scripts\Wire_Mesh_Generator\WireMeshGenerator_v1.04.mse"
			)
				
			--------------Button Function - Pattern Maker
			if lau_scripts.selection == 5 then
			(
				--Vu_FFS()
			)
			
			--------------Button Function - Tycoon
			if lau_scripts.selection == 6 then
			(
				fileIn "D:\Dropbox\[main access]\3ds_Scripts\Tycoon_Beta_1_1\Tycoon\_tycoon.mse" 
			)
			
			--------------Button Function - Weave Mesh
			if lau_scripts.selection == 7 then
			(
				--Vu_SimpleWeave ()
			)
			/*	
			-------------Button Function - refGuides UI
			if lau_scripts.selection == 8 then
			(
				macros.run "HAG refGuides" "HAG_rG_fltUI"
			)
				*/
		)
			
			
		--ON ROLLED UP -- 
		on panCreate rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panCreate
			)	
		)
			
	)	
		
	---------------------------------------------------------------------------------------------------------------- // MODELING PANEL 
	-- MODELING PANEL CONTROLS 

	Rollout subRollout3 "Modelling Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
		---------------------------------------------------------------------------MODELING TOOLS GROUP CONTROLS 
		-------------------------------------------------------------------------------------------------	
		
		Group "Object Display"
		(
			
		button laun_objprops "Object Properties" width: 160 Height: 30
			
		)
			
		-------------------------------------------------------------------------------------------------
		on laun_objprops pressed do 
		(
			filein "D:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_main_dialog\functions\object_props.ms" 
		)
			
		-------------------------------------------------------------------------------------Utilities Group Controls
		Group "Utilities"	
		( 
			
			Label	lbl_dash_label "------------- Pivot Tools -------------"	align:#center 
			
			pickbutton pb_ps 	"Grand Theft Pivot" 		width:165	align:#center
			button btn_piv_bas "_"    						width: 40	across:4 		tooltip: "Pivot to Base"   	
			button btn_piv_ape "^"   						width: 40					tooltip: "Pivot to Apex"   	
			button btn_piv_neg_y "-Y"  						width: 40					tooltip: "Pivot to Left"  		
			button btn_piv_y "+Y"   						width: 40					tooltip: "Pivot to Right"		
			button btn_piv_neg_x "-X"  						width: 40	across:4		tooltip: "Pivot to Back"		
			button btn_piv_x "+X"  							width: 40					tooltip: "Pivot to Forward"	
			button btn_piv_orig "Origin" 					width: 40					tooltip: "Pivot to Origin"		
			button btn_piv_cnt "Cntr" 						width: 40					tooltip: "Pivot to Center"	
				
			Label	lbl_dash_label2 "----------- Modeling Tools -----------"	align:#center 
				
			button btn_snd2_orig "Send to Origin"			width: 80	across:2		tooltip: "Send to Center of World"
			button btn_snd2_grid "Send to Grid"				width: 80					tooltip: "Send to Grid Space"
			button com_obj "Combine"						width: 80	across:2		tooltip: "Insets and Collapses a Face" 
			button btn_cull_tog "Culling" 					width: 80 					 
			button symRadBtn "Sym. Radial" 					width: 80 	across:2  		 
			button myBttn3 "Rename" 						width: 80  	
			button setFlowBtn "Set Flow" 					width: 80 	across:2		tooltip: "Adjust Edge Flow of Selected Edges"  
			button weld_ver "Weld Verts"					width: 80					tooltip: "Welds all verts on a single mesh.                       Only works on verts that are on top of each other. Use this as clean up."
			button zero_obj "Reset Object"					width: 80	across:2
			button btn_quick_copy "Quick Copy" 				width: 80	
			button btn_reset_trans "Reset Xform"			width: 80   across:2		 
			button btn_qck_dtach "Detach"					width: 80	
			button btn_UVW_map "UVW Map"					width: 80	across:2
			button pok_fac "Poke Face" 						width: 80 					tooltip: "Insets and Collapses a Face" 
			button delEdgePolBtn "Delete Loop" 				width: 80	across:2 		tooltip: "Cleanly Remove Edge Loop from Selected Edge"
			button tex_chk "Scale UVs" 						width: 80 					align:#right	
		)
		---------------------------------------------------------------------------------------------------- GRAND THEFT PIVOT 	
		on pb_ps picked obj do 
		(
			sel = selection as array
			
			--steal's the pivot from the picked object
			if sel != undefined do 
			sel.pivot = obj.pivot
			
		)
		---------------------------------------------------------------------------------------------------- PIVOT TO BASE	
		on btn_piv_bas pressed do
		(
			macros.run FPT toBase
		)	
		---------------------------------------------------------------------------------------------------- PIVOT to APEX
		on btn_piv_ape pressed do
		(
			macros.run FPT toApex
		)
		---------------------------------------------------------------------------------------------------- PIVOT Y max		
		on btn_piv_y pressed do
		(
			macros.run FPT yMax
		)
		---------------------------------------------------------------------------------------------------- PIVOT Y min
		on btn_piv_neg_y pressed do
		(
			macros.run FPT yMin
		)
		---------------------------------------------------------------------------------------------------- PIVOT X max
		on btn_piv_x pressed do
		(
			macros.run FPT xMax
		)
		---------------------------------------------------------------------------------------------------- PIVOT X min			
		on btn_piv_neg_x pressed do
		(
			macros.run FPT xMin
		)
		---------------------------------------------------------------------------------------------------- SEND TO ORIGIN		
		on btn_snd2_orig pressed do
		(
			Undo on
			for i in selection do 
			(
				i.pos = [0,0,0]
			)
			if selection.count == 0 do
			(
				messagebox "oops, you didn't select anything!" title:"Flow Panels"
			)
			
		)
		---------------------------------------------------------------------------------------------------- SEND TO ORIGIN		
		on btn_snd2_grid pressed do
		(
			Undo on
			for i in selection do 
			(
				i.pos = [i.pos.x,i.pos.y,0]
			)
			if selection.count == 0 do
			(
				messagebox "oops, you didn't select anything!" title:"Flow Panels"
			)
			
		)
			
		---------------------------------------------------------------------------------------------------- PIVOT TO ORIGIN				
		on btn_piv_orig pressed do
		(
			Undo on
			for i in selection do  
			(
				selection[1]
				$.pivot = [0,0,0]
			)
			if selection.count == 0 do
			(
				messagebox "oops, you didn't select anything!" title:"Flow Panels"
			)
			
		)	
		---------------------------------------------------------------------------------------------------- PIVOT TO CENTER			
		on btn_piv_cnt pressed do
		(
			Undo on
			for i in selection do  
			(
				selection[1]
				i.pivot = [i.center.x,i.center.y,i.center.z]
			)
			if selection.count == 0 do
			(
				messagebox "oops, you didn't select anything!" title:"Flow Panels"
			)
			
		)	
			
		------------------------------------------------------------------------------------------------------------------------------------
			
		--------------------------------------------------------------------------------------------------------------MODELING 
			
		------------------------------------------------------------------------------------------------------------------------------------
			
		----------------------------------------------------------------------------------------------------Delete Loop
		on delEdgePolBtn pressed do
		(
			Undo on
			macros.run FlowPanels DeleteLoop
		)			
		----------------------------------------------------------------------------------------------------Combine Objects	
		on com_obj pressed do 
		(
			Undo on
			macros.run FlowPanels CombineObj
		)
		----------------------------------------------------------------------------------------------------Weld Verts
		on weld_ver pressed do 
		(
			Undo on
			macros.run FlowPanels VertWeld
		)
		----------------------------------------------------------------------------------------------------Reset Object
		on zero_obj pressed do 
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
		on tex_chk pressed do 
		(
			undo on
			macros.run FlowPanels RescaleUVs
			
		)
		----------------------------------------------------------------------------------------------------
		
		
-------------------------------------------------------------------------------------Cloners Group Controls
			
		Group "Cloners List"
		(
			
			dropdownlist cloner_list "" items:#("...Pick Cloner...", "1. Clone Radial", "2. Clone on Curve", "3. Building Maker",  "4. CloneSpline Rad", "5. Path Cloner","6. Cloner Setup") width: 150	align:#center 
			
		)
			
			
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
				fileIn "D:\Dropbox\[main access]\3ds_Scripts\HTM-PRJ_cityblks-BMscripts\BuildingMaker.ms"
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
		
		on subRollout3 rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls subRollout3
			)
			
		)
	)
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	Rollout paintPan "Painting Panel"  
		
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// PAINTING PANEL
	--------------------------------------------------------------------------------------------------------------------------------------
		
	--------------------------------------------------------------------------------------------------------------------------------------	
	(
		
		group "Viewport Canvas: "
		(
			button viewCanvas "Launch Viewport Canvas" width: 160 Height: 30
		)
		
		on viewCanvas pressed do 
		(
			macros.run "Viewport Canvas" "ViewportCanvas"
		)
			
			
			
		on paintPan rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls paintPan
			)	
				
		)
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	Rollout subRollout4 "Normals Panel"
		
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
		
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------
		
	On cmdReset pressed do 
	(
		if selection.count > 0 do
		(
			macros.run "Modifiers" "EditPolyMod"
			maxOps.CollapseNode $ off
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
	on subRollout4 rolledUp open do if open do switchRolls subRollout4
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
		local	vendFold 	= "C:\Users\Alberto\Documents\Vendors"
		local	setDirLocal = vendFold
		local 	autoType 	= set_autoType_checked
		local 	qx_fldr 	= set_exp_location
		local	noPrompt 	= set_noprompt_exp
		local 	objTypeSet 	= set_obj_typ_checked
		local 	fbxTypeSet 	= set_fbx_typ_checked
		local   renamObjs 	= set_renamObjs
		local   offSwitch 	= false
	------------------------------------------------------------------------------------------------------------------------------------- PROPERTIES
			
		Group "Properties:"
		(	
			edittext preNam   "Prefix:"			labelOnTop: true			align:#left 	width: 35	height:20	across:3  fieldWidth: 5
			edittext multiNam "Object Name:"	labelOnTop: true			align:#center 	width: 100	height:20
			edittext verNam   "Suffix:"			labelOnTop: true			align:#right 	width: 35	height:20
			
			spinner btn_incr_vr "Use to Increment Suffix Letter" 			type:#integer	align:#right	width: 30 	height:18	range:[1, 26, 1]	tooltip:"increment suffix letter"
			
			label lbl_opt_ext "Export Options:"								align:#left			
			
			checkbutton btn_use_objNam "Name"								width: 55		checked:use_ObjNam				align:#left		Tooltip:"Toggle On, to Use Selection's name as 'Object Name'" across:3 	
			checkbutton btn_renam_on "Rename"								width: 55		checked:renamObjs				align:#center	Tooltip:"Toggle On, to allow Renaming of Objects" 	
			checkbutton btn_unity_exp "Unity3D" 							width: 55		checked:Unity_Y_Up				align:#right	Tooltip:"Sets Y-up instead of Z" 					
			
			checkBox autoTypeCheck "Auto-Match Type to Prefix" 				align:#left		checked: autoType				Tooltip:"Automatically sets the object export type based on prefix"
			checkBox noPromptCheck "No Prompt on Export" 					align:#left		checked: noPrompt				Tooltip:"Ignore all prompts and send directly to folder"
			
			label lbl_obj_typ "Export File Type:"							align:#left
			
			checkbutton btn_obj_typ "Export OBJ" 							align:#left		width: 80	checked:objTypeSet			across:2
			checkbutton btn_fbx_typ "Export FBX"							align:#left		width: 80 	checked:fbxTypeSet
		)
			
	------------------------------------------------------------------------------------------------------------------------------------- QUICK EXPORT
			
		Group "Export:"
		(
			button b_Quick_Export "Quick Export!" 				width: 160			height:50
		)
			
	------------------------------------------------------------------------------------------------------------------------------------- EXPORT LOCATION
			
		Group "Export Location:"
		(
			edittext disp_fldr_nam ""					labelOnTop: true		height:20 		width: 150		align:#left				tooltip:""							fieldWidth:160 across:2  
			button btn_add_itm "+" 												width:18 		height:20 		align:#right 			tooltip:"add item to Presets"              
			button btn_fold_path "Set Export Location"							width: 160		height: 20								tooltip: "Manually"
		)		
			
	------------------------------------------------------------------------------------------------------------------------------------- PRESETS
			
		Group "Preset Locations"
		(
			
			dropdownlist theList "" items:#() 		width:150		    height:20		align:#left			   	tooltip:""  									across: 2
			button btn_del_item "-" 				width:18 			height:20 		align:#right 			tooltip:"remove item from Presets"              
			button btn_save_itm "Save"				width:40			height:20 		align:#center			tooltip:"save presets to file"					across: 4
			button btn_load_itm "Load"				width:40			height:20		align:#center			tooltip:"load presets file"
			button btn_clear_itm "Clear"			width:40			height:20		align:#center			tooltip:"clear presets"
			button btn_dlt_preset "Delete" 			width:40			height:20		align:#center			tooltip:"delete presets save file"
		)
			
	-------------------------------------------------------------------------------------------------------------------------------- TIMERS		
			
		--Selection Timer; update Object Name on selection
		timer checkSel "" interval:100 active:use_ObjNam
		timer typCheck "" interval:100 active:autoType
			
	-------------------------------------------------------------------------------------------------------------------------------- FUNCTIONS			
			
		--EXPORTS MESHES
		fn rdyForExport = 
		(
				
			--force export  and set Y-up
			if noPrompt then
			(
				ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
					
				--sets pivot to first selection 
				$.pivot = selection[1].pivot
					
				exportFile	( qx_fldr + ObjNam ) #noPrompt selectedOnly:true
			)
			else  --prompt on export and set Y-up
			(
				ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
					
				--sets pivot to first selection 
				$.pivot = selection[1].pivot
					
				exportFile	( qx_fldr + ObjNam ) selectedOnly:true
			)
				
		)
			
		--Auto Check Type Timer  toggle 
		fn checkAutoTypeCheck bool = 
		(
			typCheck.active = bool
		)
			
		--'dynamically' changes tooltip based on selection
		fn listTooltipUpdater list =
		(			
			if list.selection != 0 do
			(
				list.tooltip = (list.items[list.selection] as string)
			)
		)	
			
		--check for Type of export based on PreFix		
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
			
		fn SomeFunction type = 
		(
			
		)
		
	--------------------------------------------------------------------------------------------------------------------------------------------------------TIMER TICKS	
			
		--No Prompt on Export
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
		
		--autoMatch prefix
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
		
		--Check for name of selection	
		on checkSel tick do 
		(
			if selection.count == 0 then 
			(			
				multiNam.enabled = offSwitch ; multiNam.text = "  Select Something"
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
			
			
	--------------------------------------------------------------------------------------------------------------------------------  PREFIX -- SETS -- TYPE	
			
		--check for Type of export based on PreFix
		on typCheck tick do 
		(
			--run function
			autoButtonTypeSwitcher fbxName objName blaName
				
		)
			
		-- RENAME LOOP
		on multiNam changed txt do 
		(
			if renamObjs do
			(
				for o in selection as array do 
					o.name = txt
			)
		)
			
	-------------------------------------------------------------------------------------------------------------------------------- EDITING LIST
			
		-- ADD - new item
		On btn_add_itm pressed do 
		(
			str = qx_fldr	
				
			driveC = @"C:\"
			driveD = @"D:\"
			driveE = @"E:\"
			driveF = @"F:\"
			driveG = @"G:\"
			driveH = @"H:\"
			driveI = @"I:\"
			driveJ = @"J:\"
				
			--Does not Allow Drives to Pass -- DRIVE GANDHALF
			if ( str == driveC or str == driveD or str == driveE or str == driveF or
					str == driveG )do
			(
				messagebox "Please pick a folder within the drive." title:"Flow Panels"
				break
				return false
			)
				
				
			if theList.selection != 0 then 
			(
				if str.count > 0 do 
				(
					if (str != theList.items[theList.selection] as string) do
					(
						append savedData str
						theList.items = savedData
						theList.selection = savedData.count
							
						--records settings
						set_list_last_sel = theList.selection
						SetAutoSettings set_list_last_sel 11
					)
						
					--'dynamically' changes tooltip based on selection
					listTooltipUpdater theList
				)
			)
			else if theList.items.count == 0 then 
			(
				if str.count > 0 do 
				(
					append savedData str
					theList.items = savedData
					theList.selection = savedData.count
					
					--records settings
					set_list_last_sel = theList.selection
					SetAutoSettings set_list_last_sel 11
				)
					
				--'dynamically' changes tooltip based on selection
				listTooltipUpdater theList
			)
			
		)
			
		-- DELETE - selected item
		On btn_del_item pressed do 
		(
			itm = theList.selection
			if itm > 0 do (
				deleteItem savedData itm
				theList.items = savedData
			)
				
			--sets selection to the last item in array
			theList.selection = theList.items.count
				
			--records settings
			set_list_last_sel = theList.selection
			SetAutoSettings set_list_last_sel 11
				
		)	
			
		-- SAVE - the export list 
		on btn_save_itm pressed do 
		(	
			local usedotNam = sysInfo.username as string
			
			if theList.items.count != 0 do
			(
				--write to file
				ss = createFile ("C:\\Users\\"+ usedotNam +"\\PresetLocations.fp") mode: "w"
				
				format "%\n" (with printAllElements on savedData as string) to:ss
				flush ss
				close ss
				
				messagebox "Presets Saved!" title:"Flow Panels"
			)
			
		)
			
		-- LOAD - the export list 
		on btn_load_itm pressed do 
		(
			local usedotNam = sysInfo.username as string
			
			-- load from file
			if (ss = openfile ("C:\\Users\\"+ usedotNam +"\\PresetLocations.fp")) != undefined do
			(
				savedData = execute (readLine ss)
				close ss
				theList.items = savedData
				--messagebox "Presets Loaded!" title:"Flow Panels"
					
				--sets selection to the last item in array
				theList.selection = 1
					
				--records settings
				set_list_last_sel = theList.selection
				SetAutoSettings set_list_last_sel 11
			)	
		)
		
		-- CLEAR - the export list
		on btn_clear_itm pressed do 
		(
			savedData = #()
			
			theList.items = savedData 
			free theList
			
		)
			
		-- DELETE - the export list
		on btn_dlt_preset pressed do 
		(		
			local usedotNam = sysInfo.username as string
				
			ss = ("C:\\Users\\"+ usedotNam +"\\PresetLocations.fp")
				
			deletefile (ss)
			savedData = #()
			theList.items = savedData
			--messagebox "Presets Loaded!" title:"Flow Panels"
					
		)
	--------------------------------------------------------------------------------------------------------------------------------Set folder path manually 
		
		on disp_fldr_nam changed txt do 
		(
			disp_fldr_nam.text = txt
			qx_fldr = txt
		)
		
	--------------------------------------------------------------------------------------------------------------------------------Set folder path 	
			
		--set export location
		On btn_fold_path pressed do 
		(
			local usedotNam = sysInfo.username as string
				
			-- sets folder path location 
			folder_path = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:setDirLocal	
				
			-- sets folder path name if undefined
			if folder_path == undefined then				
			(
				--sets prefix name to 'pre' if its field is empty
				if preNam.text == undefined or preNam.text == "" do
				(
					preNam.text = "pre"
				)
					
				--sets obj name
				multiNam.text = initNam
				ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
					
				--sets folder name
				folder_path = ("C:\\users\\"+ usedotNam +"\\Desktop")
				qx_fldr = folder_path
					
				-- filters path for displaying purposes 
				disp_fldr_nam.text = "Folder: " + filenameFromPath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
				--records settings
				SetAutoSettings qx_fldr 9
			)
			else -- sets the folder textbox text, the same as folder path location 
			(
				
				qx_fldr = folder_path
				
				disp_fldr_nam.text = "Folder: " + filenameFromPath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
				--records settings
				SetAutoSettings qx_fldr 9
			)		
				
		)
			
	--------------------------------------------------------------------------------------------------------------------------------PRESETS LOCATION ARRAY 
		
		On theList selected state do
		(
				
			--what happens when you select an item
			for i = 1 to theList.selection do
			(
					
				--grab folder path and set as item in array
				qx_fldr = theList.items[i] as string
					
				if preNam.text == undefined or preNam.text == "" do
				(
					preNam.text = "pre"
				)
					
				--set folder path
				multiNam.text = initNam
				verNam.text = "a"
				folder_path = qx_fldr
					
				--displays folder name
				disp_fldr_nam.text = "Folder: " + filenameFromPath folder_path
				--also sets the export location edit text box	
				disp_fldr_nam.tooltip = theList.tooltip
					
				--records settings
				set_list_last_sel = theList.selection
				SetAutoSettings set_list_last_sel 11
					
				--records settings
				SetAutoSettings qx_fldr 9
				
				--'dynamically' changes tooltip based on selection
				listTooltipUpdater theList
			)
				
		)
			
	--------------------------------------------------------------------------------------------------------------------------------QUICK EXPORT PROPERTIES		
			
		On b_Quick_Export  pressed do
		(   
				
			local selGroup = getCurrentSelection()
			local selArr = selGroup as array
				
			if selection.count > 0 and btn_fbx_typ.checked or selection.count > 0 and btn_obj_typ.checked then 
			(	
				--If UNITY 3D is ON - do this - sets Y-up 
				if  selGroup.count > 0 do  
				(
					--ADD OPTION TO KEEP MULTIPLE MESHES UNIQUE
					macros.run FlowPanels CopyObj
					macros.run FlowPanels CombineObj
					selGroup = getCurrentSelection()
					
					if Unity_Y_Up == true do					
					(
						for obj in selGroup do 
						(	
							--Y-up  function
							unityYUp obj
						)
					)							
					--export function
					rdyForExport()
						
					--sets pivot to first selection 
					$.pivot = selection[1].pivot
						
					--deletes exported copy 
					delete $
						
					--selects original
					select selArr
				)
			)
			else 
			(
				messagebox "Please make sure that you have a [file type] and an [object] Selected.  \n\n --This is a FlowPanels friendly reminder!" title: "Flow Panels -- Warning!" beep: false
			)	
		)
	--------------------------------------------------------------------------------------------------------------------------------INCREMENTS SUFFIX LETTER
			
		On btn_incr_vr changed val do
		(   
			verNam.text = incr[val]	
		)
			
	--------------------------------------------------------------------------------------------------------------------------------Exporting to Unity, Sets Y up 		
			
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
	--------------------------------------------------------------------------------------------------------------------------------Use to Rename Selection 		
			
		on btn_renam_on changed state do
		(
			if state == on then
			(
				renamObjs = true
				set_renamObjs = renamObjs
				
				--records settings
				SetAutoSettings set_renamObjs 10
			)
			if state == off then
			(
				renamObjs = false
				set_renamObjs = renamObjs
				
				--records settings
				SetAutoSettings set_renamObjs 10
			)
			
		)
		
	--------------------------------------------------------------------------------------------------------------------------------Use Selection Name		
			
		On btn_use_objNam changed state do
		(   
			
			if state == on then
			(
				use_ObjNam = true
				checkSel.active = use_ObjNam
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
			
	--------------------------------------------------------------------------------------------------------------------------------Set Object Type OBJ			
			
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
			
	--------------------------------------------------------------------------------------------------------------------------------Set Object Type FBX
			
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
			
	--------------------------------------------------------------------------------------------- Unreal Scripts 
		
		Group "Unreal Animation Export"
		(
			Button ue_vert_anim "Vertex Animation Tools" width:140 height:25
			Button ue_mesh_mor "Static Mesh Morpher" width:140 height:25
		)
		
		On ue_vert_anim pressed do
		(
			fileIn "D:\Dropbox\[main access]\3ds_Scripts\_Scripts\Unreal_Scripts\VertexAnimationTools.ms"
		)
		
		On ue_mesh_mor pressed do
		(
			fileIn "D:\Dropbox\[main access]\3ds_Scripts\_Scripts\Unreal_Scripts\StaticMeshMorpher.ms"
		)	
			
	-------------------------------------------------------------------------------------------------------------------------------------ON OPEN DO
			
		-- get saved data on start up
		on panExporter rolledUp open do 
		(
				
			--populate List
			theList.items = savedData
				
			--update export list's tooltip 
			listTooltipUpdater theList
				
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
				disp_fldr_nam.text = "Folder: " + filenameFromPath qx_fldr
				disp_fldr_nam.tooltip = qx_fldr
					
			)	
			--sets prefix if undefined
			if (preNam.text == "") do (
				preNam.text = "msh"
			)			
			--sets suffix to 'a' 
			if(verNam.text == "") do (
				verNam.text = "a"
			)
			
			--switches to this rollout
			if open do switchRolls panExporter
		)		
	)
-------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------
	Rollout panImporter "Import Panel"
	(
			
		local importItemsArray = set_import_array
		local impFolderPath
		local lastOpenedFldr = set_last_import_loc
		local scrollToSelection = false	
		local forceImport = false	
		local loadFBXfiles = false
		local loadMAXfiles = false		
			
			
		Group "Import Folder"
		(
			edittext import_fldr_nam ""		text: "Import Location"			labelOnTop: true		height:20 		width: 150				align:#left		tooltip:""							fieldWidth:160 across:2
			button btn_add_imp_itm "+" 												width:18 		height:20 		align:#right 			tooltip:"add item to Presets"              
			button btn_imp_fold_path "Set Import Location"							width: 160		height: 20								tooltip: "Manually"
		)
		Group "Object Info:"
		(
			label lbl_imp_obj_nam "Selected: " align:#left 
			label lbl_imp_obj_num "Number of Objects: " align:#left
		)
		
		Group "Import Options"
		(
			checkbutton loadFBXs     "Load .Fbx" 							checked:loadFBXfiles across:2
			checkbutton loadMAXs     "Load .Max" 							checked:loadMAXfiles
			
		)
		
		Group "Availble for Import:" 
		(
			listbox filesToImport 	""  									items:#() align:#right caption: "Double Click to Import"
			checkbox scrllToSel 	"Auto-Arrange Selection" 				checked:scrollToSelection
			checkbox forceImp 		"NoPrompt Import" 						checked:forceImport
			button btn_imp_all       "Import All"							width: 160		height: 20								tooltip: "Imports Everything in the list [you have been warned]"
			button btn_ref_lst       "Refresh List"							width: 160		height: 20								tooltip: "Refreshes List"
		)		
		
		Group "Preset Locations:"
		(
			dropdownlist presetImportLoc ""  items:#() 	width:150		    height:20		align:#left			   	tooltip:""										across: 2
			button btn_imp_del_item "-" 				width:18 			height:20 		align:#right 			tooltip:"remove item from Presets"              
			button btn_imp_save_itm "Save"				width:40			height:20 		align:#center			tooltip:"save presets to file"					across: 4
			button btn_imp_load_itm "Load"				width:40			height:20		align:#center			tooltip:"load presets file"
			button btn_imp_clear_itm "Clear"			width:40			height:20		align:#center			tooltip:"clear presets"
			button btn_imp_dlt_preset "Delete" 			width:40			height:20		align:#center			tooltip:"delete presets save file"
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
			
			
		-----------------------------------------------------------------------------------------------------------------------------------------------GENERATE LIST TYPE
		-- function - - Filters import list for readability-
		fn GenerateDropDownList = 
		(
			--generates dropdownlist of fbx files in the selected folder
			local files = ""
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
				
				
			local tempArray = #()
			local cleanedArray = #()
			
			importItemsArray = files
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
					
				-- filters path for displaying purposes 
				import_fldr_nam.text = "Folder: " + filenameFromPath impFolderPath
 				import_fldr_nam.tooltip = impFolderPath
 				filesToImport.tooltip = impFolderPath
					
				--generates dropdownlist of fbx files in the selected folder
				GenerateDropDownList()
					
				lbl_imp_obj_num.text = "Number of Objects: " + filesToImport.items.count as string 
				
				
				-----------------------------------------------------------------------------------SAVING DATA
				--records settings
				SetAutoSettings lastOpenedFldr 12 --saves data --function
				
				--records array
				set_import_array = importItemsArray
				SetAutoSettings set_import_array 13 --saves data --function
					
				--sets last opened location
				lastOpenedFldr = impFolderPath
			)
			else 
			(
				-- sets the folder textbox text, the same as folder path location 
				import_fldr_nam.text = impFolderPath
					
					
				--generates dropdownlist of fbx files in the selected folder
				GenerateDropDownList()
					
				--updates the Info
				lbl_imp_obj_num.text = "Number of Objects: " + filesToImport.items.count as string 
				import_fldr_nam.text = "Folder: " + filenameFromPath impFolderPath
 				import_fldr_nam.tooltip = impFolderPath
					
				-----------------------------------------------------------------------------------SAVING DATA				
				--records settings
				set_last_import_loc = impFolderPath
				SetAutoSettings set_last_import_loc 12 --saves data --function
					
				--records array
				set_import_array = importItemsArray
				SetAutoSettings set_import_array 13  --saves data --function
					
				--sets last opened location
				lastOpenedFldr = impFolderPath
			)	
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- SELECT -- IMPORT LIST -- ITEM
			
		On presetImportLoc selected state do
		(
				
			--what happens when you select an item
			for i = 1 to presetImportLoc.selection do
			(
					
				--grab folder path and set as item in array
				impFolderPath = presetImportLoc.items[i] as string
				import_fldr_nam.text = "Folder: " + filenameFromPath impFolderPath		
					
				--Refresh List
				ManifestImportList()
				
				--records settings
				set_imp_list_last_sel = presetImportLoc.selection
				SetAutoSettings set_imp_list_last_sel 15
				
			)
				
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- EDITING LIST  -- IMPORT
			
		-- ADD - new item
		On btn_add_imp_itm pressed do 
		(
			str = impFolderPath	
				
			driveC = @"C:\"
			driveD = @"D:\"
			driveE = @"E:\"
			driveF = @"F:\"
			driveG = @"G:\"
			driveH = @"H:\"
			driveI = @"I:\"
			driveJ = @"J:\"
				
			--Does not Allow Drives to Pass -- DRIVE GANDHALF
			if ( str == driveC or str == driveD or str == driveE or str == driveF or
					str == driveG )do
			(
				messagebox "Please pick a folder within the drive." title:"Flow Panels"
				break
				return false
			)				
				
			if presetImportLoc.selection != 0 then 
			(
				if str.count > 0 do 
				(
					if (str != presetImportLoc.items[presetImportLoc.selection] as string) do
					(
						append impSavedData str
						presetImportLoc.items = impSavedData
						presetImportLoc.selection = impSavedData.count
							
						--records settings
						set_imp_list_last_sel = presetImportLoc.selection
						SetAutoSettings set_imp_list_last_sel 15
					)
						
					--'dynamically' changes tooltip based on selection
					--listTooltipUpdater presetImportLoc
				)
			)
			else if presetImportLoc.items.count == 0 then 
			(
				if str.count > 0 do 
				(
					append impSavedData str
					presetImportLoc.items = impSavedData
					presetImportLoc.selection = impSavedData.count
					
					--records settings
					set_imp_list_last_sel = presetImportLoc.selection
					SetAutoSettings set_imp_list_last_sel 15
				)
					
				--'dynamically' changes tooltip based on selection
				--listTooltipUpdater presetImportLoc
			)
			print ("FUCK")
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- DELETE - selected item
		On btn_imp_del_item pressed do 
		(
			itm = presetImportLoc.selection
			if itm > 0 do (
				deleteItem impSavedData itm
				presetImportLoc.items = impSavedData
			)
				
			--sets selection to the last item in array
			presetImportLoc.selection = presetImportLoc.items.count
				
			--records settings
			set_imp_list_last_sel = presetImportLoc.selection
			SetAutoSettings set_imp_list_last_sel 15
				
		)	
			
		-------------------------------------------------------------------------------------------------------------------------------- SAVE - the import list 
		on btn_imp_save_itm pressed do 
		(	
			local usedotNam = sysInfo.username as string
			
			if presetImportLoc.items.count != 0 do
			(
				--write to file
				impss = createFile ("C:\\Users\\"+ usedotNam +"\\PresetImportLocations.fp") mode: "w"
				
				format "%\n" (with printAllElements on impSavedData as string) to:impss
				flush impss
				close impss
				
				messagebox "Presets Saved!" title:"Flow Panels"
			)
			
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- LOAD - the export list 
		on btn_imp_load_itm pressed do 
		(
			local usedotNam = sysInfo.username as string
			
			-- load from file
			if (impss = openfile ("C:\\Users\\"+ usedotNam +"\\PresetImportLocations.fp")) != undefined do
			(
				impSavedData = execute (readLine impss)
				close impss
				presetImportLoc.items = impSavedData
				--messagebox "Presets Loaded!" title:"Flow Panels"
					
				--sets selection to the last item in array
				presetImportLoc.selection = 1
					
				--records settings
				set_imp_list_last_sel = presetImportLoc.selection
				SetAutoSettings set_imp_list_last_sel 15
			)	
		)
		
		-------------------------------------------------------------------------------------------------------------------------------- CLEAR - the export list
		on btn_imp_clear_itm pressed do 
		(
			impSavedData = #()
			
			presetImportLoc.items = impSavedData 
			free presetImportLoc
			
		)
			
		-------------------------------------------------------------------------------------------------------------------------------- DELETE - the export list
		on btn_imp_dlt_preset pressed do 
		(		
			local usedotNam = sysInfo.username as string
				
			impss = ("C:\\Users\\"+ usedotNam +"\\PresetImportLocations.fp")
				
			deletefile (impss)
			impSavedData = #()
			presetImportLoc.items = impSavedData
			--messagebox "Presets Loaded!" title:"Flow Panels"
				
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------SELECTED ITEM
		--when selected 
		On filesToImport selected i do 
		(
			if scrollToSelection do 
			(
				filesToImport.selection = i
			)
			
			--Sets the name of selection and filters name 
			lbl_imp_obj_nam.text = "Obj. Name: " + filenameFromPath (filesToImport.items[i]  as string )
			str = lbl_imp_obj_nam.text
			str = substituteString str ".FBX" ""
			str = substituteString str ".fbx" ""
			lbl_imp_obj_nam.text = str 
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------DOUBLED CLICK ITEM
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
				
		)
			
		-----------------------------------------------------------------------------------------------------------------------------------------------IMPORT ALL
		--when Import All is pressed
		On btn_imp_all pressed do 
		(
			tempArray = importItemsArray
			
			if tempArray != undefined do 
			(
				if forceImport then		
				(	
					if querybox "are you sure you want to import every object within folder?" then 						
						for i in tempArray do
						(
							importFile i #noPrompt
						)
					else return false
				)
				else
				(
					if querybox "are you sure you want to import every object within folder?" then 
						
						if querybox "want to turn on automatic import?" then
							for i in tempArray do
							(
								importFile i #noPrompt
							)
						else
							for i in tempArray do
							(
								importFile i 
							)
					else return false
				)					
				
			)
		)
		
		-----------------------------------------------------------------------------------------------------------------------------------------------IMPORT CHECKBUTTON
		--LOAD FBX FILES -- TOGGLE
		On loadFBXs changed state do
		(   
			Undo on
			loadFBXfiles = not loadFBXfiles	
				
			--turn off FBX import
			loadMAXfiles = false
			loadMAXs.checked = false
				
			--records file type bool
			set_import_file_type = 1
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
		-----------------------------------------------------------------------------------------------------------------------------------------------IMPORT CHECKBUTTON
		--LOAD MAX FILES -- TOGGLE
		On loadMAXs changed state do
		(   
			Undo on
			loadMAXfiles = not loadMAXfiles	
				
			--turn off FBX import
			loadFBXfiles = false
			loadFBXs.checked = false
				
			--records file type bool
			set_import_file_type = 2
			SetAutoSettings set_import_file_type 14 --saves data --function
				
			--Refresh List
			ManifestImportList()
		)
			
			
		-----------------------------------------------------------------------------------------------------------------------------------------------REFRESH LIST
		--Refresh List 
		on btn_ref_lst pressed do 
		(
			-- function - - creates import list - 
			ManifestImportList()			
		)
		
		--------------------------------------------------------------------------------------------------------------------------------SET FOLDER PATH 	
			
		--set export location
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
			
		on panImporter rolledUp open do 
		(		
				
			--populate List
			presetImportLoc.items = impSavedData
				
			--checks to set value of export location
			if set_exp_location != undefined do
			(
					
				--resets the list's last selected item
				if(presetImportLoc.items.count > 0 and set_imp_list_last_sel != undefined) do
				(
					presetImportLoc.selection = set_imp_list_last_sel
				)
					
			)	
				
			--resets import location from memory
			if set_last_import_loc != undefined do 
			(
				lastOpenedFldr = set_last_import_loc
			)
				
			--resets File to import from last settings set
			if set_import_file_type == 1 do  --sets .fbx type
			(
				loadFBXfiles = true
				loadFBXs.checked = true
					
				loadMAXfiles = false
			)
			if set_import_file_type == 2 do  --sets .max type 
			(
				loadMAXfiles = true	
				loadMAXs.checked = true
					
				loadFBXfiles = false
			)
				
				
-- 			if lastOpenedFldr != undefined do
-- 			(
-- 				-- filters path for displaying purposes 
-- 				import_fldr_nam.text = "Folder: " + filenameFromPath lastOpenedFldr
-- 				import_fldr_nam.tooltip = lastOpenedFldr
-- 				
-- 				--sets initial dropdownlist items
-- 				filesToImport.tooltip = lastOpenedFldr
-- 				filesToImport.items = set_import_array
-- 			)
			
			-- function - - creates import list - 
			ManifestImportList()	
			
			--switches to this rollout
			if open do 
			(
				switchRolls panImporter
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
				switchRolls panViewport		
					
					
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
				switchRolls panViewport					
			)
			
			--turn off viewport timer
			getViewportTimer.active = not getViewportTimer.active
			--print ("Viewport Auto-Update is set to " + getViewportTimer.active as string)
		)
	)
		
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	local rolls = #(panOrganize, panCreate, SubRollout3, SubRollout4, paintPan, panExporter, panImporter, panViewport) 
		
	--ON START
    on  myRoll open do
	(
		
        for roll in rolls do 
		(
			addSubRollout scriptBin roll rolledup:true
		)
		
		qx_fldr = set_exp_location
		
	)
		
	--ON CLOSE 
	on myRoll close do
	(
		toolSetClosePos = getdialogpos myRoll
			
		set_exp_location = auto_FP_Settings[9]
		
		
		
		if (use_SettingsRecorder) do
		(
			--saves recorder data
			SaveRecorderSettings()
		)
			
		--saves tool settings
		SaveToolSettingsFP()
	)
	
	-- TIMER THAT DIDNT WORK
-- 	timer colorUpdate "colorUpdate" interval: 1000
-- 	
-- 	on colorUpdate tick do
-- 	(
-- 		--UI COLOR
-- 		rRed = 255
-- 		bBlu = 0
-- 		gGre = 0
-- 	)
)


-------------------------------------------------------------------------------------------------------------------------------------	

---------------------------------------------------------------------------------------------------------------- // CreateU

createdialog myRoll  width:220 height:myRoll.height style:#(#style_titlebar, #style_sysmenu, #style_toolwindow, #style_resizing, #style_minimizebox) pos:toolSetClosePos menu:ToolSettingsMenu  --bgColor:[rRed,bBlu,gGre] 


if use_AutoDocking do 
(		
	cui.registerDialogBar myRoll
	registerRightClickMenu ToolSettingsMenu
	cui.dockDialogBar myRoll #cui_dock_left
)

