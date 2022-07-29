
-- 	--Remove any existing callbacks with this ID.
-- 	callbacks.removeScripts id:#FAO_
-- 	--Add a new callback script which will call --callbacks.notificationParam() before selected nodes are deleted --and thus will print the deleted objects to the Listener:
-- 	callbacks.addScript #nodeCreated " AutoLayer()" id:#MXSHelp
-- 	global flowCore 	
-- 	filein (@"C:\Program Files\Autodesk\3ds Max 2022\scripts\Startup\XMLGenerator.ms")
-- 	--load unity layers xml file
-- 	flowIns = flowCore()
	
	
	try(closeRolloutFloater theNewFloater) catch()
	--CreateDialog uiPan 
	global theNewFloater = newRolloutFloater "Flow Attributes Scene Helper" 460 860


	--Attributes System - Global Strings
	global  FlowAttributes 	 = "FlowAttributes"
	
	global 	FlowAddAtt      = "IBGUnityAttributesAdd"
	global 	FlowRmvAtt 		= "IBGUnityAttributesDelete"
		
	ObjectTypes = #("Characters", "Exteriors", "Interiors", 
	"Lights", "Props", "Structures", "Terrain", 
	"Vehicles", "VertexAnims", "Weapons" )		
		
	ObjectAttributes = #()
		
	gameData = #("Is Prefab", "Tags","Layer","Object Type","Mesh Compression","Generate Colliders","Generate Lightmaps","Import Animation",
		"Import BlendShapes","Import Cameras","Import_Lights","Import Visibility","NormalsImport","Material Creation Mode","Material Location",
		"ObjectAttributes","Preserve_Hierarchy","fileScale","Bake Xform Conversion","Use File Units","Sort Hierarchy","Keep Quads",
		"SwapChannels","UseFileScale","Material Name","Material Search","ProcGenType","Category", "TagsList", "LayersList")
		
	colorDict = Dictionary #(#Characters, color 125 89 23) #(#Exteriors, color 61 135 6) #(#Interiors, color 135 59 8) #(#Lights, color 28 149 177) #(#Props, color 176 26 26) #(#Structures, color 148 177 27) #(#Terrain, color 225 88 199) #(#Vehicles, color 8 8 136)#(#VertexAnims, color 85 28 177)#(#Weapons, color 227 153 153)                      
		
		
		
		
	LayersList = #()
	TagsList = #()
	AttrList = #()
		
	rollout srl_Stats "Attributes-Object Helper"
	(
		--obj = lst_focObj.items[item] as string 
		local selectedMesh 
		local list = #()
			
		Group "Selector Settings:"
		(		
			label lbl_filBy "Filter Objects By:"
			radiobuttons chk_filObj labels:#("None", "Layer", "Type", "Attribute", "Tag")
			dropdownList ddl_filLay "Layers" 				items:LayersList			across:4
			dropdownList ddl_filObj "Types" 				items:ObjectTypes		
			dropdownList ddl_filAtt "Attributes" 			items:AttrList
			dropdownList ddl_filTag "Tags" 					items:TagsList
				
		)
		Group "Selector:"
		(	
			button btn_selLst "Select List"							width:84	height:30	align:#left across:5
			button btn_isoObj "Isolate List"						width:83	height:30	
			button btn_endIso "End Isolate"							width:83	height:30	
			button btn_isoSel "Hide List"							width:83	height:30	
			button btn_clrsel "UnHide List"							width:83	height:30
		)
		Group "Objects List:"
		(
			listbox lst_focObj ""									width:190 	height:17	across:2		
			listbox lst_objAtt " Attributes Reader:"				width:220	height:16 	align:#center	labelontop:true	
				
			edittext edt_refLst ""									width:96	height:18	pos:[10,435]	across:3	align:#left		enabled:false	text:"  { ObjectType }"	
			button btn_selObj "Refresh List"						width:93	height:30	pos:[109,425]
			edittext edt_name ""									width:215	height:25								align:#right
					
			colorpicker pck_wirClr "" 								width:96	height:10 	align:#right pos:[10,424]	modal:false	across:3
			checkbutton chk_test "Auto-Load Attributes"				width:120	height:18   align:#right pos:[315,190] 	checked:true
			button btn_stats "Show Attributes"						width:160	height:25 	align:#right pos:[275,460]
		)
		Group "Attributes Initialtion Settings:"
		(		
			dropdownList ddl_iniLay "layer"							height:30	items:LayersList									across:4
			dropdownList ddl_iniTyp "type"							height:30	items:ObjectTypes
			dropdownList ddl_iniAtt "attribute"						height:30						
			dropdownList ddl_iniTag "tag"							height:30	items:TagsList
				
			button chk_cnLay "Convert-Layer"						width:105	height:25		align:#left 	across:4
			button chk_cnvrt "Convert-Type"							width:105	height:25		align:#center 	
			button chk_cnAtt "Convert-Attribute"					width:105	height:25		align:#right 	
			button chk_cnTag "Convert-Tag"							width:105	height:25		align:#right 	
				
			checkbutton chk_onNew "Init w/ Settings"				width:105	height:24		align:#left 		checked:true	across:3
			checkbutton chk_lowt "Init and Prep"					width:105	height:24		align:#left 		checked:true
			checkbutton chk_flpr "EMPTY BUTTON"						width:105	height:24		align:#right
		)	
		Group "Attributes Setter:"
		(
			button btn_addObj "Add to Selected"					width:32 height: 32 align:#align_topcleft images:#("PhysX_Main_24i.bmp","PhysX_Main_241.bmp",33,1,2,1,1,true,false  ) ToolTip:"Add to Selected" across:4
			button btn_genObj "Add to Scene Objects"			width:32 height: 32 align:#align_topcleft images:#("PhysX_Main_24i.bmp","PhysX_Main_241.bmp",33,30,2,1,1,true,false  ) ToolTip:"Add to Scene Objects" 
			button btn_rmvObj "Remove from Selected"			width:32 height: 32 align:#align_topcleft images:#("ViewportNavigationControls_24i.bmp","ViewportNavigationControls_24i.bmp",46,5,6,3,3,true,false  ) ToolTip:"Remove from Selected"
			button btn_kilObj "Remove from Scene Objects"		width:32 height: 32 align:#align_topcleft images:#("ViewportNavigationControls_24i.bmp","ViewportNavigationControls_24i.bmp",46,7,8,3,3,true,false  ) ToolTip:"Remove from Scene Objects"
		)
			
		------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------
		local objFilters = #("null item", ddl_filLay, ddl_filObj, ddl_filAtt, ddl_filTag)
		local objBtns = #("null item", chk_cnLay, chk_cnvrt, chk_cnAtt, chk_cnTag)
			
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		-- Gather Data from XML file -- Unity Data Hook-up 
		------------------------------------------------------------------------------------------------
			
		-- location = @""
		------------------------------------------------------------------------------------------------
		fn LoadTagDataFromXml root = 
		(
			TagsList = #()
			childNodes=root.childNodes
				
			for i = 0 to childNodes.Count-1 do 
			(
				ele = childNodes.ItemOf[i]
				eleName = ele.getAttribute "name"
					
				if eleName == "Tags" then
				(
					eleChildren = ele.childNodes
						
					for i = 0 to eleChildren.count-1 do 
					(
						child = eleChildren.ItemOf[i]
						
						--print (child.getAttribute "name")
						TagsList[i+1] = (child.getAttribute "name")
					)
				)
					
			)
				
			--pass data
			ddl_filTag.items = TagsList
			ddl_iniTag.items = TagsList
				
		)
			
		------------------------------------------------------------------------------------------------		
		fn LoadLayerDataFromXml root = 
		(
			LayersList = #()
			childNodes=root.childNodes
				
			for i = 0 to childNodes.Count-1 do 
			(
				ele = childNodes.ItemOf[i]
				eleName = ele.getAttribute "name"
					
				if eleName == "Layers" then
				(
					eleChildren = ele.childNodes
						
					for i = 0 to eleChildren.count-1 do 
					(
						child = eleChildren.ItemOf[i]
						
						--print (child.getAttribute "name")
						LayersList[i+1] = (child.getAttribute "name")
					)
				)
					
			)
				
			--pass data
			ddl_filLay.items = LayersList
			ddl_iniLay.items = LayersList
			
		)
			
		------------------------------------------------------------------------------------------------
		--
		fn ImportDataFromUnity = 
		(
			--load unity layers xml file
			filein (getDir #startupScripts + "\\XmlGenerator.ms")
			flowIns = flowCore()
			flowIns.LoadXml()
				
			--Load data 
			LoadLayerDataFromXml flowIns.xmlDoc.DocumentElement name:"Layers"
				
			--Load data 
			LoadTagDataFromXml flowIns.xmlDoc.DocumentElement name:"Tags"
			
			
			--print ("Layers List - " + LayersList as string)
			--print ("Tags List - " + TagsList as string)
			--print ("Attributes List - " + AttrList as string)
			
			
		)
			

		fn SelectObjectsBy objAttr objFilter = 
		(	
			for i in geometry do 
			(
				
				if i.modifiers[#Unity_Attributes] != undefined then 
				(
					
					if objAttr == objFilter then 
					(	
						o+=1
							
						print ("objAttr = " + objAttr as string)
						print ("objFilter = " + objFilter as string)
						list[o] = i.name as string 
						
						lst_focObj.items = list
						
					)
					
				)
				
			)
		)
		
		
		
		--refresh attribute objects list 
		fn RefreshAttributeObjectsList = 
		(
			list = #()
			o = 0
			--clear selection before selecting more?? - check here
			--clearSelection()
			lst_focObj.items = #()
				
			case chk_filObj.state of 
			(
				1:(	print "None"
					for i in Geometry do 
					(
						if i.modifiers[#Unity_Attributes] != undefined then 
						(
							o += 1
								
							list[o] = i.name as string 
								
						)
					)
				)
				2:(	
					print "Layers"	
					list = #()
					for i in geometry do 
					(
						if i.modifiers[#Unity_Attributes] != undefined then 
						(
							if i.modifiers[#Unity_Attributes].gameData.GameLayers == ddl_filLay.selection then 
							(	
								o+=1
									
								list[o] = i.name as string 
								lst_focObj.items = list
							)
						)
					)
				)
				3:(
					print "Type"
					for i in geometry do 
					(
						if i.modifiers[#Unity_Attributes] != undefined then 
						(
							if i.modifiers[#Unity_Attributes].gameData.ObjectTypes == ddl_filObj.selection then 
							(	
								o+=1
									
								list[o] = i.name as string 
								lst_focObj.items = list
							)
						)
						
					)
				)
				4:(	print "Attr"	)		
				5:
				(
					print "Tags"
					for i in geometry do 
					(						
						if i.modifiers[#Unity_Attributes] != undefined then 
						(
							if i.modifiers[#Unity_Attributes].gameData.Tags == ddl_filTag.selection then 
							(	
								o+=1
									
								list[o] = i.name as string 
								lst_focObj.items = list
							)
						)
					)
				)
				default:
				(
					print"..."	
					
				)
			)			
				
			lst_focObj.items = list
				
		)
			
		--load attributes to dialog list 
		fn GetSelectedObjectAttribute = 
		(
			lst_objAtt.items = #()
			fps = #()
			stats  = #()
				
			for i in selection as array do 
			(
				--load attributes from object
				fps = execute (getUserPropVal i "Unity Attributes" asString:true) 
					
				if fps != undefined then
				(
					
					
					for o = 1 to fps.count-2 do
					(
						if o == 2 then --name layers
						(
							if fps[30].count > 0 then 
							(
								stats[o] = (gameData[o] as string + " = { " + (fps[30][fps[o]]) as string + " }") as string
							)
							else(
								stats[o] = "{ Error Loading Data }"
							)
						)
						else if o == 3 then --name tags 
						(
							if fps[29].count > 0 then 
							(
								stats[o] = (gameData[o] as string + " = { " + (fps[29][fps[o]]) as string + " }") as string
							)
							else(
								stats[o] = "{ Error Loading Data }"
							)
						)
						else if o == 4 then --name object types
						(
							stats[o] = (gameData[o] as string + " = { " + (ObjectTypes[fps[o]]) as string + " }") as string
						)
						else
						(
							stats[o] = (gameData[o] as string + " = { " + fps[o] as string + " }") as string
						)
					)
					
					print stats 
					
					--show attributes
					lst_objAtt.items = stats
					--selected name
					edt_name.text = (selection[1].name + " - Attributes")
				)				
			)
				
			if selection.count <= 0 then 
			(
				edt_name.text = ("")
			)
			else if selection.count == 1 then 
			(				
				--no attributes found 
				if fps.count == 0 or fps == undefined then 
				(
					stats[1] = ("No Data = { no data  }")
					lst_objAtt.items = stats
				)
			)
			else 
			(
				stats[1] = ("No Data = { no data  }")
				lst_objAtt.items = stats
			)
		)
			
		--Select item from list
		fn SelectedItem item = 
		(
			--Attributes list 
			obs = #() 
			clearSelection()
			if item != undefined and item > 0 then 
			(
				iName = lst_focObj.items[item]
				
				if (getNodeByName iName) != undefined then
				(
					select (getNodeByName iName)
						
					obs = execute (getUserPropVal selection[1] "Unity Attributes" asString:true)	
						
					if obs.count != 0 then 
					(
						edt_refLst.text = ("  { " + (ObjectTypes[obs[4]]) as string + " }")
						pck_wirClr.color = selection[1].wirecolor	
							
						if chk_test.checked then 
						(
							--show selected objects attributes
							GetSelectedObjectAttribute()	
						)			
					)
					else 
					(
						--clear list
						lst_objAtt.items = #()
						
						--selected name
						edt_name.text = (selection[1].name + " - Attributes")
						
						edt_refLst.text = ("  { " + (ObjectTypes[item]) as string + " }")
						
					)
				)	
			)
		)
			
		--show attributes button 
		on btn_stats pressed do 
		(	
			--show selected objects attributes
			GetSelectedObjectAttribute()
		)
			
		--generate objects selected 
		on btn_addObj pressed do 
		(
				
-- 			for i in selection as Array do 
-- 			(
-- 				if (classof i) == EditablePolyMesh then 
-- 				(										
-- 						

-- 						
-- 				)
-- 			)	
			macros.run FlowAttributes FlowAddAtt
			
			--check if they want to use init w/ type 
			if chk_onNew.checked then 
			(
				obs = #() 				
				for o in selection as array do 
				(
						
					o.modifiers[#Unity_Attributes].gameData.ObjectTypes = ddl_iniTyp.selection
					o.modifiers[#Unity_Attributes].gameData.ObjectAttributes = ddl_iniAtt.selection				
					o.modifiers[#Unity_Attributes].gameData.GameLayers = ddl_iniLay.selection	
						
					obs = execute (getUserPropVal o "Unity Attributes" asString:true)	
						
					--changed setting
					obs[4] = ddl_iniTyp.selection
						
					--changed setting
					obs[16] = ddl_filAtt.selection
						
					--changed setting
					obs[3] = ddl_iniLay.selection
						
					--record settings	
					setUserPropVal o "Unity Attributes" obs 
						
					--set object wirecolor 
					o.wirecolor = (GetDictValue colorDict (execute( "#"+ObjectTypes[ddl_iniTyp.selection] as string)))as color 
						
				)	
			)
			if selection.count >= 1 then
			(
				--refresh list 
				RefreshAttributeObjectsList()
				--show selected objects attributes
				GetSelectedObjectAttribute()				
			)
		)
			
		--convert to type button 
		on chk_cnvrt pressed do 
		(
			--fps = #()
			obs = #() 
				
			for i in selection as array do 
			(
					
				i.modifiers[#Unity_Attributes].gameData.ObjectTypes = ddl_iniTyp.selection
				i.modifiers[#Unity_Attributes].gameData.ObjectAttributes = ddl_iniAtt.selection				
				i.modifiers[#Unity_Attributes].gameData.GameLayers = ddl_iniLay.selection
					
				obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
				print obs
				--changed setting
				obs[4] = ddl_iniTyp.selection
					
				--record settings	
				setUserPropVal i "Unity Attributes" obs 
					
			)
			
			if selection.count >= 1 then
			(
					
				--set object wirecolor 
				selection[1].wirecolor = (GetDictValue colorDict (execute( "#"+ObjectTypes[ddl_iniTyp.selection] as string)))as color 
				pck_wirClr.color = selection[1].wirecolor
					
				--selected name
				edt_name.text = (selection[1].name + " - Attributes")
				edt_refLst.text = ("  { " + (ObjectTypes[obs[4]]) as string + " }")
					
				--refresh list 
				RefreshAttributeObjectsList()
				--show selected objects attributes
				GetSelectedObjectAttribute()				
					
			)
			
			
		)
			
		--convert to attribute button 
		on chk_cnAtt pressed do 
		(
			--fps = #()
			obs = #() 
				
			for i in selection as array do 
			(
					
				i.modifiers[#Unity_Attributes].gameData.ObjectAttributes = ddl_iniAtt.selection
					
				obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
				
				--changed setting
				obs[16] = ddl_filAtt.selection
					
				--record settings	
				setUserPropVal i "Unity Attributes" obs 
					
			)
			
			if selection.count >= 1 then
			(					
				--refresh list 
				RefreshAttributeObjectsList()
				--show selected objects attributes
				GetSelectedObjectAttribute()				
					
			)
			
			
		)
			
		--convert to layer button 
		on chk_cnLay pressed do 
		(
			--fps = #()
			obs = #() 
				
			for i in selection as array do 
			(
					
				i.modifiers[#Unity_Attributes].gameData.GameLayers = ddl_iniLay.selection
					
				obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
				
				--changed setting
				obs[3] = ddl_iniLay.selection
					
				--record settings	
				setUserPropVal i "Unity Attributes" obs 
					
			)
			
			if selection.count >= 1 then
			(
					
				--refresh list 
				RefreshAttributeObjectsList()
				--show selected objects attributes
				GetSelectedObjectAttribute()				
					
			)
			
			
		)
			
		--convert to Tag button 
		on chk_cnTag pressed do 
		(
			--fps = #()
			obs = #() 
				
			for i in selection as array do 
			(
					
				i.modifiers[#Unity_Attributes].gameData.Tags = ddl_iniTag.selection
					
				obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
				
				--changed setting
				obs[2] = ddl_iniTag.selection
					
				--record settings	
				setUserPropVal i "Unity Attributes" obs 
					
			)
			
			if selection.count >= 1 then
			(
					
				--refresh list 
				RefreshAttributeObjectsList()
				--show selected objects attributes
				GetSelectedObjectAttribute()				
					
			)
			
			
		)
			
		--generate objects in scene 
		on btn_genObj pressed do 
		(
				
			for i in objects do 
			(
				if (classof i) == EditablePolyMesh then 
				(					
					print (i.name + " is missing attributes modifier" )
					
					select i
					macros.run FlowAttributes FlowAddAtt
					
					continue 
				)
			)	
				
			--refresh list 
			RefreshAttributeObjectsList()
				
		)
			
		--remove attributes from selected object
		on btn_rmvObj pressed do 
		(
				
			for i in selection as Array do 
			(
				if i.modifiers[#Unity_Attributes] != undefined or i.modifiers[1] == EmptyModifier() then 
				(		
					macros.run FlowAttributes FlowRmvAtt
				)
			)
				
			--refresh list 
			RefreshAttributeObjectsList()
				
			--show selected objects attributes
			GetSelectedObjectAttribute()
				
		)	
			
		--remove attributes from scene objects
		on btn_kilObj pressed do 
		(
			for i in objects do 
			(
				if i.modifiers[#Unity_Attributes] != undefined  then 
				(	
					print (i.name + " is missing attributes modifier" )
					selectmore i
					macros.run FlowAttributes FlowRmvAtt
						
					continue 
				)
			)	
				
			--refresh list 
			RefreshAttributeObjectsList()
				
			--show selected objects attributes
 			GetSelectedObjectAttribute()
				
		)
			
		--on radiobuttons change
		on chk_filObj changed state do
		(
			
			for i = 2 to objFilters.count do 
			(
				if (classof objFilters[chk_filObj.state]) == (classof ddl_filLay) then
				(
					--disable all filters
					objFilters[i].enabled = false
					--objBtns[i].enabled = false
					--set active filter
					objFilters[chk_filObj.state].enabled = true
					--objBtns[chk_filObj.state].enabled = true
					continue
				)
				else
				(
					--enable all filters
					objFilters[i].enabled = true
					--objBtns[i].enabled = true
				)
			)
				
			--refresh list 
			RefreshAttributeObjectsList()
			--selected item 
			SelectedItem lst_focObj.Selection
		)
			
		--listbox items
		on lst_focObj selected item do
		(
			--selected item 
			SelectedItem item
		)
			
		--refresh list 
		on btn_selObj pressed do 
		(
			--refresh list 
			RefreshAttributeObjectsList()
		)
			
		--Object type list - selected 
		on ddl_filObj selected i do 
		(
			--refresh list 
			RefreshAttributeObjectsList()
			--selected item 
			SelectedItem lst_focObj.Selection
		)
			
		--Object Layer list - selected 
		on ddl_filLay selected i do 
		(
			--refresh list 
			RefreshAttributeObjectsList()
			--selected item 
			SelectedItem lst_focObj.Selection
		)
			
		--Object Tag list - selected 
		on ddl_filTag selected i do 
		(
			--refresh list 
			RefreshAttributeObjectsList()
			--selected item 
			SelectedItem lst_focObj.Selection
		)
			
		--select list 
		on btn_selLst pressed do 
		(
			list = #()
 			clearSelection()
				
			case chk_filObj.state of 
			(
				1:
				(
					print "None"
					for o in objects do 
					(					
						if o.modifiers[#Unity_Attributes] != undefined then 
						(
							selectmore o				
						)
						else 
						(
							print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"
						)
					) 		
					--refresh list 
					RefreshAttributeObjectsList()					
				)
				2:
				(
					print "Layers"
					for i in objects do 
					(
						if i.modifiers[#Unity_Attributes] != undefined then 
						(
							if i.modifiers[#Unity_Attributes].gameData.GameLayers == ddl_filLay.selection then 
							(	
								selectmore i
							)
						)
						else 
						(	
							print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
				)
				3:
				(
					print "Type"
					for i in objects do 
					(
						if i.modifiers[#Unity_Attributes] != undefined then 
						(
							if i.modifiers[#Unity_Attributes].gameData.ObjectTypes == ddl_filObj.selection then 
							(	
								selectmore i
							)
						)
						else 
						(	
							print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
					
				)
				4:(print "Attr")
				5:
				(
					print "Tag"
					for i in objects do 
					(
						if i.modifiers[#Unity_Attributes] != undefined then 
						(
							if i.modifiers[#Unity_Attributes].gameData.Tags == ddl_filTag.selection then 
							(	
								selectmore i
							)
						)
						else 
						(	
							print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
					
				)
			)
		)
			
		--isolate list
		on btn_isoObj pressed do 
		(
			list = #()
 			clearSelection()
				
			case chk_filObj.state of 
			(
				1:
				(
					print "None"
					for o in objects do 
					(					
						if o.modifiers[#Unity_Attributes] != undefined then 
						(
							selectmore o				
							IsolateSelection.EnterIsolateSelectionMode()
						)
						else 
						(
							print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"
						)
					) 		
					--refresh list 
					RefreshAttributeObjectsList()					
				)
				2:
				(
					print "Layers"
				)
				3:
				(
					print "Type"
					for i in objects do 
					(
						if i.modifiers[#Unity_Attributes] != undefined then 
						(
							if i.modifiers[#Unity_Attributes].gameData.ObjectTypes == ddl_filObj.selection then 
							(	
								selectmore i				
								IsolateSelection.EnterIsolateSelectionMode()
							)
						)
						else 
						(	
							print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
					
				)
				4:(print "Attr")
			)

		)
			
		--end isolate
		on btn_endIso pressed do 
		(
			IsolateSelection.ExitIsolateSelectionMode()
		)
			
		on srl_stats open do 
		(
			
			try 
			(
				--import unity data
				ImportDataFromUnity()
				
				--refresh list 
				RefreshAttributeObjectsList()
					
				--Select the object list default selection
				SelectedItem lst_focObj.selection
					
			)
			catch(print "Trouble Loading Attribute-Objects List")
		)
		
		
	)

	rollout uiPan "Flow Attributes-Object Editors" width:400 height:800
	(
		
		Group "Panel Controls:"
		(					
			checkbutton btn_stats "Attributes-Object Helper" 			checked:true		height:25	across:2
		)
			
		---------------------------------------------------------------
		fn ActivateObjectHelper state = 
		(
			if state then
			(
				AddRollout srl_Stats theNewFloater	
			)
			else 
			(
				RemoveRollout srl_Stats theNewFloater	
			)	
		)
			
		on btn_stats changed state do 
		(
			ActivateObjectHelper state
			
		)
		
		on uiPan open do 
		(
			--open object helper at start -- ??
			if btn_stats.checked then
			(
				AddRollout srl_Stats theNewFloater	
			)
			else 
			(
				RemoveRollout srl_Stats theNewFloater	
			)	
			
			
			
			
		)		
		
		
	)

	--add rollouts
	addRollout uiPan theNewFloater
	
	--AddRollout srl_Stats theNewFloater
-- 	RemoveRollout srl_Stats theNewFloater
	
	