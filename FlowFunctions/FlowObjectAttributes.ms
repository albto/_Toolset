
-----------------------------------------------------------------------------------------------------------


macroScript IBGUnityAttributesAdd
category:"FlowAttributes"
toolTip:"Add Unity Attributes"
(
	
	m = EmptyModifier()
	m.name = "Unity Attributes"
	
	
	for i in selection as array do 
	(
		mdf = modpanel.getCurrentObject()
		
		if( (classOf mdf) == (classof m)) then
		(
			try (deleteModifier i 1 ) catch()
		)
	)

	Global UnityAttributes = attributes gameData
	(
				
		parameters Param0 rollout:General
		(
			Preserve_Hierarchy 		type:#boolean ui:chk_preHier 
			Generate_Prefab_Asset 	type:#boolean ui:chk_IsPrefab 
			Tags					type:#integer ui:ddl_Tags 
			GameLayers				type:#integer ui:ddl_Lyrs 
			ObjectAttributes		type:#integer ui:ddl_oAtr 
			ObjectTypes				type:#integer ui:ddl_ObjT 
			Mesh_Compression		type:#integer ui:ddl_MshComp		
			Generate_Colliders 		type:#boolean ui:chk_Cols 	
			Generate_Lightmaps 		type:#boolean ui:chk_Lmaps 	
			Import_BlendShapes 		type:#boolean ui:chk_Blnd 					
			Import_Animation       	type:#boolean ui:chk_Amin	
			Import_Cameras			type:#boolean ui:chk_Cams
			Import_Lights			type:#boolean ui:chk_Lght
			Import_Visibility		type:#boolean ui:chk_Visi	
			NormalsImport			type:#integer ui:ddl_Nmls 		
			MaterialCreationMode	type:#integer ui:ddl_MCM	
			MaterialLocation		type:#integer ui:ddl_MLoc	
			fileScale				type:#integer ui:spn_filScale 
			BakeXformConversion     type:#boolean ui:chk_BakeXform
			UseFileUnits 			type:#boolean ui:chk_fileUnits
			SortHierarchy			type:#boolean ui:chk_SortHier 
			KeepQuads 				type:#boolean ui:chk_KeepQads  
			SwapChannels			type:#boolean ui:chk_SwapChn   
			
		)--end Param1
			
		Rollout General "Unity Attributes"
		(
			--Presets
			
			local externalFn = #("", "", "")
			local externalMod = #("", "", "", "")
			local GameTags = #("Untagged", "Respawn", "Finish", "EditorOnly", "Camera", "Player", "Game Controller", "Shootable", "Enemy", "Vehicle", "Avatar", "Muzzle", "CM_Camera",
				"CM_Vehicle", "CM_FPS_Cam", "Doorway", "Sensor", "Weapon")
			local Layers = #("Default", "TransparentFX", "Ignore Raycast", "Water", "UI", "Player", "Camera", "Interactible", "Movement","Vehicle","Walls")
			local ObjectTypes = #("Characters", "Exteriors", "Interiors", "Lights", "Props", "Structures", "Terrain", "Vehicles", "VertexAnims", "Weapons" )
			local ObjectAttributes = #("Standard", "Damageable", "Hackable", "Interactable", "Dummy")
			local MeshComp = #("Off", "Low", "Medium", "High")
			local NormalsType = #("Import", "Calculate", "None")
			local MaterialsMode = #("None", "Standard", "Import Via Description")
			local MaterialsLoc = #("External", "InPrefab")
				
			Group "Properties:"
			(
				checkbox chk_preHier "Preserve Hierarchy" 		checked:Preserve_Hierarchy
				checkbox chk_SortHier "Sort Hierarchy" 			checked:SortHierarchy
				checkbox chk_IsPrefab "Create Prefab" 			checked:Generate_Prefab_Asset
					
				checkbox chk_fileUnits "Use File Units" 		checked:UseFileUnits
				spinner spn_filScale "File Scale"				range:[0, 1000, fileScale]	type:#integer
				
				checkbox chk_BakeXform "Bake Axis Conversion" 	checked:BakeXformConversion
					
			)
			
			Group "Identification:"
			(
				dropdownlist ddl_Tags "Tag:"					items:GameTags	
				dropdownlist ddl_Lyrs "Layers:"					items:Layers 	
				dropdownList ddl_ObjT "ObjectType:" 			items:ObjectTypes
			)
			
			Group "Gameplay Settings:"
			(
				dropdownList ddl_oAtr "ObjectAttributes:"		items:ObjectAttributes
			)
			
			Group "Settings:"
			(
				dropdownlist ddl_MshComp "Mesh Compression:" 	items:MeshComp
				checkbox chk_Cols "Generate Colliders" 			checked:Generate_Colliders
				checkbox chk_Lmaps "Generate Lightmaps" 		checked:Generate_Lightmaps
				
				checkbox chk_KeepQads "Keep Quads" 				checked:KeepQuads
				checkbox chk_SwapChn "Swap Channels" 			checked:SwapChannels			
				
				checkbox chk_Amin "Import Animation" 			checked:Import_Animation
				checkbox chk_Blnd "Import BlendShapes" 			checked:Import_BlendShapes
				checkbox chk_Cams "Import Cameras" 				checked:Import_Cameras
				checkbox chk_Lght "Import Lights" 				checked:Import_Lights
				checkbox chk_Visi "Import Visibility" 			checked:Import_Visibility
				dropdownlist ddl_Nmls "Normals Import:"			items:NormalsType	
				dropdownlist ddl_MCM "Material Creation Mode:"	items:MaterialsMode
				dropdownlist ddl_MLoc "Material Location"		items:MaterialsLoc
			)	
				
			--write to file
			local fps = #()
				
				
			---------------------------------------------------------------------------------
			--FUNCTIONS -- PRESETS
			---------------------------------------------------------------------------------
			fn DefaultUnityAttrPreset = 
			(
				chk_preHier.checked		= false
				chk_IsPrefab.checked 	= false
				ddl_Tags.selection 		= 1
				ddl_Lyrs.selection 		= 1
				ddl_ObjT.selection		= 1
				ddl_MshComp.selection	= 1
				chk_Cols.checked		= false
				chk_Lmaps.checked 		= false
				chk_Amin.checked 		= false
				chk_Blnd.checked 		= false
				chk_Cams.checked 		= false
				chk_Lght.checked 		= false
				chk_Visi.checked 		= false
				ddl_Nmls.selection 		= 1
				ddl_MCM.selection 		= 1
				ddl_MLoc.selection 		= 1
				ddl_oAtr.selection		= 1
				chk_preHier.checked 	= false
				spn_filScale.value 		= 1
				chk_BakeXform.checked	= false
				chk_fileUnits.checked	= false
				chk_SortHier.checked	= false
				chk_KeepQads.checked	= false
				chk_SwapChn.checked		= false
			)
				
			
			---------------------------------------------------------------------------------
				
				
			--sets the Settings to be saved
			fn SetObjectSettings i val= 
			(
				fps[i] = val
			)	
				
			fn SaveObjectSettings =
			(
				--Save Settings
				for i in selection as Array do 
				(
						
					--set settings	
					SetObjectSettings 1 Generate_Prefab_Asset
					SetObjectSettings 2 ddl_Tags.selection
					SetObjectSettings 3	ddl_Lyrs.selection 
					SetObjectSettings 4 ddl_ObjT.selection
					SetObjectSettings 5 ddl_MshComp.selection
					SetObjectSettings 6 Generate_Colliders 			
					SetObjectSettings 7 Generate_Lightmaps
					SetObjectSettings 8 Import_Animation	
					SetObjectSettings 9 Import_BlendShapes	
					SetObjectSettings 10 Import_Cameras	
					SetObjectSettings 11 Import_Lights	
					SetObjectSettings 12 Import_Visibility	
					SetObjectSettings 13 ddl_Nmls.selection	
					SetObjectSettings 14 ddl_MCM.selection	
					SetObjectSettings 15 ddl_MLoc.selection	
					SetObjectSettings 16 ddl_oAtr.selection	
					SetObjectSettings 17 Preserve_Hierarchy	
					SetObjectSettings 18  fileScale				
					SetObjectSettings 19  BakeXformConversion     
					SetObjectSettings 20  UseFileUnits 			
					SetObjectSettings 21  SortHierarchy			
					SetObjectSettings 22  KeepQuads 				
					SetObjectSettings 23  SwapChannels			
						
						
					--record settings	
					setUserPropVal i "Unity Attributes" fps 
						
				)
			)
				
			fn LoadObjectSettings =
			(
				
				for i in selection as array do 
				(
					local obs = execute (getUserPropVal i "Unity Attributes" asString:true)
						
					--Load Settings 
					chk_IsPrefab.checked 	= obs[1]
					ddl_Tags.selection 		= obs[2]
					ddl_Lyrs.selection 		= obs[3] 
					ddl_ObjT.selection		= obs[4]
					ddl_MshComp.selection	= obs[5]
					chk_Cols.checked		= obs[6]
					chk_Lmaps.checked 		= obs[7]
					chk_Amin.checked 		= obs[8]
					chk_Blnd.checked 		= obs[9]
					chk_Cams.checked 		= obs[10]
					chk_Lght.checked 		= obs[11]
					chk_Visi.checked 		= obs[12]
					ddl_Nmls.selection 		= obs[13]
					ddl_MCM.selection 		= obs[14]
					ddl_MLoc.selection 		= obs[15]
					ddl_oAtr.selection		= obs[16]
					chk_preHier.checked 	= obs[17]
					spn_filScale.value 		= obs[18]
					chk_BakeXform.checked	= obs[19]
					chk_fileUnits.checked	= obs[20]
					chk_SortHier.checked	= obs[21]
					chk_KeepQads.checked	= obs[22]
					chk_SwapChn.checked		= obs[23]
					
					--record settings	
					setUserPropVal i "Unity Attributes" obs 
						
				)
				
			)
				
			on General open do
			(
				--Load Settings
				try (LoadObjectSettings()) catch
				(  
					print "Brand New Object Detected - Applying Default Settings"
					chk_preHier.checked		= false
					chk_IsPrefab.checked 	= false
					ddl_Tags.selection 		= 1
					ddl_Lyrs.selection 		= 1
					ddl_ObjT.selection		= 1
					ddl_MshComp.selection	= 1
					chk_Cols.checked		= false
					chk_Lmaps.checked 		= false
					chk_Amin.checked 		= false
					chk_Blnd.checked 		= false
					chk_Cams.checked 		= false
					chk_Lght.checked 		= false
					chk_Visi.checked 		= false
					ddl_Nmls.selection 		= 1
					ddl_MCM.selection 		= 1
					ddl_MLoc.selection 		= 1
					ddl_oAtr.selection		= 1
					chk_preHier.checked 	= false
					spn_filScale.value 		= 1
					chk_BakeXform.checked	= false
					chk_fileUnits.checked	= false
					chk_SortHier.checked	= false
					chk_KeepQads.checked	= false
					chk_SwapChn.checked		= false
					
					--Save Settings Applied
					SaveObjectSettings()
					
				)
				
	-- 			addFunction "Mal_Functions" externalFn --Adding all the external function
	-- 			addFunction "Mal_Modifiers" externalMod --Adding all the external modifiers
	-- 			ddl_Tags.selection = findItem ddl_Tags.items Tags
	-- 			UICaptionChange General 2 "Test"
			)
			on chk_preHier changed state do
			(
				Preserve_Hierarchy = state
				print state
			)
				
			on chk_IsPrefab changed state do
			(
				Generate_Prefab_Asset = state
				print state
			)
				
			on ddl_Tags selected val do
			(
				Tags = val
			)
			
			on ddl_Lyrs selected val do 
			(
				Layers = val 
			)
			
			on ddl_ObjT selected val do 
			(
				ObjectTypes = val 
			)
			on ddl_oAtr selected val do 
			(
				ObjectAttributes = val 
			)	
				
			on ddl_MshComp selected val do 
			(
				Mesh_Compression = val
			)
			
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				
			--Save Settings -- 
			dropdownList ddl_prst "Presets:"	items: ObjectTypes
			button btn_save "Save"	width:60	across:2
			button btn_load "Load"	width:60
				
			--------------------------------------------------------------------------------------
				
			on btn_save pressed do
			(
				--Save Settings 
				SaveObjectSettings()
				
			)
				
			on btn_load pressed do
			(
				--Set Unity Attributes
				LoadObjectSettings()
				
			)
				
			--------------------------------------------------------------------------------------9
				
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				
				
		)--end MeshInfo Rollout
		
		
	)--end posAttribs


	modPanel.addModToSelection (m) ui:on
	for i in selection as array do custAttributes.add i.modifiers[1] UnityAttributes --add the attribute in the first modifier
		
)



macroScript IBGUnityAttributesDelete
category:"FlowAttributes"
toolTip:"Delete Unity Attributes"
(
		
	m = EmptyModifier()
	m.name = "Unity Attributes"	
		
	mdf = modpanel.getCurrentObject()
		
	for i in selection as array do 
	(
		--Removes Attributes Modifier
		custAttributes.delete i UnityAttributes baseObject:true --add the attribute in the first modifier
			
		--checks to remove active attributes before being applied to object	
		if( (classOf mdf) == (classof m)) then
		(
			try (deleteModifier i 1 ) catch()
		)
			
		for i in selection as Array do 
		(
				
			--set settings	
			fps = #()
			
			--record settings	
			setUserPropVal i "Unity Attributes" fps 
				
		)
		
		
		
	)
	
)

macroScript IBGUnityAttributesClear
category:"FlowAttributes"
toolTip:"Clear Unity Attributes"
(
		
	m = EmptyModifier()
	m.name = "Unity Attributes"	
		
	mdf = modpanel.getCurrentObject()
		
	for i in selection as array do 
	(
		--Removes Attributes Modifier
		custAttributes.delete i UnityAttributes baseObject:true
			
		--checks to remove active attributes before being applied to object	
		if( (classOf mdf) == (classof m)) then
		(
			try (deleteModifier i 1 ) catch()
		)
			
-- 		for i in selection as Array do 
-- 		(
-- 				
-- 			--set settings	
-- 			fps = #()
-- 			
-- 			--record settings	
-- 			setUserPropVal i "Unity Attributes" fps 
-- 				
-- 		)
		
		
		
	)
	
)






