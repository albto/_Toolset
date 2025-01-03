------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


macroScript IBGUnityAttributesDelete
category:"FlowAttributes"
toolTip:"Delete Unity Attributes"
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


------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
	
	

macroScript IBGUnityAttributesAdd
category:"FlowAttributes"
toolTip:"Add Unity Attributes"
(			

	fn AddUnityAttribute = 
	(
			local modi = EmptyModifier()
			modi.name = "Unity Attributes"
				
			for i in selection as array do 
			(
				--filter modifier
				mdf = i.modifiers[#Unity_Attributes]
					
				if( (classOf mdf) == (classof modi)) then
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
					Types					type:#integer ui:ddl_ObjT 
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
					SubCategory 			type:#string ui:edt_scategFolder
					Classification 			type:#string ui:edt_classFolder
					Standardization 		type:#string ui:edt_standFolder
					ObjectComponent			type:#integer ui:ddl_ObjC
					Generate_AutoLOD		type:#integer ui:ddl_ObjC
					
					
					
				)--end Param1
					
					
					
				Rollout General "Unity Attributes" 	
				(	
						
					--Presets
					local externalFn = #("", "", "")
					local externalMod = #("", "", "", "")
					
					local GameTags = #()
					local UnityTypes = #()
					local UnityComponents = #() 
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
					local SubCategoryName = "None"
					local ClassificationName = "None"
					local StandardizationName = "None"
						
					local ObjectTypeSelection = 0	
						
					--write to file
					local fps = #()
					local obs = #()	
					-----------------------------------------------------------------------------------------------------------
						
					-----------------------------------------------------------------------------------------------------------	
						
					--Save Settings -- 
					dropdownList ddl_prst "Presets:"		--items:UnityTypes
					button btn_save "Save"		width:40	height:20	align:#left	across:3
					button btn_updt "Update"	width:50	height:20	align:#center
					button btn_load "Load"		width:40	height:20	align:#right
					
					button btn_clrs "Save and Clear" 			width:140	height:20	align:#center
						
					--------------------------------------------------------------------------------------	
						
						
					Group "Properties:"
					(
						checkbox chk_preHier "Preserve Hierarchy" 		checked:Preserve_Hierarchy
						checkbox chk_SortHier "Sort Hierarchy" 			checked:SortHierarchy

						checkbox chk_fileUnits "Use File Units" 		checked:UseFileUnits
						checkbox chk_fileScale "Use File Scale" 		checked:UseFileScale
						spinner spn_filScale "File Scale"				range:[0, 1000, fileScale]	type:#integer
						
						checkbox chk_BakeXform "Bake Axis Conversion" 	checked:BakeXformConversion
							
					)
					
					Group "Identification:"
					(
						dropdownlist 	ddl_Tags "Tag:"						items:GameTags	
						dropdownlist 	ddl_Lyrs "Layers:"					items:Layers 	
						dropdownList 	ddl_ObjT "Object Type:" 			items:UnityTypes		
					)
					
					Group "Archiving Settings:"
					(
						label 			lbl_cateName 	"Category:"			align:#left
						edittext 	 	edt_categFolder ""					offset:[-5,0]		width:110		text:CategoryName		labelOnTop:false  across:2
						button			btn_addCate 	"Add"				offset:[22,-1]
						label 			lbl_scateName 	"Sub-Category:"		align:#left
						edittext 	 	edt_scategFolder ""					offset:[0,0]		width:105		text:SubCategoryName	labelOnTop:true	 across:2
						button			btn_addScate 	"Add"				offset:[22,-1]
						edittext 	 	edt_classFolder "Classification:"	text:ClassificationName	labelOnTop:true
						edittext 		edt_standFolder "Standardization:"	text:StandardizationName	labelOnTop:true
					)
					
					Group "Gameplay Settings:"
					(
						dropdownList ddl_oAtr "Object Attributes:"		items:ObjectAttributes
						dropdownList ddl_procTyp "ProcGen Type:"		items:ProcGenType		enabled:false
						dropdownList ddl_ObjC "Object Component:" 		items:UnityComponents
						checkbutton chk_comp_1 "Move Asset Directory" 			checked:false
					)
					
					Group "Collider Settings:"
					(
						
						checkbox chk_Cols 	"Generate Colliders" 			checked:Generate_Colliders
						checkbox chk_UCC 	"Use Custom Colliders" 			--checked:Custom_Colliders
						checkbox chk_Prim 	"Use Primitive Colliders" 			--checked:Custom_Colliders	
					)
					
					Group "Unity Systems:"
					(
						checkbox chk_Lmaps "Generate Lightmaps" 		checked:Generate_Lightmaps
						checkbox chk_ALods "Generate LODs" 				checked:Generate_AutoLOD
						checkbox chk_IsPrefab "Generate Prefab" 		checked:Generate_Prefab_Asset
					)
					
					Group "Mesh Settings:"
					(
						checkbox chk_KeepQads "Keep Quads" 				checked:KeepQuads
						checkbox chk_SwapChn "Swap Channels" 			checked:SwapChannels			
						dropdownlist ddl_MshComp "Mesh Compression:" 	items:MeshComp
						dropdownlist ddl_Nmls "Normals Import:"			items:NormalsType	
						dropdownlist ddl_MCM "Material Creation Mode:"	items:MaterialsMode
						dropdownlist ddl_MLoc "Material Location"		items:MaterialsLoc
						dropdownlist ddl_MNam "Material Name"			items:MaterialsNam
						dropdownlist ddl_MSea "Material Search"			items:MaterialsSea
					)
					
					Group "Import Settings:"
					(													
						checkbox chk_Amin "Import Animation" 			checked:Import_Animation
						checkbox chk_Blnd "Import BlendShapes" 			checked:Import_BlendShapes
						checkbox chk_Cams "Import Cameras" 				checked:Import_Cameras
						checkbox chk_Lght "Import Lights" 				checked:Import_Lights
						checkbox chk_Visi "Import Visibility" 			checked:Import_Visibility
					)	
										
						
					---------------------------------------------------------------------------------
					--FUNCTIONS -- PRESETS
					---------------------------------------------------------------------------------	
					
					---------------------------------------------------------------------------------
						
					
					-----------------------------------------------------------------------------------------------------------
					-- Gather Data from XML file -- Unity Data Hook-up 
					-----------------------------------------------------------------------------------------------------------
					
					fn GetDataFromUnity = 
					(
						
						ImportDataFromUnity()
						
						--print ("OBJATTR   " + AttrList as string)
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
						UnityTypes = TypeList
							
						--Load data  - - Components
						ddl_ObjC.items = CompList						
						UnityComponents = CompList
							
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
						GetDataFromUnity()
						
						
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
							SetObjectSettings 33 TypeList
							SetObjectSettings 34 ddl_ObjC.selection
							SetObjectSettings 35 edt_scategFolder.text
							SetObjectSettings 36 CompList 
							SetObjectSettings 37 edt_standFolder.text
								
							--record settings	
							setUserPropVal i "Unity Attributes" fps 
							
						)
					)
							
					fn LoadObjectSettings =
					(
						--load data from unity xml
						GetDataFromUnity()
							
							
						for i in selection do 
						(
							obs = execute (getUserPropVal i "Unity Attributes" asString:true)
								
							--Load Settings 
							chk_IsPrefab.checked	= obs[1]
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
							edt_standFolder.text 	= obs[37]
							edt_classFolder.text	= obs[31]
							ddl_ObjC.selection		= obs[34]
							edt_scategFolder.text	= obs[35]
							
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
									UnityTypes = obs[33]
									ddl_ObjT.items = UnityTypes
								)
							)
								
							
							
							
							--ObjectTypeSelection 	= obs[4]
							
							--record settings	
							setUserPropVal i "Unity Attributes" obs ----------------------------------------------------------------------------------------------------- 
								
						)
						
					)
						
					on General open do
					(	
							
						--Load Settings
						try 
						(								
							print "Loaded Settings - Successfuly!"
							print (UnityTypes)
														
							--load tool settings
							LoadObjectSettings()						
							--Save Settings Applied
							--SaveObjectSettings()
						) 
						catch
						(  
							print "Brand New Object Detected - Applying Default Settings"
-- 							
-- 							chk_preHier.checked		= true
-- 							chk_IsPrefab.checked 	= false
-- 							ddl_Tags.selection 		= 1
-- 							ddl_Lyrs.selection 		= 1
-- 							ddl_ObjT.selection		= 1
-- 							ddl_MshComp.selection	= 2
-- 							chk_Cols.checked		= false
-- 							chk_Lmaps.checked 		= false
-- 							chk_Amin.checked 		= false
-- 							chk_Blnd.checked 		= false
-- 							chk_Cams.checked 		= false
-- 							chk_Lght.checked 		= false
-- 							chk_Visi.checked 		= false
-- 							ddl_Nmls.selection 		= 1
-- 							ddl_MCM.selection 		= 2
-- 							ddl_MLoc.selection 		= 2
-- 							ddl_MNam.selection		= 1
-- 							ddl_MSea.selection 		= 2
-- 							ddl_oAtr.selection		= 1
-- 							chk_preHier.checked 	= false
-- 							spn_filScale.value 		= 1
-- 							chk_BakeXform.checked	= true
-- 							chk_fileUnits.checked	= false
-- 							chk_fileScale.checked 	= true
-- 							chk_SortHier.checked	= true
-- 							chk_KeepQads.checked	= false
-- 							chk_SwapChn.checked		= false
-- 							ddl_procTyp.selection 	= 1
-- 							edt_categFolder.text	= "None"
-- 							edt_scategFolder.text	= "None"
-- 							edt_classFolder.text 	= "None"
-- 							edt_standFolder.text 	= "None"
-- 							ddl_ObjC.selection		= 1
								
							--Save Settings Applied
							--SaveObjectSettings()
								
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
						print val 
						
						UnityTypes = val 
						ObjectTypeSelection = ddl_ObjT.selection
						
						
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
										
					on edt_scategFolder entered val do
					(
						SubCategoryName = val
					)
						
					on edt_classFolder entered val do
					(
						Classification = val
					)
						
					on edt_standFolder entered val do
					(
						Standardization = val
					)
						
					on btn_save pressed do
					(
						--Save Settings 
						SaveObjectSettings()
						
						print "{BEGIN Saved Data:} \n" 
						
						print fps
						
						print "{END Saved Data:}" 
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
						GetDataFromUnity()
							
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
				
			sel = selection as array 
				
			for i = 1 to sel.count do 
			(			
				--add modifier -- needs optimizing 
				addModifier sel[i] (modi)
					
				--add the attribute in the first modifier
				custAttributes.add sel[i].modifiers[1] UnityAttributes 
				
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



------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


macroScript IBGBakingAttributesAdd
category:"BakingAttributes"
toolTip:"Add Baking Attributes"
(			

	fn AddBakeAttribute = 
	(
			b = EmptyModifier()
			b.name = "Baking Attributes"
				
			for i in selection as array do 
			(
				--filter modifier
				mdf = i.modifiers[#Baking_Attributes]
					
				if( (classOf mdf) == (classof b)) then
				(
					try (deleteModifier i mdf ) catch()
				)
			)
			
			Global BakingAttributes = attributes objectBakeData
			(
					
				parameters Param0 rollout:General
				(
					meshTag					type:#string ui:ddl_Tags 		
					
				)--end Param1
					
					
					
				Rollout General "Baking Attributes"
				(	
						
					--Presets
					local externalFn = #("", "", "")
					local externalMod = #("", "", "", "")
					
					local GameTags = #("Lowpoly Mesh", "Highpoly Mesh" )
					local UnityTypes = #()
					local ObjectAttributes = #()
					local Layers = #() 

						
					--write to file
					local fps = #()
					local obs = #()	
					-----------------------------------------------------------------------------------------------------------
					
					button btn_clrs "Save and Clear" 			width:140	height:20	align:#center
						
					--------------------------------------------------------------------------------------	

					
					Group "Identification:"
					(
						dropdownlist ddl_Tags "Tag:"					items:GameTags	
					)
					
						
						
					---------------------------------------------------------------------------------
					--FUNCTIONS -- PRESETS
					---------------------------------------------------------------------------------	
					
					---------------------------------------------------------------------------------
						
					
					-----------------------------------------------------------------------------------------------------------
					-- Gather Data from XML file -- Unity Data Hook-up 
					-----------------------------------------------------------------------------------------------------------
					
					fn GetDataFromUnity = 
					(
						
						ImportDataFromUnity()
						
						print ("OBJATTR   " + AttrList as string)
						--print ("ATTRLIST   " + AttrList as string)
						
							
-- 						--Load data  - - Layers 
-- 						ddl_Lyrs.items = LayersList
-- 						Layers = LayersList
-- 							
-- 						--Load data  - - Tags
-- 						ddl_Tags.items = TagsList
-- 						GameTags = TagsList
-- 							
-- 						--Load data  - - Attributes
-- 						ddl_oAtr.items = AttrList
-- 						ObjectAttributes = AttrList
-- 							
-- 						--Load data  - - Types
-- 						ddl_ObjT.items = TypeList
-- 						ObjectTypes = TypeList
-- 							
-- 						--Load data  - - Components
-- 						ddl_ObjC.items = CompList
-- 							
						--Load data  - - Something Else 
							
					)

						
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
							
							SetObjectSettings 1 GameTags[ddl_Tags.selection]
							
								
							--record settings	
							setUserPropVal i "Baking Attributes" fps 
								
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
							
						for i in selection as array do 
						(
							obs = execute (getUserPropVal i "Baking Attributes" asString:true)
								
							--Load Settings 
							chk_IsPrefab.checked 	= obs[1]
							ddl_Tags.selection 		= obs[2]
							ddl_Lyrs.selection 		= obs[3] 
															
							--record settings	
							setUserPropVal i "Baking Attributes" obs 
								
						)
						
					)
						
					on btn_clrs pressed do 
					(
						--Save Settings 
						SaveObjectSettings()
						
						macros.run "BakingAttributes" "IBGBakingAttributesClear"
						
					)
						
					on General open do
					(									
						
					)
					
					--------------------------------------------------------------------------------------
						
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						
						
				)--end MeshInfo Rollout
				
				
			)--end posAttribs
			
			--add modifier -- needs optimizing 
			modPanel.addModToSelection (b) ui:on
			for i in selection as array do 
			(
				--add the attribute in the first modifier
				custAttributes.add i.modifiers[1] BakingAttributes 
				
			)
			
	)

	
	on execute do 
	(
		AddBakeAttribute()
	)
			

)

macroScript IBGBakingAttributesClear
category:"BakingAttributes"
toolTip:"Clear Baking Attributes"
(
		
	b = EmptyModifier()
	b.name = "Baking Attributes"	
		
	for i in selection as array do 
	(
		--filter modifier
		mdf = i.modifiers[#Baking_Attributes]
		
		--Removes Attributes Modifier
		custAttributes.delete i BakingAttributes baseObject:true --add the attribute in the first modifier
			
		--checks to remove active attributes before being applied to object	
		if( (classOf mdf) == (classof b)) then
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

macroScript IBGBakingAttributesLPMesh
category:"BakingAttributes"
toolTip:"Set as Lowpoly Mesh"
(
		
	b = EmptyModifier()
	b.name = "Baking Attributes"	
		
	obs = #()
	
	
	for i in selection as array do 
	(
		--changed setting
		obs[1] = "Lowpoly Mesh"
		
		--record settings	
		setUserPropVal i "Baking Attributes" obs 	
	)
	
)

macroScript IBGBakingAttributesHPMesh
category:"BakingAttributes"
toolTip:"Set as Highpoly Mesh"
(
		
	b = EmptyModifier()
	b.name = "Baking Attributes"	
		
	obs = #()
	
	
	for i in selection as array do 
	(
		--changed setting
		obs[1] = "Highpoly Mesh"
		
		--record settings	
		setUserPropVal i "Baking Attributes" obs 	
	)
	
)





------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------















