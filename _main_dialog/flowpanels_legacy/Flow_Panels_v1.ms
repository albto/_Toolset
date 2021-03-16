
---------------------------------------------------------------------------------------------------------------- // Tool Settings
--Tool Settings 

--try(closeRolloutFloater newwind)catch()

Try(cui.UnregisterDialogBar myRoll)catch()
Try(destroydialog myRoll)catch()


persistent global toolSetClosePos
if toolSetClosePos == undefined do toolSetClosePos = [400,100]
	

global myRoll, menuBox, paintPan, SubRollout1, SubRollout2, SubRollout3, SubRollout4, SubRollout5, SubRollout6, UE4Tools

--------------------------------------------------------------------------------------------------------------------------------------
rcMenu myMenu 
--------------------------------------------------------------------------------------------------------------------------------------
(	
	submenu "Flow Panels" 
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

rollout myRoll "FP - v1.0"
	
--------------------------------------------------------------------------------------------------------------------------------------

(

	--ROLLOUT CONTROLS
	subRollout scriptBin width:(myRoll.width as float -10) height:880 pos:[5,5]

   --Adds Sub-Rollouts
	on myRoll open do
    (
			
		addsubRollout scriptBin myRoll 
		addSubRollout scriptBin subRollout4 rolledup: true --obj prop
		addSubRollout scriptBin subRollout6 rolledup: true --selection 
		addSubRollout scriptBin subRollout1 rolledup: true --create
		addSubRollout scriptBin subRollout3 rolledup: true --modelling
		addSubRollout scriptBin subRollout5 rolledup: true --grid 
		addSubRollout scriptBin paintPan rolledup: true --
		addSubRollout scriptBin subRollout2 rolledup: true --transform
		addSubRollout scriptBin UE4Tools rolledup:true --exporter
    )	

	on myRoll close do
	(
		toolSetClosePos= getdialogpos myRoll
	)
	
	
	
)	
---------------------------------------------------------------------------------------------------------------- // Selection Panel 
-- Selection Panel

Rollout subRollout6 "Selection Panel"

--------------------------------------------------------------------------------------------------------------------------------------

(

---------------------------------------------------------------------------------------------------------------// Banner 	

	--local b = openBitMap(@"C:\Users\Alberto\Desktop\UI.bmp")
	--imgTag imgLogo "logo" tooltip:"logo" style:#bmp_center bitmap:b width: 240 height:100 pos:[0, 0]

	--on imgLogo lbuttonup do
	--(
		--hitByNameDlg()
	--)
---------------------------------------------------------------------------------------------------------------// Selection
	
	
	group "Selection Type:" 
	(
		
	label lbl_01 "No - Items Selected"  
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
		
		
	fn zwroc obj= 
			
	(						
		contador = (selection.count as string)
			
		if selection.count == 1 then  
		(
			
			lbl_01.text = ("Name: " + obj.name) 
			
		)
		if selection.count == 0 then 
		(
			lbl_01.text = "No - Items Selected" 
		)
		if selection.count >= 2 then (lbl_01.text = (contador + " - Items Selected" ))
			
	)

	
		
---------------------------------------------------------------------------------------------------------------// Clean Up Controls
	
	Group "Clean-Up:"
	(
		button selNQ "Select NGons" width:90 height: 20	across:2
		button selOF "Select Open" width:90 height: 20	
		button selMCU "Mesh CleanUp" width:90 height: 20
	)


	On selNQ pressed do 
	(
		NQmod = edit_poly()
		NQMod.name = "CLEAN-UP: N-Gons"
		addModifier $ NQMod
		subobjectLevel = 4
		macros.run "PolyTools" "NonQuad"
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
	
---------------------------------------------------------------------------------------------------------------	
	
	on subRollout6 open do callbacks.addScript #selectionSetChanged "subRollout6.zwroc $" id:#cb1 
	on subRollout6 close do callbacks.removescripts #selectionSetChanged id:#cb1
---------------------------------------------------------------------------------------------------------------	

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
	button myBttn26 "geoSphere" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,7,7,1,1 ) ToolTip: "Create GeoSphere"  
	button myBttn27 "Box" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,4,4,1,1 ) ToolTip: "Create Torus" 
	button myBttn28 "Box" width:32 height:32 align:#align_topcleft images:#("Standard_24i.bmp", "Standard_24i.bmp",11,11,11,1,1 ) ToolTip: "Create Text+"  
	)

	
	--Button Function - Create Box 
	
	on myBttn5 pressed do
	(
		
		mybox = box length:20 width:20 height:20 isSelected: On 
		mybox.mapcoords = on		
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
		mysphere = sphere length:20 width:20 height:20 segments:32 isSelected: On
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
		tplustext = "Flow Panels"
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
)			

---------------------------------------------------------------------------------------------------------------- // Transform Panel 
-- Transform Panel Controls 

Rollout subRollout2 "Transform Panel"
	
--------------------------------------------------------------------------------------------------------------------------------------

( 
	group "Rotate per Axis:"
	(
		radioButtons axis labels:#("X","Y","Z") columns:3
	)
	
	group "Rotate Amount:"
	(
		button rotPos45 "+45" width:60 across:3
		button rotPos90 "+90" width:60
		button rotPos180 "+180" width:60		
		button rotNeg45 "-45" width:60	across:3
		button rotNeg90 "-90" width:60
		button rotNeg180 "-180" width:60
			
	)
	
	on axis changed state do
	(
		case state of 
		(
			1: axis = [1,0,0]
			2: axis = [0,1,0]
			3: axis = [0,0,1]
		)
	)
	on rotNeg45 pressed do (rotate selection -45 axis)
	on rotPos45 pressed do (rotate selection 45 axis)
	on rotNeg90 pressed do (rotate selection -90 axis)
	on rotPos90 pressed do (rotate selection 90 axis)
	on rotNeg180 pressed do (rotate selection -180 axis)
	on rotPos180 pressed do (rotate selection 180 axis)	

------------------------------------------------------------------------------------------------Random Transform
	label lbrndtrans " // Random Transforms:" pos:[0,130]
	
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
)

---------------------------------------------------------------------------------------------------------------- // Modelling Panel 
-- Modelling Panel Controls 

Rollout subRollout3 "Modelling Panel"
	
--------------------------------------------------------------------------------------------------------------------------------------

(
	
	---------------------------------------------------------------------------Modelling Tools Group Controls 

	-------------------------------------------------------------------------------------------------	
	
	Group "Object Display:"
	(
		
	button wireview "Wireframe"  width:100 across: 2 
	button edgeview "Edge Face" width:100
		
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
	
	-------------------------------------------------------------------------------------------------
	/*
	Group "Modifier List:"
	(
		button bttnModPan "Launch Panel" width: 200 height: 40
	)
	
	-------------------------------------------------------------------------------------------------
	
	on bttnModPan pressed do
	(
		local modPanPos
		modPanPos = getdialogpos myRoll + [-180,80]
		try destroyDialog menuModPan catch()
		createDialog menuModPan pos: modPanPos

	)
	*/
	-------------------------------------------------------------------------------------------------
	
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
	
	-------------------------------------------------------------------------------------MaxScripts Group Controls
	
	group "Launch MaxScripts:"
	(
	button myBttn1 "Welder" width: 100 align:#align_topleft	across:2  
	button myBttn2 "Bend of Bros" width: 100 align:#align_topleft 
	button myBttn4 "Wire Mesh"  width: 100 align:#align_topleft across:2 
	button myBttn12 "Pattern Maker" width: 99 align:#align_topleft
	button Tyc_Btn "Tycoon" width: 99 align:#align_topleft across: 2
	button wevMeshBtn "Weave Mesh" width: 99 align:#align_topleft 
	button creHolBtn "Create Holes" width: 99 align:#align_topleft  across: 2
	button symRadBtn "Symmetry Radial" width: 99 align:#align_topleft 
	)
		
	--------------Button Function - Welder
	on myBttn1 pressed do
	(
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\Welder2\Welder.mse"
	)
	
	--------------Button Function - Bend of Brothers
	on myBttn2 pressed do
	(
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\BendOfBrothers-AlexanderDelagrange\BendOfBrothers.mse"
	)
	--------------Button Function - Tools
	on myBttn3 pressed do
	(
		macros.run "Tools" "RenameObjects"
	)
	
	--------------Button Function - Wire Mesh
	on myBttn4 pressed do
	(
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\Wire_Mesh_Generator\WireMeshGenerator_v1.04.mse" 
	)
	
	--------------Button Function - Tycoon
	on Tyc_Btn pressed do
	(
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\Tycoon_Beta_1_1\Tycoon\_tycoon.mse" 
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

	-------------------------------------------------------------------------------------Cloners Group Controls
	
	Group "Cloners:"
	(
	button cloRadBtn "Clone Radial" width: 99 align:#align_topleft   across: 2
	button pathCloBtn "Clone on Curve" width: 99 align:#align_topleft 
	button bldgMakBtn "Building Maker" width: 99 align:#align_topleft   across: 2
	button cloSplRadBtn "CloneSpline Rad" width: 99 align:#align_topleft
	button pthClonerBtn "Path Cloner" width: 99 align:#align_topleft   across: 2
	button cloSetUpBtn "Cloner Setup" width: 99 align:#align_topleft
	)
	
	
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
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\HTM-PRJ_cityblks-BMscripts\BuildingMaker.ms"
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
	
	
	-------------------------------------------------------------------------------------Make Planar Group Controls
	Group "Make Planar:"
	(
	Button MPX_btn 	"_X_" width: 66 height: 25 across: 3
	Button MPY_btn "_Y_"  width: 66 height: 25
	Button MPZ_btn "_Z_"  width: 66 height: 25
	)
	
	on MPX_btn pressed do 
	(
		$.modifiers[#Edit_Poly].ButtonOp #MakePlanarInX
	)
	
	on MPY_btn pressed do 
	(
		$.modifiers[#Edit_Poly].ButtonOp #MakePlanarInY
	)
	
	on MPZ_btn pressed do 
	(
		$.modifiers[#Edit_Poly].ButtonOp #MakePlanarInZ
	)
	
	-------------------------------------------------------------------------------------Utilities Group Controls
	group "Utilities:"	
	(
	button myBttn3 "Rename" width: 99  across:2 
	button myBttn11 "Export to Engine" width: 99  tooltip: "Records current position, resets tranforms, sets pivot to object's  and exports object at world origin."
	button myBttn13 "Pivot to Base" width: 99  across:2
	button myBttn13a "Pivot to Apex" width: 99  
	button myBttn14 "Object to Origin" width: 99 across:2
	button myPivBttn "Pivot to Origin" width: 99
	button setFlowBtn "Set Flow" width: 99 tooltip: "Adjust Edge Flow of Selected Edges"  across:2
	button delEdgePolBtn "Delete Loop" width: 99 tooltip: "Cleanly Remove Edge Loop from Selected Edge"
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
	
	on myBttn12 pressed do 
	(
		Vu_FFS()
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
)

---------------------------------------------------------------------------------------------------------------- // Grid Panel 
-- Grid Panel Controls 

Rollout subRollout5 "Grid Panel" 

--------------------------------------------------------------------------------------------------------------------------------------

(
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
		label lbl_02 "Preset Spacing: " across: 2
		dropdownlist scale_dd "" items:#("   10 cm", "   8 cm", "   6cm",  "   4 cm", "   2 cm","   1 cm", "   1/2 cm", "   1/4 cm", "   1/8 cm") width: 90
		
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
	
)

---------------------------------------------------------------------------------------------------------------- // Modifier Panel 
-- Modifier Panel Controls 

Rollout paintPan "Painting Panel"  

--------------------------------------------------------------------------------------------------------------------------------------

(
	group "Viewport Canvas: "
	(
		button viewCanvas "Launch Viewport Canvas" width: 160 height: 30
	)
	
	on viewCanvas pressed do 
	(
		macros.run "Viewport Canvas" "ViewportCanvas"
	)
	
)

---------------------------------------------------------------------------------------------------------------- // Properties Panel 
-- Properties Panel Controls 

rollout subRollout4 "Object Control Panel"
	
--------------------------------------------------------------------------------------------------------------------------------------

(
	Group "Information:"
	(
	edittext edt_name "Name:"  pos: [15,30] width:155 height:17 across: 2
	colorPicker clp_Wirecolor "" pos: [170,29] width:40 height:20 color:(color 16 16 16)
	edittext edt_matname "Materialname:"  width:180 height:17 enabled:true readOnly:true
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
		
	spinner spn_posX "X Position:"  pos: [45,310] width:65 height:17 type:#worldunits range:[-1e9,1e9,0]
	spinner spn_posY "Y Position:"  pos: [45,330] width:65 height:17  type:#worldunits range:[-1e9,1e9,0]
	spinner spn_posZ "Z Position:"  pos: [45,350] width:65 height:17  type:#worldunits range:[-1e9,1e9,0]
	spinner spn_ScaleX "X Scale:"  pos: [145,310] width:65 height:17 range:[-1e9,1e9,0]
	spinner spn_ScaleY "Y Scale:"  pos: [145,330] width:65 height:17 range:[-1e9,1e9,0]
	spinner spn_ScaleZ "Z Scale:"  pos: [145,350] width:65 height:17 range:[-1e9,1e9,0]
		
		
	)
	Group "Interactivity:"
	(
	checkbox chk_hide "Hide"  width:46 height:15
	checkbox chk_Freeze "Freeze"  width:56 height:15
	)
		
	Group "Display Properties:"
	(
	spinner spn_Visibility "Visibility: " width:90 height:16 range:[0,1,1] type:#float across:2
	button btn_DpbyLayer "By Layer" width:57 height:21
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
	checkbutton btn_Shaded "Shaded"  pos:[160,689]  width:57 height:21
	spinner spn_mapchannel "Map Channel:"  width:106 height:16 range:[1,99,1] type:#integer
	)
	
	Group "Rendering Control:"
	(
	button btn_RPbyLayer "By Layer" pos:[140,755] width:57 height:21 
	checkbox chk_renderable "Renderable" width:79 height:15 across:1
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
	spinner spn_gbuffer "Object ID" width:92 height:16 range:[0,1000,1] type:#integer across:1
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
			for o in SubRollout4.controls do o.enabled = true
				
			if selection.count == 1 then
			(
				edt_name.text = selection[1].name
				edt_name.readonly = false
				if selection[1].material != undefined then edt_matname.text = selection[1].material.name
					else edt_matname.text = "None"
				
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
			for o in SubRollout4.controls do o.enabled = false
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
	
	
	on SubRollout4 open do
	(
		UpdateSel()
		
		callbacks.addScript #selectionSetChanged "SubRollout4.UpdateSel()" id:#DW_ObjProps
		callbacks.addScript #nodeLayerChanged "SubRollout4.UpdateSel()" id:#DW_ObjProps
		callbacks.addScript #nodePostMaterial "SubRollout4.UpdateSel()" id:#DW_ObjProps
		callbacks.addScript #sceneUndo "SubRollout4.UpdateSel()" id:#DW_ObjProps
		registerTimeCallback SubRollout4.UpdateSel
	)
	on SubRollout4 close do
	(
		callbacks.removescripts #selectionsetchanged id:#DW_ObjProps
		callbacks.removescripts #nodeLayerChanged id:#DW_ObjProps
		callbacks.removescripts #nodePostMaterial id:#DW_ObjProps
		callbacks.removescripts #sceneUndo id:#DW_ObjProps
		unRegisterTimeCallback SubRollout4.UpdateSel
	

	)
	on edt_name changed text do undo "Object Properties - Change Name" on selection[1].name = text
	on clp_Wirecolor changed col do updateobj "wirecolor" col
	
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

)

---------------------------------------------------------------------------------------------------------------- // Modelling Panel 
-- Export Panel Controls 

rollout UE4Tools "Export Panel"

-------------------------------------------------------------------------------------------------------------------------------------	

(
		
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
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\_Scripts\Unreal_Scripts\VertexAnimationTools.ms"
	)
	
	On ue_mesh_mor pressed do
	(
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\_Scripts\Unreal_Scripts\StaticMeshMorpher.ms"
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
		
)

-------------------------------------------------------------------------------------------------------------------------------------	

---------------------------------------------------------------------------------------------------------------- // CreateU

--newwind = newRolloutFloater "Alberto's Toolset" 250 900 
createdialog myRoll  width:250 menu: myMenu style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox) pos:toolSetClosePos

cui.registerDialogBar myRoll
cui.dockDialogBar myRoll #cui_dock_right