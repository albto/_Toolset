	
--------------------------------------------------------------------------------------------------------------------------------------
-- Scripts Launch Preset Locations on Start-up
if doesFileExist(mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp") then
(	
	scpts = openfile (mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp") mode:"r"
	scptsData = execute (readLine scpts)
	close scpts
)
else (
	scptsData = Dictionary()
)
	

global toolMiniLauncherPos = #([400, 200], [500, 200])

persistent global Selc = 1
global panO, panC, panM, panN, panP, panS, panPf, panE, panI, panV

try (DestroyDialog flow_miniLauncher) catch()
rollout flow_miniLauncher "Mini Launcher" 
( 	
	local rolls = #("Organize Tools", "Create Tools", "Modeling Tools", "Normals Tools", "Painting Tools", "Substance Tools", "Prefabs Tools", "Export Tools", "Import Tools", "Viewport Tools", "Project Helper", "Attributes Helper")
	dropdownList ddl_pan_lst 	"Panel's List: "				items:rolls  default:1
	button btn_lau_pan 			"Launch Selected Panel"
		
	fn LoadData = (
			
		case of 
		(
			(ddl_pan_lst.selection == 1):
			(					
				Rollout panO "Organize Tools" 
				(
					include "flow_panOrganize.ms"
				)	
					
				CreateDialog panO width:260 height:340
			)
			(ddl_pan_lst.selection == 2):
			(					
				Rollout panC "Creation Tools" 
				(
					include "flow_panCreate.ms"
					
					on panC open do 
					(
						--------------------------------------------------------------------------------------------------------------------------------------
						-- Scripts Launch Preset Locations on Start-up
						if doesFileExist(mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp") then
						(
							scpts = openfile (mainFPFolder + "\\FlowPanels\\savedata\\ScriptsLocations.fp") mode:"r"
							scptsData = execute (readLine scpts)
							close scpts
						)
						else (
							scptsData = Dictionary()
						)
								
						--pass data 
						lau_scripts.items = scptsData.keys
							
							
					)
					
					on panC close do 
					(
						toolMiniLauncherPos[2] = GetDialogPos panC
					)
					
					
				)	
					
					
				CreateDialog panC width:260 height:490 	pos:toolMiniLauncherPos[2] 
			)
			(ddl_pan_lst.selection == 3):
			(					
				Rollout panM "Modeling Tools" 
				(
					include "flow_panModeling.ms"
				)	
					
				CreateDialog panM width:250 height:490
			)
			(ddl_pan_lst.selection == 4):(
				
				
				Rollout panN "Vertex Normal Tools" 
				(
					include "flow_panNormals.ms"
				)	
					
				CreateDialog panN width:260 height:380
			)
			(ddl_pan_lst.selection == 5):(
				
				
				Rollout panP "Painting Tools" 
				(
					include "flow_panPainting.ms"
				)	
					
				CreateDialog panP width:260 height:505
			)
			(ddl_pan_lst.selection == 6):(
				
				
				Rollout panS "Substance Tools" 
				(
					include "flow_panSubstance.ms"
				)	
					
				CreateDialog panS width:260 height:475
			)
			(ddl_pan_lst.selection == 7):(
				
				
				Rollout panPf "Prefabs Tools" 
				(
					include "flow_panPrefabs.ms"
				)	
					
				CreateDialog panPf width:260 height:580
			)
			(ddl_pan_lst.selection == 8):(
				
				Rollout panE "Export Tools" 
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
								--vernam.visible = false
								radsufval.enabled = false
								--radsufval.visible = false
								prenam.enabled = false
								--prenam.visible = false
								btn_incr_vr.enabled = false
								--btn_incr_vr.visible = false
									
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
					
				CreateDialog panE width:245 height:550
			)
			(ddl_pan_lst.selection == 9):(
				
				Rollout panI "Import Tools" 
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
			(ddl_pan_lst.selection == 10):(
				
				Rollout panV "Viewport Tools" 
				(
					include "flow_panViewport.ms"
				)	
					
				CreateDialog panV width:260 height:532
			)
			(ddl_pan_lst.selection == 11):(
				try ( filein "FlowToolsProjectHelper.ms" ) catch()
			)
			(ddl_pan_lst.selection == 12):(
				global FlowAttEditor 	
					
				--link to script here 
				sysFolder = sysInfo.windowsdir
				subS = substituteString sysFolder "WINDOWS" ("Users\\" + sysInfo.username as string)
				
				if (doesDirectoryExist (subS + "\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms") ) then
				(
					sysFolder = (subS + "\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms")
				)
				else
				(
					sysFolder = (subS + "\\OneDrive\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms")
				)
				
				filein sysFolder
			)
		)
		
	)
		
	on btn_lau_pan pressed do 
	(
		case ddl_pan_lst.selection of 
		(
			1: 	try (DestroyDialog panO)  catch()
			2:	try (DestroyDialog panC)  catch()
			3:	try (DestroyDialog panM)  catch()
			4:	try (DestroyDialog panN)  catch()
			5:	try (DestroyDialog panP)  catch()
			6:	try (DestroyDialog panS)  catch()
			7:	try (DestroyDialog panPf) catch()
			8:	try (DestroyDialog panE)  catch()
			9:	try (DestroyDialog panI)  catch()
			10:	try (DestroyDialog panV)  catch()				
		)
			
			
		filein (getThisScriptFilename())			
			
		LoadData()
			
			
			
			
	)	
		
		
	on flow_miniLauncher open do 
	(
		
		
		ddl_pan_lst.selection = Selc
			
		print "--Mini Launcher Test Tool -- Open:: "
	)
	
	on flow_miniLauncher close do 
	(
		--record Tool Position
		toolMiniLauncherPos[1] = getdialogpos flow_miniLauncher
		
		Selc = ddl_pan_lst.selection
			
		print "--Mini Launcher Test Tool -- Closed:: "
	)
		
)


CreateDialog flow_miniLauncher pos:toolMiniLauncherPos[1] autoLayoutOnResize:true


	