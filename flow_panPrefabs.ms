		--Local Variables File

	--------------------------------------------
		
	--Colors
	local prefabColor 	= (color 28 89 177 255)
	local custGeoColor 	= (color 150 89 66 255)
	
	local structColor 	= (color 177 89 27 255)
	local intWallColor 	= (color 66 89 35 255)
	local intCeiColor 	= (color 66 120 45 255)
	local propColor 	= (color 10 125 150 255)
	local vehiColor 	= (color 200 89 80 255)
	local decalColor 	= (color 255 23 23 255)
	local dynamicColor 	= (color 125 89 23 255)
	local shaOnlyColor 	= (color 50 50 50 255)
	local mshColColor 	= (color 2 255 255 255)
	local finalColor 	= (color 28 89 177 255)
		
	--------------------------------------------
		
	--Booleans
	local LabelGrp 		= false
	local LockRatio 	= false
	local LoadAttr 		= true	
	local UseSelName 	= true
	local GenGeo 		= false
	local CrtGrp 		= false	
	local ClrPre 		= true
		
	--------------------------------------------
		
	--Strings
	local typePre = ""
		
	--------------------------------------------
		
	--Numbers
	local txtBfr = .25
	local txtSize = .25
	local finalRatio = 0
	local XRatio = 1
	local YRatio = 1
		
	--------------------------------------------
		
	--Arrays
	local obs	= #()
	local clrArr = #(structColor, intWallColor, intCeiColor, propColor, vehiColor, decalColor, dynamicColor, shaOnlyColor, mshColColor)
		
	--------------------------------------------
			
		--include "scripts//_panels/_subPanels/panBaker.ms"
			
			
		Group "Prefab Label Settings:"
		(
			edittext 	edt_text 	"Prefab Name: "		 		labelontop:true			align:#left		
			colorpicker clr_text	"Color:"					width:90				color: finalColor	across:2
			spinner 	spn_tSiz	"Size: "					range:[0, 100, txtSize] 			
			spinner 	spn_BufX 	"W:"						range:[0, 100, 2.0] 		align:#left		across:3
			spinner 	spn_BufY	"L:"						range:[0, 100, 1.0] 		align:#left 
			checkbox 	chk_LckR	"Lock Ratio"										align:#left
		)	
			
		Group "Setup:"	
		(			
			timer 		tim_Tick1  	"timer"						active:true
			checkbox 	chk_selN	"Use Selection's Name"		checked:UseSelName		
			checkbox 	chk_lodTyp 	"Use Object Attributes" 	checked:LoadAttr
			checkbox 	chk_gGeo	"Create TextMesh"			checked:GenGeo
			checkbox 	chk_grp		"Label as One"				checked:LabelGrp
			checkbox 	chk_cgrp	"Group Selection"			checked:CrtGrp
			checkbox 	chk_colP	"Colorize Prefab Type"		checked:ClrPre
				
		)
			
		Group "Type Settings:"
		(
			dropdownList lst_obTyp	"Prefab Object Type"		items:#("Structure", "Interior - Wall", "Interior - Ceiling", "Vehicle", "Prop", "Decal", "Dynamic", "Shadow Only", "Mesh Collider")
			button btn_fndtyp "Select Objects of Type"			height:30
		)
		
		Group "Baker To Texture"
		(
				
			Button btn_OpenSett "Open Bake Settings"			width:200	height:30
				
		)
		
		Group "LOD Settings"
		(
			checkbox chk_type "Use Object Type"
			button prc_geo "LOD Reduction Chain"						width: 100	height:30	across:2	align:#center	
			button prc_proxy "HLOD Proxy"								width: 100	height:30				align:#center
		)
			
		---------------------------------------------------------------------------------------------------------------- INSTANCES
		group "Prefab Instances:" 
		(
			button c_CreateContainers "Create" 					width: 100	height:40	across:2
			button c_LoadContainer "Load"  						width: 100	height:40
		)
			
			
		on btn_OpenSett pressed do 
		(
			--launch Baker
			filein (mainFPFolder + "\FlowPanels\_subPanels\panBaker.ms")		
		)
			
			
			
		----------------------------------------------------------------------------------
		----------------------------------------------------------------------------------
		
		-- FUNTIONS--------------------------------------------------------------------- 
		
		----------------------------------------------------------------------------------
		----------------------------------------------------------------------------------
			
		fn objAttributes =
		(
			for i in selection as array do 
			(
				if (doesUserPropExist i "Unity Attributes") then 
				(
					--Load Settings 
					obs = execute (getUserPropVal i "Unity Attributes" asString:true)	
					
				)
				else
				(
					macros.run "FlowAttributes" "IBGUnityAttributesAdd"
				)
					
			)
		)
			
		----------------------------------------------------------------------------------
		----------------------------------------------------------------------------------
			
		fn attachObjs objs =
		(
			convertToPoly objs[1]
			for obj in 2 to objs.count do
				polyop.attach objs[1] objs[obj]
			return objs[1]
		)
			
			
			
		----------------------------------------------------------------------------------
		----------------------------------------------------------------------------------
		
		-- CHECKBOXES ------------------------------------------------------------------
		
		----------------------------------------------------------------------------------
		----------------------------------------------------------------------------------
			
		on chk_grp changed state do 
		(
			LabelGrp = state
		)
		----------------------------------------------------------------------------------
		on chk_cgrp changed state do 
		(
			CrtGrp = state
		)
		----------------------------------------------------------------------------------
		on chk_colP changed state do
		(
			ClrPre = state
		)	
		----------------------------------------------------------------------------------
		on lst_obTyp selected i do
		(
			typePre = lst_obTyp.items[i]
			
			if ClrPre then
			(		
				clr_text.color = clrArr[i]
			)
			else
			(
				
			)
			
		)
		----------------------------------------------------------------------------------
		on chk_lodTyp changed state do 
		(
			if (state == true) then
			(
				LoadAttr = true
				lst_obTyp.enabled = false
			)
			else
			(
				LoadAttr = false
				lst_obTyp.enabled = true			
			)
				
		)
		----------------------------------------------------------------------------------
		on chk_selN changed state do
		(
			if(state)then
			(
				edt_text.enabled = false
				if(selection.count > 0) then
				(
					edt_text.text = selection[1].name
				)
			)
			else
			(
				edt_text.enabled = true
			)
				
			UseSelName = state
				
		)	
		----------------------------------------------------------------------------------
		on chk_LckR changed state do
		(
				
			if (state == true) then 
			(
				LockRatio = true
				finalRatio = spn_BufY.value = spn_BufX.value
				spn_BufY.enabled = false
			)
			else 
			(
				LockRatio = false
				XRatio = spn_BufX.value
				YRatio = spn_BufY.value
				spn_BufY.enabled = true
			)
				
		)
		----------------------------------------------------------------------------------
		on chk_gGeo changed state do 
		(
			GenGeo = state
		)		
		----------------------------------------------------------------------------------
		on spn_tSiz changed val do 
		(		
			txtSize = val
		)
		----------------------------------------------------------------------------------
		on spn_tBuf changed val do
		(
			
			txtBfr = val
			
		)
		----------------------------------------------------------------------------------
		on spn_BufX changed val do 
		(
			if LockRatio == true then
			(
				finalRatio = spn_BufX.value = val
				spn_BufY.value = val
			)
			else	
			(
				
			)
				
			
		)
		----------------------------------------------------------------------------------
		on spn_BufY changed val do 
		(
			if LockRatio then 
			(
				finalRatio = spn_BufY.value = spn_BufX.value = val
			)
			else(
				
			)			
				
		)
		
		
		----------------------------------------------------------------------------------
		----------------------------------------------------------------------------------
		
		-- BUTTONS ---------------------------------------------------------------------
		
		----------------------------------------------------------------------------------
		----------------------------------------------------------------------------------


		--Button Process Prefab - LOD -- 
		----------------------------------------------------------------------------------
		on prc_geo pressed do 
		(
			--Create LOD Prefab -- asset
			filein (mainFPFolder + "\FlowPanels\_processors\LOD_Processor.ms")
		)
		
		--Button Process Prefab - HLOD -- 
		----------------------------------------------------------------------------------
		on prc_proxy pressed do 
		(
				
			--Create HLOD Prefab -- asset
			filein (mainFPFolder + "\FlowPanels\_processors\HLOD_Processor.ms")
				
		)

		
		--Button Function - Load Instances
		----------------------------------------------------------------------------------
		on c_LoadContainer pressed do
		(		
			actionMan.executeAction -1172021248 "0"  -- Containers: Inherit Container
		)
			
		--Button Function - Create Container
		----------------------------------------------------------------------------------
		on c_CreateContainers pressed do
		(
				
			--load attributes 
			objAttributes()
				
			local bbObj
			local bbMin 
			local bbMax 
			local bbSize
				
			local tempObj
				
			local attachedObjs = #()
				
			sel = selection as array 	
				
			if selection.count > 0 then
			(
					
				--set prefab wirecolor

				newmat = standard diffuseMap:(checker()) showInViewport:true
					
					
				for i in sel do
				(
					i.material = newmat
					i.wirecolor = clr_text.color		
				)
						
					
				local selObjs = for obj in selection collect obj
					
				if CrtGrp then
				(
					grp = group selObjs
				)
					
				if (not LabelGrp) then
				(
					
					for o in selObjs do (append attachedObjs (copy o))
					tempObj = attachObjs attachedObjs				
				)	
				else(
					tempObj = grp
				)
					
				bbObj = Rectangle() --box()
				bbObj.wirecolor = clr_text.color
				bbObj.name = "BoundingBox"
				bbMin = tempObj.min
				bbMax = tempObj.max
				bbSize = bbMin - bbMax
				bbSize.x = abs(bbSize.x)
				bbSize.y = abs(bbSize.y)
				bbSize.z = abs(bbSize.z)
					
				if(chk_LckR.checked) then
				(
					bbObj.width = (bbSize.x + finalRatio)
					bbObj.length = (bbSize.y + finalRatio)
				)
				else
				(
					bbObj.width = (bbSize.x + spn_BufX.value)
					bbObj.length = (bbSize.y + spn_BufY.value)				
				)	
					
				--bbObj.height = bbSize.z
				--bbObj.wirecolor = clr_text
				bbObj.pivot = bbObj.center
				bbObj.pos = [tempObj.center.x, tempObj.center.y, tempObj.min.z]--tempObj.center
					
					
				--text settings
				
				if (GenGeo == true ) then
				(
					txt = TextPlus() 
				)
				else
				(
					txt = text()
				)
				txt.rotation = quat 0 0 180 0
				txt.size = txtSize
				txt.pos = [tempObj.center.x, ((bbObj.max.y) + txtSize), tempObj.min.z]
				txt.parent = bbObj
				txt.wirecolor = clr_text.color
					
				-------------------------------------------------------------------------------------------------------------------------------------------			
					
				--Check for Attributes, first 
				if (loadAttr) then
				(	
					--load attributes 
					objAttributes()
					
					--apply attributes
					typePre = lst_obTyp.items[obs[4] as integer]
				)
				else
				(
					typePre = lst_obTyp.items[lst_obTyp.selection]
					--txt.SetPlaintextString selection[1].name
				)
					
				-------------------------------------------------------------------------------------------------------------------------------------------
					
				if(UseSelName) then
				(
					if (GenGeo == true) then
					(
						txt.SetPlaintextString ("[" + typePre + "]" + " - " +  selection[1].name)
					)
					else
					(
						txt.text = ("[" + typePre + "]" + " - " +  selection[1].name)
					)
				)
				else if (not UseSelName) then 
				(
					if (GenGeo == true) then
					(
						txt.SetPlaintextString ("[" + typePre + "]" + " - " +  edt_text.text) as string
					)
					else
					(
						txt.text = ("[" + typePre + "]" + " - " +  edt_text.text) as string
					)
						
				)
				else
				(
					txt.text = "No Name Was Provided"
					--txt.SetPlaintextString "No Name Was Provided"
				)
					
				select sel --bbObj
				delete tempObj
			)
			else messagebox("Nothing selected")
				
				
			undo on
				
			-- place on selection's pivot point
			for i in sel do 
			(					
					
				--position variable
				place = i.pos
					
				--places container on selection's pivot 
				myCont = Container isSelected:on allowInPlaceEditing:true pos:place size:1 displayLabel:true
					
				--adds node to container
				myCont.AddNodeToContent i
					
				--names container
				myCont.name = "inst_" + i.name as string
				myCont.wirecolor = clr_text.color
				myCont.size = PrimScale
					
				--Creates a layer for each selected container and names it accordingly			
				layer = LayerManager.newLayer()
				layer.setname (myCont.name as string)
				layer.addnode i
				layer.addnode myCont
					
				----------------------------------------------------------------------------
					
			)
				
			completeRedraw() 
			forceCompleteRedraw doDisabled:true 
				
		)
			
		----------------------------------------------------------------------------------
		----------------------------------------------------------------------------------
		
		on panPrefabs rolledUp open do 
		(
				
			--set correct color
			if ClrPre then
			(		
				clr_text.color = clrArr[lst_obTyp.selection]
			)
						
			--check for useselname to disable 'Prefab Name' textfield
			if UseSelName then
			(
				edt_text.enabled = false
			)
			
			--Check for LoadAttr to disable 'Prefab Object Type'
			if LoadAttr then 
			(
				lst_obTyp.enabled = false
			)
			
			--set prefab object type on start
			typePre = lst_obTyp.items[1]
			
			
			
			if use_autocollapse == true do 
			(
				--switches to this rollout
				if open do switchrolls panPrefabs
			)	
			
			
		)
		