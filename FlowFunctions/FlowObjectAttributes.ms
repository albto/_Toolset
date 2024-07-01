-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------


macroScript IBGUnityAttributesDelete
category:"FlowAttributes"
toolTip:"Delete Unity Attributes"
(
		
-- 	m = EmptyModifier()
-- 	m.name = "Unity Attributes"	
-- 		
-- 		
-- 	for i in selection as array do 
-- 	(
-- 		--filter modifier
-- 		mdf = i.modifiers[#Unity_Attributes]
-- 		
-- 		--Removes Attributes Modifier
-- 		custAttributes.delete i UnityAttributes baseObject:true --add the attribute in the first modifier
-- 			
-- 		--checks to remove active attributes before being applied to object	
-- 		if( (classOf mdf) == (classof m)) then
-- 		(
-- 			index = modPanel.getModifierIndex i mdf
-- 			
-- 			try (deleteModifier i (index) ) catch()
-- 		)
-- 		else
-- 		(
-- 			continue
-- 		)
-- 			
-- 	)
		
	for o in selection as Array do 
	(
			
		--set settings	
		fps = #()
		
		--record settings	
		setUserPropBuffer o ""
		--setUserProp o "Unity Attributes" ""  
		--setUserPropVal o "Unity Attributes" fps 
		--deleteUserProp o "Unity Attributes" 
		
	)
	
)

macroScript IBGUnityAttributesClear
category:"FlowAttributes"
toolTip:"Clear Unity Attributes"
(
		
	m = EmptyModifier()
	m.name = "Unity Attributes"	
		
	for i in selection as array do 
	(
		--filter modifier
		mdf = i.modifiers[#Unity_Attributes]
		
		--Removes Attributes Modifier
		custAttributes.delete i UnityAttributes baseObject:true --add the attribute in the first modifier
			
		--checks to remove active attributes before being applied to object	
		if( (classOf mdf) == (classof m)) then
		(
			index = modPanel.getModifierIndex i mdf
			
			try (deleteModifier i (index) ) catch()
		)
		else
		(
			continue
		)
			
	)
	
)

macroScript IBGUnityAttributesHelper
category:"FlowAttributes"
toolTip:"Unity Attributes Helper"
(
	global FlowAttEditor 	
	
	--link to script here 
	sysFolder = sysInfo.windowsdir
	subS = substituteString sysFolder "WINDOWS" ("Users\\" + sysInfo.username as string)
	
	if (doesDirectoryExist (subS + "\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms") ) then
	(
		sysFolder = (subS + "\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms")
	)
	else
	(
		sysFolder = (subS + "\\OneDrive\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms")
	)
	
	filein sysFolder
	
)



-------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	

macroScript IBGUnityAttributesAdd
category:"FlowAttributes"
toolTip:"Add Unity Attributes"
(			

	fn AddUnityAttribute = 
	(
			m = EmptyModifier()
			m.name = "Unity Attributes"
				
			for i in selection as array do 
			(
				--filter modifier
				mdf = i.modifiers[#Unity_Attributes]
					
				if( (classOf mdf) == (classof m)) then
				(
					try (deleteModifier i mdf ) catch()
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
					ProcGenType				type:#integer ui:ddl_procTyp 
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
					MaterialName 			type:#integer ui:ddl_MNam
					MaterialSearch			type:#integer ui:ddl_MSea
					fileScale				type:#integer ui:spn_filScale 
					BakeXformConversion     type:#boolean ui:chk_BakeXform
					UseFileUnits 			type:#boolean ui:chk_fileUnits
					UseFileScale 			type:#boolean ui:chk_fileScale
					SortHierarchy			type:#boolean ui:chk_SortHier 
					KeepQuads 				type:#boolean ui:chk_KeepQads  
					SwapChannels			type:#boolean ui:chk_SwapChn   
					Category 				type:#string ui:edt_categFolder
					Classification 			type:#string ui:edt_classFolder
					ObjectComponent			type:#integer ui:ddl_ObjT		
					
				)--end Param1
					
					
					
				Rollout General "Unity Attributes"
				(	
						
					--Presets
					local externalFn = #("", "", "")
					local externalMod = #("", "", "", "")
					
					local GameTags = #()
					local ObjectTypes = #()
					local ObjectAttributes = #()
					local Layers = #() 
					
					local ProcGenType = #("None","StartRoom", "Hallway", "BossRoom", "Room", "EndRoom") 
					local MeshComp = #("Off", "Low", "Medium", "High")
					local NormalsType = #("Import", "Calculate", "None")
					local MaterialsMode = #("None", "Standard (Legacy)", "Import Via Description")
					local MaterialsLoc = #("External", "InPrefab")
					local MaterialsNam = #("BasedOnTexture", "BasedOnMaterial", "BasedOnModel")
					local MaterialsSea = #("Local", "Recursive-Up", "Everywhere")
					local CategoryName = "None"
					local ClassificationName = "None"
						
					--write to file
					local fps = #()
					local obs = #()	
					-----------------------------------------------------------------------------------------------------------
						
					-----------------------------------------------------------------------------------------------------------	
						
					--Save Settings -- 
					dropdownList ddl_prst "Presets:"		items:ObjectTypes
					button btn_save "Save"		width:40	height:20	align:#left	across:3
					button btn_updt "Update"	width:50	height:20	align:#center
					button btn_load "Load"		width:40	height:20	align:#right
					
					button btn_clrs "Save and Clear" 			width:140	height:20	align:#center
						
					--------------------------------------------------------------------------------------	
						
						
					Group "Properties:"
					(
						checkbox chk_preHier "Preserve Hierarchy" 		checked:Preserve_Hierarchy
						checkbox chk_SortHier "Sort Hierarchy" 			checked:SortHierarchy
						checkbox chk_IsPrefab "Create Prefab" 			checked:Generate_Prefab_Asset
							
						checkbox chk_fileUnits "Use File Units" 		checked:UseFileUnits
						checkbox chk_fileScale "Use File Scale" 		checked:UseFileScale
						spinner spn_filScale "File Scale"				range:[0, 1000, fileScale]	type:#integer
						
						checkbox chk_BakeXform "Bake Axis Conversion" 	checked:BakeXformConversion
							
					)
					
					Group "Identification:"
					(
						dropdownlist ddl_Tags "Tag:"					items:GameTags	
						dropdownlist ddl_Lyrs "Layers:"					items:Layers 	
						dropdownList ddl_ObjT "Object Type:" 			items:ObjectTypes
						edittext 	 edt_categFolder "Category:"		text:CategoryName		labelOnTop:true
						edittext 	 edt_classFolder "Classification:"	text:ClassificationName	labelOnTop:true
					)
					
					Group "Gameplay Settings:"
					(
						dropdownList ddl_oAtr "Object Attributes:"		items:ObjectAttributes
						dropdownList ddl_procTyp "ProcGen Type:"		items:ProcGenType		enabled:false
						dropdownList ddl_ObjC "Object Component:" 		items:ObjectTypes
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
						dropdownlist ddl_MNam "Material Name"			items:MaterialsNam
						dropdownlist ddl_MSea "Material Search"			items:MaterialsSea
					)	
						
					---------------------------------------------------------------------------------
					--FUNCTIONS -- PRESETS
					---------------------------------------------------------------------------------	
					
					---------------------------------------------------------------------------------
						
					
					-----------------------------------------------------------------------------------------------------------
					-- Gather Data from XML file -- Unity Data Hook-up 
					-----------------------------------------------------------------------------------------------------------
					
					fn ImportDataFromUnity = 
					(
						
						srl_Stats.ImportDataFromUnity()
						
						print ("OBJATTR   " + AttrList as string)
						--print ("ATTRLIST   " + AttrList as string)
						
							
						--Load data  - - Layers 
						ddl_Lyrs.items = LayersList
						Layers = LayersList
							
						--Load data  - - Tags
						ddl_Tags.items = TagsList
						GameTags = TagsList
							
						--Load data  - - Attributes
						ddl_oAtr.items = AttrList
						ObjectAttributes = AttrList
							
						--Load data  - - Types
						ddl_ObjT.items = TypeList
						ObjectTypes = TypeList
							
						--Load data  - - Components
						ddl_ObjC.items = CompList
							
						--Load data  - - Something Else 
							
					)

						
					--sets the Settings to be saved
					fn SetObjectSettings i val= 
					(
						fps[i] = val
					)	
						
					fn SaveObjectSettings =
					(
						--load data from unity xml 
						ImportDataFromUnity()
						
						
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
							SetObjectSettings 13 (ddl_Nmls.selection)
							SetObjectSettings 14 ddl_MCM.selection	
							SetObjectSettings 15 ddl_MLoc.selection	
							SetObjectSettings 16 ddl_oAtr.selection	
							SetObjectSettings 17 Preserve_Hierarchy	
							SetObjectSettings 18 (fileScale)				
							SetObjectSettings 19 BakeXformConversion     
							SetObjectSettings 20 UseFileUnits 			
							SetObjectSettings 21 SortHierarchy			
							SetObjectSettings 22 KeepQuads 				
							SetObjectSettings 23 SwapChannels			
							SetObjectSettings 24 UseFileScale 	
							SetObjectSettings 25 ddl_MNam.selection 	
							SetObjectSettings 26 ddl_MSea.selection 
							SetObjectSettings 27 ddl_procTyp.selection
							SetObjectSettings 28 edt_categFolder.text
							SetObjectSettings 29 Layers
							SetObjectSettings 30 GameTags
							SetObjectSettings 31 edt_classFolder.text
							SetObjectSettings 32 ObjectAttributes
							SetObjectSettings 33 ObjectTypes
							SetObjectSettings 34 ddl_ObjC.selection
								
								
							--record settings	
							setUserPropVal i "Unity Attributes" fps 
								
							for i = 1 to fps.count do
							(
								--print ("SavedSetttings -[" + ((i) as string) + "] = { " + fps[i] as string + " }" )
								
								if (classof fps[i]) == array then(
									--print ("["+i as string +"]" + " is an aray")
									--print ("["+i as string +"]'s" + " count = " + fps[i].count as string)
								)
								
							)
						)
					)
							
					fn LoadObjectSettings =
					(
						--load data from unity xml
						ImportDataFromUnity()
							
							
						for i in selection as array do 
						(
							obs = execute (getUserPropVal i "Unity Attributes" asString:true)
								
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
							chk_fileScale.checked	= obs[24]
							ddl_MNam.selection		= obs[25]
							ddl_MSea.selection 		= obs[26]
							ddl_procTyp.selection	= obs[27]
							edt_categFolder.text	= obs[28]
															
							if (classOf obs[29]) == array then
							(
								if obs[29].count > 0 then 
								(
									--print "Loading from Memory  - layers"
									--print (obs[29] as string)
									Layers = obs[29]
									ddl_Lyrs.items = Layers
								)
							)
								
							if (classOf obs[30]) == array then 
							(
								if obs[30].count > 0 then 
								(
									--print "Loading from Memory - tags"
									--print (obs[30] as string)							
									GameTags = obs[30]
									ddl_Tags.items = GameTags
								)
							)					
							
							edt_classFolder.text	= obs[31]

							
							if (classOf obs[32]) == array then 
							(
								if obs[32].count > 0 then 
								(
									--print "Loading from Memory - attributes"
									--print (obs[32] as string)							
									ObjectAttributes = obs[32]
									ddl_oAtr.items = ObjectAttributes
								)
							)	
							
							if (classOf obs[33]) == array then 
							(
								if obs[33].count > 0 then 
								(
									--print "Loading from Memory - attributes"
									--print (obs[32] as string)							
									ObjectTypes = obs[33]
									ddl_ObjT.items = ObjectTypes
								)
							)
								
							ddl_ObjC.selection		= obs[34]
							
							
							--record settings	
							setUserPropVal i "Unity Attributes" obs 
								
						)
						
					)
						
					on General open do
					(									
						--Load Settings
						try 
						(	
							--load tool settings
							LoadObjectSettings()
							--Save Settings 
							SaveObjectSettings()							
						) 
						catch
						(  
							print "Brand New Object Detected - Applying Default Settings"
							
							chk_preHier.checked		= true
							chk_IsPrefab.checked 	= false
							ddl_Tags.selection 		= 1
							ddl_Lyrs.selection 		= 1
							ddl_ObjT.selection		= 1
							ddl_MshComp.selection	= 2
							chk_Cols.checked		= false
							chk_Lmaps.checked 		= false
							chk_Amin.checked 		= false
							chk_Blnd.checked 		= false
							chk_Cams.checked 		= false
							chk_Lght.checked 		= false
							chk_Visi.checked 		= false
							ddl_Nmls.selection 		= 1
							ddl_MCM.selection 		= 2
							ddl_MLoc.selection 		= 2
							ddl_MNam.selection		= 1
							ddl_MSea.selection 		= 2
							ddl_oAtr.selection		= 1
							chk_preHier.checked 	= false
							spn_filScale.value 		= 1
							chk_BakeXform.checked	= true
							chk_fileUnits.checked	= false
							chk_fileScale.checked 	= true
							chk_SortHier.checked	= true
							chk_KeepQads.checked	= false
							chk_SwapChn.checked		= false
							ddl_procTyp.selection 	= 1
							edt_categFolder.text	= "None"
							edt_classFolder.text 	= "None"
								
								
							--Save Settings Applied
							SaveObjectSettings()
								
						)
							
					)
					
					on chk_preHier changed state do
					(
						Preserve_Hierarchy = state
						--print state
					)
						
					on chk_IsPrefab changed state do
					(
						Generate_Prefab_Asset = state
						--print state
					)
						
					on ddl_Tags selected val do
					(
						Tags = val
					)
					
					on ddl_Lyrs selected val do 
					(
						GameLayers = val 
					)
					
					on ddl_ObjT selected val do 
					(
						ObjectTypes = val 
					)
					
					on ddl_oAtr selected val do 
					(
						if val == 6 then
						(
							ddl_procTyp.enabled = true
						)
						else(ddl_procTyp.enabled = false)
							
						ObjectAttributes = val 
					)	
					
					on spn_filScale changed val do 
					(
						fileScale = val+1		
					)
					
					on ddl_MshComp selected val do 
					(
						Mesh_Compression = val
					)
					
					on edt_categFolder entered val do
					(
						CategoryName = val
					)
					
					on edt_categFolder entered val do
					(
						CategoryName = val
					)
						
					on btn_save pressed do
					(
						--Save Settings 
						SaveObjectSettings()
					)
					
					on btn_clrs pressed do 
					(
						--Save Settings 
						SaveObjectSettings()
						
						macros.run "FlowAttributes" "IBGUnityAttributesClear"
						
					)
						
					on btn_updt pressed do
					(
						--load data from unity xml 
						ImportDataFromUnity()
							
						--Save Settings 
						SaveObjectSettings()
					)
					on btn_load pressed do
					(
						--Set Unity Attributes
						LoadObjectSettings()
					)
						
					--------------------------------------------------------------------------------------
						
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						
						
				)--end MeshInfo Rollout
				
				
			)--end posAttribs
			
			--add modifier -- needs optimizing 
			modPanel.addModToSelection (m) ui:on
			for i in selection as array do 
			(
				--add the attribute in the first modifier
				custAttributes.add i.modifiers[1] UnityAttributes 
				
			)
			
	)

	
	on execute do 
	(
		AddUnityAttribute()
	)
			

)



macroScript IBGUnityAttributesClean
category:"FlowAttributes"
toolTip:"Clean-Up Attributes Modifier"
(
			
	--filter modifier
	mdf = selection[1].modifiers[#Editable_Poly]

	mainName = selection[1].name
	origSel = selection[1]


	if (classOf origSel == Editable_Poly) then
	(
		modPanel.setCurrentObject origSel.baseobject 
		subObjectLevel = 5 
		polyop.SetFaceSelection origSel #all
		
		faces = polyop.getFaceSelection origSel
		print ("Number of faces: " + faces as string)
		polyop.detachFaces origSel faces delete:false asNode:true name:(mainName + "_cleaned") actualNodeList:&a newNodes:&b
		
		subObjectLevel = 0 
		
		delete selection
		select (getNodeByName (mainName + "_cleaned") )
		
		--delete origSel
		
		--select a 
		
		--print (origNodes as string)
		
		--a = maxOps.CloneNodes (selection) clonetype:#copy  actualNodeList:origNodes newNodes:newNodes
		--a.name = origNodes[1].name
	)
	else(
			
	)
	
)




