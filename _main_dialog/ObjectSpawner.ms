try (DestroyDialog objSpawn) catch()

Rollout objSpawn "Object Spawner"
(
		
	button btn_Spawn "Spawn"
		
		
	-----------------------------------------------------------------------------------------------------------------------------
	fn aveSelVertPosPoly obj =
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
	-----------------------------------------------------------------------------------------------------------------------------
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
	-----------------------------------------------------------------------------------------------------------------------------	
	
	fn createObject pos =
	(
		b = box()
		
		b.pos = pos
		
		
	)
	
	
	on btn_Spawn pressed do 
	(
		obj = selection
		mdf = modpanel.getCurrentObject()
		
		if obj.count > 0 then
		(		
			if (classof mdf) == Editable_Poly then
			(
				o = aveSelVertPos $
					
				vPos = transMatrix o
					
				wp = WorkingPivot
				
				if wp.usemode then
				(
					wp.SetTM vPos
				)
				else
					--Create Object
					createObject vPos.translation
			)
			else if (classof mdf) == edit_poly then
			(
					
				o = aveSelVertPosPoly $
					
				vPos = transMatrix o
					
				wp = WorkingPivot
				
				if wp.usemode then
				(
					wp.SetTM vPos
				)
				else
					--Create Object
					createObject vPos.translation
			)
			else
				messagebox "Must be an editable poly or edit poly"
				
			select obj
			subobjectLevel = 0
		)	
	)	
		
	
)

CreateDialog objSPawn 