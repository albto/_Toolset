	--	make modifiers unique
-- 	for o in selection as Array do
-- 	(
-- 		for m in o.modifiers do
-- 		(
-- 			if (InstanceMgr.CanMakeModifiersUnique o m) then
-- 			(
-- 				InstanceMgr.MakeModifiersUnique o m #individual
-- 			)
-- 			else
-- 				print "Can't make unique"
-- 		)
-- 	)
	
-- 	--reset normals 
-- 	
-- 	modf = Edit_Normals () 
-- 	modf.displayLength = 1
-- 	
-- 	for i in selection as array do 
-- 	(
-- 		modPanel.addModToSelection (modf) ui:on	
-- 		subObjectLevel = 0
-- 	)
-- 	
-- 	


-- 	matID = 1
-- 	objWithMatID = #() 
-- 	poGetMatID = polyop.getFaceMatID 	
-- 	for obj in geometry where (classof obj) == Editable_Poly do 
-- 	( 
-- 		allFaces = polyop.getNumFaces obj 
-- 		notFound = true 
-- 		for i = 1 to allFaces while notFound where (matID == (poGetMatID obj i) ) do 
-- 		( 
-- 			append objWithMatID obj 
-- 			notFound = false 
-- 		) 
-- 	) 
-- 	if objWithMatID.count != 0 do select objWithMatID 


-- 	rollout SetMatIDByUvSel "SetMatIDByUvSel" 
-- 	(
-- 		spinner spnID "MaterialID: " range:[1,100,1] type:#integer
-- 		button btnSetID "Set ID" width:100
-- 		on btnSetID pressed do
-- 		(
-- 			for i in selection do 
-- 			(
-- 				if (classOf selection[1]) == Unwrap_UVW then
-- 				(				
-- 					selectedFaces = i.modifiers["Unwrap_UVW"].getSelectedFaces()
-- 					polyop.setFaceMatID i.baseobject selectedFaces (spnID.value as integer)
-- 						
-- 				)
-- 				else if (classOf selection[1]) == Editable_Poly then
-- 				(
-- 					selectedFaces = getFaceSelection i
-- 					polyop.setFaceMatID i.baseobject selectedFaces (spnID.value as integer)
-- 						
-- 				)
-- 			)
-- 		)
-- 	)
-- 	createDialog SetMatIDByUvSel 120 50
-- 	
	
	
--******************************************************************************************************
-- Created: 		08-09-2011
-- Last Updated:	08-09-2011
-- Version:			1.0
--
-- Author :  Kostadin Kotev / miau_u@yahoo.com /
-- Version:  3ds max 2009 (10) (should work in older versions too!)
--
-- Discription: This script will check for UVs outside of the 0-1 space. Requested in this thread: http://www.polycount.com/forum/showthread.php?t=88562
-- Usage: RUN IT
--******************************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

-- macroscript CheckUVpos
-- category:"miauu"
-- tooltip:"Check UV position"
-- buttonText:"Check UV position"
-- (
-- 	if getCommandPanelTaskMode() != #modify do setCommandPanelTaskMode #modify
-- 	objSel = selection as array
-- 	if objSel.count != 0 then
-- 	(
-- 		for o in objSel do
-- 		(
-- 			select o
-- 			AddModifier o (Unwrap_UVW ())		   
-- 			local faces = #{1..(meshOp.getNumFaces o.mesh)}
-- 			o.modifiers["Unwrap_UVW"].getArea faces &uvX &uvY &uvWidth &uvHeight &uvFaceArea &objGeomArea
-- 			if uvWidth > 1 or uvHeight >1 do format "Object % is out of the 0-1 UV Range!\n" o.name
-- 			DeleteModifier o 1
-- 		)
-- 	)
-- 	else
-- 		messagebox "Select some objects" title:"miauu Script Error!!!"
-- )
-- 	addModifier $ uvMod
	 -- pack( method, spacing, normalize, rotate, fillHoles )	
	
	
	
-- 	uvMod.setMapChannel 2

-- 	uvMod.pack 1 0.02 true false false

-- 	for i in selection do 
-- 	(
-- 		--uvMod.selectFacesByNode #{1..i.numFaces} i
-- 		AllFaces = #{1..i.numFaces}
-- 	)
		
		
-- 		modPanel.addModToSelection (Unwrap_UVW() )
		
		uvMod = $.modifiers[#Unwrap_UVW]
			
			
		
-- 		uvMod.unwrap4.flattenMapByMatID  45.0 0.002 false 0 false true 
		
			
			
-- 		--collapse to code
-- 		for obj in selection do
-- 		(
-- 			for i in obj.modifiers.count to 1 by -1 where
-- 				obj.modifiers[i] == uvMod do
-- 				(
-- 					maxops.CollapseNodeTo obj i off
-- 					exit
-- 				)
-- 		)


-- 		uvMod.unwrap.edit();
-- 		uvMod.unwrap2.setTVSubObjectMode(3);
-- 			
		b = selection[1]
		bb = (b.max - b.min) -- collect BBox to variable
		-- simple format [x,y,z]:
		format "x: %;y: %;z: %\n" bb[1] bb[2] bb[3]
		 
		modPanel.setCurrentObject uvMod
		subObjectLevel = 3
		FaceArr = for f=1 to uvMod.numberPolygons() collect f 
		FaceElements = #()
			
-- 			
-- 		while FaceArr.count > 0 do 
-- 		(
-- 			uvMod.selectFaces #{FaceArr[1]}
-- 			uvMod.selectElement()
-- 			currElement = (uvMod.getSelectedFaces()) as array
-- 			append FaceElements currElement 
-- 				
-- 			for faceId in currElement do deleteItem FaceArr (findItem FaceArr faceId) 
-- 				
-- 		)	
-- 		
		if not FaceArr.isEmpty do
		(
			while not FaceArr.isEmpty do
			(
				uv.selectFaces #{(FaceArr as array)[1]}
				uv.SelectElement()
				elem01faces = uv.getSelectedFaces()
				append uvIslands elem01faces
				allFaces = allFaces-elem01faces
			)
		)
		
		for i = 1 to uvIslands.count do 
		(			
			uvMod.selectFaces #{uvIslands[i]}
-- 	 		uvMod.faceToVertSelect()
-- 	 		subObjectLevel = 1
-- 			uvMod.snapPivot	1
			
			if bb[3] > bb[1] and bb[2] > bb[1] then
			(
				print("walls")
				uvMod.moveSelected ([bb[2]/2,bb[3]/2,0] - uvMod.getSelCenter())
			)				
			else 
			(
				print("floor")
				uvMod.moveSelected ([bb[1]/2,bb[1]/2,0] - uvMod.getSelCenter())
			)
				
		)		
		
		
		
		
		uvMod.Edit()
		
-- 	fn getUnwrapElements myMod =
-- 	(
-- 		if classof myMod == Unwrap_UVW then
-- 		(
-- 			modPanel.setCurrentObject myMod
-- 			subobjectLevel = 3
-- 			facesAr = for f=1 to myMod.numberPolygons() collect f
-- 			myElements = #()
-- 			 
-- 			while facesAr.count > 0 do
-- 			(
-- 				myMod.selectFaces #{facesAr[1]}
-- 				myMod.selectElement()
-- 				myElement = (myMod.getSelectedFaces()) as array
-- 				append myElements myElement
-- 				for faceId in myElement do deleteItem facesAr (findItem facesAr faceId)
-- 			)
-- 			myElements
-- 		)
-- 	)
-- 	getUnwrapElements $.modifiers[1]
-- 		
	
	
	--uvMod.unwrap6.GroupGetTexelDensity()
		
	
	--uvMod.pack 1 0.01 false false false
	
	
	
	
	--AllFaces = uvMod.getSelectedFaces()
	
	--for o in AllFaces do
	(
-- 		for f = 1 to AllFaces.count do 
-- 		(
-- 			uvMod.selectFaces AllFaces[f] 
-- 			uvMod.pack 1 0.02 true false false
-- 			
-- 		)
		
	)
-- 	
-- 	uvMod.GroupCreate "Uv TD Cluster"
-- 	
-- 	uvMod.unwrap6.GroupSetTexelDensity 10.24	
	--uvMod.unwrap6.GroupGetTexelDensity()
-- 	
-- 			uvMod.getSelectedFaces() 
-- 			uvMod.unwrap6.RescaleCluster <bitArray>facesel <node>node
-- 			
-- 			.selectFaces <bitArray>selection 
-- 			
-- 			uvMod.unwrap6.flattenMapNoParams() 
-- 			uvMod.unwrap6.packNoParams() 
	
-- 	--Move Selected UVs to [0,0,0]
-- 	uvIslands = #()
-- 	uv = modpanel.getcurrentobject()
-- 	if classof (uv) == Unwrap_UVW then
-- 	(
-- 		uvIslands = #()
-- 		subObjLevel = uv.getTVsubobjectMode()
-- 		case subObjLevel of
-- 		(
-- 			1: 
-- 			(
-- 				allVerts = uv.getSelectedVertices()
-- 				if not allVerts.isEmpty do
-- 				(
-- 					while not allVerts.isEmpty do
-- 					(				
-- 						uv.selectVertices #{(allVerts as array)[1]}
-- 						uv.SelectElement()
-- 						elem01verts = uv.getSelectedVertices()
-- 						append uvIslands elem01verts
-- 						allVerts = allVerts-elem01verts
-- 					)
-- 				)
-- 			)
-- 			2:
-- 			(
-- 				allEdges = uv.getSelectedEdges()
-- 				if not allEdges.isEmpty do
-- 				(
-- 					while not allEdges.isEmpty do
-- 					(
-- 						uv.selectEdges #{(allEdges as array)[1]}
-- 						uv.SelectElement()
-- 						elem01verts = uv.getSelectedEdges()
-- 						append uvIslands elem01verts
-- 						allEdges = allEdges-elem01verts
-- 					)
-- 				)
-- 			)
-- 			3:
-- 			(
-- 				allFaces = uv.getSelectedFaces()
-- 				if not allFaces.isEmpty do
-- 				(
-- 					while not allFaces.isEmpty do
-- 					(
-- 						uv.selectFaces #{(allFaces as array)[1]}
-- 						uv.SelectElement()
-- 						elem01faces = uv.getSelectedFaces()
-- 						append uvIslands elem01faces
-- 						allFaces = allFaces-elem01faces
-- 					)
-- 				)
-- 			)
-- 		)	
-- 		if uvIslands.count != 0 do with undo "UVs to [0,0,0]" on
-- 		(
-- 			case subObjLevel of 
-- 			(
-- 				1: 
-- 				(
-- 					for i=1 to uvIslands.count do
-- 					(
-- 						uv.selectVertices uvIslands[i]
-- 						uv.moveSelected ([0,0,0] - uv.getSelCenter())
-- 					)
-- 				)
-- 				2: 
-- 				(
-- 					for i=1 to uvIslands.count do
-- 					(
-- 						uv.selectEdges uvIslands[i]
-- 						uv.moveSelected ([0,0,0] - uv.getSelCenter())
-- 					)
-- 				)
-- 				3: 
-- 				(
-- 					for i=1 to uvIslands.count do
-- 					(
-- 						uv.selectFaces uvIslands[i]
-- 						uv.moveSelected ([0,0,0] - uv.getSelCenter())
-- 					)
-- 				)
-- 			)
-- 		)

-- 	)
-- 	else
-- 	(
-- 		messagebox "Open the \"Edit UVWs\" window!" title:"miauu Script Error!!!"
-- 		chkbtn_holdSelection.state = false
-- 	)
-- 	
-- 	
	
	
	
	
	
	
	
	
	
	
	
	