
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
			
			
			print ("Layers List - " + LayersList as string)
			print ("Tags List - " + TagsList as string)
			print ("Attributes List - " + AttrList as string)
			
			
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
				
				if iName != undefined then
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
						
					obs = execute (getUserPropVal o "Unity Attributes" asString:true)	
					
					--changed setting
					obs[4] = ddl_iniTyp.selection
						
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
					
				obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
				
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
		
	rollout srl_Materials "Materials"
	(
		
		local selectedMat
		local mapArr = #("ab", "rg", "nm", "op", "mt", "ao", "hg", "em")
		
		Group "MatLib Directory Helper: "
		(
			
			button btn_crt_mtlb "Save"												width:70 	height:22		across:2 							--offset:[90,0]
			button btn_open_mtlb "Open" 											width:70 	height:22											--offset:[22,0]
		)
			
		Group "MatLib Presets: "
		(
			edittext 	edt_mtlb_name "New Preset Name:"	 						width:260 	height:20 		across:2				
			button 		btn_mtlb_prst "Create New Library Preset"												enabled:false						offset:[28,0]	
			label 		lbl_mtlb_list "MatLib Presets: " 														across:4							offset:[-14,0]
			dropdownList ddl_mtlb_list ""											width:172					labelontop:false 					offset:[-20,0]
			button 		btn_sel_mtlb "Load Library"																									offset:[35,0]
			button 		btn_sav_mtlb "Save Library"																									offset:[10,0]		
			
			listbox 	lst_crnt_mtlb "Current Loaded Library:"						height:2					across:3							offset:[-02, 00]
			listbox 	lst_mtlb_mats "Library Materials:"							height:14
			bitmap 		bmp_img "test"  																			offset:[01, 15]		
			
			
			button 		btn_mat_sme   "Edit Material in SME"						width:138					across:5							offset:[10,-160]
			button 		btn_mat_opn   "Open Material in SME"						width:138														offset:[-70,-138]
			button 		btn_mat_aply  "Apply Material to Selected"					width:138														offset:[-142,-116]
			button 		btn_open_maps "Open Map Locations"							width:138														offset:[-240,-94]
			button 		btn_add_fsel  "Add Material from Selected"							width:138												offset:[-308,-72]
			radiobuttons rad_dbg_maps ""											columns:4					labels:mapArr						offset:[145,-5]
				
			
			edittext 		edt_mat_name "Material Name:" 								width:280													offset:[00,17]	
			checkbutton 	chk_ab_map "ab"												width:30							across:8				offset:[-15,00]				
			checkbutton 	chk_rg_map "rg"												width:30													offset:[-35,00]	
			checkbutton 	chk_nm_map "nm"												width:30													offset:[-55,00]				
			checkbutton 	chk_op_map "op"												width:30													offset:[-75,00]	
			checkbutton 	chk_mt_map "mt"												width:30													offset:[-95,00]	
			checkbutton 	chk_ao_map "ao"												width:30													offset:[-115,00]	
			checkbutton 	chk_hg_map "hg"												width:30													offset:[-135,00]	
			checkbutton 	chk_em_map "em"												width:30													offset:[-155,00]	
			checkbutton 	chk_bk_map "  "												width:30													offset:[57,-26]		enabled:false
			label 			lbl_space 	""												height:5
		)
			
		Group "Material Toolkit: "
		(
			checkbutton chk_mtlb_slnt "Open SME"									height:25 					across:3		checked:false   	offset:[-40,0]
			button 		btn_comb_mats "Create Combined MultiMat"					height:25 														offset:[-70,0]
			button 		btn_apnd_mtl  "Add Selected Material to Current MatLib"		height:25														offset:[-30,0]
			--timer 	tck_updt_mtlb ""		interval:100
			spinner 	spn_uv_ctrl "UVs Scaler"   									width:280		           	range:[0, 1000, 100]				offset:[00,00]
			
		)
		----------------------------------------------------------------------------------------------------------
		
-- 		on tck_updt_mtlb tick do 
-- 		(
-- 			--print "tick" 
-- 			
-- 			
-- 		)
		
		
		local mapCtrlArr = #(chk_ab_map, chk_rg_map, chk_nm_map, chk_op_map, chk_mt_map, chk_ao_map, chk_hg_map, chk_em_map)
		
		
		
		--Load Library Buttton - function 
		fn LoadSelectedLibraryFromList = 
		(
			if ddl_mtlb_list.items.count > 0 then 
			(
				if sme.isOpen() then 
				(
					sme.close()
				)
					
				--load the selected material library from the mtlb list 
				lib = loadMaterialLibrary (ddl_mtlb_list.selected + ".mat") as string
				print ("Loaded Library Successfully: " + lib as string )
					
				--object usable list 
				loadedLib = currentMaterialLibrary
					
				--display current matlib's name 
				arr = #( filenameFromPath ( getMatLibFileName() ) )
				lst_crnt_mtlb.items = arr
					
				lst = #()
				lst_mtlb_mats.items = lst
				--print loadedLib.count
				if loadedLib.count > 0 then 
				(
					for i = 1 to loadedLib.count do 
					(
						lst[i] = loadedLib[i] as string 
					)			
					
					lst_mtlb_mats.items = lst
					
				)	
					
				if chk_mtlb_slnt.checked then 
				(
					sme.open()
				)
			)
			else(
				print "No Material Libraries Found"
			)
			
		)
		--refresh list of custom material libraries
		fn LoadCustomMLs = 
		(
			mtlbDir = getdir #matlib 
			files = getfiles (mtlbDir + "\\*.mat")
			fileNames = #()
			for i = 1 to files.count do 
			(
				fileNames[i] = filenameFromPath (files[i])
				
				str = substituteString fileNames[i] ".mat" ""
				fileNames[i] = str
			)
			
			if files.count > 0 then 
			(
				ddl_mtlb_list.items = fileNames 
			)
			
		)
		
		--checks if the selectMaterials maps exists and displays the preview 
		fn GetMaterialMaps map = 
		( 
			
					
			if (classof map) == MultiOutputChannelTexmapToTexmap then 
			(
				if map.sourcemap != undefined then 
				(
					strng = filenameFromPath (map.sourcemap.filename)
						
					--#PSEUDO
					if (matchpattern strng pattern:"*_MaskMap*") or (matchpattern strng pattern:"*_mm*")then
					(
						--split channel 
						print "Channel Belongs to _MaskMap"
					)					
					
					print ("Texmap: " + filenameFromPath(map.sourcemap.filename) + " is present")
						
					bmp_img.filename = map.sourcemap.filename
						
					p = (bitmap 128 128 color: (color 0 0 0 0))
					copy bmp_img p
						
					bmp_img.filename = p.filename
						
				)
			)
			else
			(
				print ("no " + map as string + " is present")	
				
				bmp_img.filename = "C:\Users\albto\OneDrive\Documents\GitHub\_Toolset\FlowPanels\_base\error.png"
				p = (bitmap 132	132 color:(color 0 0 0 0))
				print p.hasAlpha 
				print (getChannel p [0,0] #UVCoords)
				copy bmp_img p
					
				if map == undefined then 
				(
					
				)
					
				bmp_img.filename = p.filename
				bmp_img
			)
		)
				
		--Gets the selected material 
		fn GetSelectedMaterial = 
		(
			if lst_mtlb_mats.items.count > 0 then
			(
				selectedMat = currentMaterialLibrary [lst_mtlb_mats.selection]
					
				--get material name 
				edt_mat_name.text = selectedMat.name 
			)
			else
			(
				--clear material name 
				edt_mat_name.text = "" 
			)
		)
						
		--switch the map displayed on the preview window 
		fn FilterMaterialMapsDisplay =
		(
			--get selected Material
			GetSelectedMaterial()
				
			--grab maps from material
			ab = selectedMat.base_color_map
			rg = selectedMat.roughness_map
			nm = selectedMat.norm_map 	
			op = selectedMat.opacity_map
			mt = selectedMat.metalness_map
			ao = selectedMat.ao_map
			hg = selectedMat.displacement_map
			em = selectedMat.emit_color_map
				
			mapArr = #(ab, rg, nm, op, mt, ao, hg, em)
				
			--set map checkbutton status 
			for i = 1 to mapArr.count do 
			(
				map1 = mapArr[i]
				
				if (classof map1) == MultiOutputChannelTexmapToTexmap then 
				(
					   
					if map1.sourcemap != undefined then 
					(
						print (map1.outputChannelIndex) 
						mapCtrlArr[i].enabled = true
						mapCtrlArr[i].checked = true
					)
				)
				else(mapCtrlArr[i].enabled = false; mapCtrlArr[i].checked = false)
			)
				
				
			case rad_dbg_maps.state of 
			(
				1: 	GetMaterialMaps ab 
				2: 	GetMaterialMaps rg 
				3: 	GetMaterialMaps nm
				4: 	GetMaterialMaps op
				5: 	GetMaterialMaps mt
				6: 	GetMaterialMaps ao
				7: 	GetMaterialMaps hg
				8: 	GetMaterialMaps em
				--default: selectedMat = currentMaterialLibrary [item]
			)
		)		
		
		
		
		
		
		
		

		
		----------------------------------------------------------------------------------------------------------
			
		
		on btn_mat_aply pressed do 
		(
			for i in (selection as array) do 
			(
				if selectedMat != undefined then 
				(
					i.mat = selectedMat
				)
			)
			
		)
		
		on edt_mat_name changed txt do 
		(
			
		)
			
			
		on edt_mtlb_name changed txt do 
		(
			if txt.count > 0 then 
			(
				btn_mtlb_prst.enabled = true 
			)
			else(
				btn_mtlb_prst.enabled = false
			)
		)
			
			
		--create new preset 
		on btn_mtlb_prst pressed do 
		(
			if edt_mtlb_name.text.count > 0 then 
			(				
				--save new preset to default matlib directory
				libPath = getdir #matlib
				saveMaterialLibrary ((libPath + "\\" + edt_mtlb_name.text) as string + ".mat")
					
				--load Material Libraries
				LoadCustomMLs()	
			)
				
			edt_mtlb_name.text = ""
				
		)
			
		--uv scalar spinner ui - on value change 
		on spn_uv_ctrl changed val do 
		(
			undo on 
				
			for i in selection as array do 
			(			
				uvMod = i.modifiers[#Unwrap_uvw]
				uvMod2 = uvMod.unwrap2
				uvMod2.ScaleSelectedCenter (spn_uv_ctrl.value) 0 
			)
				
		)		
			
		--uv scalar tester 
		on spn_uv_ctrl entered do 
		(
			spn_uv_ctrl.value = 100
		)	
			
		--save library as - dialog
		on btn_crt_mtlb pressed do 
		(
			FileSaveAsMatLib()
		)
			
		--open library - dialog  
		on btn_open_mtlb pressed do 
		(
			sme.close() 
			FileOpenMatLib()
			--sme.open()
			
		)
			
		--create a combined multi-material 
		on btn_comb_mats pressed do 
		(
			--create combined multi-mat
			objMats = for i in selection as array where i.mat != undefined collect i.mat
			print objMats.count
			
				
			if objMats.count > 1 then 
			(
				
				mm = Multimaterial numsubs:objMats.count 
				
				for o = 1 to objMats.count do 
				(
					mm[o] = objMats[o]				
				)
				
				viewNode = sme.GetView (sme.activeView)
				sme.SetMtlInParamEditor mm
				newMat = copy (sme.GetMtlInParamEditor())
				newMat.name = "_Combined_Mat_Test"
				
				matPos = [20,20]
				viewnode.createnode newMat &matPos
					
				for s in selection do 
				(
					s.mat = newMat
				)
				print "created new multimaterial"
					
			)
			else(
				print "only has one material"
			)
				
		)
			
		--Load Selected Library from list 
		on btn_sel_mtlb pressed do 
		(
			--Load Library
			LoadSelectedLibraryFromList()
				
			if lst_mtlb_mats.items.count > 0 then
			(
				--get selected Material
				GetSelectedMaterial()
				
				ab = selectedMat.base_color_map
				nm = selectedMat.norm_map 	
				
				--switch map preview
				FilterMaterialMapsDisplay()
			)	
			else(								
				b = (bitmap 128 128 color:gray)
				print "No Albedo Found"
				bmp_img.bitmap = b
			)
		)	
			
		on btn_sav_mtlb pressed do 
		(
			--Save loaded Library
			
			a = loadTempMaterialLibrary (getMatLibFileName())
			
			saveTempMaterialLibrary a (lst_crnt_mtlb.items[1] as string)
		)
			
		--On library list item selected 
		on lst_crnt_mtlb selected item do 
		(
			
		)
			
		on rad_dbg_maps changed state do 
		(
			--get selected Material
			GetSelectedMaterial()
				
			ab = selectedMat.base_color_map
			nm = selectedMat.norm_map 
			
			FilterMaterialMapsDisplay()
		)
			
		--On materials list item selected 
		on lst_mtlb_mats selected item do 
		(
			--get selected Material
			GetSelectedMaterial()
				
			ab = selectedMat.base_color_map
			nm = selectedMat.norm_map 
				
			--switch map preview
			FilterMaterialMapsDisplay()
				
		)
			
		--edit material parameters
		on btn_mat_sme pressed do 
		(
			if selectedMat != undefined then 
			(
				if not SME.isOpen() then 
				(
					sme.open()
					sme.SetMtlInParamEditor selectedMat
				)
				else
				(
					sme.SetMtlInParamEditor selectedMat
				)
			)
		)
			
		--open/edit material in SME
		on btn_mat_opn pressed do 
		(
			if selectedMat != undefined then 
			(
				local n
				local curView = SME.getView SME.activeView  
				
				if not SME.isOpen() then 
				(
					sme.open()
					curView.CreateNode selectedMat [0,0]
						
					n = curView.GetNodeByRef selectedMat 
					n.selected = true 
						
					print n.name 
					sme.SetMtlInParamEditor selectedMat
						
				)
				else
				(
					curView.CreateNode selectedMat [0,0]
						
					n = curView.GetNodeByRef selectedMat 
					n.selected = true 
						
					sme.SetMtlInParamEditor selectedMat
						
				)
			)
		)
			
		--add selected material to matlib
		on btn_add_fsel pressed do 
		(
			sel = selection[1]		
				
			if sel != undefined then
			(
				lib = loadTempMaterialLibrary (lst_crnt_mtlb.items[1] as string)
				
				
				objMats = #()
				objMats = for i in sel where i.mat != undefined collect i.mat
					
				print ("matLib name > " + lib[1] as string)
					
				print ("selected mat name > " + objMats[1] as string)
					
				for i in selection do 
				(
					--append material test 
					append (lib) (objMats[1])
				)
				
				saveTempMaterialLibrary lib (lst_crnt_mtlb.items[1] as string)
				
				--load Material Libraries
				LoadCustomMLs()	
				
				--Load Library
				LoadSelectedLibraryFromList()
			)
		)
			
		--on dialog open 
		on srl_materials open do 
		(
			--load Material Libraries
			LoadCustomMLs()		
				
			--load current matlib
			arr = #( filenameFromPath ( getMatLibFileName() ) )
				
			--Load Library at start
			if ddl_mtlb_list.items.count > 0 then 
			(
				if sme.isOpen() then 
				(
					sme.close()
				)
					
				--object usable list 
				loadedLib = currentMaterialLibrary
					
				--display current matlib's name 
				arr = #( filenameFromPath ( getMatLibFileName() ) )
				lst_crnt_mtlb.items = arr
					
				lst = #()
				lst_mtlb_mats.items = lst
				print loadedLib.count
				if loadedLib.count > 0 then 
				(
					for i = 1 to loadedLib.count do 
					(
						lst[i] = loadedLib[i] as string 
					)			
					
					lst_mtlb_mats.items = lst
					
				)	
					
				if chk_mtlb_slnt.checked then 
				(
					sme.open()
				)
			)
			else(
				print "No Material Libraries Found"
			)
				
			lst_crnt_mtlb.items = arr
			
			selectedMat = currentMaterialLibrary [lst_mtlb_mats.selection]
				
			if selectedMat != undefined then 
			(
				--get material name 
				edt_mat_name.text = (selectedMat.name as string) 
					
				ab = selectedMat.base_color_map
				nm = selectedMat.norm_map 
				
				FilterMaterialMapsDisplay()
				
				
			)
			else(
				
			)

				
		)
			
	)
		
	rollout uiPan "Flow Attributes-Object Editors" width:400 height:800
	(
		
		Group "Panel Controls:"
		(					
			checkbutton btn_stats "Attributes-Object Helper" 			checked:false		height:25	across:2
			checkbutton btn_mats "Attributes-Object Materials Pallette"	checked:true		height:25
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
		
		on btn_mats changed state do 
		(
			
			if state then
			(
				AddRollout srl_Materials theNewFloater
			)
			else 
			(
				RemoveRollout srl_Materials	theNewFloater
			)			
			
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
			
			if btn_mats.checked then
			(
				AddRollout srl_Materials theNewFloater
			)
			else 
			(
				RemoveRollout srl_Materials	theNewFloater
			)	
			
			
			
			
		)		
		
		
	)

	--add rollouts
	addRollout uiPan theNewFloater
	
	--AddRollout srl_Stats theNewFloater
-- 	RemoveRollout srl_Stats theNewFloater
	
	