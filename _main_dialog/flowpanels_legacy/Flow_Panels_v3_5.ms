
---------------------------------------------------------------------------------------------------------------- // Tool Settings
--Tool Settings 

--try(closeRolloutFloater newwind)catch()
Try(cui.UnregisterDialogBar myRoll)catch()
Try(destroydialog myRoll)catch()


--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------- // FUNCTIONS

-- UNITY EXPORTER
global unityYUp
global rot = eulerToQuat(eulerAngles 90 0 0)


fn unityYUp obj = 
(
	Select obj
	ResetXForm obj
	modPanel.addModToSelection (XForm ()) ui:on
	obj.modifiers[#XForm].gizmo.rotation += rot as quat
	rotate obj (inverse rot as quat)
	--for obj in (selection as array) do ( convertToPoly obj)
)
		

--------------------------------------------------------------------------------------------------------------------------------------

global SubRollout1, SubRollout2, SubRollout3, SubRollout4, paintPan, SubRollout6, ExportTools, viewSettings

--------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------


-- just create a global variable (array) where to store the strings
if savedData == undefined do global savedData = #()

if classOf roExample == RolloutClass do DestroyDialog roExample


--------------------------------------------------------------------------------------------------------------------------------------
rcMenu myMenu 
--------------------------------------------------------------------------------------------------------------------------------------
(	
	submenu "FlowPanels" 
	(
	)
	submenu "Tool Settings"
	(
		menuItem myItem4 "Close Tool" 
	separator sp1
		submenu "Dock Tool"
		(
		menuItem myItem1 "Dock"
	separator sp5
		menuItem myItem3 "Float Tool"		
		)
	separator sp2
	)
    -- Allows the Tool to Dock Right 
	on myItem1 picked do
    (
		cui.registerDialogBar myRoll
        cui.dockDialogBar myRoll #cui_dock_right
	)
    -- Allows the Tool to Float
    on myItem3 picked do
    (
        if myRoll.dialogBar then (cui.floatDialogBar myRoll)
	)
    -- Close Tool
	on myItem4 picked do
	(
	    if myRoll.dialogBar then (cui.unRegisterDialogBar myRoll)
        Try(destroydialog myRoll)catch()
	)
	submenu "Help" 
	(
		menuItem myItem5 "Manual"
		separator sp3
	)
	
    -- Help Archives 
	on myItem5 picked do
    (
		actionMan.executeAction 0 "40036"  
	)
)

---------------------------------------------------------------------------------------------------------------- // Main GUI
-- Main GUI - Scripts and Tools
--------------------------------------------------------------------------------------------------------------------------------------
rollout myRoll "FlowPanels"
	
--------------------------------------------------------------------------------------------------------------------------------------
(
	
	
	--ROLLOUT CONTROLS
	subRollout scriptBin width:(myRoll.width as float -10) height:880 pos:[5,5]

	fn switchRolls openedRoll =
	for roll in myRoll.rolls where roll != openedRoll do roll.open = false


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
	---------------------------------------------------------------------------------------------------------------- // Selection Panel 
	-- Selection Panel

	Rollout subRollout6 "Organize Panel"

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
		
		on subRollout6 rolledUp open do if open do switchRolls subRollout6	
		
	)
	
	---------------------------------------------------------------------------------------------------------------- // Create Panel 
	-- Create Panel Controls 

	Rollout subRollout1 "Create - Launch Panel" 
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
		
	----------------------------------------------------------------------------------------------------------------
	--Primitives Group Controls
		
		group "Primitives:" 
		(
			button myBttn5 "Box" 		width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,1,1,1,1) 		ToolTip: "Create Box"  			across:5
			button myBttn6 "Cylinder" 	width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,3,3,1,1) 		ToolTip: "Create a Cylinder"
			button myBttn7 "Sphere" 	width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,2,2,1,1) 		ToolTip: "Create Sphere"
			button myBttn8 "Tube"  		width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,8,8,1,1) 		ToolTip: "Create Tube"
			button myBttn9 "Plane"  	width:32 height:32 	images:#("Standard_24i.bmp", "Standard_24i.bmp",11,10,10,1,1) 		ToolTip: "Create Plane"
			button myBttn24 "Cone" 		width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,6,6,1,1) 		ToolTip: "Create Cone"  		across:5
			button myBttn25 "Pyramid" 	width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,9,9,1,1) 		ToolTip: "Create Pyramid"  
			button myBttn26 "GeoSphere" width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,7,7,1,1) 		ToolTip: "Create GeoSphere"  
			button myBttn27 "Torus" 	width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,4,4,1,1) 		ToolTip: "Create Torus" 
			button myBttn28 "Text Plus" width:32 height:32  images:#("Standard_24i.bmp", "Standard_24i.bmp",11,11,11,1,1) 	ToolTip: "Create Text+"  
		)
		
		
		--Button Function - Create Box 
		
		on myBttn5 pressed do
		(
			Undo on 
			mybox = box length:2 width:2 height:2 isSelected: On 
			mybox.mapcoords = on		
			names = mybox
			$.wirecolor = gray
			
		)
		
		--Button Function - Create Cylinder 
		
		on myBttn6 pressed do
		(
			Undo on 
			mycyl = cylinder radius:1 height:3 isSelected: On
			mycyl.mapcoords = on
			mycy
			$.wirecolor = gray 
		)
			
		--Button Function - Create Sphere
		
		on myBttn7 pressed do
		(
			Undo on 
			mysphere = sphere radius:2 segments:32 isSelected: On
			mysphere.mapcoords = on
			mysphere
			$.wirecolor = gray 
		)
			
		--Button Function - Create Sphere
		
		on myBttn8 pressed do
		(
			Undo on 
			mytube = tube radius1:.75  radius2:1.25 height:6 isSelected: On
			mytube.mapcoords = on
			mytube
			$.wirecolor = gray 
		)
			
		--Button Function - Create Plane
		
		on myBttn9 pressed do
		(
			Undo on 
			myplane = plane length:2 width:2 isSelected: On
			myplane.mapcoords = on
			myplane
			$.wirecolor = gray 
		)
			
		--Button Function - Create Cone
		
		on myBttn24 pressed do
		(
			Undo on 
			mycone = cone radius1:1 radius2:0 width:2 height:2 isSelected: On
			mycone.mapcoords = on
			mycone
			$.wirecolor = gray 
		)
			
		on myBttn25 pressed do
		(
			Undo on 
			mypyra = pyramid width:2 depth:2 height:2 isSelected: On
			mypyra.mapcoords = on
			mypyra
			$.wirecolor = gray 
		)
		
		on myBttn26 pressed do
		(
			Undo on 
			mygeo = geosphere radius:2 isSelected: On
			mygeo.mapcoords = on
			mygeo
			$.wirecolor = gray 
		)
		
		on myBttn27 pressed do
		(
			Undo on 
			mytor = torus radius1:2 radius2:1 isSelected: On
			mytor.mapcoords = on
			mytor
			$.wirecolor = gray 
		)
		
		on myBttn28 pressed do
		(
			Undo on 
			mytplus = TextPlus layouttype:0 Plane:0  isSelected: On
			$.width = 10
			$.length = 10
			tplustext = "Flow Panels"
			mytplus.SetPlaintextString tplustext
			$.wirecolor = gray 
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
			Point pos:[0,0,0] size:2 isSelected:on	
			$.name = "hlpr_point_" 	+ hlp_point as string
			$.name = uniquename("hlpr_point_")
		)
			
		--Button Function - Create Dummy
		
		on helperBttn2 pressed do
		(
			hlp_grid = 0 
			grid length:10 width:10 grid:50 pos:[0,0,0] isSelected:on
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
		on subRollout1 rolledUp open do if open do switchRolls subRollout1
			
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
				Vu_FFS()
			)
			
			--------------Button Function - Tycoon
			if lau_scripts.selection == 6 then
			(
				fileIn "D:\Dropbox\[main access]\3ds_Scripts\Tycoon_Beta_1_1\Tycoon\_tycoon.mse" 
			)
			
			--------------Button Function - Weave Mesh
			if lau_scripts.selection == 7 then
			(
				Vu_SimpleWeave ()
			)
			/*	
			-------------Button Function - refGuides UI
			if lau_scripts.selection == 8 then
			(
				macros.run "HAG refGuides" "HAG_rG_fltUI"
			)
				*/
		)
			
	)	
		
	---------------------------------------------------------------------------------------------------------------- // Transform Panel 
	-- Transform Panel Controls 

	Rollout subRollout2 "Transform Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------

	(
	------------------------------------------------------------------------------------------------Random Transform
		
		label lbrndtrans "Random Transforms:                                         "
		
		group "Move" 
		(
			checkbutton chk1 "X" width:60 height:24 checked:true across: 3 
			checkbutton chk2 "Y" width:60 height:24 checked:true
			checkbutton chk3 "Z" width:60 height:24 checked:true
		)
		
		group "Rotate"
		(
			checkbutton chk4 "X" width:60 height:24 across: 3
			checkbutton chk5 "Y" width:60 height:24
			checkbutton chk6 "Z" width:60 height:24
		)
		
		group "Scale" 
		(
			checkbutton chk7 "X"  width:60 height:24 across: 3
			checkbutton chk8 "Y"  width:60 height:24
			checkbutton chk9 "Z"  width:60 height:24
		)
		
		group "Random Settings:"
		(
			spinner spn1 "From" width:72 range:[-10000,10000,0] across: 2
			spinner spn2 "To    " width:72 range:[-10000,10000,0]
			checkbox chk10 "Relative_Scale" width:100 
			button rand_but  "Randomize" width:146 height:32
		)
		group "Animation Range:"
		(
			spinner spn3 "From" width:72 height:16  range:[-10000,10000,0] type:#integer across:2
			spinner spn4 "To    " width:72 height:16 range:[0,10000,0] type:#integer
			spinner spn5 "by    " width:72 height:16 range:[0,1000,5] type:#integer
			button anim_but  "go animate" width:146 height:32
		)


	----------------------------------------------------------------------------------------------------------------------
	on rand_but pressed do 
	(
		if (selection.count == 0) then 
			messageBox "plz select an one or more object to randomize" title:"Flow Panels"
		else 
			undo on
		(
			
			for i in selection do 
			(
				--- check foooooooooor relative
						if (chk10.checked == true and chk7.checked == false )do 
				(
							messageBox "plz chek the x scale for relative scale or uncheck RelativeScale  " title:"Flow Panels"
					exit
					)
			-- random the postion
				
				if (chk1.checked == false) then
				ranx  = 0
				else 
				ranx = random spn1.value spn2.value
					if (chk2.checked == false)then
				rany  = 0
				else 
				rany = random spn1.value spn2.value
					if (chk3.checked == false)then
				ranz  = 0
				else 
				ranz= random spn1.value spn2.value
				move i [ranx,rany,ranz]
			-- random the Rotation
					if (chk4.checked == false)then
				ranx  = 0
				else 
				ranx = random spn1.value spn2.value
					if (chk5.checked == false)then
				rany  = 0
				else 
				rany = random spn1.value spn2.value
					if (chk6.checked == false)then
				ranz  = 0
				else 
				ranz= random spn1.value spn2.value
				roteu = eulerangles ranx rany ranz
			rotate i roteu
			-- random the Scale
				if (chk7.checked == false)then
				ranx  =1
				else 
				ranx = random spn1.value spn2.value
				if (chk8.checked == false)then
				rany  = 1
				else 
				rany = random spn1.value spn2.value
				if (chk9.checked == false)then
				ranz  = 1
				else 
				ranz= random spn1.value spn2.value
				if (ranx !=1) do
				ranx=ranx/100
				if (rany !=1) do
				rany=rany/100
				if (ranz!=1) do
				ranz=ranz/100
				if (chk10.checked == false)then
				scale i [ranx,rany,ranz]
				else (
				if (chk7.checked == false)then(
					messageBox "plz chek the x scale for relative scale " title:"Flow Panels"
					)else 
					scale i [ranx,ranx,ranx]
				)
			)
		)
	)
	on anim_but pressed do 
	(

	if (selection.count == 0)then 
		messageBox "plz select an one or more object to randomize"
			else 
		(
			
			stepy = spn5.value
			spnin  = spn3.value
			spnout = spn4.value
						undo on 
						animate on
		(
			for tframe =  (spnin+stepy)  to spnout by stepy do 
			(
						if (chk10.checked == true and chk7.checked == false )do 
				(
							messageBox "plz chek the x scale for relative scale or uncheck RelativeScale  "
					exit
				)
			for i in selection do 
			(
			-- random the postion
				if (chk1.checked == false)then
				ranx  = 0
				else 
				ranx = random spn1.value spn2.value
					if (chk2.checked == false)then
				rany  = 0
				else 
				rany = random spn1.value spn2.value
					if (chk3.checked == false)then
				ranz  = 0
				else 
				ranz= random spn1.value spn2.value
				at time tframe (move i [ranx,rany,ranz])
			-- random the Rotation
					if (chk4.checked == false)then
				ranx  = 0
				else 
				ranx = random spn1.value spn2.value
					if (chk5.checked == false)then
				rany  = 0
				else 
				rany = random spn1.value spn2.value

					if (chk6.checked == false)then
				ranz  = 0
				else 
				ranz= random spn1.value spn2.value

				roteu = eulerangles ranx rany ranz
			at time tframe (rotate i roteu)


			-- random the Scale

				if (chk7.checked == false)then
				ranx  =1
				else 
				ranx = random spn1.value spn2.value

					if (chk8.checked == false)then
				rany  = 1
				else 
				rany = random spn1.value spn2.value

					if (chk9.checked == false)then
				ranz  = 1
				else 
				ranz= random spn1.value spn2.value
			if (ranx!=1) do
			ranx=ranx/100

			if (rany!=1) do
			rany=rany/100

			if (ranz!=1) do
			ranz=ranz/100
					if (chk10.checked == false)then
			at time tframe (scale i [ranx,rany,ranz])
				else (
					if (chk7.checked == false)then(
					messageBox "plz chek the x scale for relative scale "
					)else 
					at time tframe (scale i [ranx,ranx,ranx])
			)
			)
			)
		)
		)
	)
	-------------------------------------------------------------------------------------------------------------
	on subRollout2 rolledUp open do if open do switchRolls subRollout2
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
			
		Group "Poly Operations" 
		(
			dropdownlist bevel_typ "" items:#("       Edge - Bevel - 0.5", "       Edge - Bevel - 1", "       Edge - Bevel - 2", "       Edge - Bevel - 4") width: 140 across:1 align:#center
		)
			
		-------------------------------------------------------------------------------------------------	
		on bevel_typ selected i do
		(
			undo on
				
			if bevel_typ.selection == 1 then
			(
				for i in selection do
				(
					undo on
					mdf = $.modifiers[1]
					if (classof mdf ) == Edit_Poly then
					(
						$.modifiers[#Edit_Poly].SetOperation #ChamferEdge
						$.modifiers[#Edit_Poly].chamferEdgeAmount = 0.5
						$.modifiers[#Edit_Poly].edgeChamferSegments = 2
						$.modifiers[#Edit_Poly].edgeChamferSmooth = on
						$.modifiers[#Edit_Poly].edgeChamferSmoothType = 0
						$.modifiers[#Edit_Poly].edgeChamferSmoothThreshold = 65
						$.modifiers[#Edit_Poly].Commit ()
					)
					else if (classof $) == Editable_Poly then
					(
						$.edgeChamferSegments = 1
						$.edgeChamferTension = 0.5
						$.edgeChamferSmoothType = 0
						$.edgeChamferSmoothThreshold = 60
						$.edgeChamferTension = 0.195
						$.edgeChamferSmoothThreshold = 45
						$.edgeChamferTension = 0.75
						$.edgeChamfer = 0.5
						$.EditablePoly.buttonOp #Chamfer
					)
					else return false 
				)
			)
				
			if bevel_typ.selection == 2 then
			(
				for i in selection do
				(
					undo on
					mdf = $.modifiers[1]
					if (classof mdf ) == Edit_Poly then
					(
						$.modifiers[#Edit_Poly].SetOperation #ChamferEdge
						$.modifiers[#Edit_Poly].chamferEdgeAmount = 1
						$.modifiers[#Edit_Poly].edgeChamferSegments = 2
						$.modifiers[#Edit_Poly].edgeChamferSmooth = on
						$.modifiers[#Edit_Poly].edgeChamferSmoothType = 0
						$.modifiers[#Edit_Poly].edgeChamferSmoothThreshold = 65
						$.modifiers[#Edit_Poly].Commit ()
					)
					else if (classof $) == Editable_Poly then
					(
						$.edgeChamfer = 1
						$.edgeChamferType = 1
						$.edgeChamferTension = 0.75
						$.edgeChamferSmoothThreshold = 45
						$.edgeChamferTension = 0.5
						$.edgeChamferSmoothThreshold = 65
						$.edgeChamferTension = 0.65
						$.EditablePoly.buttonOp #Chamfer
					)	
					else return false 
				)
			)
				
			if bevel_typ.selection == 3 then
			(
				for i in selection do 
				(
					undo on 
					mdf = $.modifiers[1]	
					if (classof mdf) == Edit_Poly then
					(
						$.modifiers[#Edit_Poly].SetOperation #ChamferEdge
						$.modifiers[#Edit_Poly].chamferEdgeAmount = 2
						$.modifiers[#Edit_Poly].edgeChamferSegments = 2
						$.modifiers[#Edit_Poly].edgeChamferSmooth = on
						$.modifiers[#Edit_Poly].edgeChamferSmoothType = 0
						$.modifiers[#Edit_Poly].edgeChamferSmoothThreshold = 65
						$.modifiers[#Edit_Poly].Commit ()
					)
					else if (classof $) == Editable_Poly then
					(
						$.edgeChamfer = 2
						$.edgeChamferSegments = 1
						$.edgeChamferTension = 0.65
						$.edgeChamferSegments = 1
						$.edgeChamferSmoothThreshold = 65
						$.edgeChamferSegments = 1
						$.edgeChamfer = 2
						$.EditablePoly.buttonOp #Chamfer
					)
					else return false 
				)
			)
				
			if bevel_typ.selection == 4 then
			(
				for i in selection do 
				(
					undo on 
					if (classof $) == Edit_Poly then
					(
						$.modifiers[#Edit_Poly].SetOperation #ChamferEdge
						$.modifiers[#Edit_Poly].chamferEdgeAmount = 4
						$.modifiers[#Edit_Poly].edgeChamferSegments = 2
						$.modifiers[#Edit_Poly].edgeChamferSmooth = on
						$.modifiers[#Edit_Poly].edgeChamferSmoothType = 0
						$.modifiers[#Edit_Poly].edgeChamferSmoothThreshold = 65
						$.modifiers[#Edit_Poly].Commit ()
					)
					else if (classof $) == Editable_Poly then
					(
						$.edgeChamfer = 4
						$.edgeChamferSegments = 1
						$.edgeChamferTension = 0.65
						$.edgeChamferSegments = 1
						$.edgeChamferSmoothThreshold = 65
						$.edgeChamferSegments = 1
						$.edgeChamfer = 2
						$.EditablePoly.buttonOp #Chamfer
					)
					else return false 
				)
			)
				
		)
		-------------------------------------------------------------------------------------Utilities Group Controls
		Group "Utilities"	
		(
			Label	lbl_dash_label "------------- Pivot Tools -------------"	align:#center 
			button btn_piv_bas "_"    						width: 40	across:4 	tooltip: "Pivot to Base"   	
			button btn_piv_ape "^"   						width: 40					tooltip: "Pivot to Apex"   	
			button btn_piv_neg_y "-Y"  						width: 40					tooltip: "Pivot to Left"  		
			button btn_piv_y "+Y"   							width: 40					tooltip: "Pivot to Right"		
			button btn_piv_neg_x "-X"  					width: 40	across:4		tooltip: "Pivot to Back"		
			button btn_piv_x "+X"  						width: 40					tooltip: "Pivot to Forward"	
			button btn_piv_orig "Origin" 					width: 40					tooltip: "Pivot to Origin"		
			button btn_piv_cnt "Cntr" 						width: 40					tooltip: "Pivot to Center"	
			Label	lbl_dash_label2 "----------- Modeling Tools -----------"	align:#center 
			button myBttn14 "Send to Origin"				width: 80	across:2		tooltip: "Send to Center of World"
			button com_obj "Combine"						width: 80					tooltip: "Insets and Collapses a Face" 
			button btn_cull_tog "Culling" 				width: 80 	across: 2 align:#center 
			button symRadBtn "Sym. Radial" 					width: 80 	align:#center 
			button myBttn3 "Rename" 						width: 80  	across:2 
			button setFlowBtn "Set Flow" 					width: 80 	tooltip: "Adjust Edge Flow of Selected Edges"  across:2
			button weld_ver "Weld Verts"					width: 80	across: 2		tooltip: "Welds all verts on a single mesh.                       Only works on verts that are on top of each other. Use this as clean up."
			button zero_obj "Reset Object"					width: 80
			button btn_quick_copy "Quick Copy" 				width: 80	across: 2
			button btn_reset_trans "Reset Xform"			width: 80   				align:#center 
			button btn_qck_dtach "Detach"					width: 80	across: 2
			button btn_UVW_map "UVW Map"					width: 80
			button pok_fac "Scale UVs" 						width: 80 	tooltip: "Insets and Collapses a Face" across: 2
			button delEdgePolBtn "Delete Loop" 				width: 80	tooltip: "Cleanly Remove Edge Loop from Selected Edge"
			button tex_chk "Rescale UV Clusters" 			width: 160 	height: 30
		)
			
		on btn_piv_bas pressed do
		(
		---------------------------------------------------------------------------------------------------- PIVOT TO BASE
			Undo on
			for i in selection do 
			(
				i.pivot = [i.pivot.x,i.pivot.y,i.min.z]
			)
		)	
			
		on btn_piv_y pressed do
		(
		---------------------------------------------------------------------------------------------------- PIVOT +Y
			Undo on
			for i in selection do  
			(
				i.pivot = [i.pivot.x,i.max.y,i.pivot.z]
			)
			
		)
		---------------------------------------------------------------------------------------------------- PIVOT -Y
		on btn_piv_neg_y pressed do
		(
			Undo on
			for i in selection do  
			(
				i.pivot = [i.pivot.x,i.min.y,i.pivot.z]
			)
			
		)
		---------------------------------------------------------------------------------------------------- PIVOT +X
		on btn_piv_x pressed do
		(
			Undo on
			for i in selection do  
			(
				i.pivot = [i.max.x,i.pivot.y,i.pivot.z]
			)
			
		)
		---------------------------------------------------------------------------------------------------- PIVOT -X			
		on btn_piv_neg_x pressed do
		(
			Undo on
			for i in selection do  
			(
				i.pivot = [i.min.x,i.pivot.y,i.pivot.z]
			)
			
		)
		---------------------------------------------------------------------------------------------------- PIVOT to APEX
		on btn_piv_ape pressed do
		(
			Undo on
			for i in selection do  
			(
				i.pivot = [i.pivot.x,i.pivot.y,i.max.z]
			)
			
		)	
			
		on myBttn14 pressed do
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
			
		on com_obj pressed do 
		(
			Undo on
			if classof selection != Editable_Poly then converttopoly selection
			for i = 1 to selection.count do
			(
				selcount = selection.count
				for i = selcount to 2 by -2 do
				(
					polyop.attach selection[i] selection[i-1]
				)
				update selection[1]	
			)
		)
			
		on weld_ver pressed do 
		(
			undo on
			if selection.count > 0 then
			(
				subobjectLevel = 1
				actionMan.executeAction 0 "40021"  -- Selection: Select All
				$.weldThreshold = 0.046
				subobjectLevel = 0
			)
			else if selection.count == 0 then
			(
				messagebox "WARNING: nothing selected!" title:"Flow Panels"
				
			)
		)
			
		on zero_obj pressed do 
		(
			undo on
			if selection.count > 0 then
			(
				$.rotation = eulerangles 0 0 0
				$.pivot = [$.center.x,$.center.y,$.min.z]
				$.pos = [0,0,0]
				$.scale = [1,1,1]
			)
			else
			(
				messagebox "WARNING: nothing selected!" title:"Flow Panels"
				
			)
		)
			
		On btn_quick_copy pressed do 
		(
			Undo on
			maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
			select nnl
		)
			
		on btn_reset_trans pressed do
		(
			actionMan.executeAction 1584743139 "0"  -- Tools: Reset Transforms Selected
			macros.run "Modifier Stack" "Convert_to_Poly"
		)
			
		on btn_qck_dtach pressed do 
		(
			for i in selection do 
			(
				mdf = $.modifiers[1]
				if (classof mdf) == Edit_Poly then
				(
					$.modifiers[#Edit_Poly] 
					$.modifiers[#Edit_Poly].DetachToObject #DetachFace
					$.modifiers[#Edit_Poly].SetSelection #Face #{}
				)
				if (classof $) == Editable_Poly then
				(
					$.EditablePoly.buttonOp #Detach
					$.EditablePoly.SetSelection #Face #{}
					$.EditablePoly.detachToElement #Face keepOriginal:off	
				)
			)
		)
		on btn_UVW_map pressed do 
		(
			for i in selection do 
			(
				macros.run "Modifiers" "Uvwmap"
				$.modifiers[#UVW_Map].maptype = 4
				$.modifiers[#UVW_Map].width = 1
				$.modifiers[#UVW_Map].height = 1
				$.modifiers[#UVW_Map].length = 1
			)
		)
		local cull_tog = false
		--------------Button Function - Create Holes
		on btn_cull_tog pressed do
		(
			cull_tog = Not cull_tog 
			print cull_tog
			if cull_tog == true then
			(
				$.displaybylayer = off
				$.backfacecull = on
			)
			else if cull_tog == false then
			(
				$.displaybylayer = off
				$.backfacecull = off
			)
		)
		
		--------------Button Function - Symmetry Radial
		on symRadBtn pressed do
		(
			modPanel.addModToSelection (SymmetryRadial ()) ui:on
		)
		
		on tex_chk pressed do 
		(
			for i in selection do
			(
				macros.run "Modifiers" "Unwrap_UVW"
				macros.run "Modifier Stack" "SubObject_3"
				macros.run "Modifier Stack" "SubObject_3"
				$.modifiers[#unwrap_uvw].unwrap6.selectFacesByNode #{1..10000000}$
				actionMan.executeAction 2077580866 "40207"  -- Unwrap UVW: Rescale Clusters	
				SubObjectLevel = 0
			)
		)
		
-------------------------------------------------------------------------------------Cloners Group Controls
			
		Group "Cloners List"
		(
			
			dropdownlist cloner_list "" items:#("...Pick Cloner...", "1. Clone Radial", "2. Clone on Curve", "3. Building Maker",  "4. CloneSpline Rad", "5. Path Cloner","6. Cloner Setup") width: 150	align:#center 
			
		)
			
			
		on cloner_list selected i do
		(
				
			if cloner_list.selection == 2 then 
			(
				modPanel.addModToSelection (Vu_mcgCloneRadial ()) ui:on
			)
			
			if cloner_list.selection == 3 then 
			(
				modPanel.addModToSelection (VA_CloneOnCurve ()) ui:on
			)
			
			if cloner_list.selection == 4 then
			(
				fileIn "D:\Dropbox\[main access]\3ds_Scripts\HTM-PRJ_cityblks-BMscripts\BuildingMaker.ms"
			)
			
			if cloner_list.selection == 5 then
			(
				startObjectCreation Vu_CloneSplRadial
			)
			
			if cloner_list.selection == 6 then
			(
				Path_Cloner ()
			)
			
			if cloner_list.selection == 7 then
			(
				modPanel.addModToSelection (Cloner_Transform ()) ui:on
				modPanel.addModToSelection (Cloner_Mesher ()) ui:on
				modPanel.addModToSelection (Stacker ()) ui:on	
			)
				
		)
		
		on subRollout3 rolledUp open do if open do switchRolls subRollout3
	)
	
	---------------------------------------------------------------------------------------------------------------- // Modifier Panel 
	-- Modifier Panel Controls 

	Rollout paintPan "Painting Panel"  

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
		on paintPan rolledUp open do if open do switchRolls paintPan
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------	
		
	Rollout subRollout4 "Normals Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--//////////////////////////////////////////////////////////////////////////////////////////// NORMALS PANEL
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

	Rollout ExportTools "Export Panel"

	-------------------------------------------------------------------------------------------------------------------------------------	
	(
	-------------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////////////// QUICK EXPORT
	-------------------------------------------------------------------------------------------------------------------------------------
				
			
		Group "Properties:"
		(	
			edittext preNam   "Prefix:"			labelOnTop: true			align:#left 	width: 35	height:18	across:3  fieldWidth: 5
			edittext multiNam "Object Name:"	labelOnTop: true			align:#center 	width: 100	height:18
			edittext verNam   "Suffix:"			labelOnTop: true			align:#right 	width: 35	height:18
			
			spinner btn_incr_vr "Use to Increment Suffix Letter" 			type:#integer	align:#right	width: 30 	height:18	range:[1, 26, 1]	tooltip:"increment suffix letter"
			
			label lbl_opt_ext "Export Options:"								align:#left			
			
			checkbutton btn_use_objNam "Name"							width: 55		align:#left	Tooltip:"Toggle On, to Use Selection's name as 'Object Name'" across:3 	
			checkbutton btn_renam_on "Rename"								width: 55		align:#center	Tooltip:"Toggle On, to allow Renaming of Objects" 	
			checkbutton btn_unity_exp "Unity3D" 							width: 55		align:#right	Tooltip:"Sets Y-up instead of Z" 					
			
			label lbl_obj_typ "Export File Type:"							align:#left
			
			checkbutton btn_obj_typ "Export OBJ" 							align:#left		width: 80				across:2
			checkbutton btn_fbx_typ "Export FBX"							align:#left		width: 80
		)
	-------------------------------------------------------------------------------------------------------------------------------------	
			
		Group "Export:"
		(
			button btn_QXport "Quick Export!" 				width: 160			height:50
		)
	-------------------------------------------------------------------------------------------------------------------------------------
			
		Group "Export Location:"
		(
			edittext qx_fldr "Location: "		labelOnTop: true			align:#center		width: 160			fieldWidth: 160
			button btn_fold_path "Set Export Location"							width: 160		height: 25
		)	
	-------------------------------------------------------------------------------------------------------------------------------------
			
		Group "Preset Locations"
		(
			dropdownlist theList "" items:#() 				align:#center		width: 165	
			button btnAdd "Save Current location" 			width:120 			height:30 		align:#left  across:2
			button btnRem "Del" 							width:40 			height:30 		align:#right
		)
	--------------------------------------------------------------------------------------------------------------------------------
		--Selection Timer; update Object Name on selection
		timer checkSel "" interval:100 active:false
			
		on checkSel tick do 
		(
			if selection.count == 0 then 
			(			
				multiNam.enabled = false ; multiNam.text = "  Select Something"
			) 
			else
			(
				multiNam.enabled = true
				if selection.count >= 1 then multiNam.text = selection[1].name 
			)
			
		)
		on multiNam entered txt do 
		(
			for o in selection do o.name = multiNam.text
		)	
		
	--------------------------------------------------------------------------------------------------------------------------------	
			
		local	incr = #("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
		local	typ1 = ".OBJ"		
		local	typ2 = ".FBX"
		local	typ_setr = "."
		local	initNam = "object_name"
		local	use_ObjNam = false
		local	Unity_Y_Up = false
 		local	main_db = "[main access]"
		local	vendFold = "C:\Users\Alberto\Documents\Vendors"
		local	setDirLocal = vendFold
			
	--------------------------------------------------------------------------------------------------------------------------------
				 
		-- get saved data on start up
		On ExportTools open do (theList.items = savedData)
			
		-- add NEW item
		On btnAdd pressed do 
		(
			str = qx_fldr.text
			if str.count > 0 do (
				append savedData str
				theList.items = savedData
				theList.selection = savedData.count
			)
		)
		
		-- delete SELECTED item
		On btnRem pressed do 
		(
			itm = theList.selection
			if itm > 0 do (
				deleteItem savedData itm
				theList.items = savedData
			)
		)	
	--------------------------------------------------------------------------------------------------------------------------------Set folder path 	
			
		On btn_fold_path pressed do 
		(
			-- sets folder path location 
			folder_path = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:setDirLocal	
			
			-- sets folder path name if undefined
			if folder_path == undefined then				
			(
				preNam.text = "obj"
				multiNam.text = initNam
				verNam.text = "a"
				ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
				folder_path = "C:\\users\Alberto\Desktop"
				qx_fldr.text = folder_path
			)
			
			-- sets the folder textbox text, the same as folder path location 
			else 
			qx_fldr.text = folder_path
			
		)
			
	--------------------------------------------------------------------------------------------------------------------------------Presets Location Array 
		
		On theList selected state do
		(
			for i = 1 to theList.selection do
			(
				qx_fldr.text = theList.items[i] as string
				preNam.text = "obj"
				multiNam.text = initNam
				verNam.text = "a"
				folder_path = qx_fldr.text
			)
			
		)
			
	--------------------------------------------------------------------------------------------------------------------------------Quick Export Properties		
			
		On btn_QXport  pressed do
		(   
			local selGroup = selection as array
			selectedObjects = getCurrentSelection()
			if  selection.count == 1 and Unity_Y_Up == true do  for obj in selectedObjects do unityYUp obj
				
			for i in selGroup collect i 
			(
				if selection.count > 0 do 
				(
					ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
					exportFile	( qx_fldr.text + ObjNam )		selectedOnly:true
				)
			)
			if selection.count == 0 do 
			(
				messagebox "Please select something to export." title: "Flow Panels"
			)
			ObjNam = "\\" + preNam.text + "_" + multiNam.text + "_" + verNam.text + typ_setr
			
			
		)
	--------------------------------------------------------------------------------------------------------------------------------		
			
		On btn_incr_vr changed val do
		(   
			verNam.text = incr[val]	
		)
	--------------------------------------------------------------------------------------------------------------------------------Exporting to Unity, Sets Y up 		
			
		On btn_unity_exp changed state do
		(   
			
			Undo on
			if state == on then
				Unity_Y_Up = true
			if state == off then
				Unity_Y_Up = false
				
		)	
					
				
	--------------------------------------------------------------------------------------------------------------------------------Use Selection Name		
			
		On btn_use_objNam changed state do
		(   
			
			Undo on
			if state == on then
			(
				checkSel.active = true
			)
			if state == off then
			(
				checkSel.active = false
				multiNam.enabled = true
				multiNam.text = "  "

			)
		)	
			
	--------------------------------------------------------------------------------------------------------------------------------Set Object Type OBJ			
			
		On btn_obj_typ changed state do 		
		(
			Undo on
			if state == on then
				typ_setr = typ1
			else
				false
		)
			
	--------------------------------------------------------------------------------------------------------------------------------Set Object Type FBX
			
		On btn_fbx_typ changed state do 
		(
			Undo on
			if state == on then
				typ_setr = typ2
			else
				false
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
		
		on ExportTools rolledUp open do if open do switchRolls ExportTools
	)
		
	Rollout viewSettings "Viewport Panel"
	(	
		
	--------------------------------------------------------------------------------------------------------------------------------	
	--//////////////////////////////////////////////////////////////////////////////////////// VIEWPORT SETTINGS
	--------------------------------------------------------------------------------------------------------------------------------		
			
		Group "Viewport Settings" 
		(
			spinner fov "Field of View" 		width:128  	range:[25,200,viewport.GetFOV()] type:#integer align:#left
			button btn_vie_real "Realistic" 	width:50 	across: 3
			button btn_vie_sha "Shaded" 		width:50
			checkbutton btn_vie_edg "Wires"  	width:50
			checkbox btn_vie_shad_tg "Shadows" 	checked:true triState:2 across: 2
			checkbox btn_vie_amb_tg "Occlusion" checked:true triState:2
		)
			
	--------------------------------------------------------------------------------------------------------------------------------
			
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
			
			
		---------------------------------------------------------------------------Grid Options
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
		
		--------------------------------------------------------------------------------------------
			
		group "Grid Spacing:" 
		(
			
			Spinner set_spacing 		"Grid Spacing:" 		type:#float range: [0,1000,0]  width:150 across: 1 height: 20 			align: #center
			Spinner set_majorlines 		"Major Lines:" 			type:#integer range: [0,1000,0]  width:150 across: 1 height: 20 		align: #center
			Spinner set_persviewextent 	"Grid Extent:" 	type:#integer range: [0,1000,0]  width:150 across: 1 height: 20			align: #center
			label lbl_02 				"Preset Spacing:" 		across: 2
			dropdownlist scale_dd 		"" 						items:#("   10 cm", "   8 cm", "   6 cm",  "   4 cm", "   2 cm","   1 cm", "   1/2 cm", "   1/4 cm", "   1/8 cm") width: 80 align: #center
			
		)
			
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
	
		
		on viewSettings rolledUp open do if open do switchRolls viewSettings
		
	)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	local rolls = #(SubRollout6, SubRollout1, SubRollout3, SubRollout4, paintPan, SubRollout2, ExportTools, viewSettings)
		
    on  myRoll open do
	(

        for roll in rolls do addSubRollout scriptBin roll rolledUp:true
		
	)
	
	on myRoll close do
	(
		
		toolSetClosePos= getdialogpos myRoll
	)
		
		
)
-------------------------------------------------------------------------------------------------------------------------------------	

---------------------------------------------------------------------------------------------------------------- // CreateU

--newwind = newRolloutFloater "Alberto's Toolset" 250 900 
createdialog myRoll  width:220 menu:myMenu style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)

cui.registerDialogBar myRoll
cui.dockDialogBar myRoll #cui_dock_right 


