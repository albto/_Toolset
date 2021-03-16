
---------------------------------------------------------------------------------------------------------------- // Tool Settings
--Tool Settings 
	
try destroydialog myRoll catch()
----------------------------------------------------------------------------------------------------------------
rcMenu myMenu 
(	
	submenu "                       " 
	(
	)
	submenu "Tool Settings"
	(
		menuItem myItem4 "Close Tool" 
	separator sp1
		submenu "Dock Tool"
		(
		menuItem myItem1 "Dock Right"
	separator sp4
		menuItem myItem2 "Dock Left"
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
    -- Allows the Tool to Dock Left	
    on myItem2 picked do
    (
		cui.registerDialogBar myRoll
        cui.dockDialogBar myRoll #cui_dock_left
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

rollout myRoll "Alberto Makes a Tool - v1.0"
----------------------------------------------------------------------------------------------------------------
(

	--ROLLOUT CONTROLS
	subRollout scriptBin width:(myRoll.width as float -10) height:880 pos:[5,5]

   --Adds Sub-Rollouts
	on myRoll open do
    (
		addsubRollout scriptBin myRoll 
		addSubRollout scriptBin subRollout1 rolledup: false
		addSubRollout scriptBin subRollout3 rolledup: false
		addSubRollout scriptBin subRollout5 rolledup: false
		addSubRollout scriptBin subRollout2 rolledup: true
		addSubRollout scriptBin subRollout4 rolledup: true
		addSubRollout scriptBin renamer rolledup: true
    )
)	


---------------------------------------------------------------------------------------------------------------- // Create Panel 
-- Create Panel Controls 

rollout subRollout1 "Create Panel" 
----------------------------------------------------------------------------------------------------------------
(

---------------------------------------------------------------------------------------------------------------// Banner 	
	local b = openBitMap(@"C:\Users\Alberto\Desktop\UI.bmp")
	imgTag imgLogo "logo" tooltip:"logo" style:#bmp_center bitmap:b align:#top width: 219 height:100 pos:[5,0]

	
---------------------------------------------------------------------------------------------------------------// Selection
	
	group "Current Selection:" 
	(
		
	label lbl_01 "No - Items Selected"  
		
	)

---------------------------------------------------------------------------------------------------------------// Current Selection Function
	
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
			
	on subRollout1 open do callbacks.addScript #selectionSetChanged "subRollout1.zwroc $" id:#cb1 
	on subRollout1 close do callbacks.removescripts #selectionSetChanged id:#cb1
		
----------------------------------------------------------------------------------------------------------------
--Primitives Group Controls
		
	group "Create Objects:" 
	(
	button myBttn5 "Box" width:100 align:#align_topcleft across:2 
	button myBttn6 "Cylinder" width:100 align:#align_topleft  
	button myBttn7 "Sphere" width:100 align:#align_topleft across:2 
	button myBttn8 "Tube"  width:100 align:#align_topleft  
	button myBttn9 "Plane"  width:100 align:#align_topleft across:2 
	button myBttn10 "Spline"  width:99 align:#align_topleft  
	)

	
	--Button Function - Create Box 
	
	on myBttn5 pressed do
	(
		try destroyDialog menuBox catch()
		createDialog menuBox pos: [1000, 550]
		mybox = box length:20 width:20 height:20 isSelected: On 
		mybox.mapcoords = on
		
	)

	--Button Function - Create Cylinder 
	
	on myBttn6 pressed do
	(
		mycyl = cylinder length:20 width:20 height:20 isSelected: On
		mycyl.mapcoords = on
		mycy
	)
		
	--Button Function - Create Sphere
	
	on myBttn7 pressed do
	(
		mysphere = sphere length:20 width:20 height:20
		mysphere.mapcoords = on
		mysphere
	)
		
	--Button Function - Create Sphere
	
	on myBttn8 pressed do
	(
		mytube = tube length:20 width:20 height:20
		mytube.mapcoords = on
		mytube
	)
		
	--Button Function - Create Plane
	
	on myBttn9 pressed do
	(
		myplane = plane length:20 width:20 height:20
		myplane.mapcoords = on
		myplane
	)
		
	--Button Function - Create Spline
	
	on myBttn10 pressed do
	(
		startObjectCreation line		
	)
)			
		

----------------------------------------------------------------------------------------------------------------

Rollout menuBox "Box Parameters"  
(

	Group "Object Birth Name: "
	(
	edittext BName "Name" type:#string 
	)
	
	Group "Set Material:"
	(
		label smtl_lbl "Set selection's material:"
		materialbutton choosemtl "Pick Material"
		on choosemtl picked mtl do
		(
			if $ != undefined do $.material=mtl
		)
	)
	
	Group "Scale: "
	(
	Spinner BLength "Length" type:#float range: [0,1000,20] 
	Spinner BWidth "Width" type:#float range: [0,1000,20]
	Spinner BHeight "Height" type:#float range: [0,1000,20]
	)
	
	Group "Segments: "
	(
	Spinner BLengthSegs "Length Segs:" type:#integer range: [0,1000,0] 
	Spinner BWidthSegs "Width Segs:" type:#integer range: [0,1000,0]
	Spinner BHeightSegs "Height Segs:" type:#integer range: [0,1000,0]
	)
	
	Group "Rotation: "
	(
	Spinner BX_Rotation "X Rotation:" type:#float range: [-1000,1000,0]
	Spinner BY_Rotation "Y Rotation" type:#float range: [-1000,1000,0]
	Spinner BZ_Rotation "Z Rotation" type:#float range: [-1000,1000,0]
	)
	
	-- Action 
	On BName changed val do 
	(
		$.name  = val
	)
	
----------------------------------------------------------------------------------------------------------------	
	
	On BLength changed val do 
	(
		$.Length = val
	)
	
	On BWidth changed val do 
	(
		$.Width = val
	)
	
	On BHeight changed val do 
	(
		$.Height = val
	)

----------------------------------------------------------------------------------------------------------------
	
	On BLengthSegs changed val do 
	(
		$.LengthSegs = val
	)
	
	On BWidthSegs changed val do 
	(
		$.WidthSegs = val
	)
	
	On BHeightSegs changed val do 
	(
		$.HeightSegs  = val
	)

----------------------------------------------------------------------------------------------------------------
	
	On BX_Rotation changed val do 
	(
		$.rotation.x_rotation = val
	)

	On BY_Rotation changed val do 
	(
		$.rotation.y_rotation = val
	)
	
	On BZ_Rotation changed val do 
	(
		$.rotation.z_rotation = val
	)
)

----------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------- // Transform Panel 
-- Transform Panel Controls 

rollout subRollout2 "Transform Panel"
----------------------------------------------------------------------------------------------------------------
( 
	group "Position:"
	(
	spinner xSpin "X Position    " type:#float range:[-300, 300, 0] align:#align_topleft offset:[0,0] 
	spinner ySpin "Y Position    " type:#float range:[-300, 300, 0] align:#align_topleft offset:[0,0] 
	spinner zSpin "Z Position    " type:#float range:[-300, 300, 0] align:#align_topleft offset:[0,0] 
	)
		
	on xSpin changed newV do ($.pos = [xSpin.value,ySpin.value,zSpin.value])
	on ySpin changed newV do ($.pos = [xSpin.value,ySpin.value,zSpin.value])
	on zSpin changed newV do ($.pos = [xSpin.value,ySpin.value,zSpin.value])
		
		
)
---------------------------------------------------------------------------------------------------------------- // Modelling Panel 
-- Modelling Panel Controls 

rollout subRollout3 "Modelling Panel"
----------------------------------------------------------------------------------------------------------------	
(
	
	---------------------------------------------------------------------------Modelling Tools Group Controls 
	
	Group "Object Display:"
	(
	button wireview "Wireframe"  width:100 across: 2 
	button edgeview "Edge Face" width:100
	)

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
	
	Group "Modifier List:"
	(
		button bttnModPan "Launch Panel" width: 200 height: 40
	)
	
	-------------------------------------------------------------------------------------------------
	
	on bttnModPan pressed do
	(
		try destroyDialog menuModPan catch()
		createDialog menuModPan pos: [1650,200]
	)
	
	
	
	-----------------------------------------------------------------------------------------------------------
	
	group "Sub Tools:"
	(
	button myBttn1 "Welder" width: 100 align:#align_topleft	across:2  
	button myBttn2 "Bend of Bros" width: 100 align:#align_topleft 
	button myBttn4 "Wire Mesh"  width: 100 align:#align_topleft across:2 
	button myBttn12 "Weave Mesh" width: 99 align:#align_topleft

	)
	
	---------------------------------------------------------------------------Utilities Group	Controls
	group "Utilities:"	
	(
	button myBttn3 "Rename" width: 99  across:2 
	button myBttn11 "Export to Engine" width: 99  tooltip: "Records current position, resets tranforms, sets pivot to object's  and exports object at world origin."
	button myBttn13 "Pivot to Base" width: 99  across:2
		button myBttn14 "Object to World" width: 99
	)
	
	---------------------------------------------------------------------------Button Function - Welder
	on myBttn1 pressed do
	(
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\Welder2\Welder.mse"
	)
	
	---------------------------------------------------------------------------Button Function - Bend of Brothers
	on myBttn2 pressed do
	(
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\BendOfBrothers-AlexanderDelagrange\BendOfBrothers.mse"
	)
	--Button Function - Tools
	on myBttn3 pressed do
	(
		macros.run "Tools" "RenameObjects"
	)
	
	---------------------------------------------------------------------------Button Function - Wire Mesh
	on myBttn4 pressed do
	(
		fileIn "C:\Users\Alberto\Dropbox\[main access]\3ds_Scripts\Wire_Mesh_Generator\WireMeshGenerator_v1.04.mse" 
	)
	
	---------------------------------------------------------------------------Button Function - Export to Engine
	on myBttn11 pressed do
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
	
	---------------------------------------------------------------------------Button Function - MISSSING SCRIPT	
	on myBttn13 pressed do
	(
		selection[1]
		$.pivot = [$.center.x,$.center.y,$.min.z]
	)	
	
	on myBttn14 pressed do
	(
		selection[1]
		$.pos = [0,0,0]
	)	

)
---------------------------------------------------------------------------------------------------------------- // Modelling Panel 
-- Grid Panel Controls 

Rollout subRollout5 "Grid Panel"
(
	---------------------------------------------------------------------------Grid Options
	group "Options:" 
	(
	Spinner set_spacing "Set Spacing:         " type:#integer range: [0,100,0]  width:100 across: 1 height: 20
	label lbl_02 "Preset Spacing:" across: 2
	dropdownlist scale_dd "" items:#("   10 cm", "   8 cm", "   4 cm", "   2 cm","   1 cm", "   1/2 cm", "   1/4 cm", "   1/8 cm") width: 90
	)
		
	---------------------------------------------------------------------------Grid Spacing Controls
	on scale_dd selected i do
	(
		if scale_dd.selection == 1 then setGridSpacing 10.0
		if scale_dd.selection == 2 then setGridSpacing 8.0
		if scale_dd.selection == 3 then setGridSpacing 4.0
		if scale_dd.selection == 4 then setGridSpacing 2.0
		if scale_dd.selection == 5 then setGridSpacing 1.0			
		if scale_dd.selection == 6 then setGridSpacing .5
		if scale_dd.selection == 7 then setGridSpacing .25
		if scale_dd.selection == 8 then setGridSpacing .125
	)
	
	on set_spacing changed spa do
	(
		spa = set_spacing.value
		setGridSpacing spa
	)
)

	--------------------------------------------------------------------------------------------	



---------------------------------------------------------------------------------------------------------------- // Modifier Panel 
-- Modifier Panel Controls 

Rollout menuModPan "Modifier List"
(
	group "Modifiers: "
	(
		button Ed_Poly "Edit Poly" width: 100 height: 30
		button Ed_Norm "Edit Normals" width: 100 height: 30
		button UV_Edit "Unwrap UVW" width: 100 height: 30
	)
	
	on Ed_Poly pressed do 
	(
		macros.run "Modifiers" "EditPolyMod"
	)
	
	on Ed_Norm pressed do 
	(
		macros.run "Modifiers" "EditNormals"
		$.modifiers[#Edit_Normals].displayLength = 4
	)
	
	on UV_Edit pressed do 
	(
		macros.run "Modifiers" "Unwrap_UVW"
	)
	
)





---------------------------------------------------------------------------------------------------------------- // Properties Panel 
-- Properties Panel Controls 


rollout subRollout4 "Properties Panel"
----------------------------------------------------------------------------------------------------------------
(
	button theButton "Press To Render!" width:200 height:100
	on theButton pressed do
	(
		theBmp = render outputsize:[200,100] vfb:off
		theButton.images = #(theBmp, undefined, 1,1,1,1,1 )
	)
	group "Display Properties:" 
	( 
	checkbox hde "Hide" 
	checkbox frz "Freeze" 
	checkbox disbox "Display as Box" 
	checkbox edgonly "Edges Only" 
	checkbox vertix "Vertex Ticks" 
	checkbox trajec "Trajectory" 
	checkbox sthrough "See-Through" 
	checkbox igtense "Ignore Extense" 
	checkbox sfreeze "Show Frozen in Gray"

		
	button selname "Select By Name" pos: [10,320] 
	) 
	
	
	on selname pressed do 
	(
		hitByNameDlg()
	)
	
	
	
)
---------------------------------------------------------------------------------------------------------------- // Properties Panel 
-- Properties Panel Controls 

rollout renamer "Rename Panel"
----------------------------------------------------------------------------------------------------------------	
(
	group  "Selected Objects:" 
	(
	label lbl_rename "Rename" pos:[18, 30]
	dropdownlist ddl_rename ""  width: 60 items:#("Object", "Material") pos:[75, 25]
	button btn_name "Name"  pos:[15, 55] align:#align_left tooltip:"Clear name field" across: 2
	Edittext edt_name fieldwidth:140 pos:[70, 56]
	Spinner spn_numstart "Start" range:[0,10000,1] type:#integer pos:[20, 85]  fieldwidth:30 tooltip:"Start from"
	Spinner spn_digit "Suffix" range:[30,10,3] type:#integer pos:[140, 85]  fieldwidth:30  tooltip:"Suffix Length"
	button btn_rename "Rename" width:195 tooltip:"Rename selected Object"
	)
	group "Suffix:"
	(
	button btn_ObjName "$ - Object" width:75 tooltip:"Insert Current Object name" across: 2
	button btn_MatName "@ - Material" width:75 tooltip:"Insert Current Material name"
	button btn_Number "# - Number" width:75 tooltip:"Insert Number to Name"
	)
	
	group  "Find and Replace:"
	(
	button btn_find "Find" width:50 border:off tooltip:"Clear find text field"
	Edittext edt_find fieldwidth:140 
	button btn_findobj "Find" width:195 tooltip:"Execute Find and Replace on Selection"
	button btn_with "Replace" width:50 border:off tooltip:"Clear replace text field"
	Edittext edt_with fieldwidth:140
	button btn_replace "Replace" width:195 tooltip:"Execute Find and Replace on Selection"
	)
	
	group "Remove Character:"
	(
	button btn_rmStart "Remove From Begining" width:120 tooltip:"Remove characters from begining"
	spinner spn_start "" range:[0,1000,0] type:#integer fieldwidth:40 tooltip:"Start Character"
	button btn_rmEnd "Remove From End" width:120 tooltip:"Remove characters from End"
	spinner spn_end "" range:[0,1000,0] type:#integer fieldwidth:40 tooltip:"End Character"
	)

	
	local RnDest
	local oname
	

	function fn_checkstate =
	(
		if findString edt_name.text "#" != undefined then 
		(
			spn_numstart.enabled = true
			spn_digit.enabled = true
		)
		else 
		(
			spn_numstart.enabled = false
			spn_digit.enabled = false
		)
		if edt_find.text != "" then btn_replace.enabled = true else btn_replace.enabled = false
	)
	on renamer open do
	(
		fn_checkstate()
	)
	on renamer moved pos do
	(
		if renamer_help.isdisplayed do
		(
			renamerpos = GetDialogPos renamer
			setdialogpos renamer_help [renamerpos.x+renamer.width+10,renamerpos.y+30]
		)
	)
	on btn_name pressed do edt_name.text = ""	
	on btn_with pressed do edt_with.text = ""
	on edt_name changed txt do fn_checkstate	()
	on btn_rename pressed do
	(
		if edt_name.text != "" do
		(
			undo "Rename" on
			(
				onum = spn_numstart.value
				digit = (10^(spn_digit.value-1)) as string
				obj = selection as array
				for i=1 to obj.count do 
				(
					oname= edt_name.text
					for j=1 to oname.count do
					(
						findtext = "#"
						if spn_digit.value > 1 do 
						(	
							n = (i+spn_numstart.value-1)
							if i < 10 do n = ("0" + n as string)
							if i >= 10 do n = n as string
							
							replacetext = ((substring (digit as string) 2 (digit.count-2))+ n)
							if replacetext.count > digit.count do replacetext = substring replacetext (replacetext.count-(digit.count-1)) (replacetext.count)
						)
						num = findString oname findtext
						if num != undefined do oname = replace oname num findtext.count replacetext
						
						findtext = "$"
						num = findString oname findtext
						if num != undefined do oname = replace oname num findtext.count obj[i].name
						
						findtext = "@"
						num = findString oname findtext
						if num != undefined  and obj[i].material != undefined  then oname = replace oname num findtext.count obj[i].material.name
						else if num != undefined do oname = replace oname num findtext.count "No Material"
					)
					if ddl_rename.selection == 1 do obj[i].name = oname
					if ddl_rename.selection == 2 and obj[i].material != undefined do obj[i].material.name = oname
				)
			)
		)
	)
	on edt_find changed txt do fn_checkstate	()
	on btn_replace pressed do
	(
		if edt_find.text != "" do
		(
			undo "Rename" on
			(
				obj = selection as array
				for i=1 to obj.count do 
				(
					findtext = edt_find.text
					if ddl_rename.selection == 1 do
					(
						num = findString obj[i].name findtext
						if num != undefined do obj[i].name = replace obj[i].name num findtext.count edt_with.text
					)
					if ddl_rename.selection == 2 and obj[i].material != undefined do
					(
						num = findString obj[i].material.name findtext
						if num != undefined do obj[i].material.name = replace obj[i].material.name num findtext.count edt_with.text
					)
				)
			)
		)
	)
	on btn_rmStart pressed do
	(
		undo "Rename" on
		(
			obj = selection as array
			for i=1 to obj.count do 
			(
				if ddl_rename.selection == 1 do obj[i].name = substring obj[i].name (spn_start.value+1) (obj[i].name.count)
				if ddl_rename.selection == 2 and obj[i].material != undefined do obj[i].material.name = substring  obj[i].material.name (spn_start.value+1) (obj[i].material.name.count)
			)
		)
	)
	on btn_rmEnd Pressed do
	(
		undo "Rename" on
		(
			obj = selection as array
			for i=1 to obj.count do 
			(
				if ddl_rename.selection == 1 do obj[i].name = substring obj[i].name (1) (obj[i].name.count-spn_end.value)
				if ddl_rename.selection == 2 and obj[i].material != undefined do obj[i].material.name = substring obj[i].material.name (1) (obj[i].material.name.count-spn_end.value)
			)
		)
	)
)
---------------------------------------------------------------------------------------------------------------- // CreateUI
createdialog myRoll  width:250 height:900  pos:[60,90] menu: myMenu 






