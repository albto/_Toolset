
-- 	--Remove any existing callbacks with this ID.
-- 	callbacks.removeScripts id:#FAO_
-- 	--Add a new callback script which will call --callbacks.notificationParam() before selected nodes are deleted --and thus will print the deleted objects to the Listener:
-- 	callbacks.addScript #nodeCreated " AutoLayer()" id:#MXSHelp
	
	
	try(closeRolloutFloater theNewFloater) catch()
		--CreateDialog uiPan 
	global theNewFloater = newRolloutFloater "Flow Attributes Scene Helper" 460 880
	

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- 
	-----------------------------------------------------------------------------------------------------------------------------------------
		
		
	--load unity layers xml file
	filein ((mainFPFolder + "\\FlowPanels\\_base\\XMLGenerator.ms") as String ) 
	flowIns = flowCore()
	flowIns.LoadXml()
		
	-----------------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
				
	gameData = #("Is Prefab", "Tags","Layer","Object Type","Mesh Compression","Generate Colliders","Generate Lightmaps","Import Animation",
		"Import BlendShapes","Import Cameras","Import_Lights","Import Visibility","NormalsImport","Material Creation Mode","Material Location",
		"ObjectAttributes","Preserve_Hierarchy","fileScale","Bake Xform Conversion","Use File Units","Sort Hierarchy","Keep Quads",
		"SwapChannels","UseFileScale","Material Name","Material Search","ProcGenType","Category", "TagsList", "LayersList")
		
	colorDict = Dictionary #(#Character, color 125 89 23) #(#Exteriors, color 6 61 135) #(#Interior, color 135 59 8) #(#Light, color 28 149 177) #(#Prop, color 176 26 26) #(#Structure, color 225 88 199) #(#Terrain, color 148 177 27) #(#Vehicle, color 8 8 136)#(#VertexAnim, color 85 28 177)#(#Weapons, color 227 153 153)                      
		
	clrARR = #(#Character)

		
	--write to file
	fps = #()
	obs = #()
		
	rollout srl_Stats "Unity Attributes Helper"
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
			button btn_hidSel "Hide List"							width:83	height:30	
			button btn_unhsel "UnHide List"							width:83	height:30
		)
		Group "Objects List:"
		(
			listbox lst_focObj ""									width:190 	height:17	across:2		
			listbox lst_objAtt " Attributes Reader:"				width:220	height:16 	align:#center	labelontop:true	
				
			edittext edt_refLst ""									width:96	height:18	pos:[10,435]	across:3	align:#left		enabled:false	text:"  { ObjectType }"	
			button btn_selObj "Refresh List"						width:93	height:30	pos:[109,425]
			edittext edt_name ""									width:215	height:25								align:#right
					
			colorpicker pck_wirClr "" 								width:96	height:10 	align:#right pos:[10,424]	modal:false	across:3
			checkbutton chk_test "Auto-Load Attributes"				width:120	height:18   align:#right pos:[315,190] 	checked:false
			button btn_stats "Show Attributes"						width:160	height:25 	align:#right pos:[275,460]
		)
		Group "Unity Layers Helper"
		(
			dropdownlist ddl_lay_gen ""								height:30	items:LayersList	across:2
			button btn_lay_gen "Create Layer"						width:90	height:25 	align:#right pos:[227,515]
			button btn_all_gen "Sync All"							width:90	height:25 	align:#right pos:[320,515]
		)		
		Group "Initialtion and Conversion Settings:"
		(		
			dropdownList ddl_iniLay "layer"							height:30	items:LayersList									across:4
			dropdownList ddl_iniTyp "type"							height:30	items:ObjectTypes
			dropdownList ddl_iniAtt "attribute"						height:30						
			dropdownList ddl_iniTag "tag"							height:30	items:TagsList
				
			button chk_cnLay "Convert-Layer"						width:105	height:25		align:#left 	across:4
			button chk_cnvrt "Convert-Type"							width:105	height:25		align:#center 	
			button chk_cnAtt "Convert-Attribute"					width:105	height:25		align:#right 	
			button chk_cnTag "Convert-Tag"							width:105	height:25		align:#right 	
				
		)	
		Group "Attributes Setter:"
		(
			checkbutton chk_onNew "Use Init Settings"				width:105	height:24		align:#left 		checked:true	across:4
			checkbutton chk_inPre "Init and Prep"					width:105	height:24		align:#left 		checked:true
			checkbutton chk_inMod "Init w/o Modifier"						width:105	height:24		align:#right
			checkbutton chk_inSet "Init from Preset"						width:105	height:24		align:#right
			
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
			
		------------------------------------------------------------------------------------------------
		--load and distribute xml data to types dropdownList
		fn GetTypesFromXmlData root = 
		(
			--global function 
			LoadTypesDataFromXml root
			--pass data
			ddl_filObj.items = TypeList
			ddl_iniTyp.items = TypeList
			
		)
			
		------------------------------------------------------------------------------------------------
		--load and distribute xml data to types dropdownList
		fn GetComponentsFromXmlData root = 
		(
			--global function 
			LoadComponentsDataFromXml root
				
			--pass data
			ObjectComponents = CompList
			
		)
		
		-- location = @""
		------------------------------------------------------------------------------------------------
		--load and distribute xml data to tags dropdownList
		fn GetTagsFromXmlData root = 
		(
			--global function 
			LoadTagDataFromXml root
				
			--pass data
			ddl_filTag.items = TagsList
			ddl_iniTag.items = TagsList
				
		)
			
		------------------------------------------------------------------------------------------------		
		--load and distribute xml data to layers dropdownList
		fn GetLayersFromXmlData root = 
		(
			--global function 
			LoadLayerDataFromXml root
				
			--pass data
			ddl_filLay.items = LayersList
			ddl_iniLay.items = LayersList
			ddl_lay_gen.items = LayersList
			
		)
			
		------------------------------------------------------------------------------------------------	
		--load and distribute xml data to attributes dropdownList
		fn GetAttributesFromXmlData root = 
		(
			--global function 
			LoadAttributeDataFromXml root
				
			--pass data
			ddl_filAtt.items = AttrList
			ddl_iniAtt.items = AttrList
			
		)
		------------------------------------------------------------------------------------------------
		--import data from the unity xml 
		fn ImportDataFromUnity = 
		(
			--load xml data 
			flowIns.LoadXml()
			
			--Load layers data 
			GetLayersFromXmlData flowIns.xmlDoc.DocumentElement name:"Layers"
				
			--Load tags data 
			GetTagsFromXmlData flowIns.xmlDoc.DocumentElement name:"Tags"
				
			--Load attributes data 
			GetAttributesFromXmlData flowIns.xmlDoc.DocumentElement name:"Attributes"
				
			--Load types data 
			GetTypesFromXmlData flowIns.xmlDoc.DocumentElement name:"Types"
				
			--Load components data 
			GetComponentsFromXmlData flowIns.xmlDoc.DocumentElement name:"Components"
			
			--print ("Layers List - " + LayersList as string)
			--print ("Tags List - " + TagsList as string)
			--print ("Attributes List - " + AttrList as string)
				
		)
			
		--Load prop attributes from selection 
		fn GetUnityPropVal nod = 
		(
			local str 
			try 
			(
				str = (getUserPropVal nod "Unity Attributes" asString:true)
			)
			catch ("FlowError - { Can't Find ::Flow_Attribute_Objects:: }")
			return str 
		)
		
		fn SelectObjectsBy objAttr objFilter = 
		(	
			for i in geometry do 
			(
				str = (getUserPropVal i "Unity Attributes" asString:true)
							
				--print (doesUserPropExist i "Unity Attributes")						
						
				if (str != undefined) do
				(
					
					if objAttr == objFilter then 
					(	
						o+=1
							
						--print ("objAttr = " + objAttr as string)
						--print ("objFilter = " + objFilter as string)
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
				1:(	
					--print "None"
					for i in objects do 
					(
						str = (getUserPropVal i "Unity Attributes" asString:true)
							
						--print (doesUserPropExist i "Unity Attributes")						
						
						if (str != undefined) do
						(
							o += 1	
							--print str[o]
							list[o] = i.name as string 
						)
							
					)
				)
				2:(	
					--print "Layers"	
					list = #()
					for i in objects do 
					(
						str = (getUserPropVal i "Unity Attributes" asString:true)
						propValArr = execute (str as string )
							
						if str != undefined do 
						(
							if (propValArr[3]) == ddl_filLay.selection then 
							(
								o+=1
									
								list[o] = i.name as string 
								lst_focObj.items = list
							)
							continue
						)
					)
				)
				3:(
					--print "Type"
					for i in objects do 
					(
						str = (getUserPropVal i "Unity Attributes" asString:true)
						propValArr = execute (str as string )
							
						if str != undefined do 
						(
							if (propValArr[4]) as string ==  ddl_filObj.selection as string then 
							(
								o+=1
									
								list[o] = i.name as string 
								lst_focObj.items = list
							)
							continue
						)
					)
				)
				4:(	
					--print "Attr"
					for i in objects do 
					(
						str = (getUserPropVal i "Unity Attributes" asString:true)
						propValArr = execute (str as string )
							
						if str != undefined do 
						(
							--print  (propValArr[16]) 
							if (propValArr[16]) == ddl_filAtt.selection then 
							(
								o+=1
									
								list[o] = i.name as string 
								lst_focObj.items = list
							)
							continue
						)						
					)				
				)		
				5:
				(
					--print "Tags"
					for i in objects do 
					(						
						str = (getUserPropVal i "Unity Attributes" asString:true)
						propValArr = execute (str as string)
							
						if str != undefined do 
						(
							if (propValArr[2]) == ddl_filTag.selection then 
							(	
									o+=1
										
									list[o] = i.name as string 
									lst_focObj.items = list
								
							)
							continue
						)
					)
				)
				default:
				(
					--print"..."	
					
				)
			)			
				
			lst_focObj.items = list
				
		)
			
		--load attributes to dialog list 
		fn GetSelectedObjectAttribute = 
		(
			lst_objAtt.items = #()
			fps = undefined
			stats  = #()
			edt_name.text = ("")
				
			for i in selection as array do 
			(
				propVals = getUserPropVal i "Unity Attributes" asString:true
				
				if propVals != undefined do 
				(
					--load attributes from object
					fps = execute(propVals) 
				)
					
				if fps == undefined then 
				(
					stats[1] = ("No Data = { no data  }")
					lst_objAtt.items = stats	
						
					--selected name
					edt_name.text = (selection[1].name + " - No Attributes")
					
					edt_refLst.text = ("  { " + (ObjectTypes) as string + " }")
				)
				else if fps != undefined then
				(					
					if fps.count > 1 then 
					(						
						
						for o = 1 to fps.count-2 do
						(
							if o == 2 then --name layers
							(
								if fps[30] != undefined do 
								(
									if fps[30].count > 0 then 
									(
										stats[o] = (gameData[o] as string + " = { " + (fps[30][fps[o]]) as string + " }") as string
									)
									else(
										stats[o] = "{ Error Loading Data }"
									)
								)
							)
							else if o == 3 then --name tags 
							(
								if fps[29] != undefined do 
								(
									if fps[29].count > 0 then 
									(
										stats[o] = (gameData[o] as string + " = { " + (fps[29][fps[o]]) as string + " }") as string
									)
									else(
										stats[o] = "{ Error Loading Data }"
									)
								)
							)
							else if o == 4 then --name object types
							(
								stats[o] = (gameData[o] as string + " = { " + (TypeList[fps[o]]) as string + " }") as string
							)
							else if o == 16 then --name tags 
							(
								stats[o] = (gameData[o] as string + " = { " + (AttrList[fps[16]]) as string + " }") as string
							)
							else
							(
								stats[o] = (gameData[o] as string + " = { " + fps[o] as string + " }") as string
							)
						)
					)					
					--print stats 
					
					--show attributes
					lst_objAtt.items = stats
					--selected name
					edt_name.text = (selection[1].name + " - Attributes")
				)							
				if selection.count <= 0 then 
				(
					edt_name.text = ("")
				)
-- 				else if selection.count == 1 then 
-- 				(				
-- 						stats[1] = ("No Data = { no data  }")
-- 						lst_objAtt.items = stats
-- 				)
-- 				else 
-- 				(
-- 					stats[1] = ("No Data = { no data  }")
-- 					lst_objAtt.items = stats
-- 				)
			)
		)
			
		--Select item from list
		fn SelectedItem item = 
		(
			if (obs[4] != undefined and ObjectTypes.count > 0) then 
			( 
				
				--Attributes list 
				obs = #() 
				--clearSelection()
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
				
		)
			
		--show attributes button 
		on btn_stats pressed do 
		(	
			--show selected objects attributes
			GetSelectedObjectAttribute()
		)

		--convert to type button 
		on chk_cnvrt pressed do 
		(
			--fps = #()
			obs = #() 
				
			for i in selection as array do 
			(
					
				obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
				
				--changed setting
				obs[4] = ddl_iniTyp.selection
					
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
			
		--convert to attribute button 
		on chk_cnAtt pressed do 
		(
			--fps = #()
			obs = #() 
				
			for i in selection as array do 
			(
				obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
				
				--changed setting
				obs[16] = ddl_iniAtt.selection
					
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
				if (getUserPropVal i "Unity Attributes" asString:true) != undefined then 
				(
					--load Selection's Unity Attributes 
					obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
						
					--changed setting
					obs[3] = ddl_iniLay.selection
					
					--record settings	
					setUserPropVal i "Unity Attributes" obs 
				)
				else(continue)
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
					
				--load Selection's Unity Attributes 
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
					
		--generate objects selected 
		on btn_addObj pressed do 
		(
			--create array
			obs = #() 	
			for o in selection as array do 
			(		
				--check if they want to set attributes without modifier
				if chk_inMod.checked then 
				(
						str = getUserPropVal o "Unity Attributes" asString:true
						if str != undefined do 
						(
							obs = execute(str as string)
						)
							
						-- set settings --------------------
						------------------------------------
						obs [1] 	=false
						obs [2] 	=1
						obs [3] 	=1
						obs [4] 	=1
						obs [5] 	=1
						obs [6] 	=true 			
						obs [7] 	=true
						obs [8]		=false	
						obs [9] 	=false	
						obs [10] 	=false	
						obs [11] 	=false
						obs [12]	=false
						obs [13] 	=1
						obs [14] 	=1	
						obs [15] 	=1	
						obs [16] 	=1
						obs [17] 	=false	
						obs [18] 	=1
						obs [19] 	=true     
						obs [20] 	=false 			
						obs [21] 	=true			
						obs [22] 	=true 				
						obs [23] 	=false			
						obs [24] 	=false 	
						obs [25] 	=1 	
						obs [26] 	=2
						obs [27]	=2
						obs [28] 	="None"
						obs [29] 	=LayersList
						obs [30] 	=TagsList
							
						--record settings	
						setUserPropVal o "Unity Attributes" obs 
						
				)
				else 
				(		
					macros.run FlowAttributes FlowAddAtt
				)
					
				--check if they want to use init w/ type 
				if chk_onNew.checked then 
				(						
					str = getUserPropVal o "Unity Attributes" asString:true
					if str != undefined do 
					(
						obs = execute(str)
						--print obs
					)						
						
					--check if they want to set attributes without modifier 
					if chk_inMod.checked then 
					(
						--changed setting
						obs[4] = ddl_iniTyp.selection
							
						--changed setting
						obs[16] = ddl_filAtt.selection
							
						--changed setting
						obs[3] = ddl_iniLay.selection
							
						--changed setting
						obs[2] = ddl_iniTag.selection
					)
					else 
					(
						--set modifier settings
						o.modifiers[#Unity_Attributes].gameData.ObjectTypes 		= ddl_iniTyp.selection
						o.modifiers[#Unity_Attributes].gameData.ObjectAttributes 	= ddl_iniAtt.selection				
						o.modifiers[#Unity_Attributes].gameData.GameLayers 			= ddl_iniLay.selection	
						o.modifiers[#Unity_Attributes].gameData.Tags 				= ddl_iniTag.selection						
							
						--changed setting
						obs[4] = ddl_iniTyp.selection
							
						--changed setting
						obs[16] = ddl_filAtt.selection
							
						--changed setting
						obs[3] = ddl_iniLay.selection
							
						--changed setting
						obs[2] = ddl_iniTag.selection
							
						--set object wirecolor 
						--o.wirecolor = (GetDictValue colorDict clrARR[ddl_iniTyp.selection]  as color)
					)
						
					--record settings	
					setUserPropVal o "Unity Attributes" obs 
						
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
			
		--generate objects in scene 
		on btn_genObj pressed do 
		(
				
			for i in geometry do 
			(
				str = (getUserPropVal i "Unity Attributes" asString:true)
				--print str 
							
				if (str == undefined) then
				(					
					--print (i.name + " is missing attributes modifier" )
					
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
				str = (getUserPropVal i "Unity Attributes" asString:true)
				--print str 
							
				if (str != undefined) then
				(		
					macros.run FlowAttributes FlowRmvAtt
				)
			)
				
			clearSelection()
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
				str = (getUserPropVal i "Unity Attributes" asString:true)
				--print str 
							
				if (str != undefined) then
				(	
					--print (i.name + " is missing attributes modifier" )
					selectmore i
					macros.run FlowAttributes FlowRmvAtt
						
					continue 
				)
			)	
				
				
			clearSelection()
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
			
		--------------------------------------------------------------------------------------------------------------------------------		
			
		--------------------------------------------------------------------------------------------------------------------------------
			
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
			
		--Object Att list - selected 
		on ddl_filAtt selected i do 
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
			
		--------------------------------------------------------------------------------------------------------------------------------		
			
		--------------------------------------------------------------------------------------------------------------------------------
			
		--select list 
		on btn_selLst pressed do 
		(			
				
			case chk_filObj.state of 
			(
				1:
				(
					--print "None"
					for o in geometry do 
					(					
						
						str = (getUserPropVal (o as object)  "Unity Attributes" asString:true)
							
							
						if (str != undefined) then
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
					--print "Layers"
					for i in geometry do 
					(
						str = (getUserPropVal i "Unity Attributes" asString:true)
						propValArr = execute (str as string )
							
						if str != undefined do 
						(
							if (propValArr[3]) == ddl_filLay.selection then 
							(	
								selectmore i
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)						
					)
					--refresh list 
					RefreshAttributeObjectsList()
				)
				3:
				(
					--print "Type"
					for i in geometry do 
					(
						str = (getUserPropVal i "Unity Attributes" asString:true)
						propValArr = execute (str as string )
							
						if str != undefined do 
						(
							if (propValArr[4]) == ddl_filObj.selection then 
							(	
								selectmore i
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
					
				)
				4:(
					--print "Attr"
					for i in geometry do 
					(
						str = (getUserPropVal i "Unity Attributes" asString:true)
						propValArr = execute (str as string )
							
						if (propValArr[16]) == ddl_filAtt.selection then 
						(	
							selectmore i
						)
						else 
						(	
							print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
						)
					)

					)
				5:
				(
					--print "Tag"
					for i in geometry do 
					(
						str = (getUserPropVal i "Unity Attributes" asString:true)
						propValArr = execute (str as string )
							
						
						if (propValArr[2]) == ddl_filTag.selection then 
						(	
							selectmore i
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
					--print "None"
					for o in geometry do 
					(					
						str = GetUnityPropVal o
						
						if (str != undefined) then 
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
					--print "Layers"
					for i in geometry do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(
							if (propValArr[3]) == ddl_filLay.selection then 
							(	
								selectmore i				
								IsolateSelection.EnterIsolateSelectionMode()
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
				)
				3:
				(
					--print "Type"
					for i in geometry do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(		
							if (propValArr[4]) == ddl_filObj.selection then 
							(	
								selectmore i				
								IsolateSelection.EnterIsolateSelectionMode()
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
					
				)
				4:(
					--print "Attr"
					for i in geometry do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(	
							if (propValArr[16]) == ddl_filAtt.selection then 
							(	
								selectmore i				
								IsolateSelection.EnterIsolateSelectionMode()
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
				)
				5:(
					--print "Tag"
					for i in geometry do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(	
							if (propValArr[2]) == ddl_filTag.selection then 
							(	
								selectmore i				
								IsolateSelection.EnterIsolateSelectionMode()
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
				)
			)

		)
			
		--end isolate
		on btn_endIso pressed do 
		(
			IsolateSelection.ExitIsolateSelectionMode()
		)
			
		--hide list
		on btn_hidSel pressed do 
		(
			list = #()
 			clearSelection()
				
			case chk_filObj.state of 
			(
				1:
				(
					--print "None"
					for o in geometry do 
					(					
						upv = GetUnityPropVal o
						
						if (upv != undefined) then 
						(
							selectmore o				
							hide o
							continue
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
					--print "Layers"
					for i in geometry do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(		
							if (propValArr[3]) == ddl_filLay.selection then 
							(	
								selectmore i				
								hide i
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
				)
				3:
				(
					--print "Type"
					for i in geometry do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(		
							if (propValArr[4]) == ddl_filObj.selection then 
							(	
								selectmore i				
								hide i
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
					
				)
				4:(
					--print "Attr"
					for i in geometry do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(						
							if (propValArr[16]) == ddl_filAtt.selection then 
							(	
								selectmore i				
								hide i 
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
				)
				5:(
					--print "Tag"
					for i in geometry do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(		
							if (propValArr[2]) == ddl_filTag.selection then 
							(	
								selectmore i				
								hide i 
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
				)
			)
		)
			
		--unhide list
		on btn_unhSel pressed do 
		(
			list = #()
 			clearSelection()
				
			case chk_filObj.state of 
			(
				1:
				(
					--print "None"
					for o in objects do 
					(					
						str = GetUnityPropVal o
						
						if (str != undefined) then 
						(
							selectmore o				
							unhide o
							continue
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
					--print "Layers"
					for i in objects do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(		
							if (propValArr[3]) == ddl_filLay.selection then 
							(	
								selectmore i				
								unhide i
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
				)
				3:
				(
					--print "Type"
					for i in objects do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(		
							if (propValArr[4]) == ddl_filObj.selection then 
							(	
								selectmore i				
								unhide i 
								
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
					--refresh list 
					RefreshAttributeObjectsList()
					
				)
				4:(
					--print "Attr"
					for i in objects do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(	
							if (propValArr[16]) == ddl_filAtt.selection then 
							(	
								selectmore i				
								unhide i 
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
				)
				5:(
					--print "Tag"
					for i in objects do 
					(
						--get unity prop value 
						upv = GetUnityPropVal i
						propValArr = execute (upv as string )
							
						if upv != undefined do 
						(		
							if (propValArr[2]) == ddl_filTag.selection then 
							(	
								selectmore i				
								unhide i 
							)
							else 
							(	
								print "FlowError - { Can't Find ::Flow_Attribute_Objects:: }"	
							)
						)
					)
				
				)
			)
		)
			
		--------------------------------------------------------------------------------------------------------------------------------		
			
		--------------------------------------------------------------------------------------------------------------------------------
			
		on srl_stats open do 
		(
			--try 
			(
				--import unity data
				ImportDataFromUnity()
				
				--refresh list 
				RefreshAttributeObjectsList()
					
				--Select the object list default selection
				SelectedItem lst_focObj.selection
					
			)
			--catch(print "Trouble Loading Attribute-Objects List")
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
		

	-------------------------------------------------------------------------------------------------------------------------------------------------


	-------------------------------------------------------------------------------------------------------------------------------------------------

			
			
		--callbacks
		callbacks.removeScripts id:#flowCallbacks
			
		callbacks.addScript #filePostOpenProcess "srl_Stats.RefreshAttributeObjectsList()" id:#flowCallbacks
					
		--callbacks
		callbacks.removeScripts id:#flowAttCallbacks
			
		--callbacks.addScript #postModifierAdded "srl_Stats.RefreshAttributeObjectsList()" id:#flowAttCallbacks	
			
		--callbacks.addScript #preModifierAdded "srl_Stats.RefreshAttributeObjectsList()" id:#flowAttCallbacks
		
		callbacks.addScript #modPanelObjPostChange "srl_Stats.RefreshAttributeObjectsList()" id:#flowAttCallbacks




	-------------------------------------------------------------------------------------------------------------------------------------------------


	--AddRollout srl_Stats theNewFloater
-- 	RemoveRollout srl_Stats theNewFloater

