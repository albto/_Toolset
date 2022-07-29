-- 	globalInstance = (dotNetClass "Autodesk.Max.GlobalInterface").instance	
-- 	currentAngle = globalInstance.coreinterface7.SnapAngle_ as integer
--  
-- 	if currentAngle != 5 then currentAngle = 5 else currentAngle = 45
-- 	globalInstance.coreinterface7.SnapAngle_ = currentAngle
-- 	
-- 	
-- 	
-- 	tmGizmos.rotationIncrement = 
-- 	
-- 	
	fn aveSelVertPos obj =
	(
		obj = selection
		mdf = modpanel.getCurrentObject()
			
		if (classof mdf) == Editable_Poly then
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
		else if (classof mdf) == edit_poly then
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
	)	
		
		
-- 	o = aveSelVertPos $
	
	
	
 	sel = getNodeByName selection[1].name

	if selection.count > 0 then 
	(		
		when transform sel changes do 
		( 
			sel.pos = [(floor (1.0*sel.pos.x/1)*.2) as float, sel.pos.y, sel.pos.z]
			print "xform change"
		)
		
		when topology sel changes do  
		(	
				
			sVerts = sel.selectedVerts 
				
			print sVerts[1].pos 
			sVerts[1].pos = [(floor(1*sVerts[1].pos.x/1)*2) as float, sVerts[1].pos.y as float, sVerts[1].pos.z as float]
				
			print "geo change"
		)
		
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	