

function convertDummyToBone i =
(
	local root
	local boneID = i
	local count = 1 
		
	childNodes = i.children
		
	if i.parent.name == "Skeleton" then
	(			
		root = i
		print ("Root Object = {" + root.name as string + "}")
		
		b = BoneSys.createBone [root.pos.x, root.pos.y, root.pos.z] [root.pos.x, root.pos.y, root.pos.z-0.015]  [0,0,1]
		b.name = root.name
		b.height = 0.03
		b.width = 0.03
		b.wirecolor = orange 
		b.taper = 100
		boneID = b 
			
		
	)	
	else
	(
		root = undefined
	)
		
-- 	if root != undefined then
	(	
		if i.parent.name == "Hips" then 
		(
			print "-----------------------------------PARENT IS HIPSSS"
		)
	)
		
	print (i.parent.name + " / " + i.name)
		
	for c in childNodes do 
	(
		b = BoneSys.createBone i.pos childNodes[count].pos [0,0,1]
		
		--b = ::Bone prefix:"bone_" pos:i.pos baseObject:(createInstance BoneGeometry width:.05 height:.05 taper:100 length:.05 pos:childNodes[count].pos forceCreate:on) boneEnable:on	parent:boneID	
		
		
		b.name = childNodes[count].name
		b.height = 0.025
		b.width = 0.025
		--b.pivot = c.pos
			
		if childNodes.count == 1 then 
		(
			b.wirecolor = blue
		)
		else if childNodes.count == 2 then 
		(
			b.wirecolor = green
		)
		else if childNodes.count == 3 then 
		(
			b.wirecolor = yellow
		)
		else 
		(
			b.wirecolor = red
		)
			
		convertDummyToBone c
			
		count += 1
			
	)
		
	return boneID
)



try 
(
	undo on
	convertDummyToBone selection[1]
)
catch()























