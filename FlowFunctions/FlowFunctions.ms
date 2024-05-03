-- ////////////////////////////////////////////////////////////////////////////////

-- GLOBAL -- STRINGS

-- ////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------

	global  FlowPanels 	 	= "FlowFunctions"
	
	global  CombineObj 	 	= "ObjectCombine"
	global  VertWeld 	 	= "WeldAllVerts"
	global  ResetObj 	 	= "ResetObject"
	global  CopyObj 	 	= "QuickCopy"
	global  ResTransform 	= "ResetObjTransforms"
	global  ObjDetach 	 	= "ObjDetach"
	global  QuickUV 	 	= "QuickUV"
	global  RescaleUVs 	 	= "RescaleUVs"
	global  Cull 		 	= "Cull"
	global  PolyOs		 	= "PolyOperationsFF"
	global	DeleteLoop	 	= "DeleteLoop"	
	global	DeleteMod	 	= "DeleteMod"
	global	DubSmooth	 	= "DubSmooth"
	global 	PivtoVerts	 	= "Pivot_to_Vert_Selection"	
	global 	RandElementClr	= "AssignRandomElementColor"
	global 	UvShllGrps 	 	= "UVIslandsToSmoothing"
		
	global 	GetChildren	 	= "SelectChildren"
		
	global  cull_tog 	 	= true
	
------------------------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////////////////

-- FUNCTIONS -- LIBRARY -- modeling 

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
macroScript ObjectCombine
category:"FlowFunctions"
toolTip:"Combine Poly Mesh"
(
	Undo on
	if classof selection != Editable_Poly and selection.count >= 2 then 
	(
		converttopoly selection
	)
	else 
		return false
	
	for i = 1 to selection.count do
	(
		selcount = selection.count
		for i = selcount to 2 by -2 do
		(
-- 			if (classof selection[i] != Editable_Poly or classof selection[i] != Edit_Poly)then 
-- 			(
-- 				continue
-- 			)
-- 			else
				polyop.attach selection[i] selection[i-1]
		)
		update selection[1]	
	)
	
)
------------------------------------------------------------------------------------
macroScript WeldAllVerts
category:"FlowFunctions"
toolTip:"Weld All Verts"
(
	undo on
		
	for i in selection do 
	(
		mdf = modpanel.getcurrentobject()
		if (classof mdf) == Editable_Poly then
		(
			subobjectLevel = 1
			actionMan.executeAction 0 "40021"  -- Selection: Select All
			i.weldThreshold = 0.046
			i.EditablePoly.weldFlaggedVertices ()
			subobjectLevel = 0
		)
		if (classof mdf) == Edit_Poly then
		(
			macros.run "Modifier Stack" "SubObject_1"
			actionMan.executeAction 0 "40021"  -- Selection: Select All
			i.modifiers[#Edit_Poly].SetOperation #WeldVertex
			i.modifiers[#Edit_Poly].weldVertexThreshold = 0.06
			i.modifiers[#Edit_Poly].Commit ()
			subobjectLevel = 0	
		)
	)
)
------------------------------------------------------------------------------------
macroScript ResetObject
category:"FlowFunctions"
toolTip:"reset selected objects"
(
	undo on
	for i in selection as array do 
	(
		i.rotation = eulerangles 0 0 0
		i.pivot = [$.center.x,$.center.y,$.min.z]
		i.pos = [0,0,0]
		i.scale = [1,1,1]
	)
)
------------------------------------------------------------------------------------
macroScript QuickCopy
category:"FlowFunctions"
toolTip:"copy selected objects"
(
	if selection.count > 0 do
	(
		Undo on
		maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
		select nnl
	)
)
------------------------------------------------------------------------------------
macroScript ResetObjTransforms
category:"FlowFunctions"
toolTip:"reset transform for selected objects"
(

	actionMan.executeAction 1584743139 "0"  -- Tools: Reset Transforms Selected
	macros.run "Modifier Stack" "Convert_to_Poly"
	
)
------------------------------------------------------------------------------------
macroScript ObjDetach
category:"FlowFunctions"
toolTip:"Detach Object"
(

	for i in selection do 
	(
		mdf = modpanel.getcurrentobject()
		if (classof mdf) == Edit_Poly then
		(
			i.modifiers[#Edit_Poly] 
			i.modifiers[#Edit_Poly].DetachToObject #DetachFace
			i.modifiers[#Edit_Poly].SetSelection #Face #{}
		)
		if (classof mdf) == Editable_Poly then
		(
			i.EditablePoly.buttonOp #Detach
			i.EditablePoly.SetSelection #Face #{}
			i.EditablePoly.detachToElement #Face keepOriginal:off	
		)
	)

	
)
------------------------------------------------------------------------------------
macroScript RescaleUVs
category:"FlowFunctions"
toolTip:"Rescale UV Clusters"
(
	for i in selection as array do
	(
		macros.run "Modifiers" "Unwrap_UVW"
		macros.run "Modifier Stack" "SubObject_3"
		macros.run "Modifier Stack" "SubObject_3"
		$.modifiers[#unwrap_uvw].unwrap6.selectFacesByNode #{1..10000000}$
		actionMan.executeAction 2077580866 "40207"  -- Unwrap UVW: Rescale Clusters	
		SubObjectLevel = 0
	)
)
------------------------------------------------------------------------------------
macroScript Cull
category:"FlowFunctions"
toolTip:"Culling Polygons"
(	
	cull_tog = Not cull_tog 
--	print cull_tog
	if selection.count > 0 then
	(
		if cull_tog == true then
		(
			$.displaybylayer = off
			$.backfacecull = on
		)
		else
		(
			$.displaybylayer = off
			$.backfacecull = off
		)
	)
)
------------------------------------------------------------------------------------
macroScript DeleteLoop
category:"FlowFunctions"
toolTip:"Delete Edge Loop"
(	
	mdf = modpanel.getcurrentobject()
		
	fn removeEdgeVerts obj =
	(	
		obj.selectedverts = (for i in 1 to obj.numverts where obj.GetVertexEdgeCount i == 2 collect i)
		obj.remove selLevel:#Vertex
	)	
		
	if (classof mdf) == edit_poly then
	(		
		macros.run "PolyTools" "Loop"
		$.modifiers[#Edit_Poly].ButtonOp #RemoveEdgeRemoveVertices
		print ("Loop Deleted")
	)
	else if (classof mdf) == editable_poly then
	(
		macros.run "PolyTools" "Loop"		
		$.EditablePoly.Remove ()
		removeEdgeVerts $
	)
)
------------------------------------------------------------------------------------
macroScript DeleteMod
category:"FlowFunctions"
toolTip:"Delete Selected Modifier"
(	
	
	if selection.count == 1 do
	(
		for i in selection do
		(	
			mdf = modpanel.getcurrentobject()
			
			if (classof mdf) == Plane or (classof mdf) == Box or (classof mdf) == Cylinder then
			(
				return false
			)
			else 
			(
				deleteModifier i mdf
			)
		)
	)
)
------------------------------------------------------------------------------------
macroScript DubSmooth
category:"FlowFunctions"
toolTip:"Double Smooth Modifier Setup"
(	
	rollout SmoothProgress "Smoothing Progress:"
	(
		label SmProg "Smoothing Progress"
		progressbar prog color:red --value:0
		button sm "Start Smoothing"
			
		on sm pressed do
		(
			sel = selection as array
							
			local o = 1
			if sel.count > 0 do 
			(
				for i = o to sel.count  do
				(	
					Undo on
						
					select sel[i]
						
					modPanel.addModToSelection (TurboSmooth ()) ui:on
					$.modifiers[#TurboSmooth].iterations = 2
					$.modifiers[#TurboSmooth].sepBySmGroups = on
					modPanel.addModToSelection (TurboSmooth ()) ui:on
					$.modifiers[#TurboSmooth].iterations = 1
						
					o = o + 1	
						
					if sel.count > 0 then
					(
						prog.value = 100*o/sel.count
						SmProg.text = ("Smoothing Progress: " + prog.value as string + "%")
					)
					
						
				)
			)					
			if prog.value == 100 then
			(
				prog.value = 0
				SmProg.text = "Smoothing Progress: DONE!"
				destroyDialog SmoothProgress
			)
		)
			
	)				
		
	createDialog SmoothProgress

-- 	else
-- 	(
-- 		local o = 1
-- 		
-- 		for i = o to sel.count  do
-- 		(	
-- 			Undo on
-- 				
-- 			select sel[i]
-- 				
-- 			modPanel.addModToSelection (TurboSmooth ()) ui:on
-- 			$.modifiers[#TurboSmooth].iterations = 2
-- 			$.modifiers[#TurboSmooth].sepBySmGroups = on
-- 			modPanel.addModToSelection (TurboSmooth ()) ui:on
-- 			$.modifiers[#TurboSmooth].iterations = 1
-- 				
-- 		)
-- 	)
	
	
	
)
------------------------------------------------------------------------------------
Macroscript Pivot_to_Vert_Selection
category:"FlowFunctions"
toolTip:"Pivot to Vert Selection"
(
	on execute do 
	(
		obj = selection
		mdf = modpanel.getCurrentObject()
			
		if (classof mdf) == Editable_Poly then
		(
			
			fn aveSelVertPos obj =
			(
				verts = obj.selectedVerts
				p = Point3 0 0 0
				for v in verts do
				(
					p += v.pos
				)
				p = p/verts.count
				return p
			)	
				
			o = aveSelVertPos $
				
			vPos = transMatrix o
				
			wp = WorkingPivot
			
			if wp.usemode then
			(
				wp.SetTM vPos
			)
			else
				$.pivot = vPos.translation
		)
		else if (classof mdf) == edit_poly then
		(
			fn aveSelVertPos obj =
			(
				--gather selection array and collects a point3 value
				VertArr = #{}			
				VertArr = selection[1].modifiers[#Edit_Poly].getSelection #Vertex
				p3Arr = for v in VertArr collect selection[1].modifiers[#Edit_Poly].GetVertex v 
					
				--collects the point3 of selected verts 
				p = Point3 0 0 0
				for v in p3Arr do
				(
					p += v
				)
				--sets average vert position
				p = p/p3Arr.count
					
				--commits the action 
				selection[1].modifiers[#Edit_Poly].commit()
					
				return p
				
			)	
				
			o = aveSelVertPos $
				
			vPos = transMatrix o
				
			wp = WorkingPivot
			
			if wp.usemode then
			(
				wp.SetTM vPos
			)
			else
				$.pivot = vPos.translation
		)
		else
			messagebox "Must be an editable poly or edit poly"
			
		select obj
		subobjectLevel = 0
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() 
	)
	
	
)
------------------------------------------------------------------------------------
macroScript selectByAngleFive
category:"FlowFunctions"
toolTip:"Select by Angle: 05"
(
		
	fn selByAngle5 obj = 
	(
			
		for i = 1 to obj.modifiers.count do 
		(
			local mf = obj.modifiers[i]
			if (classof mf ) == Edit_Poly do 
			(
				obj.modifiers[#Edit_Poly].SelectByAngle = on
				obj.modifiers[#Edit_Poly].selectAngle = 5
			)
		)
		
		for i in obj do 
		(
			if (classof obj) == Editable_Poly do
			(
				obj.SelectByAngle = on
				obj.selectAngle = 5
			)
		)
			
	)
		
	on execute do 
	(
		Modpanel.getcurrentObject()
		selByAngle5 $
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() and (subobjectlevel == 4)
	)
		
)
------------------------------------------------------------------------------------
macroScript selectByAngleTen
category:"FlowFunctions"
toolTip:"Select by Angle: 10"
(
		
	fn selByAngle10 obj = 
	(
			
		for i = 1 to obj.modifiers.count do 
		(
			local mf = obj.modifiers[i]
			if (classof mf ) == Edit_Poly do 
			(
				obj.modifiers[#Edit_Poly].SelectByAngle = on
				obj.modifiers[#Edit_Poly].selectAngle = 10
			)
		)
		
		for i in obj do 
		(
			if (classof obj) == Editable_Poly do
			(
				obj.SelectByAngle = on
				obj.selectAngle = 10
			)
		)
			
	)
		
	on execute do 
	(
		Modpanel.getcurrentObject()
		selByAngle10 $
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() and (subobjectlevel == 4)
	)
)
------------------------------------------------------------------------------------
macroScript selectByAngleFifteen
category:"FlowFunctions"
toolTip:"Select by Angle: 15"
(
		
	fn selByAngle15 obj = 
	(
			
		for i = 1 to obj.modifiers.count do 
		(
			local mf = obj.modifiers[i]
			if (classof mf ) == Edit_Poly do 
			(
				obj.modifiers[#Edit_Poly].SelectByAngle = on
				obj.modifiers[#Edit_Poly].selectAngle = 15
			)
		)
		
		for i in obj do 
		(
			if (classof obj) == Editable_Poly do
			(
				obj.SelectByAngle = on
				obj.selectAngle = 15
			)
		)
			
	)
		
	on execute do 
	(
		Modpanel.getcurrentObject()
		selByAngle15 $
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() and (subobjectlevel == 4)
	)		
		
)
------------------------------------------------------------------------------------
macroScript selectByAngleTwentyfive
category:"FlowFunctions"
toolTip:"Select by Angle: 25"
(
		
	fn selByAngle25 obj = 
	(
			
		for i = 1 to obj.modifiers.count do 
		(
			local mf = obj.modifiers[i]
			if (classof mf ) == Edit_Poly do 
			(
				obj.modifiers[#Edit_Poly].SelectByAngle = on
				obj.modifiers[#Edit_Poly].selectAngle = 25
			)
		)
		
		for i in obj do 
		(
			if (classof obj) == Editable_Poly do
			(
				obj.SelectByAngle = on
				obj.selectAngle = 25
			)
		)
			
	)
		
	on execute do 
	(
		Modpanel.getcurrentObject()
		selByAngle25 $
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() and (subobjectlevel == 4)
	)	
		
)
------------------------------------------------------------------------------------
macroScript setAngleSelectfortyfive
category:"FlowFunctions"
toolTip:"Select by Angle: 45"
(
	fn setAngle45 obj = 
	(
		for i = 1 to obj.modifiers.count do
		(
			local mf = obj.modifiers[i]
			if (classof mf) == Edit_poly do 
			(
				obj.modifiers[#Edit_Poly].SelectByAngle = on
				obj.modifiers[#Edit_Poly].selectAngle = 45
			)
			
		)
		
		for i in obj do
		(
			if classof obj == Editable_Poly do 
			(
				obj.SelectByAngle = on
				obj.selectAngle = 45
			)
		)
		
	)
	on execute do 
	(
		Modpanel.getcurrentObject()
		setAngle45 $
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() and (subobjectlevel == 4)
	)	

)

------------------------------------------------------------------------------------
macroScript SetNormals
category:"FlowFunctions"
buttonText:"Set Normals"
tooltip:"Set Normals"
(
	function setNormals =
	(
		if (getCommandPanelTaskMode() != #modify) do
			setCommandPanelTaskMode #modify

		if (Filters.Is_EditPoly()) do
		(
			local theNode = selection[1]
			local theEditObj = modPanel.getCurrentObject()
			local theEditNorm = undefined

			local iModIndex = theNode.modifiers.count

			if ((classOf theEditObj) == Editable_Poly) then
			(
				theEditNorm = theNode.modifiers[theNode.modifiers.count]

				local baFaceSelection = polyOp.getFaceSelection theEditObj
			)
			else if ((classOf theEditObj) == Edit_Poly) then
			(
				iModIndex = (modPanel.getModifierIndex theNode theEditObj) -1
				theEditNorm = theNode.modifiers[iModIndex]
			)

			if (not baFaceSelection.isEmpty) do
			(
				if ((classOf theEditNorm) == UndefinedClass) then
				(
					theEditNorm = Edit_Normals()
					addModifier theNode theEditNorm
				)
				else if ((classOf theEditNorm) != Edit_Normals) then
				(
					theEditNorm = Edit_Normals()
					addModifier theNode theEditNorm before:iModIndex
				)

				if (theEditNorm != undefined) do
				(
					local baVertsFromFace = polyOp.getVertsUsingFace theEditObj baFaceSelection
					local baInnerVert = polyOp.getVertsUsedOnlyByFaces theEditObj baFaceSelection
					local baOuterVert = baVertsFromFace - baInnerVert

					local baFacesFromOuterVert = polyOp.getFacesUsingVert theEditObj baOuterVert
					local baOuterFaces = baFaceSelection * baFacesFromOuterVert

					local ap3FaceNormals = for iFace = 1 to (polyOp.getNumFaces theEditObj) collect
						if (baOuterFaces[iFace]) then (polyOp.getFaceNormal theEditObj iFace) else ( 0.0 )

					local baVertNormals = #{}

					theEditNorm.convertVertexSelection baVertsFromFace baVertNormals node:theNode
					theEditNorm.reset selection:baVertNormals node:theNode

					modPanel.setCurrentObject theEditNorm

					for iVert in baOuterVert do
					(
						local baVertFaces = polyOp.getFacesUsingVert theEditObj iVert
						local p3NewVertNormal = Point3 0.0 0.0 0.0

						for iFace in baVertFaces do
							p3NewVertNormal += ap3FaceNormals[iFace]

						p3NewVertNormal = normalize p3NewVertNormal

					 	theEditNorm.convertVertexSelection #{iVert} baVertNormals node:theNode

						theEditNorm.setNormal ((baVertNormals as Array)[1]) p3NewVertNormal node:theNode
					)

					theEditNorm.convertVertexSelection baOuterVert baVertNormals node:theNode
					theEditNorm.makeExplicit selection:baVertNormals node:theNode

					modPanel.setCurrentObject theEditObj
				)
			)
		)
	)

	on execute do
	(
		setNormals()
	)
)
------------------------------------------------------------------------------------
macroScript RingConnect
category:"FlowFunctions"
toolTip:"Ring Connect"
(
	macros.run "PolyTools" "Ring"
	macros.run "Editable Polygon Object" "EPoly_Connect2"
)
------------------------------------------------------------------------------------
macroScript SelHardEdges
category:"FlowFunctions"
toolTip:"Select Hard Edges"
(
		
	fn selHrdEdg obj = 
	(
			
		for i in obj do 
		(
			if (classof obj) == Editable_Poly then
			(
				subobjectlevel = 2
				i.EditablePoly.selectHardEdges()
			)
			else 
			(
			)
		)
			
	)
			
	on execute do 
	(
		Modpanel.getcurrentObject()
		selHrdEdg $
	)
		
-- 	on isEnabled do 
-- 	(
-- 		Ribbon_Modeling.ValidSOMode() and (subobjectlevel ==2)
-- 	)	
		
)
------------------------------------------------------------------------------------
macroScript QuickUV
category:"FlowFunctions"
toolTip:"QuickUV"
(
-- 	fn runMod =
-- 	(
-- 		macros.run "Modifiers" "Uvwmap" 
-- 	)
-- 	 
		
	fn QuickUVMap obj =
	(
		for i in obj do 
		(
			AddModifier i (Uvwmap ()) ui:on
			i.modifiers[#UVW_Map].maptype = 4
			i.modifiers[#UVW_Map].width = 1
			i.modifiers[#UVW_Map].height = 1
			i.modifiers[#UVW_Map].length = 1
		)
	)	
		
	on execute do 
	(
		if selection.count > 0  then
		(
			QuickUVMap $
		)
	)

)
------------------------------------------------------------------------------------
macroScript Planar_on_X
category:"FlowFunctions"
toolTip:"Make Planar on X"
(
	fn smMakePlanarX obj = 
	(
			
		for i = 1 to obj.modifiers.count do 
		(
			local mf = modpanel.getcurrentobject()
			if (classof mf ) == Edit_Poly do 
			(
				obj.modifiers[#Edit_Poly].ButtonOp #MakePlanarInX
				print "Success!"
			)
		)
		
		for i in obj do 
		(
			if (classof obj) == Editable_Poly do
			(
				obj.EditablePoly.MakePlanarIn #X
				print "Success!"
			)
		)
			
	)
			
	on execute do 
	(
		Modpanel.getcurrentObject()
		smMakePlanarX $
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() 
	)
		
)
------------------------------------------------------------------------------------
macroScript Planar_on_Y
category:"FlowFunctions"
toolTip:"Make Planar on Y"
(
	fn smMakePlanarY obj = 
	(
			
		for i = 1 to obj.modifiers.count do 
		(
			local mf = modpanel.getcurrentobject()
			if (classof mf ) == Edit_Poly do 
			(
				obj.modifiers[#Edit_Poly].ButtonOp #MakePlanarInY
				print "Success!"
			)
		)
		
		for i in obj do 
		(
			if (classof obj) == Editable_Poly do
			(
				obj.EditablePoly.MakePlanarIn #Y
				print "Success!"
			)
		)
			
	)
			
	on execute do 
	(
		Modpanel.getcurrentObject()
		smMakePlanarY $
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() 
	)
		
)
------------------------------------------------------------------------------------
macroScript Planar_on_Z
category:"FlowFunctions"
toolTip:"Make Planar on Z"
(
	fn smMakePlanarZ obj = 
	(
			
		for i = 1 to obj.modifiers.count do 
		(
			local mf = modpanel.getcurrentobject() 
			if (classof mf ) == Edit_Poly do 
			(
				obj.modifiers[#Edit_Poly].ButtonOp #MakePlanarInZ
				print "Success!"
			)
		)
		
		for i in obj do 
		(
			if (classof obj) == Editable_Poly do
			(
				obj.EditablePoly.MakePlanarIn #Z
				print "Success!"
			)
			
		)
			
	)
		
	on execute do 
	(
		Modpanel.getcurrentObject()
		smMakePlanarZ $
	)
		
	on isEnabled do 
	(
		Ribbon_Modeling.ValidSOMode() 
	)
	
	
)
------------------------------------------------------------------------------------
macroScript VWMirrorOffset
category:"FlowFunctions"
toolTip:"Mirror Offset UVs"
(
	--SWITCH TO MODIFY PANEL
	max modify mode

	undo "Mirror and Weld" on
	(
		try
		(
			subLevel = subObjectLevel

			--CREATE AN EDIT POLY TO NOT DEAL WITH DIFFERING CLASSES
			pMod = Edit_Poly()
			modPanel.addModToSelection pMod ui:on

			--MIRROR THE GEO
			mMod = mirror()
			mMod.copy = true
			addModifier selection mMod

			--GO BACK DOWN TO THE EPOLY TO CONVERT SELECTION TO FACE
			modPanel.setCurrentObject pMod
			subObjectLevel = subLevel
			subType = pMod.GetMeshSelLevel()
			pMod.SetEPolySelLevel subType

			if subType != #Face do pMod.convertSelection subType #Face
			
			--STORE THE FACE SELECTION TO REMOVE IT LATER
			selFaces = pMod.GetSelection #Face

			modPanel.setCurrentObject mMod

			--ADD ANOTHER EDIT POLY TO MODIFY THE SELECTION AFTER MIRRORING
			pMod2 = Edit_Poly()
			addModifier selection pMod2
			pMod.SetEPolySelLevel #Face

			pMod2.SetSelection #Face ((pMod2.GetSelection #Face) - selFaces)

			--ADJUST UVs
			uvMod = UVW_Xform()
			uvMod.U_Offset = 1
			addModifier selection uvMod

			--WELD
			vMod = vertexWeld()
			addModifier selection vMod
			vMod.threshold = 0.01
		)
		catch
		(
			format "%\n" (getCurrentException())
		)

		ok
	)
)
------------------------------------------------------------------------------------
macroScript SelEdgesByAngle
category:"FlowFunctions"
buttontext:"Faces By Angle"
tooltip:"Select Faces By Angle"
(
	local theThreshold = 30
	local include_open_edges = false
	local auto_preview_selection = true
	
	fn filter_function =
	(
		theObj = modPanel.getCurrentObject()
		subObjectLevel == 4 and selection.count == 1 and (classof theObj == Editable_Poly or (classof theObj == Edit_Poly and theObj.enabled and theObj.enabledInViews))
	)
	
	on isEnabled return filter_function()
	on isVisible return filter_function()

	fn perform_selection =
	(
		selEdges = #{}
		theObj = $

		eCount = polyOp.getNumfaces theObj
		for e = 1 to eCount do
		(
			theFaces = (polyOp.getEdgeFaces theObj e) as array
			if theFaces.count == 2 then
			(
				theAngle = acos(dot (polyOp.getFaceNormal theObj theFaces[1]) (polyOp.getFaceNormal theObj theFaces[2]))
				if theAngle >= theThreshold do selEdges[e] = true
			)
			else
				if include_open_edges do selEdges[e] = true
		)
		case classof (modPanel.getCurrentObject()) of
		(
			Editable_Poly: polyOp.setFaceSelection theObj selEdges
			Edit_Poly: (modPanel.getCurrentObject()).SetSelection #Face &selEdges
		)
		redrawViews()
	)

	on execute do perform_selection()

	on altExecute theType do
	(
		rollout SelEdgesByAngle_Rollout "Select Edges By Angle"
		(
			checkbox include_open "Include Open Edges" checked:include_open_edges
			spinner threshold_value "Angle Threshold" range:[0,180,theThreshold] type:#float fieldwidth:60
			checkbutton preview_selection "Preview" width:85 across:2 align:#left checked:auto_preview_selection
			button select_now "Update" width:85 align:#right
				
			on threshold_value changed val do
			(
				theThreshold = val
				if preview_selection.checked and filter_function() do perform_selection()
			)
				
			on include_open changed state do
			(
				include_open_edges = state
				if filter_function() do perform_selection()
			)
				
			on preview_selection changed state do auto_preview_selection = state
			on select_now pressed do if filter_function() do perform_selection()
		)
		createDialog SelEdgesByAngle_Rollout 200 70
	)
)
------------------------------------------------------------------------------------
macroScript AlignPivotToDirection
category:"FlowFunctions"
tooltip:"Align Pivot to Direction"
buttonText:"Align Pivot to Direction"
(
	global miauuAlignObjectToVector
	local objToAlignArr = #()
	local pickedPoint
	
	tool miauuAlignPivotToVector
	(
		on mousePoint clickno do
		(
			if clickno == 1 do
			(
				pickedPoint = worldPoint
			)
		)
	)
	
	function TransformPivot obj vec dir =
	(
		vec = obj.transform[1]
		tm = obj.transform
		vec = normalize vec
		dir = normalize dir
		rtm = angleaxis (acos (dot vec dir)) (normalize (cross dir vec))
		tempObjTM = translate (rotate (scalematrix tm.scale) (tm.rotation*rtm)) tm.pos
		--
		worldAlignPivot obj
		rotation = inverse tempObjTM.rotation
		in coordsys local obj.rotation *= rotation
		obj.objectoffsetrot *= rotation
		obj.objectoffsetpos *= rotation	
		
	)
	
	function AlignPivotToVector axis: pos: =
	(	
		local curSnapMode = snapMode.active
		local curSnapType = snapMode.type
		snapMode.active = true
		snapMode.type = #3D
		p1 = startTool miauuAlignPivotToVector numPoints:1
		if p1 != undefined and p1 != #escale and p1 != #abort do
		(
			p1 = pickedPoint
			p2 = startTool miauuAlignPivotToVector numPoints:1			
			if p2 != undefined and p2 != #escale and p2 != #abort do
			(
				p2 = pickedPoint
				if axis == #xyz then
				(
					--	p1 and p2 define the X axis
					p3 = startTool miauuAlignPivotToVector numPoints:1
					if p3 != undefined and p3 != #escale and p3 != #abort do
					(
						p3 = pickedPoint
						p4 = startTool miauuAlignPivotToVector numPoints:1
						if p4 != undefined and p4 != #escale and p4 != #abort do
						(
							--	p3 and p4 define the Y axis
							p4 = pickedPoint
							p5 = startTool miauuAlignPivotToVector numPoints:1
							if p5 != undefined and p5 != #escale and p5 != #abort do
							(
								--	p5 and p6 define the Z axis
								p5 = pickedPoint
								p6 = startTool miauuAlignPivotToVector numPoints:1
								if p6 != undefined and p6 != #escale and p6 != #abort do
								(
									p6 = pickedPoint
									if classOf p1 == point3 and classOf p2 == point3 and classOf p3 == point3 and classOf p4 == point3 and classOf p5 == point3 and classOf p6 == point3 do
									(	
										
										dirX = normalize (p2 - p1)
										dirY = normalize (p4 - p3)
										dirZ = normalize (p6 - p5)
										for obj in objToAlignArr do
										(
											--	align X axis
											tm = obj.transform
											vec = normalize obj.transform[1]
											dir = normalize dirX
											rtm = angleaxis (acos (dot vec dir)) (normalize (cross dir vec))
											tempObjTM = translate (rotate (scalematrix tm.scale) (tm.rotation*rtm)) tm.pos
											worldAlignPivot obj
											rotation = inverse tempObjTM.rotation
											in coordsys local obj.rotation *= rotation
											obj.objectoffsetrot *= rotation
											obj.objectoffsetpos *= rotation
											--	align Y axis
											tm = obj.transform
											vec = normalize obj.transform[2]
											dir = normalize dirY
											rtm = angleaxis (acos (dot vec dir)) (normalize (cross dir vec))
											tempObjTM = translate (rotate (scalematrix tm.scale) (tm.rotation*rtm)) tm.pos
											worldAlignPivot obj
											rotation = inverse tempObjTM.rotation
											in coordsys local obj.rotation *= rotation
											obj.objectoffsetrot *= rotation
											obj.objectoffsetpos *= rotation
											--	align Z axis
											tm = obj.transform
											vec = normalize obj.transform[3]
											dir = normalize dirZ
											rtm = angleaxis (acos (dot vec dir)) (normalize (cross dir vec))
											tempObjTM = translate (rotate (scalematrix tm.scale) (tm.rotation*rtm)) tm.pos
											worldAlignPivot obj
											rotation = inverse tempObjTM.rotation
											in coordsys local obj.rotation *= rotation
											obj.objectoffsetrot *= rotation
											obj.objectoffsetpos *= rotation
											if pos == true do obj.pivot = p1
										)
									)
								)
							)
						)
					)
				)
				else
				(
					if classOf p1 == point3 and classOf p2 == point3 do
					(	
						dir = normalize (p2 - p1)
						for obj in objToAlignArr do
						(
							--	align the temporary matrix
							vec = case axis of
							(
								#x: obj.transform[1] 
								#y: obj.transform[2] 
								#z: obj.transform[3] 
							)
							tm = obj.transform
							vec = normalize vec
							dir = normalize dir
							rtm = angleaxis (acos (dot vec dir)) (normalize (cross dir vec))
							tempObjTM = translate (rotate (scalematrix tm.scale) (tm.rotation*rtm)) tm.pos
							--
							worldAlignPivot obj
							rotation = inverse tempObjTM.rotation
							in coordsys local obj.rotation *= rotation
							obj.objectoffsetrot *= rotation
							obj.objectoffsetpos *= rotation
							if pos == true do obj.pivot = p1
						)
					)
				)
				snapMode.active = curSnapMode
				try(snapMode.type = curSnapType)catch()				
			)
		)	
	)
		
	if selection.count != 0 then
	(
		objToAlignArr = selection as array
		try
		(
			rcMenu rcMapSize
			(
				menuItem alignX "Align X axis" checked:false
				menuItem alignY "Align Y axis" checked:false
				menuItem alignZ "Align Z axis" checked:false
				menuItem alignXYZ "Align XYZ axes" checked:false
				
				on alignX picked do with undo "Align Pivot to Vector" on
				(
					if keyboard.shiftPressed then
						AlignPivotToVector axis:#X pos:true
					else
						AlignPivotToVector axis:#X pos:false
				)
				on alignY picked do with undo "Align Pivot to Vector" on
				(
					if keyboard.shiftPressed then
						AlignPivotToVector axis:#Y pos:true
					else
						AlignPivotToVector axis:#Y pos:false
				)
				on alignZ picked do with undo "Align Pivot to Vector" on
				(
					if keyboard.shiftPressed then
						AlignPivotToVector axis:#Z pos:true
					else
						AlignPivotToVector axis:#Z pos:false
				)	
				on alignXYZ picked do with undo "Align Pivot to Vector" on
				(
					if keyboard.shiftPressed then
						AlignPivotToVector axis:#XYZ pos:true
					else
						AlignPivotToVector axis:#XYZ pos:false
				)
			) 
			rcPos = mouse.screenpos
			popUpMenu rcMapSize pos:rcPos
		)catch()		
	)
	else
		messagebox "Select some objects" title:"Invalid Selection"
)
------------------------------------------------------------------------------------
macroScript AssignRandomElementColor
category:"FlowFunctions"
tooltip:"Assign Random Element Color"
buttonText:"Mesh IDs"
(
	
	fn shuffle arr =
	(
		for counter = arr.count to 1 by -1 collect
		(
			local swapIndex = random 1 counter
			swap arr[random 1 counter] arr[counter]
		)
	)
		
	fn incrementCounters &r &g &b step =
	(	
		if (b += step) > 256 do
		(
			b = 1
			if (g += step) > 256 do
			(
				g = 1
				if (r += step) > 256 do r = 1
			)
		)
	)
		
	fn getElements mesh =
	(
		local vertCount = mesh.numVerts
		local faces = mesh.faces as bitArray
		local facesByVert = for v = 1 to vertCount collect #()
			
		for face in faces do
		(
			local faceVerts = getFace mesh face
			append facesByVert[faceVerts[1]] face
			append facesByVert[faceVerts[2]] face
			append facesByVert[faceVerts[3]] face
		)
			
		for face in faces collect
		(
			local i = 0, element = #(face), elementVerts = #()
				
			while (local f = element[i += 1]) != undefined do if faces[f] do
			(
				faces[f] = false
				local faceVerts = getFace mesh f
					
				for v = 1 to 3 do facesByVert[faceVerts[v]] = 
					for vertFace in facesByVert[faceVerts[v]] where faces[vertFace] collect
					(
						append element vertFace
						append elementVerts (int faceVerts[v])
						dontCollect
					)
			)
			elementVerts as bitarray
		)
	)

	fn assignUniqueElementColor obj op shuffleElements:off =
	(
		local elements = getElements (snapshotAsMesh obj)
		local stepCount = elements.count^(double 1/3) + 1
		local step = 255./stepCount
		local redArr = shuffle (#(0) + #{1..255})
		local greenArr = shuffle (#(0) + #{1..255})
		local blueArr = shuffle (#(0) + #{1..255})
		local r = 1, g = 1, b = 1
			
		if shuffleElements do
		  elements = shuffle elements
			
		for element in elements do
		(
			op.setVertColor obj 0 element [redArr[int r], greenArr[int g], blueArr[int b]]
			incrementCounters &r &g &b step
		)
	)
		
	if isKindOf $ Editable_Mesh then assignUniqueElementColor $ meshop shuffleElements:on
	else if isKindOf $ Editable_Poly do assignUniqueElementColor $ polyop shuffleElements:on
		
		
)

------------------------------------------------------------------------------------
macroscript UVIslandsToSmoothing 
category:"FlowFunctions"
buttontext:"UV Shells to Smooth Groups"
tooltip:"Convert UV shells to smoothing groups"
autoUndoEnabled:false
(   
    -- Helper function to get the index of the first true element in a bit array
    function getFirstActiveInBitarray aBitArray =
    (
        for i = 1 to aBitArray.count do
        (
            if aBitArray[i] == true do return i
        )
        -- return 0 if none are found active
        return 0
    )
 
    -- Actually performs the operation on the currently selected object
    function ConvertUVIslandsToSmoothingGroups aUVChannel =
    (
        if $ != undefined then
        (           
            modPanel.addModToSelection(Edit_Poly()) ui:on
            local editPoly = $.modifiers[#edit_poly]
             
            local facesDone = #{} -- empty bit array since no faces are done
            local allFaces = #{1.. polyop.getNumFaces $}
            local facesNotDone = allFaces
             
            -- Stick on a UVW modifier
            modPanel.addModToSelection (Unwrap_UVW ()) ui:on
            local uv_modifier = $.modifiers[#unwrap_uvw]                
            uv_modifier.unwrap2.setTVSubObjectMode 3 -- Use face selection
                 
            if (aUVChannel != 1) then -- Only need to mess with this if it's not default
            (
                uv_modifier.unwrap.setMapChannel aUVChannel
                uv_modifier.unwrap.reset()
                forcecompleteredraw dodisabled:true -- Hacky fix for a bug, see http://www.polycount.com/forum/showthread.php?t=97059
            )
                 
            local uv_islands = #() -- Empty array that will store bitarrays of all our UV islands
            local abort = false -- Abort boolean for breaking out of the loop and avoid the performance penalty of using break
             
            -- Build array of UV islands
            while (facesNotDone.isEmpty == false and abort == false) do
            (               
                nextFace = getFirstActiveInBitarray facesNotDone -- Get next face that hasn't been processed yet
                 
                uv_modifier.unwrap2.selectFaces #{nextFace} -- Select that face
                uv_modifier.unwrap2.selectElement() -- Grow selection to element
                uv_island = uv_modifier.unwrap2.getSelectedFaces()  -- Get a bitaray of all those faces (representing a UV island)
                 
                -- Update faces done/not done bit masks
                facesDone += uv_island
                facesNotDone -= uv_island
                 
                insertItem uv_island uv_islands (uv_islands.count + 1) -- Add that bitarray to our array of UV islands
                 
                if uv_islands.count > allFaces.count then -- this should never happen, if it does means we are in an infinite loop and will crash max, so bail
                (
                    abort = true
                    print ("Error, calculated too many islands, something went wrong")
                )
            )
             
            deletemodifier $ uv_modifier -- Don't need the UV modifier anymore
             
            editPoly.autoSmoothThreshold = 180.0 -- If we auto smooth, it should always be in the same smoothing group
             
            for island = 1 to uv_islands.count do -- Select and auto smooth each UV island
            (
                editPoly.SetSelection #Face uv_islands[island]
                editPoly.ButtonOp #Autosmooth
            )
        )
    )
     
    local isOpen = false -- Store if the rollout is open or closed
     
    rollout UV2SmoothRollout "UV_2_Smooth"
    (
        spinner UVChannelSpinner "UV Channel" range:[1,99,1] type:#integer
        button GoBtn "        Run        "
         
        on GoBtn pressed do
        (
            ConvertUVIslandsToSmoothingGroups (UVChannelSpinner.value)
            destroyDialog UV2SmoothRollout -- Close rollout after running
        )
         
        on UV2SmoothRollout close do
        (
            isOpen = false
            updateToolbarButtons() -- Update the toolbar icon when closing
        )
    )
     
    on execute do
    (
        if isOpen then --if open, close it
        (
            destroyDialog UV2SmoothRollout
        )
         
        else --if closed, open it
        (
            createDialog UV2SmoothRollout
            isOpen = true
        )
    )
   
    on isChecked return isOpen --return the flag
     
    on isEnabled do
    (
        -- Need an editable poly selected to work
        if $ == undefined then
        (
            -- Close the window if it's open and it shouldn't be
            if (isOpen) then
                destroyDialog UV2SmoothRollout
             
            return false
        )
        else
            return true
    )
)
------------------------------------------------------------------------------------
macroscript SelectChildren 
category:"FlowFunctions"
buttontext:"Select Children"
tooltip:"Select Children of Selection"
autoUndoEnabled:false
(   
		
	sel = selection[1]
		
	selectmore sel.children
	deselect sel
		
)	

------------------------------------------------------------------------------------
macroscript ResetSelectionsNormals
category:"FlowFunctions"
buttontext:"Reset Selection Normals"
tooltip:"Reset Selection's Normals"
autoUndoEnabled:false
(   
	--reset normals 
	modf = Edit_Normals () 
	modf.displayLength = 1
	
	for i in selection as array do 
	(
		--modPanel.addModToSelection
		modPanel.addModToSelection (modf)	
		subObjectLevel = 0
		i.modifiers[#Edit_Normals].EditNormalsMod.Reset()
	)
		
)	




macroScript UVShellsToSmthGrps
category:"FlowFunctions"
toolTip:"UV Shells to Smoothing Groups"
(
	function smoothByUVShells=(
		clearListener();
		if (getCommandPanelTaskMode() != #modify)then(--make sure we are in the modify panel section
			setCommandPanelTaskMode #modify;
		)
		if (selection.count == 1)then(--at least an object selected
			local obj = selection[1]; 
			local uv = modPanel.getCurrentObject();
			
			if (classof(uv) != Unwrap_UVW)then(
				modPanel.addModToSelection (Unwrap_UVW ()) ui:on;
				uv = modPanel.getCurrentObject();
			)
			
			uv.unwrap.edit();
			uv.unwrap.edit();
			uv.unwrap2.setTVSubObjectMode(3);
	 
			local totalFaces = uv.unwrap.numberPolygons();
			
			local faceElemArray = #();
			for f=1 to totalFaces do (
				faceElemArray[ f ] = 0;
			)
			local elem = #();
			--with redraw off;
			for f=1 to totalFaces do (
				if faceElemArray[ f ] == 0 then (
					uv.unwrap2.selectFaces  #{ f };
					uv.unwrap2.selectElement();
					local elemFaces = uv.unwrap2.getSelectedFaces() 
					
					append elem (uv.unwrap2.getSelectedFaces());
					for i in elemFaces do (
						faceElemArray[ i ] = elem.count; -- Mark these vertices with their element number in vertElemArray.
					)
				)
			)
			
			print("num shells: "+elem.count as string+"t"+totalFaces as string);
			
			modPanel.addModToSelection (Edit_Poly ()) ui:on;
			obj.modifiers[#Edit_Poly].autoSmoothThreshold = 180	
			for e in elem do(
				obj.modifiers[#Edit_Poly].SetSelection #Face e;	
				obj.modifiers[#Edit_Poly].ButtonOp #Autosmooth	
			)	
		)
	)
	
	on execute do 
	(
		smoothByUVShells();
	)
		
)
















