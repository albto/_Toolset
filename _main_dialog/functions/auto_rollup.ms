try(destroydialog dRol) catch()

Global rolA, rolB, rolC, rolD

rollout dRol "Dialog" height:220 width:900
(
    subRollout subRolls "" width:(dRol.width as float -20) height:880 pos:[10,5]
    
	fn switchRolls openedRoll =
        for roll in dRol.rolls where roll != openedRoll do roll.open = false

    rollout rolA "Selection Panel" 
    (
		group "Current Selection:" 
		(
			
		button selname "Name Select" width:90 height: 20 across:2
		button selsim "Select Similar" width:90 height: 20 
		button selclr "Select By Color" width:90 height: 20 across:2
		button selset "Selection Sets" width:90 height: 20 
			
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
			
		on rolA rolledUp open do if open do switchRolls rolA
    )

    rollout rolB "Create Panel" 
    (
	----------------------------------------------------------------------------------------------------------------
	--Primitives Group Controls

		group "Primitives:" 
		(
		button myBttn5 "Box" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,1,1,1,1 ) ToolTip: "Create Box"  across:5
		button myBttn6 "Cylinder" width:32 align:#align_topleft  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,3,3,1,1 ) ToolTip: "Create a Cylinder"
		button myBttn7 "Sphere" width:32 align:#align_topleft  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,2,2,1,1 ) ToolTip: "Create Sphere"
		button myBttn8 "Tube"  width:32 align:#align_topleft  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,8,8,1,1 ) ToolTip: "Create Tube"
		button myBttn9 "Plane"  width:32 align:#align_topleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,10,10,1,1 ) ToolTip: "Create Plane"
		button myBttn24 "Cone" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,6,6,1,1 ) ToolTip: "Create Cone"  across:5
		button myBttn25 "Pyramid" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,9,9,1,1 ) ToolTip: "Create Pyramid"  
		button myBttn26 "geoSphere" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,7,7,1,1 ) ToolTip: "Create GeoSphere"  
		button myBttn27 "Box" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,4,4,1,1 ) ToolTip: "Create Torus" 
		button myBttn28 "Box" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,11,11,1,1 ) ToolTip: "Create Text+"  
		)

		
		--Button Function - Create Box 
		
		on myBttn5 pressed do
		(
			
			mybox = box length:20 width:20 height:20 isSelected: On 
			$.name = "msh_objname_" + obj_box as string
			$.name = uniquename("msh_objname_")
			names = mybox
			
		)

		--Button Function - Create Cylinder 
		
		on myBttn6 pressed do
		(
			mycyl = cylinder radius:10 height:30 isSelected: On
			mycyl.mapcoords = on
			mycy
		)
			
		--Button Function - Create Sphere
		
		on myBttn7 pressed do
		(
			mysphere = sphere length:20 width:20 height:20 isSelected: On
			mysphere.mapcoords = on
			mysphere
		)
			
		--Button Function - Create Sphere
		
		on myBttn8 pressed do
		(
			mytube = tube radius1:10  radius2:7 height:30 isSelected: On
			mytube.mapcoords = on
			mytube
		)
			
		--Button Function - Create Plane
		
		on myBttn9 pressed do
		(
			myplane = plane length:20 width:20 isSelected: On
			myplane.mapcoords = on
			myplane
		)
			
		--Button Function - Create Cone
		
		on myBttn24 pressed do
		(
			mycone = cone radius1:10 radius2:0 width:20 isSelected: On
			mycone.mapcoords = on
			mycone
		)
			
		on myBttn25 pressed do
		(
			mypyra = pyramid width:20 depth:20 width:20 isSelected: On
			mypyra.mapcoords = on
			mypyra
		)
		
		on myBttn26 pressed do
		(
			mygeo = geosphere radius:20 isSelected: On
			mygeo.mapcoords = on
			mygeo
		)
		
		on myBttn27 pressed do
		(
			mytor = torus radius:20 isSelected: On
			mytor.mapcoords = on
			mytor
		)
		
		on myBttn28 pressed do
		(
			mytplus = TextPlus layouttype:0 Plane:0  isSelected: On
			$.width = 100
			$.length = 100
			tplustext = "Alberto's Tools :)"
			mytplus.SetPlaintextString tplustext

		)
		
	----------------------------------------------------------------------------------------------------------------
		
		Group "Shapes:"
		(
		button myBttn10 "Spline"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,1,1,1,1 ) ToolTip: "Create Spline" across: 5
		button myBttn15 "Circle"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,2,2,1,1 ) ToolTip: "Create Circle"
		button myBttn16 "Arc"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,3,3,1,1 ) ToolTip: "Create Arc"
		button myBttn17 "NGon"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,4,4,1,1 ) ToolTip: "Create NGon"
		button myBttn18 "Text"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,5,5,1,1 ) ToolTip: "Create Text"
		button myBttn19 "Rectangle"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,7,7,1,1 ) ToolTip: "Create Rectangle" across:5
		button myBttn20 "Ellipse"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,8,8,1,1 ) ToolTip: "Create Ellipse"
		button myBttn21 "Donut"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,9,9,1,1 ) ToolTip: "Create Donut"
		button myBttn22 "Star"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,10,10,1,1 ) ToolTip: "Create Star"
		button myBttn23 "Helix"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,11,11,1,1 ) ToolTip: "Create Star"
		)

		--Button Function - Create Spline
		on myBttn10 pressed do
		(
			startObjectCreation line		
		)
		
		on myBttn15 pressed do
		(
			
			startObjectCreation circle	
			
		)
		
		on myBttn16 pressed do
		(
			
			startObjectCreation arc	
			
		)	

		on myBttn17 pressed do
		(
			
			startObjectCreation ngon
			
		)	

		on myBttn18 pressed do
		(
			
			startObjectCreation text
			
		)	
		
		on myBttn19 pressed do
		(
			
			startObjectCreation rectangle
			
		)	
		
		on myBttn20 pressed do
		(
			
			startObjectCreation ellipse
			
		)	

		on myBttn21 pressed do
		(
			
			startObjectCreation donut	
			
		)
		
		on myBttn22 pressed do
		(
			
			startObjectCreation star
			
		)
		
		on myBttn23 pressed do
		(
			
			startObjectCreation helix
			
		)
		
	----------------------------------------------------------------------------------------------------------------
		
		group "Helpers:" 
		(
			
		button helperBttn1 "Point" width:32 height: 32 align:#align_topcleft images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,2,2,1,1 ) ToolTip:"Create Point" across:5
		button helperBttn2 "Active Grid" width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,4,4,1,1 ) ToolTip:"Create Grid Helper" 
		button helperBttn3 "Container" width:32 height: 32 align:#align_topleft  images:#("Containers_24i.bmp", "Containers_24i.bmp",17,2,2,1,1 ) ToolTip:"Create Container" 
		button helperBttn4 "Dummy"  width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,1,1,1,1 ) ToolTip:"Create Dummy Helper" 
		button helperBttn5 "Tape Measure"  width:32 height: 32 align:#align_topleft  images:#("Helpers_24i.bmp", "Helpers_24i.bmp",6,5,5,1,1 ) ToolTip:"Create Dummy Helper" 
		)
			
		--Button Function - Create Point
		
		on helperBttn1 pressed do
		(
			hlp_point = 0 
			Point pos:[0,0,0] isSelected:on	
			$.name = "hlpr_point_" 	+ hlp_point as string
			$.name = uniquename("hlpr_point_")
		)
			
		--Button Function - Create Dummy
		
		on helperBttn2 pressed do
		(
			hlp_grid = 0 
			grid length:1000 width:1000 grid:50 pos:[0,0,0] isSelected:on
			$.name = "hlpr_grid_" + hlp_grid as string
			$.name = uniquename("hlpr_grid_")
			
		)
			
		--Button Function - Create Container
		
		on helperBttn3 pressed do
		(
			hlp_cont = 0 
			myCont = Container isSelected:on
			myCont.name = "cont_" + hlp_cont as string
			myCont.name = uniquename("cont_")		
		)
			
		--Button Function - Create Spline
		
		on helperBttn4 pressed do
		(
			
			hlp_dum = 0 
			Dummy pos:[0,0,0] isSelected:on
			$.name = "hlpr_node_" + hlp_dum as string
			$.name = uniquename("hlpr_node_")
			
		)

		on helperBttn5 pressed do
		(
			
			hlp_dum = 0 
			Tape length:100 pos:[0,0,0] isSelected:on target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [100,0,0]))
			$.name = "hlpr_node_" + hlp_dum as string
			$.name = uniquename("hlpr_node_")
			
		)
			
        on rolB rolledUp open do if open do switchRolls rolB
    )

    rollout rolC "Rollout C" 
    (
--------------------------------------------------------------------------------------------------------------------------------------
		Group "Information:"
		(
		edittext edt_name "Name:"  pos: [15,30] width:155 height:17 across: 2
		colorPicker clp_Wirecolor "" pos: [170,29] width:40 height:20 color:(color 16 16 16)
		edittext edt_matname "Materialname:"  width:180 height:17 enabled:true readOnly:true
		button btn_Putmat "Put Material"  width:165 height:30 
		edittext edt_layername "Layername:" width:180 height:17 enabled:true readOnly:true
		edittext edt_Vertices "Verts:" width:102 height:17 enabled:true readOnly:true
		edittext edt_Faces "Polys:"  width:100 height:17 enabled:true readOnly:true
		edittext edt_Parent "Parent:"  width:180 height:17 enabled:true readOnly:true
		edittext edt_NumChildren "Num. Children:"  width:180 height:17 enabled:true readOnly:true
		edittext edt_XRef "Xref File:" width:180 height:17 enabled:true readOnly:true
		edittext edt_X "Object Width:    " width:160 height:17 enabled:true readOnly:true
		edittext edt_Y "Object Length:   " width:160 height:17 enabled:true readOnly:true
		edittext edt_Z "Object Height:   "   width:160 height:17 enabled:true readOnly:true
		)
		Group "Translation:"
		(
		spinner spn_posX "X Position:"  pos: [60,340] width:65 height:17 type:#worldunits range:[-1e9,1e9,0]
		spinner spn_posY "Y Position:"  pos: [60,360] width:65 height:17  type:#worldunits range:[-1e9,1e9,0]
		spinner spn_posZ "Z Position:"  pos: [60,380] width:65 height:17  type:#worldunits range:[-1e9,1e9,0]
		spinner spn_ScaleX "X Scale:"  pos: [60,400] width:65 height:17 range:[-1e9,1e9,0]
		spinner spn_ScaleY "Y Scale:"  pos: [60,420] width:65 height:17 range:[-1e9,1e9,0]
		spinner spn_ScaleZ "Z Scale:"  pos: [60,440] width:65 height:17 range:[-1e9,1e9,0]
		)
		Group "Interactivity:"
		(
		checkbox chk_hide "Hide"  width:46 height:15
		checkbox chk_Freeze "Freeze"  width:56 height:15
		)
			
		Group "Display Properties:"
		(
		spinner spn_Visibility "Visibility: " pos:[30,555] width:90 height:16 range:[0,1,1] type:#float across:2
		button btn_DpbyLayer "By Layer" pos:[140,553] width:57 height:21
		checkbox chk_SeeThrough "See-Through" width:86 height:15
		checkbox chk_boxmode "Display as Box" width:93 height:15
		checkbox chk_BackfaceCull "Backface Cull" width:90 height:15
		checkbox chk_EdgesOnly "Edges Only" width:78 height:15
		checkbox chk_VertexTicks "Vertex Ticks" width:83 height:15
		checkbox chk_Trajectory "Trajectory" width:71 height:15
		checkbox chk_IgnoreExtents "Ignore Extents"  width:92 height:15
		checkbox chk_ShowFrozeninGray "Show Frozen in Gray" width:122 height:15
		checkbox chk_NeverDegrade "Never Degrade" width:97 height:15
		checkbox chk_VertexChannelDisplay "Vertex Channel Display"  width:133 height:15
		dropdownList ddl_VertexDisplayMode ""  width:136 height:21 items:#("Vertex Color", "Vertex Illumination", "Vertex Alpha", "Map Channel Color", "Soft Selection Color")
		checkbutton btn_Shaded "Shaded"  pos:[160,779]  width:57 height:21
		spinner spn_mapchannel "Map Channel:"  width:106 height:16 range:[1,99,1] type:#integer
		)
		
		Group "Rendering Control:"
		(
		button btn_RPbyLayer "By Layer" pos:[140,849] width:57 height:21 
		checkbox chk_renderable "Renderable" pos:[15,855] width:79 height:15 across:1
		checkbox chk_inherit "Inherit Visibility"  width:92 height:15 across:1
		checkbox chk_PrimVis "Visible to Camera" width:105 height:15 across:1
		checkbox chk_SecondVis "Visible to Reflection/Refraction" width:171 height:15 across:1
		checkbox chk_ReceiveShadows "Receive Shadows" width:111 height:15 across:1
		checkbox chk_CastShadows "Cast Shadows" width:92 height:15 across:1
		checkbox chk_applyatmospherics "Apply Atmospherics" width:116 height:15 across:1
		checkbox chk_RenderOccluded "Render Occluded Objects"  width:147 height:15 across:1
			
		)
		
		Group "G-Buffer:"
		(
		spinner spn_gbuffer "Object ID" pos:[55,1055] width:92 height:16 range:[0,1000,1] type:#integer across:1
		)
		
		Group "Motion Blur:"
		(
		spinner spn_MbMultiplier "Multiplier"  width:91 height:16 across:1
		button btn_mbByLayer "By Layer"  width:57 height:21 across:1
		checkbox chk_MbEnabled "Enabled" width:63 height:15 across:1
		radiobuttons rdo_MbMode "" width:184 height:16 labels:#("None", "Object", "Image") columns:3
		)
		
		fn getprop thecontrol theProp =
		(
			local theVal = getproperty selection[1] theProp
			local testVal = theVal
			
			for o in selection while testVal == theVal do
			(
				if theval != (getproperty o theProp) then testVal = (getproperty o theProp)
			)
			
			if testVal == theVal then
			(
				if theVal then thecontrol.tristate = 1
					else thecontrol.tristate = 0
			)
				else
			(
				thecontrol.tristate = 2
			)
		)
		
		fn ToggleDisplayProps s =
		(
			chk_SeeThrough.enabled = s
			chk_boxmode.enabled = s
			chk_BackfaceCull.enabled = s
			chk_EdgesOnly.enabled = s
			chk_VertexTicks.enabled = s
			chk_Trajectory.enabled = s
			chk_IgnoreExtents.enabled = s
			chk_ShowFrozeninGray.enabled = s
			chk_NeverDegrade.enabled = s
			chk_VertexChannelDisplay.enabled = s
			ddl_VertexDisplayMode.enabled = s
			btn_Shaded.enabled = s
			
			
			if s and ddl_VertexDisplaymode.selection != 4 then
			(
				spn_mapchannel.enabled = false
			)
			else
				spn_mapchannel.enabled = s
		)
		
		fn ToggleRenderProps s =
		(
			spn_visibility.enabled = s
			chk_renderable.enabled = s
			chk_inherit.enabled = s
			chk_PrimVis.enabled = s
			chk_SecondVis.enabled = s
			chk_ReceiveShadows.enabled = s
			chk_CastShadows.enabled = s
			chk_applyatmospherics.enabled = s
			chk_RenderOccluded.enabled = s
		)
		
		fn ToggleMbProps s =
		(
			
			chk_MbEnabled.enabled = s
			rdo_MbMode.enabled = s
			
			if rdo_MbMode.state != 3 then 
				spn_MbMultiplier.enabled = false
			else spn_mbMultiplier.enabled = s
			
			
		)
		
		fn UpdateSel =
		(
			if selection.count != 0 then
			(
				for o in rolC.controls do o.enabled = true
					
				if selection.count == 1 then
				(
					edt_name.text = selection[1].name
					edt_name.readonly = false
					if selection[1].material != undefined then edt_matname.text = selection[1].material.name
						else edt_matname.text = "None"
					
					btn_Putmat.enabled = true
					
					edt_layername.text = selection[1].layer.name
					if selection[1].parent != undefined then edt_parent.text = selection[1].parent.name
						else edt_parent.text =  "Scene Root"
					edt_numchildren.text = selection[1].children.count as string
					
					if classof selection[1] == XrefObject then edt_Xref.text = getfilenamefile (selection[1].filename) + ".max"
					else edt_XRef.text = ""
					
					local thefacecount = ""
					local thevertcount = ""
					
					if classof selection[1] == Editable_mesh then 
					(
						thefacecount = selection[1].faces.count
						thevertcount = selection[1].vertices.count
					)
					if classof selection[1] == Editable_poly then 
					(
						thefacecount = selection[1].faces.count
						thevertcount = selection[1].vertices.count
					)
					
					edt_vertices.text = thevertcount as string
					edt_faces.text = thefacecount as string
					
					objLocalBBox= in coordsys local nodeLocalBoundingBox selection[1]
					olbb = objLocalBBox[2] - objLocalBBox[1]
					edt_x.text = units.formatValue olbb[1]
					edt_y.text = units.formatValue olbb[2]
					edt_z.text = units.formatValue olbb[3]
					--format "width:% length:% height:%\n" w l h
					
					spn_posX.value = selection[1].transform.pos.x
					spn_posY.value = selection[1].transform.pos.y
					spn_posZ.value = selection[1].transform.pos.z
					
					spn_scaleX.value = $.transform.scale.x
					spn_scaleY.value = $.transform.scale.y
					spn_scaleZ.value = $.transform.scale.z
				)			
				else
				(
					edt_name.text = ("Multiple Selected: " + selection.count as string + " objects")
					edt_name.readonly = true
					edt_matName.text = ""
					
					edt_vertices.text = ""
					edt_faces.text = ""
					edt_Xref.text = ""
					edt_layername.text = ""
					edt_numchildren.text = ""
					
					btn_Putmat.enabled = false
					
					edt_x.text = ""
					edt_y.text = ""
					edt_z.text = ""
					
					spn_posX.indeterminate = true
					spn_posY.indeterminate = true
					spn_posZ.indeterminate = true
					spn_posX.enabled = false
					spn_posY.enabled = false
					spn_posZ.enabled = false
					
					spn_scaleX.indeterminate = true
					spn_scaleY.indeterminate = true
					spn_scaleZ.indeterminate = true
					spn_scaleX.enabled = false
					spn_scaleY.enabled = false
					spn_scaleZ.enabled = false
				)
				
				
				clp_wirecolor.color = selection[1].wireColor 			
				
				getprop chk_hide "ishidden"
				getprop chk_freeze "isfrozen"
				
				getprop chk_SeeThrough "xray"
				getprop chk_boxmode "boxMode"
				getprop chk_BackfaceCull "backFaceCull"
				getprop chk_EdgesOnly "allEdges"
				chk_EdgesOnly.checked = not chk_EdgesOnly.checked
				
				getprop chk_VertexTicks "vertexTicks"
				getprop chk_Trajectory "showTrajectory"
				getprop chk_IgnoreExtents "ignoreExtents" 
				getprop chk_ShowFrozeninGray "showFrozenInGray" 
				getprop chk_NeverDegrade "neverdegrade"
				getprop chk_VertexChannelDisplay "showVertexColors" 
				
				btn_shaded.checked = selection[1].vertexColorsShaded 
				
				getprop chk_renderable "renderable"
				getprop chk_inherit "inheritVisibility"
				getprop chk_PrimVis "primaryVisibility"
				getprop chk_SecondVis "secondaryVisibility"
				getprop chk_ReceiveShadows "Receiveshadows"
				getprop chk_CastShadows"castshadows"
				getprop chk_applyatmospherics "applyatmospherics"
				getprop chk_RenderOccluded "renderoccluded"
				

				ddl_VertexDisplayMode.selection = Case selection[1].vertexColorType of
				(
					#color: 1
					#illum: 2
					#alpha: 3
					#color_plus_illum: 4
					#soft_select: 5
					default: 1
				)

				spn_mapchannel.value = selection[1].vertexColorMapChannel
				
				
				--btn_mbByLayer
				local s = true
				
				local same = true
				local value = selection[1].motionByLayer 
				for o in selection while same do same = o.motionByLayer == value
							
				if not same then
				(
					btn_mbByLayer.caption = "Mixed"
					s = false
				)
				else
				(
					if value then
					(
						s = false
						btn_mbByLayer.caption = "By Layer"
					)
					else 
					(
						s = true
						btn_mbByLayer.caption = "By Object"
					)
				)
				
				
				
				spn_MbMultiplier.value = selection[1].imageMotionBlurMultiplier
				chk_MbEnabled.checked = selection[1].motionBlurOn
				rdo_MbMode.state = Case selection[1].motionBlur of
				(
					#none: 1
					#object: 2
					#image: 3
				)
				
				ToggleMbProps s
				
				
				
				local s = true
				
				local same = true
				local value = selection[1].displaybyLayer
				for o in selection while same do same = o.displaybyLayer == value
							
				--if not same .displaybyLayer then
				if not same then
				(
					btn_DpByLayer.caption = "Mixed"
					s = false
				)
				else
				(
					if value then
					(
						s = false
						btn_DpByLayer.caption = "By Layer"
					)
					else 
					(
						s = true
						btn_DPByLayer.caption = "By Object"
					)
				)
				
				ToggleDisplayProps s	
				
				
				local s = true
				
				local same = true
				local value = selection[1].renderbyLayer
				for o in selection while same do same = o.renderbyLayer == value
							
				if not same then
				(
					btn_RPByLayer.caption = "Mixed"
					s = false
				)
				else
				(
					if value then
					(
						s = false
						btn_RPByLayer.caption = "By Layer"
					)
					else 
					(
						s = true
						btn_RPByLayer.caption = "By Object"
					)
				)
				
				
				
				
				if selection[1][1].controller == undefined then
				(
					if selection[1].visibility = true then
						spn_Visibility.value = 1.0
					else
						spn_Visibility.value = 0.0
					
				)
				else					
					spn_Visibility.value = selection[1].visibility.controller.value
				
				
				
				ToggleRenderProps s
				
				if selection.count == 1 then spn_gbuffer.value = selection[1].gbufferchannel
				else	
				(
					local s = true
					local same = true
					local value = selection[1].gbufferchannel
					for o in selection while same do same = o.gbufferchannel == value
					
					if same then spn_gbuffer.value = selection[1].gbufferchannel
					else spn_gbuffer.indeterminate = true
				)
				
				
				
			)
			else
			(
				for o in rolC.controls do o.enabled = false
				edt_name.text = "No object selected"
				edt_layername.text = ""
				edt_matname.text =""
				edt_Xref.text = ""
				edt_X.text = ""
				edt_Y.text = ""
				edt_Z.text = ""
				edt_parent.text = ""
				edt_numChildren.text = ""
			)
		)
			
		
		
		
		fn Updateobj theprop theState =
		(
			with redraw off
			(
				local s = ("Object Properties - " + theprop as string)
				undo s on 
					for o in selection do setproperty o theprop thestate
			)
		)
		
		
		-- btn_mbByLayer
		
		
		on rolC open do
		(
			UpdateSel()
			
			callbacks.addScript #selectionSetChanged "rolC.UpdateSel()" id:#DW_ObjProps
			callbacks.addScript #nodeLayerChanged "rolC.UpdateSel()" id:#DW_ObjProps
			callbacks.addScript #nodePostMaterial "rolC.UpdateSel()" id:#DW_ObjProps
			callbacks.addScript #sceneUndo "rolC.UpdateSel()" id:#DW_ObjProps
			registerTimeCallback rolC.UpdateSel
		)
		on rolC close do
		(
			callbacks.removescripts #selectionsetchanged id:#DW_ObjProps
			callbacks.removescripts #nodeLayerChanged id:#DW_ObjProps
			callbacks.removescripts #nodePostMaterial id:#DW_ObjProps
			callbacks.removescripts #sceneUndo id:#DW_ObjProps
			unRegisterTimeCallback rolC.UpdateSel
		
		)
		on edt_name changed text do undo "Object Properties - Change Name" on selection[1].name = text
		on clp_Wirecolor changed col do updateobj "wirecolor" col
		on btn_Putmat pressed do
		(
			if selection[1].material != undefined do meditmaterials[medit.GetActiveMtlSlot()] = selection[1].material
		)
		
		on spn_posX changed val do undo "Object Properties - Pos X" on selection[1].pos.x = val
		on spn_posY changed val do undo "Object Properties - Pos Y" on selection[1].pos.y = val
		on spn_posZ changed val do undo "Object Properties - Pos Z" on selection[1].pos.z = val
		
		on spn_scaleX changed val do undo "Object Properties - Scale X" on selection[1].scale.x = val 
		on spn_scaleY changed val do undo "Object Properties - Scale Y" on selection[1].scale.y = val 
		on spn_scaleZ changed val do undo "Object Properties - Scale Z" on selection[1].scale.z = val
		
		
		on chk_hide changed state do updateobj "ishidden" state
		on chk_Freeze changed state do updateobj "isfrozen" state
		on btn_DpbyLayer pressed do
		(
			-- "Mixed" to "Layer" to "Object"
			Case btn_DpbyLayer.caption of
			(
				"Mixed": (
					btn_DpbyLayer.caption = "By Layer"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.displaybylayer = true
				)
				"By Layer": (
					btn_DpbyLayer.caption = "By Object"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.displaybylayer = false
					ToggledisplayProps true
				)
				"By Object": (
					btn_DpbyLayer.caption = "By Layer"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.displaybylayer = true
					ToggledisplayProps false
				)
			)
		)
		on chk_SeeThrough changed state do updateobj "xray" state
		on chk_boxmode changed state do updateobj "boxmode" state
		on chk_BackfaceCull changed state do updateobj "backfacecull" state
		on chk_EdgesOnly changed state do updateobj "alledges" (not state)
		on chk_VertexTicks changed state do updateobj "vertexticks" state
		on chk_Trajectory changed state do updateobj "showtrajectory" state
		on chk_IgnoreExtents changed state do updateobj "ignoreextents" state
		on chk_ShowFrozeninGray changed state do updateobj "ShowFrozeninGray" state
		on chk_NeverDegrade changed state do updateobj "neverdegrade" state
		on chk_VertexChannelDisplay changed state do updateobj "showvertexcolors" state
		on ddl_VertexDisplayMode selected sel do
		(
			print sel
			local m = Case sel of
			(
				1: #color
				2: #illum
				3: #alpha
				4: #color_plus_illum
				5: #soft_select
				default: #color
			)
			if sel != 4 then spn_mapchannel.enabled = false
				else spn_mapchannel.enabled = true
			
			with redraw off undo "Object Properties - Change Vertex Color Type" on for o in selection do o.vertexColorType = m
		)
		on btn_Shaded changed val do updateobj "vertexColorsShaded" val
		on spn_mapchannel changed val do updateobj "vertexColorMapChannel" val
		on btn_RPbyLayer pressed do
		(
			-- "Mixed" to "Layer" to "Object"
			Case btn_RpbyLayer.caption of
			(
				"Mixed": (
					btn_RpbyLayer.caption = "By Layer"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.renderbylayer = true
				)
				"By Layer": (
					btn_RpbyLayer.caption = "By Object"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.renderbylayer = false
					ToggleRenderProps true
				)
				"By Object": (
					btn_RpbyLayer.caption = "By Layer"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.renderbylayer = true
					ToggleRenderProps false
				)
			)
		)
		on spn_Visibility changed val do
		(
			for o in selection where o[1].controller == undefined do o.visibility = bezier_float()
			with redraw off undo "Object Properties - Change Visibility" on for o in selection do o.visibility.controller.value = val 
		)
		on chk_renderable changed state do updateobj "renderable" state
		on chk_inherit changed state do updateobj "inheritvisibility" state
		on chk_PrimVis changed state do updateobj "primaryvisibility" state
		on chk_SecondVis changed state do updateobj "Secondaryvisibility" state
		on chk_ReceiveShadows changed state do updateobj "receiveShadows" state
		on chk_CastShadows changed state do updateobj "castshadows" state
		on chk_applyatmospherics changed state do updateobj "applyatmospherics" state
		on chk_RenderOccluded changed state do updateobj "renderoccluded" state
		on spn_gbuffer changed val do	updateobj "gbufferchannel" val
		on spn_MbMultiplier changed val do updateobj "imageMotionBlurMultiplier" val
		on btn_mbByLayer pressed do
		(
			-- "Mixed" to "Layer" to "Object"
			Case btn_MbbyLayer.caption of
			(
				"Mixed": (
					btn_MbbyLayer.caption = "By Layer"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.motionbylayer = true
				)
				"By Layer": (
					btn_MbbyLayer.caption = "By Object"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.motionbylayer = false
					ToggleMBProps true
				)
				"By Object": (
					btn_MbbyLayer.caption = "By Layer"
					with redraw off undo "Object Properties - Change By Layer" on for o in selection do o.motionbylayer = true
					ToggleMBProps false
				)
			)
		)
		on chk_MbEnabled changed state do
			updateobj "motionBlurOn" state
		on rdo_MbMode changed state do
		(
			local m = Case state of
			(
				1: #none
				2: #object
				3: #image
			)
			
			if state != 3 then spn_MbMultiplier.enabled = false
				else spn_mbMultiplier.enabled = true
			
			with redraw off undo "Object Properties - Motion Blur Mod" on for o in selection do o.motionBlur = m
			
		)
	
	
	on rolC rolledUp open do if open do switchRolls rolC
    )

	
    rollout rolD "Rollout D" 
    (
		button dd "this is D"
        on rolD rolledUp open do if open do switchRolls rolD
    )

    local rolls = #(rolA, rolB, rolC, rolD)

    on dRol open do
        for roll in rolls do addSubRollout subRolls roll rolledUp:true
)
createdialog dRol  width:250 height:900 

