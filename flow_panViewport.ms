	--------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////////// VIEWPORT SETTINGS
	--------------------------------------------------------------------------------------------------------------------------------		
		Group "Viewport Filters"
		(
			checkbutton btn_filGeo "Geometry" 		width:32 height: 32 align:#align_topcleft images:#("Extended_24i.bmp", "Extended_24i.bmp",12,10,10,1,1 ) ToolTip:"Toggle Geometry Visibility" across:6
			checkbutton btn_filSha "Shapes" 		width:32 height: 32 align:#align_topcleft images:#("Splines_24i.bmp", "Splines_24i.bmp",11,10,10,1,1 ) ToolTip:"Toggle Shapes Visibility" 
			checkbutton btn_filLig "Lights" 		width:32 height: 32 align:#align_topcleft images:#("Lights_24i.bmp", "Lights_24i.bmp",7,3,3,1,1 ) ToolTip:"Toggle Lights Visibility" 
			checkbutton btn_filHel "Helpers" 		width:32 height: 32 align:#align_topcleft images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,1,1,1,1 ) ToolTip:"Toggle Helpers Visibility" 
			checkbutton btn_filBon "Bones" 			width:32 height: 32 align:#align_topcleft images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,2,2,1,1 ) ToolTip:"Toggle Bones Visibility" 
			button btn_filNon "Bones" 				width:32 height: 32 align:#align_topcleft images: #("UVWUnwrapView_24i.bmp", "UVWUnwrapView_24a.bmp",27,8,6,1,1) ToolTip:"Disable All Filters" 
		)
		Group "Viewport Settings" 
		(
			label FOVpre "Field of View Presets:" 		align:#left
			button btn_fov65 "65" 				width:40	across:4
			button btn_fov75 "75" 				width:40
			button btn_fov85 "85" 				width:40
			button btn_fov95 "95" 				width:40
			spinner fov " Set Field of View: " 	width:128  	range:[25,200,viewport.GetFOV()] type:#integer align:#left
			button btn_vie_real "Realistic" 	width:50 	across: 3
			button btn_vie_sha "Shaded" 		width:50
			checkbutton btn_vie_edg "Wires"  	width:50
			checkbox btn_vie_shad_tg "Shadows" 	checked:true triState:2 across: 2
			checkbox btn_vie_amb_tg "Occlusion" checked:true triState:2
		)
	--------------------------------------------------------------------------------------------------------------------------------LOCALS
		
		local viewFilterButtons = #(btn_filGeo,btn_filSha,btn_filLig,btn_filHel,btn_filBon)
		local viewFilterBtnBaseImgs = #()
		
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
			
	--------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////// GRID DISPLAY SETTINGS
	--------------------------------------------------------------------------------------------------------------------------------	
		Group "Grid Display"
		(
				
			checkbox grid_on "Grid Toggle" across: 2
			dropdownlist grid_active "Pick Grid Type:" items:#("Actvie Grid","Home Grid") 
				
		)
			
	--------------------------------------------------------------------------------------------------------------------------------FILTERS 
		
		fn setViewFilterButtonStates = 
		(
			case hideByCategory.geometry of 
			(
				false:
				(
					btn_filGeo.images = #("Extended_24i.bmp", "Extended_24i.bmp",12,10,10,1,1 )
				)
				true:
				(
					btn_filGeo.images = #("UVWUnwrapView_24i.bmp", "UVWUnwrapView_24a.bmp",27,14,14,1,1)
				)				
			)
			case hideByCategory.shapes of 
			(
				false:
				(
					btn_filSha.images = #("Splines_24i.bmp", "Splines_24i.bmp",11,10,10,1,1 )
				)
				true:
				(
					btn_filSha.images = #("UVWUnwrapView_24i.bmp", "UVWUnwrapView_24a.bmp",27,14,14,1,1)
				)				
			)
			case hideByCategory.lights of 
			(
				false:
				(
					btn_filLig.images = #("Lights_24i.bmp", "Lights_24i.bmp",7,3,3,1,1 )
				)
				true:
				(
					btn_filLig.images = #("UVWUnwrapView_24i.bmp", "UVWUnwrapView_24a.bmp",27,14,14,1,1)
				)				
			)
			case hideByCategory.helpers of 
			(
				false:
				(
					btn_filHel.images = #("Helpers_24i.bmp", "Helpers_24i.bmp",6,1,1,1,1 )
				)
				true:
				(
					btn_filHel.images = #("UVWUnwrapView_24i.bmp", "UVWUnwrapView_24a.bmp",27,14,14,1,1)
				)				
			)
			case hideByCategory.bones of 
			(
				false:
				(
					btn_filBon.images = #("Helpers_24i.bmp", "Helpers_24i.bmp",6,2,2,1,1 )
				)
				true:
				(
					btn_filBon.images = #("UVWUnwrapView_24i.bmp", "UVWUnwrapView_24a.bmp",27,14,14,1,1)
				)				
			)
		)
		
		
		
		on btn_filGeo changed state do 
		(
			hideByCategory.geometry = state
		)
		on btn_filSha changed state do 
		(
			hideByCategory.shapes = state

		)
		on btn_filLig changed state do 
		(
			hideByCategory.lights = state
			
		)
		on btn_filHel changed state do 
		(
			hideByCategory.helpers = state
		)
		on btn_filBon changed state do 
		(
			hideByCategory.bones = state
		)
		on btn_filNon pressed do 
		(
			hideByCategory.none()			
			
			for i in viewFilterButtons do i.checked = false
			
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
			
		--------------------------------------------------------------------------------------------
			
		timer getViewportTimer "" interval:100
		timer getPresetSpace   "" interval:100	
			
		on getViewportTimer tick do 
		(
			set_spacing.range = [0,1000,getGridSpacing()]
			set_majorlines.range = [0,1000,getGridMajorLines()]
			set_persviewextent.range = [0,1000,gridPrefs.perspViewGridExtents]
			fov.range = [25,200,viewport.GetFOV()]
			
			--set viewport filter button states 
			setViewFilterButtonStates()
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
				
			checkbox chk_autU	"Find Unit Type"
				
			checkbutton chk_met	"Meters"									across:3
			checkbutton chk_cen	"Centimeters"
			checkbutton chk_inc	"Inches"
					
			
			Button btn_un_M		"Set to Meters"			 	across:3
			Button btn_un_CM	"Set to CM"		
			Button btn_un_IN	"Set to Inches"			
		)
		
		on chk_autU changed state do 
		(
			if state then
			(
				if units.SystemType == #Meters then 
				(
					chk_met.checked = true 
				)
				else
				(
					chk_met.checked = false
				)
			)
			else
			(
				chk_met.checked = false
			)
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
							btn_filGeo.checked = hideByCategory.geometry()
				btn_filGeo.state = hideByCategory.geometry()
				
				
			if open do 
			(
				

				--AutoCollapse
				if use_AutoCollapse == true do 
				(
					--switches to this rollout
					if open do switchRolls panViewport
				)
					
				if autoFindUnits then
				(
					
				)
				else
				(
					
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
				--Save Settings
				SetAutoSettings "" 14
				
				
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