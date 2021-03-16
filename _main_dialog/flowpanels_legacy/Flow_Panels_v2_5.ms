
---------------------------------------------------------------------------------------------------------------- // Tool Settings
--Tool Settings 

--try(closeRolloutFloater newwind)catch()
Try(cui.UnregisterDialogBar myRoll)catch()
Try(destroydialog myRoll)catch()

--------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------

global SubRollout1, SubRollout2, SubRollout3, SubRollout4, paintPan, SubRollout5, SubRollout6, UE4Tools

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
        destroyDialog myRoll
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
	   if (mf.name == wnmodname) then (
		return mf
	   ) else (
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
		--local b = openBitMap(@"K:\Desktop\UI.bmp")
		--imgTag imgLogo "logo" tooltip:"logo" style:#bmp_center bitmap:b width: 240 height:100 pos:[0, 0]
		--on imgLogo lbuttonup do
		--(
			--hitByNameDlg()
		--)
	---------------------------------------------------------------------------------------------------------------// Selection
		
		
		group "Selection Type:" 
		(
		button selname "Name Select" width:99 height: 20 across:2
		button selsim "Select Similar" width:99 height: 20 
		button selclr "Select By Color" width:99 height: 20 across:2
		button selset "Selection Sets" width:99 height: 20 
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
			button selNQ "Select NGons" width:99 height: 20	across:2
			button selOF "Select Open" width:99 height: 20	
			button selMCU "Mesh CleanUp" width: 200 Height: 30
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
			OFmod = edit_poly()
			OFMod.name = "CLEAN-UP: Open Faces"
			addModifier $ OFMod
			subobjectLevel = 3
			macros.run "PolyTools" "OpenSelect"
		)
		
		On selMCU pressed do
		(
			macros.run "rapidTools" "rapidMeshCleanUp"
		)	
		
		on subRollout6 rolledUp open do if open do switchRolls subRollout6	
		
	)

	---------------------------------------------------------------------------------------------------------------- // Create Panel 
	-- Create Panel Controls 

	Rollout subRollout1 "Create Panel" 
		
	--------------------------------------------------------------------------------------------------------------------------------------

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
		button myBttn26 "GeoSphere" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,7,7,1,1 ) ToolTip: "Create GeoSphere"  
		button myBttn27 "Torus" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,4,4,1,1 ) ToolTip: "Create Torus" 
		button myBttn28 "Text Plus" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,11,11,1,1 ) ToolTip: "Create Text+"  
		)

		
		--Button Function - Create Box 
		
		on myBttn5 pressed do
		(
			
			mybox = box length:20 width:20 height:20 isSelected: On 
			mybox.mapcoords = on		
			names = mybox
			$.wirecolor = gray
			
		)

		--Button Function - Create Cylinder 
		
		on myBttn6 pressed do
		(
			
			mycyl = cylinder radius:10 height:30 isSelected: On
			mycyl.mapcoords = on
			mycy
			$.wirecolor = gray 
		)
			
		--Button Function - Create Sphere
		
		on myBttn7 pressed do
		(
			mysphere = sphere length:20 width:20 height:20 segments:32 isSelected: On
			mysphere.mapcoords = on
			mysphere
			$.wirecolor = gray 
		)
			
		--Button Function - Create Sphere
		
		on myBttn8 pressed do
		(
			mytube = tube radius1:10  radius2:7 height:30 isSelected: On
			mytube.mapcoords = on
			mytube
			$.wirecolor = gray 
		)
			
		--Button Function - Create Plane
		
		on myBttn9 pressed do
		(
			myplane = plane length:20 width:20 isSelected: On
			myplane.mapcoords = on
			myplane
			$.wirecolor = gray 
		)
			
		--Button Function - Create Cone
		
		on myBttn24 pressed do
		(
			mycone = cone radius1:10 radius2:0 width:20 isSelected: On
			mycone.mapcoords = on
			mycone
			$.wirecolor = gray 
		)
			
		on myBttn25 pressed do
		(
			mypyra = pyramid width:20 depth:20 width:20 isSelected: On
			mypyra.mapcoords = on
			mypyra
			$.wirecolor = gray 
		)
		
		on myBttn26 pressed do
		(
			mygeo = geosphere radius:20 isSelected: On
			mygeo.mapcoords = on
			mygeo
			$.wirecolor = gray 
		)
		
		on myBttn27 pressed do
		(
			mytor = torus radius:20 isSelected: On
			mytor.mapcoords = on
			mytor
			$.wirecolor = gray 
		)
		
		on myBttn28 pressed do
		(
			mytplus = TextPlus layouttype:0 Plane:0  isSelected: On
			$.width = 100
			$.length = 100
			tplustext = "Flow Panels"
			mytplus.SetPlaintextString tplustext
			$.wirecolor = gray 
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
		button myBttn23 "Helix"  width:32 align:#align_topleft  images:#("Splines_24i.bmp", "Splines_24i.bmp",11,11,11,1,1 ) ToolTip: "Create Helix"
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
		on subRollout1 rolledUp open do if open do switchRolls subRollout1
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
		on rand_but pressed do (
		if (selection.count == 0)then 
			messageBox "plz select an one or more object to randomize"
			else 

			undo on
			(
	for i in selection do 
	(
		--- check foooooooooor relative
				if (chk10.checked == true and chk7.checked == false )do 
		(
					messageBox "plz chek the x scale for relative scale or uncheck RelativeScale  "
			exit
			)
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
	if (ranx!=1) do
	ranx=ranx/100

	if (rany!=1) do
	rany=rany/100

	if (ranz!=1) do
	ranz=ranz/100
			if (chk10.checked == false)then
		scale i [ranx,rany,ranz]
		else (
		if (chk7.checked == false)then(
			messageBox "plz chek the x scale for relative scale "
		
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


	))
	-------------------------------------------------------------------------------------------------------------
	on subRollout2 rolledUp open do if open do switchRolls subRollout2
	)

	---------------------------------------------------------------------------------------------------------------- // Modelling Panel 
	-- Modelling Panel Controls 

	Rollout subRollout3 "Modelling Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------

	(
		
		---------------------------------------------------------------------------Modelling Tools Group Controls 
		-------------------------------------------------------------------------------------------------	
		
		Group "Object Display"
		(
			
		button wireview "Wireframe"  width:100 across: 2 
		button edgeview "Edge Face" width:100
		button laun_objprops "Object Properties" width: 200 Height: 30
			
		)

		on theColor changed new_col do selection.wirecolor = new_col	
			
		-------------------------------------------------------------------------------------------------

		on wireview pressed do
		(
			actionMan.executeAction 0 "272"
		)
		

		on edgeview pressed do
		(
			actionMan.executeAction 0 "369"
		)
		
		on laun_objprops pressed do 
		(
			filein "K:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_main_dialog\functions\object_props.ms" 
		)
		
		-------------------------------------------------------------------------------------MaxScripts Group Controls
		
		group "Launch MaxScripts" 
		(
			
		/*	
		button myBttn1 "Welder" width: 100 align:#align_topleft	across:2  
		button myBttn2 "Bend of Bros" width: 100 align:#align_topleft 
		button myBttn4 "Wire Mesh"  width: 100 align:#align_topleft across:2 
		button myBttn12 "Pattern Maker" width: 99 align:#align_topleft
		button Tyc_Btn "Tycoon" width: 99 align:#align_topleft across: 2
		button wevMeshBtn "Weave Mesh" width: 99 align:#align_topleft
		*/
		DropDownList lau_scripts "" items:#("...Pick Scripts...", "1. Welder", "2. Bend of Bros", "3. Wire Mesh", "4. Pattern Maker", "5. Tycoon", "6. Weave Mesh", "7. refGuides")
			
		)
			
		on lau_scripts selected i do
		(
				
			--------------Button Function - Welder
			if lau_scripts.selection == 2 then 
			(
				fileIn "K:\Dropbox\[main access]\3ds_Scripts\Welder2\Welder.mse"
			)
			
			--------------Button Function - Bend of Brothers
			if lau_scripts.selection == 3 then 
			(
				fileIn "K:\Dropbox\[main access]\3ds_Scripts\BendOfBrothers-AlexanderDelagrange\BendOfBrothers.mse"
			)
			
			--------------Button Function - Wire Mesh
			if lau_scripts.selection == 4 then
			(
				fileIn "K:\Dropbox\[main access]\3ds_Scripts\Wire_Mesh_Generator\WireMeshGenerator_v1.04.mse"
			)
				
			--------------Button Function - Pattern Maker
			if lau_scripts.selection == 5 then
			(
				Vu_FFS()
			)
			
			--------------Button Function - Tycoon
			if lau_scripts.selection == 6 then
			(
				fileIn "K:\Dropbox\[main access]\3ds_Scripts\Tycoon_Beta_1_1\Tycoon\_tycoon.mse" 
			)
			
			--------------Button Function - Weave Mesh
			if lau_scripts.selection == 7 then
			(
				Vu_SimpleWeave ()
			)
			
			-------------Button Function - refGuides UI
			if lau_scripts.selection == 8 then
			(
				macros.run "HAG refGuides" "HAG_rG_fltUI"
			)
				
		)
			
			
		/*
		--------------Button Function - Welder
		on myBttn1 pressed do
		(
			fileIn "K:\Dropbox\[main access]\3ds_Scripts\Welder2\Welder.mse" 
		)
		
		--------------Button Function - Bend of Brothers
		on myBttn2 pressed do
		(
			fileIn "K:\Dropbox\[main access]\3ds_Scripts\BendOfBrothers-AlexanderDelagrange\BendOfBrothers.mse"
		)
		
		--------------Button Function - Wire Mesh
		on myBttn4 pressed do
		(
			fileIn "K:\Dropbox\[main access]\3ds_Scripts\Wire_Mesh_Generator\WireMeshGenerator_v1.04.mse" 
		)
		
		--------------Button Function - Pattern Maker
		on myBttn12 pressed do 
		(
			Vu_FFS()
		)
		
		--------------Button Function - Tycoon
		on Tyc_Btn pressed do
		(
			fileIn "K:\Dropbox\[main access]\3ds_Scripts\Tycoon_Beta_1_1\Tycoon\_tycoon.mse" 
		)
		*/
		-------------------------------------------------------------------------------------Cloners Group Controls
		
		Group "Cloners List"
		(
		/*
		button cloRadBtn "Clone Radial" width: 99 align:#align_topleft   across: 2
		button pathCloBtn "Clone on Curve" width: 99 align:#align_topleft 
		button bldgMakBtn "Building Maker" width: 99 align:#align_topleft   across: 2
		button cloSplRadBtn "CloneSpline Rad" width: 99 align:#align_topleft
		button pthClonerBtn "Path Cloner" width: 99 align:#align_topleft   across: 2
		button cloSetUpBtn "Cloner Setup" width: 99 align:#align_topleft
		*/
			
		dropdownlist cloner_list "" items:#("...Pick Cloner...", "1. Clone Radial", "2. Clone on Curve", "3. Building Maker",  "4. CloneSpline Rad", "5. Path Cloner","6. Cloner Setup") width: 200			
			
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
				fileIn "K:\Dropbox\[main access]\3ds_Scripts\HTM-PRJ_cityblks-BMscripts\BuildingMaker.ms"
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
			
			
		/*
		--------------Button Function - Clone Radial
		on cloRadBtn pressed do
		(
			modPanel.addModToSelection (Vu_mcgCloneRadial ()) ui:on
		)
		
		--------------Button Function - Clone on Curve
		on pathCloBtn pressed do
		(
			modPanel.addModToSelection (VA_CloneOnCurve ()) ui:on
		)
		
		--------------Button Function - Building Maker
		on bldgMakBtn pressed do
		(
			fileIn "K:\Dropbox\[main access]\3ds_Scripts\HTM-PRJ_cityblks-BMscripts\BuildingMaker.ms"
		)
		
		--------------Button Function - Weave Mesh
		on wevMeshBtn pressed do
		(
			Vu_SimpleWeave ()
		)
		
		--------------Button Function - Path Cloner
		on pthClonerBtn pressed do
		(
			Path_Cloner ()
		)
		
		--------------Button Function - Cloner Setup
		on cloSetUpBtn pressed do
		(
			modPanel.addModToSelection (Cloner_Transform ()) ui:on
			modPanel.addModToSelection (Cloner_Mesher ()) ui:on
			modPanel.addModToSelection (Stacker ()) ui:on
		)

		--------------Button Function - Path Cloner
		on cloSplRadBtn pressed do
		(
			startObjectCreation Vu_CloneSplRadial
		)	
		*/

-----------------------------------------------------------------------------------------------------------------------------------------

	/*	
		-------------------------------------------------------------------------------------Make Planar Group Controls
		Group "Make Planar"
		(
		Button MPX_btn 	"_X_" width: 66 height: 25 across: 3
		Button MPY_btn "_Y_"  width: 66 height: 25
		Button MPZ_btn "_Z_"  width: 66 height: 25
		)
		
		on MPX_btn pressed do 
		(
			macros.run "Modifiers" "EditPolyMod"
			$.modifiers[#Edit_Poly].ButtonOp #MakePlanarInX
		)
		
		on MPY_btn pressed do 
		(
			 
			(
			macros.run "Modifiers" "EditPolyMod"
			$.modifiers[#Edit_Poly].ButtonOp #MakePlanarInY
			)
		)
		
		on MPZ_btn pressed do 
		(
			macros.run "Modifiers" "EditPolyMod"
			$.modifiers[#Edit_Poly].ButtonOp #MakePlanarInZ
		)
	*/	
		-------------------------------------------------------------------------------------Utilities Group Controls
		
		Group "Preset Bevels"
		(
			ListBox btn_pre_bev "1 Line - Bevels"  items: #("1/2", "1", "2") width: 70 height:4
		)
		
		on btn_pre_bev doubleClicked o do 
		(
			if btn_pre_bev.selection == 1 do
			(
				$.modifiers[#Edit_Poly].SetOperation #ChamferEdge
				$.modifiers[#Edit_Poly].edgeChamferType = 1
				$.modifiers[#Edit_Poly].chamferEdgeAmount = 0.5
				$.modifiers[#Edit_Poly].edgeChamferTension = 0.5
				$.modifiers[#Edit_Poly].edgeChamferSmoothThreshold = 65
				$.modifiers[#Edit_Poly].Commit ()
			)
			if btn_pre_bev.selection == 2 do
			(
				$.modifiers[#Edit_Poly].SetOperation #ChamferEdge
				$.modifiers[#Edit_Poly].edgeChamferType = 1
				$.modifiers[#Edit_Poly].chamferEdgeAmount = 1
				$.modifiers[#Edit_Poly].edgeChamferTension = 0.5
				$.modifiers[#Edit_Poly].edgeChamferSmoothThreshold = 65
				$.modifiers[#Edit_Poly].Commit ()
			)
			if btn_pre_bev.selection == 3 do
			(
				$.modifiers[#Edit_Poly].SetOperation #ChamferEdge
				$.modifiers[#Edit_Poly].edgeChamferType = 2
				$.modifiers[#Edit_Poly].chamferEdgeAmount = 2
				$.modifiers[#Edit_Poly].edgeChamferTension = 0.5
				$.modifiers[#Edit_Poly].edgeChamferSmoothThreshold = 65
				$.modifiers[#Edit_Poly].Commit ()
			)
		)
		
		-------------------------------------------------------------------------------------Utilities Group Controls
		Group "Utilities"	
		(
			button creHolBtn "Create Holes" width: 99 align:#align_topleft  across: 2
			button symRadBtn "Symmetry Radial" width: 99 align:#align_topleft 
			button myBttn3 "Rename" width: 99  across:2 
			button myBttn11 "Export to Engine" width: 99  tooltip: "Records current position, resets tranforms, sets pivot to object's  and exports object at world origin."
			button myBttn13 "Pivot to Base" width: 99  across:2
			button myBttn13a "Pivot to Apex" width: 99  
			button myBttn14 "Object to Origin" width: 99 across:2
			button myPivBttn "Pivot to Origin" width: 99
			button setFlowBtn "Set Flow" width: 99 tooltip: "Adjust Edge Flow of Selected Edges"  across:2
			button delEdgePolBtn "Delete Loop" width: 99 tooltip: "Cleanly Remove Edge Loop from Selected Edge"
			button pok_fac "Scale UVs" width: 99 across: 2 tooltip: "Insets and Collapses a Face" across: 2
			button zero_obj "Reset Object" width: 99 tooltip: "Zero-out Transforms" 
			button tex_chk "Rescale UV Clusters" width: 200 Height: 30
		)
			
		--------------Button Function - Tools
		on myBttn3 pressed do
		(
			macros.run "Tools" "RenameObjects"
		)
		
		---------------Button Function - Export to Engine
		on myBttn11 pressed do
		(
			
			if selection.count > 0 then 
			(
				
				selection[1]
				
				$.pos = [$.center.x, $.center.y, $.center.z]
				sliderTime = 0f
				
				max set key mode
				max set key keys
				max set key keys
				max set key keys
				
				sliderTime = 2f
				
				$.pivot = [$.center.x,$.center.y,$.min.z]
				$.pos = [0,0,0]
				$.rotation = eulerangles 0 0 0
				
				max set key keys
				max set key keys
				max set key keys
				max set key mode
				
				max file export selected
				
			)
			else if selection.count == 0 then 
			(
				messagebox "oops, you didn't select anything!"
			)
		)
			
		on myBttn13 pressed do
		(
			
			if selection.count > 0 then 
			(
				selection[1]
				$.pivot = [$.center.x,$.center.y,$.min.z]
			)
			else if selection.count == 0 then 
			(
				messagebox "oops, you didn't select anything!"
			)
			
		)	
			
		on myBttn13a pressed do
		(
			
			if selection.count > 0 then 
			(
				selection[1]
				$.pivot = [$.center.x,$.center.y,$.max.z]
			)
			else if selection.count == 0 then 
			(
				messagebox "oops, you didn't select anything!"
			)
			
		)	
			
		on myBttn14 pressed do
		(

			if selection.count > 0 then 
			(
				selection[1]
				$.pos = [0,0,0]
			)
			else if selection.count == 0 then 
			(
				messagebox "oops, you didn't select anything!"
			)
			
		)
			
		on myPivBttn pressed do
		(
			
			if selection.count > 0 then 
			(
				selection[1]
				$.pivot = [0,0,0]
			)
			else if selection.count == 0 then 
			(
				messagebox "oops, you didn't select anything!"
			)
			
		)	
			
		On delEdgePolBtn pressed do 
		(
			macros.run "Editable Polygon Object" "EPoly_Select_Loop"
			$.modifiers[#Edit_Poly].ButtonOp #RemoveEdgeRemoveVertices
		)
			
		On setFlowBtn pressed do 
		(
			macros.run "PolyTools" "SetFlow"
		)
		
		
		on pok_fac pressed do 
		(
			macros.run "Modifiers" "Unwrap_UVW"
			macros.run "Modifier Stack" "SubObject_3"
			macros.run "Modifier Stack" "SubObject_3"
			$.modifiers[#unwrap_uvw].unwrap6.selectFacesByNode #{1..10000000}$
			actionMan.executeAction 0 "371"  -- Tools: Viewport Selection Shade Selected Faces Toggle
			filein "K:\Dropbox\[main access]\3ds_Scripts\Alberto_Tools\_main_dialog\functions\precisionScaleUVs.ms"
		)
			
		on zero_obj pressed do 
		(
			if selection.count > 0 then
			(
				$.rotation = eulerangles 0 0 0
				$.pivot = [$.center.x,$.center.y,$.min.z]
				$.pos = [0,0,0]
				
			)
			else if selection.count == 0 then
			(
				messagebox "WARNING: nothing selected!"
				
			)
		)	
			
			--------------Button Function - Create Holes
		on creHolBtn pressed do
		(
			modPanel.addModToSelection (CreateHoles ()) ui:on
		)
		
		--------------Button Function - Symmetry Radial
		on symRadBtn pressed do
		(
			modPanel.addModToSelection (SymmetryRadial ()) ui:on
		)
		
		on tex_chk pressed do 
		(
			macros.run "Modifiers" "Unwrap_UVW"
			macros.run "Modifier Stack" "SubObject_3"
			macros.run "Modifier Stack" "SubObject_3"
			$.modifiers[#unwrap_uvw].unwrap6.selectFacesByNode #{1..10000000}$
			actionMan.executeAction 2077580866 "40207"  -- Unwrap UVW: Rescale Clusters	
			SubObjectLevel = 0
		)
		
		
		on subRollout3 rolledUp open do if open do switchRolls subRollout3
	)
	---------------------------------------------------------------------------------------------------------------- // Grid Panel 
	-- Grid Panel Controls 

	Rollout subRollout5 "Grid & Snaps Panel" 

	--------------------------------------------------------------------------------------------------------------------------------------

	(
		Group "Snap Enable:"
		(
			checkbutton snapBtn ""  images:#("Snap_Points_24i.bmp", "Snap_Points_24i.bmp",7,1,1,1,1 ) ToolTip:"Snap Toggle"	across: 4 	
			checkbutton snapFrzBtn ""  images:#("SnapsControls_24i.bmp", "SnapsControls_24i.bmp",38,33,33,1,1 ) ToolTip:"Snap to Frozen Objects"		
			checkbutton snapAxisBtn ""  images:#("SnapsControls_24i.bmp", "SnapsControls_24i.bmp",38,36,36,1,1 ) ToolTip:"Enable Axis Constraints in Snap Toggle"		
			checkbutton snapAnglBtn ""  images:#("SnapsControls_24i.bmp", "SnapsControls_24i.bmp",37,23,23,1,1 ) ToolTip:"Angle Snap Toggle"		
		)
		
		on snapBtn changed state do
		(
			if state == on then
				max snap toggle
			else
				max snap toggle
			
		)
			
		on snapFrzBtn changed state do
		(
			if state == on then
				max snap to frozen object
			else
				max snap to frozen object
			
		)
		
		on snapAxisBtn changed state do
		(
			if state == on then
				actionMan.executeAction 0 "40904"
			else
				actionMan.executeAction 0 "40904"
			
		)
		
		on snapAnglBtn changed state do
		(
			if state == on then
				max angle snap toggle
			else
				max angle snap toggle
			
		)
		
		-------------------------------------------------------------------------------------------------
		
		Group "Snap Type:"
		(
			checkbutton gridBox "Grid Point"  across: 6  images:#("Snap_Points_24i.bmp", "Snap_Points_24i.bmp",7,1,1,1,1 ) ToolTip:"Snap to Grid Point"
			checkbutton vertBox "Vertex"  images:#("Snap_Points_24i.bmp", "Snap_Points_24i.bmp",7,2,2,1,1 ) ToolTip:"Snap to Vertex"
			checkbutton pivotBox "Pivot"  images:#("Snap_Points_24i.bmp", "Snap_Points_24i.bmp",7,4,4,1,1 ) ToolTip:"Snap to Pivot"
			checkbutton midBox "Midpoint"  images:#("Snap_Points_24i.bmp", "Snap_Points_24i.bmp",7,6,6,1,1 ) ToolTip:"Snap to Midpoint"
			checkbutton edgeBox "Edge"  images:#("Snap_Points_24i.bmp", "Snap_Points_24i.bmp",7,3,3,1,1 ) ToolTip:"Snap to Edge"
			checkbutton faceBox "Face"  images:#("Snap_Points_24i.bmp", "Snap_Points_24i.bmp",7,5,5,1,1 ) ToolTip:"Snap to Face"
		)
		
		on gridBox changed state do
		(
			if state == on then
				snapMode.setOSnapItemActive 4 1 true
			else
				snapMode.setOSnapItemActive 4 1 false
		)
		
		On vertBox changed state do
		(
			if state == on then
				snapMode.setOSnapItemActive 7 1 true
			else
				snapMode.setOSnapItemActive 7 1 false
		)
		
		On pivotBox changed state do
		(
			if state == on then
				snapMode.setOSnapItemActive 5 1 true
			else
				snapMode.setOSnapItemActive 5 1 false
		)
		
		On midBox changed state do
		(
			if state == on then
				snapMode.setOSnapItemActive 7 4 true
			else
				snapMode.setOSnapItemActive 7 4 false
		)
		
		On edgeBox changed state do
		(
			if state == on then
				snapMode.setOSnapItemActive 7 3 true
			else
				snapMode.setOSnapItemActive 7 3 false
		)
		
		On faceBox changed state do
		(
			if state == on then
				snapMode.setOSnapItemActive 7 6 true
			else
				snapMode.setOSnapItemActive 7 6 false
		)
		
		---------------------------------------------------------------------------Grid Options
		Group "Display"
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
			
		group "Spacing:" 
		(
			
			Spinner set_spacing "Home Grid Spacing:" type:#integer range: [0,100,0]  width:150 across: 1 height: 20
			Spinner set_majorlines "Set Major Lines:     " type:#integer range: [0,100,0]  width:150 across: 1 height: 20 
			Spinner set_persviewextent "Home Grid Extent:" type:#integer range: [0,100,0]  width:150 across: 1 height: 20
			label lbl_02 "Preset Spacing: " across: 2
			dropdownlist scale_dd "" items:#("   10 cm", "   8 cm", "   6 cm",  "   4 cm", "   2 cm","   1 cm", "   1/2 cm", "   1/4 cm", "   1/8 cm") width: 90
			
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
			
			on subRollout5 rolledUp open do if open do switchRolls subRollout5
		)

	---------------------------------------------------------------------------------------------------------------- // Modifier Panel 
	-- Modifier Panel Controls 

	Rollout paintPan "Painting Panel"  

	--------------------------------------------------------------------------------------------------------------------------------------

	(
		
		group "Viewport Canvas: "
		(
			button viewCanvas "Launch Viewport Canvas" width: 200 Height: 30
		)
		
		on viewCanvas pressed do 
		(
			macros.run "Viewport Canvas" "ViewportCanvas"
		)
		on paintPan rolledUp open do if open do switchRolls paintPan
	)

	---------------------------------------------------------------------------------------------------------------- // Properties Panel 
	-- Properties Panel Controls 

	Rollout subRollout4 "Normals Panel"
		
	--------------------------------------------------------------------------------------------------------------------------------------
	(
	Group "Set Normals"
	(
		
	Button cmdCreate "Set Weighted Normals" width: 200 Height: 40
	Button cmdLock "Set & Lock Normals" width: 200 Height: 40
	Button cmdReset "Release Normals" width: 200 Height: 40
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
			messagebox "WARNING!: Nothing is Selected"
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


	---------------------------------------------------------------------------------------------------------------- // Modelling Panel 
	-- Export Panel Controls 

	Rollout UE4Tools "Export Panel"

	-------------------------------------------------------------------------------------------------------------------------------------	
	(
--------------------------------------------------------------------------------------------------------------------------------------------------------------	
--////////////////////////////////////////////////////////////////////////////////////////////Quick Export
--------------------------------------------------------------------------------------------------------------------------------------------------------------
			
		Group "Quick Export"
		(		
				
			button btn_QXport "Quick Export!" 					width: 160		height:50
			edittext multiNam "Name:"			align:#center 	width: 160
			checkbutton btn_obj_typ "OBJ" 	align:#center	width: 45			across:2
			checkbutton btn_fbx_typ "FBX"	align:#center	width: 45
			button btn_fold_path "Set Export Location"		width: 160		height:25
			label lbl_selID_typ "---------------------------------------------"
			dropdownlist ddl_local_set "" 	align:#center 	width: 160		items:#("...preset project list...", "EK_elven_king") columns:2
			edittext qx_fldr "Location: "		align:#center	width: 160
				
		)
			
	--------------------------------------------------------------------------------------------------------------------------------
			
		local	typ1 = ".OBJ"		
		local	typ2 = ".FBX"
		local	typ_setr = "."
		local	initNam = "obj_default_name_a"		
		local	main_db = "[main access]"
			
	--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_fold_path pressed do 
		(
				
			folder_path = getSavepath()	
			if folder_path == undefined do 
			(
				folder_path = "C:\\users\Alberto\Desktop"
				qx_fldr.text = folder_path 
			)
			qx_fldr.text = folder_path 
				
		)
			
	--------------------------------------------------------------------------------------------------------------------------------		
			
		On btn_QXport  pressed do
		(   
				
			ObjNam = "\\" + multiNam.text + typ_setr
			for i in selection do 
			(
				exportFile	( qx_fldr.text + ObjNam )		selectedOnly:true
			)
				
		)	
	--------------------------------------------------------------------------------------------------------------------------------			
			
		On btn_obj_typ changed state do 		
		(
			Undo on
			if state == on then
				typ_setr = typ1
			else
				false
		)
			
	--------------------------------------------------------------------------------------------------------------------------------
			
		On btn_fbx_typ changed state do 
		(
			Undo on
			if state == on then
				typ_setr = typ2
			else
				false
		)
		/*
			thefolder = filterstring Qxportr "\\"
			thefolder = thefolder[thefolder.count]
			folder_pth.text = theFolder	
		*/
	--------------------------------------------------------------------------------------------------------------------------------
			
		On ddl_local_set selected state do
		(
			multiNam.text = initNam
			(
				
				if ddl_local_set.selection == 1 then ()
				if ddl_local_set.selection == 2 then qx_fldr.text = "K:\\Dropbox\\" + main_db + "\\projects\\EK_elven_king\\models\\objs"
				if ddl_local_set.selection == 3 then qx_fldr.text = "C:\Users\\" + UsrNam + "\\Documents\Vendors\PS_Structures\objects\ps_structures"
				if ddl_local_set.selection == 4 then qx_fldr.text = "C:\Users\\" + UsrNam + "\\Documents\Vendors\PS_Furniture\objects\ps_furniture"					
				
			)
		)
			
-------------------------------------------------------------------------------------------------------------------------------------------------------------	
--//////////////////////////////////////////////////////////////////////////////////////////Folder Manager
-------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			
		Group  "Folder Manager "
		(
		button 'btn_exportdirectory' "Set Export Folder"     width:100 height:24 toolTip:"Set the export directory for where your FBX files will export to." align:#left across:2
		button 'btn_openExplorer' "Open in Explorer"              width:100 height:24 toolTip:"Open the specified export directory in a new window." align:#left
		edittext 'edittext_exportDirectory' ""                      width:195 height:24 enabled:false readOnly:true align:#left 
		dropdownList 'ddl_FileType' "Export File Type"    width:200 height:40 enabled:false items:#("FBX", "OBJ") align:#left
		)
		
		Group "Export Options"
		(
		checkbox 'chk_origin' "Zero on Export (Pos, Rot)"     width:146 height:16 enabled:false checked:true align:#left
		checkbox 'chk_exportSelected' "Export Selected"    width:104 height:16 enabled:false align:#left
		checkbox 'chk_options' "FBX/OBJ Options on Export"       width:150 height:16 enabled:false align:#left
		)	
			
		Group "Layer Options"       
		(
		checkbox 'chk_layers' "Export Layers"                   width:88 height:16 enabled:false checked:true align:#left
		)
			
		Group  "Unreal Options" 
		(
		checkbox 'chk_xformToClip' "Clipboard Text"        width:96 height:16 enabled:false checked:true align:#left
		checkbox 'chk_collision' "Export Collision"          width:96 height:16 enabled:false checked:false align:#left
		)
		
		--------------------------------------------------------------------------------------------- Unreal Scripts 
		
		Group "Unreal Animation Export"
		(
			Button ue_vert_anim "Vertex Animation Tools" width:140 height:25
			Button ue_mesh_mor "Static Mesh Morpher" width:140 height:25
		)
		
		On ue_vert_anim pressed do
		(
			fileIn "K:\Dropbox\[main access]\3ds_Scripts\_Scripts\Unreal_Scripts\VertexAnimationTools.ms"
		)
		
		On ue_mesh_mor pressed do
		(
			fileIn "K:\Dropbox\[main access]\3ds_Scripts\_Scripts\Unreal_Scripts\StaticMeshMorpher.ms"
		)
		
		--------------------------------------------------------------------------------------------------------------------------
		Group "Export Mesh"
		(
		button 'btn_export' "Export"                                       width:100 height:24 enabled:false  toolTip:"Exports objects to the designated export folder. Also copies transforms of all specified objects."  across: 2
		button 'btn_transformsToClipboard' "XYZ to Clipboard"      width:100 height:24 enabled:false toolTip:"Copy the transforms of the specified objects to the clipboard."
		)
	----------------------------------------------------------------------------------------------------------------	

		
		--Directories
		global exportDirectory = undefined
		global layerDirectory = undefined
		
		--Export Variables
		global exportObjs = #()
		global exportText = undefined
		global exportFileType = "FBX"
		
		--Export Options
		global check_origin = true
		global check_selected = false
		global check_layerFolders = true
		global check_xFormToClip = true
		global check_options = false
		
		--Header text for Unreal Paste
		global exportText_header = 
	"Begin Map
		Begin Level
	"

		--Body text for Unreal Paste
		global exportText_body = 
	"	Begin Actor Class=StaticMeshActor Name=% Archetype=StaticMeshActor'/Script/Engine.Default__StaticMeshActor'
			Begin Object Class=StaticMeshComponent Name=\"StaticMeshComponent0\" Archetype=StaticMeshComponent'Default__StaticMeshActor:StaticMeshComponent0'
			End Object
			
			Begin Object Name=\"StaticMeshComponent0\"
			StaticMesh=StaticMesh'/Game/%.%'
			RelativeLocation=(X=%,Y=%,Z=%)
			RelativeRotation=(Pitch=%,Yaw=%,Roll=%)
			RelativeScale3D=(X=%,Y=%,Z=%)
			End Object
			
			StaticMeshComponent=StaticMeshComponent0
			RootComponent=StaticMeshComponent0
			ActorLabel=\"%\"
			FolderPath=\"Meshes/%\"
		End Actor
	"
		--Footer text for Unreal Paste
		global exportText_footer =
	"		End Level
		Begin Surface
		End Surface
	End Map
	"

		--Set Export Directory
		fn fn_exportDirectory =
		(
			try
			(
				--Get the directory the user chooses
				exportDirectory = getSavePath caption:"Select your Meshes folder in your Unreal Project" initialDir:#images
				exportDirectory = exportDirectory + @"\export"
				edittext_exportDirectory.text = exportDirectory
				
				--Enable buttons/checkboxes/etc.
				btn_export.enabled = on
				btn_transformsToClipboard.enabled = on
				edittext_exportDirectory.enabled = on
				chk_origin.enabled = on
				chk_exportSelected.enabled = on
				chk_layers.enabled = on
				chk_xformToClip.enabled = on
				chk_options.enabled = on
				ddl_FileType.enabled = on
			)
			catch()
		)
		
		--Open Explorer
		fn fn_explorer =
		(
			if exportDirectory == undefined then
			(
				--Prompt for not selecting an export directory yet
				messageBox "Please select an export directory."
			)
			else
			(
				--Launching a new explorer window of the export directory, as set in fn_exportDirectory
				ShellLaunch exportDirectory ""
			)
		)

		--Export All Objects in Scene
		fn fn_export =
		(
			exportObjs = #()
			exportText = exportText_header
			local exportStream = stringstream ""
			local myinstances = #()
			
			--Check to see if the user wants to only export selected objects
			if check_selected == false do
			(
				select geometry --If not, select all geometry in the scene
			)
			
			if selection.count != 0 do --If the selection count is not equal to zero
			(
				local firstInstances = #()
				
				-- Go through and find all master objects from instances
				for o in selection do 
				(
					--Determine the master instance
					InstanceMgr.GetInstances o &firstOnly
					if firstOnly.count > 1 do append firstInstances firstOnly[firstOnly.count]
					masterInstance = (firstOnly[firstOnly.count]).name
					
					--Variables
					local exportText_bodyTemp = exportText_body
					local objCoord = o.pos
					local objX_pos = o.pos.x
					local objY_pos = o.pos.y * -1.0
					local objZ_pos= o.pos.z
					local objX_rot = o.rotation.x_rotation 
					local objY_rot = o.rotation.y_rotation * -1.0
					local objZ_rot = o.rotation.z_rotation * -1.0
					local objX_scale = o.scale.x
					local objY_scale = o.scale.y
					local objZ_scale = o.scale.z
					local currentObj = o.name
					local objectLayer = o.layer.name
					
					--Format UE4 paste text
					if check_layerFolders == true then
					(
						format exportText_bodyTemp currentObj masterInstance masterInstance objX_pos objY_pos objZ_pos objY_rot objZ_rot objX_rot 1 1 1  currentObj objectLayer to:exportStream
					)
					else
					(
						format exportText_bodyTemp currentObj masterInstance masterInstance objX_pos objY_pos objZ_pos objY_rot objZ_rot objX_rot 1 1 1  currentObj "" to:exportStream
					)
					
					exportText_bodyTemp = exportStream
					exportStream = stringstream ""
					exportText += exportText_bodyTemp
				)

				-- Go through and find all singular non-instance objects
				for o in selection do 
				(
					if InstanceMgr.CanMakeObjectsUnique o == false then
					(append firstInstances o)
				)
				
				--Select All Master Instances
				if firstInstances.count != 0 do select firstInstances
				
				for i in selection do
				(
					insertItem i exportObjs 1
				)
				
				--Export Objects
				for o = 1 to exportObjs.count do
				(
					--Select the current object in the list of export objects
					select exportObjs[o]
					
					local objectLayer = undefined
					
					--Get the layer the object is on
					for i = 0 to layerManager.count-1 do
					(
						for o in selection where matchpattern o.layer.name pattern:(layermanager.getLayer i).name do
						(
							objectLayer = o.layer.name
						)
					)

					--Variables
					local subDirectory = exportDirectory + (@"\") + objectLayer
					local objPos = $.pos
					local objX_rot = $.rotation.x_rotation
					local objY_rot = $.rotation.y_rotation
					local objZ_rot = $.rotation.z_rotation
					local posMatrix = transMatrix $.transform.pos
					local scaMatrix = scaleMatrix $.transform.scale
					$.transform = scaMatrix * posMatrix
					
					--Move objects to origin on export
					if check_origin == true do
					(
						$.pos = [0,0,0]
					)
					
					--Set Rotations to 0
					rotate $ (angleaxis 0 [1,0,0])
					rotate $ (angleaxis 0 [0,1,0])
					rotate $ (angleaxis 0 [0,0,1])
					
					--Export to layer subfolders
					if check_layerFolders == true then
					(
						local exportFileName = subDirectory + (@"\") + $.name + (@".") + exportFileType
						makeDir subDirectory all:true 
					)
					else
					(
						local exportFileName = exportDirectory + (@"\") + $.name +  (@".") + exportFileType
						makeDir exportDirectory
					)
					
					--Export the file
					if check_options == false then
					(
						exportFile exportFileName #noPrompt selectedOnly:true
					)
					else
					(
						exportFile exportFileName selectedOnly:true
					)
					
					--Reset position, rotations
					$.pos = objPos
					rotate $ (angleaxis objX_rot [1,0,0])
					rotate $ (angleaxis objY_rot [0,1,0])
					rotate $ (angleaxis objZ_rot [0,0,1])
				)
				
				--Append the footer to the export text
				exportText += exportText_footer
				
				--Check to see if the user wants to copy the text to the clipboard
				if check_xFormToClip == true then
				(
					setClipBoardText exportText
					messageBox "All objects exported. Transforms copied to clipboard. Import into the Content folder of your Unreal project. Go to Edit -> Paste to populate meshes in your scene."
				)
				else
				(
					messageBox "All objects exported."
				)
			)
		)
		
			--Transforms to Clipboard
		fn fn_transformsToClipboard =
		(
			exportObjs = #()
			local myinstances = #()
			exportText = exportText_header
			local exportStream = stringstream ""
			
			if check_selected == false do
			(
				select geometry
			)
			
			if selection.count != 0 do
			(
				local firstInstances = #()
				
				-- Go through and find all master objects from instances
				for o in selection do 
				(
					InstanceMgr.GetInstances o &firstOnly
					if firstOnly.count > 1 do append firstInstances firstOnly[firstOnly.count]
					masterInstance = (firstOnly[firstOnly.count]).name
					
					local exportText_bodyTemp = exportText_body
					local objCoord = o.pos
					local objX_pos = o.pos.x
					local objY_pos = o.pos.y * -1.0
					local objZ_pos= o.pos.z
					local objX_rot = o.rotation.x_rotation 
					local objY_rot = o.rotation.y_rotation * -1.0
					local objZ_rot = o.rotation.z_rotation * -1.0
					local objX_scale = o.scale.x
					local objY_scale = o.scale.y
					local objZ_scale = o.scale.z
					local currentObj = o.name
					local exportFileName = exportDirectory + (@"\") + currentObj + @".fbx"
					local objectLayer = o.layer.name
					
					if check_layerFolders == true then
					(
						format exportText_bodyTemp currentObj masterInstance masterInstance objX_pos objY_pos objZ_pos objY_rot objZ_rot objX_rot 1 1 1  currentObj objectLayer to:exportStream
					)
					else
					(
						format exportText_bodyTemp currentObj "" masterInstance masterInstance objX_pos objY_pos objZ_pos objY_rot objZ_rot objX_rot 1 1 1  currentObj "" to:exportStream
					)
					
					exportText_bodyTemp = exportStream
					exportStream = stringstream ""
					exportText += exportText_bodyTemp
				)

				-- Go through and find all singular non-instance objects
				for o in selection do 
				(
					if InstanceMgr.CanMakeObjectsUnique o == false then
					(append firstInstances o)
				)
				
				--Select All Master Instances
				if firstInstances.count != 0 do select firstInstances
				
				for i in selection do
				(
					insertItem i exportObjs 1
				)
				
				exportText += exportText_footer
				messageBox "All objects exported. Transforms copied to clipboard. Import into the Content folder of your Unreal project. Go to Edit -> Paste to populate meshes in your scene."
				setClipBoardText exportText
			)
		)
		

		on btn_exportdirectory pressed do
			fn_exportDirectory()
		on btn_export pressed do
			fn_export()
		on btn_openExplorer pressed do
			fn_explorer()
		on btn_transformsToClipboard pressed do
			fn_transformsToClipboard()
		on chk_origin changed state do
		(
			if state then
			(
				check_origin = true
				print "Checked"
			)
			else
			(
				check_origin = false
				print "Unchecked"
			)
		)
		on chk_exportSelected changed state do
		(
			if state then
			(
				check_selected = true
				print "Selected"
			)
			else
			(
				check_selected = false
				print "Unchecked"
			)
		)
		on chk_layers changed state do
		(
			if state then
			(
				check_layerFolders = true
				print "Layers"
			)
			else
			(
				check_layerFolders = false
				print "Unchecked"
			)
		)
		on chk_xformToClip changed state do
		(
			if state then
			(
				check_xFormToClip = true
				print "xForm"
			)
			else
			(
				check_xFormToClip = false
				print "Unchecked"
			)
		)
		on chk_options changed state do
		(
			if state then
			(
				check_options = true
				print "Options"
			)
			else
			(
				check_options = false
				print "Unchecked"
			)
		)
		on ddl_FileType selected i do
			exportFileType = ddl_FileType.items[i]
			
		
		on UE4Tools rolledUp open do if open do switchRolls UE4Tools
	)

    local rolls = #(SubRollout6, SubRollout1, SubRollout3, SubRollout4, paintPan, SubRollout5, SubRollout2, UE4Tools)

    on  myRoll open do
        for roll in rolls do addSubRollout scriptBin roll rolledUp:true

	on myRoll close do
	(
		toolSetClosePos= getdialogpos myRoll
	)
)	


-------------------------------------------------------------------------------------------------------------------------------------	

---------------------------------------------------------------------------------------------------------------- // CreateU

--newwind = newRolloutFloater "Alberto's Toolset" 250 900 
createdialog myRoll  width:250 menu:myMenu

cui.registerDialogBar myRoll
cui.dockDialogBar myRoll #cui_dock_right