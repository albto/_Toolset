
	--------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------- // GLOBAL SETTINGS
	--------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------


	--------------------------------------------------------------------------------------------------------------------------------------

	persistent global toolSetClosePos
	global FPHeight = Point2 0 1150 

	------------------------------------------------------------------------------------------------------------- 
	--resets all settings from last session and distributes them to 
	--the parameters set in memory intgrs.	--LOAD settings
	------------------------------------------------------------------------------------------------------------- 

	global useGlobalDotNam = (sysInfo.username as string)
		
	--------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------- // FUNCTIONS

	-- UNITY EXPORTER
	---------------------------------------------------------------------------------------------------------------
	global unityYUp

	fn unityYUp obj = 
	(	
		rot = eulerToQuat(eulerAngles 90 0 0)
				
		Select obj
		ResetXForm obj
		modPanel.addModToSelection (XForm ()) ui:on
		obj.modifiers[#XForm].gizmo.rotation += rot as quat
		rotate obj (inverse rot as quat)
		for obj in (selection as array) do 
		( 
			convertToPoly obj
			
		) 	
			
	)
			
	-- SET NORMALS 
	---------------------------------------------------------------------------------------------------------------
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
			
	--------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------	

	--SEND TO SUBSTANCE PAINTER -- 

	--------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------	

		--forgot what this does -- shit -- 
		if classOf roExample == RolloutClass do DestroyDialog roExample
			
		-- Get banner bitmap file from 3dsMax folder
		rootDir = getDir #maxRoot
		bitmapBannerFile = (rootDir  + "scripts\\SendToSubstance\\banner.jpg")
			
		-- Set default Substance Painter path
		defaultSubstancePainterPath = "C:\\Program Files\\Allegorithmic\\Substance Painter"
			
		-- Set default export path
		defaultExportPath = "D:\\Projects\\Project3D\\_source\\Models\\PainterTest"	
			
		-- Set default export path
		defaultSppPath = ""
			
		-- Create variables to store the user inputs
		persistent global userSubstancePainterPath
		persistent global userExportPath
			
		global SendToSubstancePainterRollout
		global firstExport = true
		global copiedNormalMaps
			
		-- If the user already setup paths, use them (SP/export)
		if (userSubstancePainterPath != undefined) do 
			if (userSubstancePainterPath != "") do
				defaultSubstancePainterPath = userSubstancePainterPath
				
		if (userExportPath != undefined) do 
			if (userExportPath != "") do 
				defaultExportPath = userExportPath
				

	----------------------------------------------------
					
	--------------------------------------------------------------------------------------------------------------------------------------
	--------------