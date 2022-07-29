	try(closeRolloutFloater MtlbManager) catch()
	--CreateDialog uiPan 
	global MtlbManager = newRolloutFloater "Flow Materials Helper" 460 660
	
		

	
	rollout rl_Materials "Materials Database"
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
						
					p = (bitmap 132 132 color: (color 0 0 0 0))
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
				bmp_img.filename = p.filename
						
				if map == undefined then 
				(
					
				)
					
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
				
			if selectedMat != undefined then 
			(
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
			)					
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
				
			if selectedMat != undefined then 
			(
				ab = selectedMat.base_color_map
				nm = selectedMat.norm_map 
			)
				
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
				local curView 
					
				--check if it already exists
				
				print ( SME.GetViewByName (selectedMat.name + "_Edit") as string) 
				(
					
				)
				
					--SME.CreateView (selectedMat.name + "_Edit") as string
				
					
				curView = SME.getView SME.activeView 
					
				if not SME.isOpen() then 
				(
					sme.open()
					curView.CreateNode selectedMat [0,0]
						
					--n = curView.GetNodeByRef selectedMat 
					--n.selected = true 
						
					sme.SetMtlInParamEditor selectedMat
						
				)
				else
				(
					curView.CreateNode selectedMat [0,0]
						
					--n = curView.GetNodeByRef selectedMat 
					--n.selected = true 
						
					sme.SetMtlInParamEditor selectedMat
						
				)
					
-- 				nos = curView.GetNumNodes()
-- 					
-- 				print nos 
-- 				for i = 1 to nos do 
-- 				(
-- 					l = (curView.GetNode i)
-- 					print l.name 
-- 				)		
-- 					
-- 				abNode = curView.GetNode 1 
-- 				mmNode = curView.GetNode 2 
-- 				nmNode = curView.GetNode 3 
-- 				emNode = curView.GetNode 4 
-- 				
-- 				print abNode.name 
-- 				print mmNode.name 
-- 				print nmNode.name 
-- 				print emNode.name 
-- 		
				
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
		on rl_Materials open do 
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
				
			--switch map preview
			FilterMaterialMapsDisplay()
				
			p = (bitmap 132 132 color: (color 0 0 0 0))
			copy bmp_img p
			
			
		)
			
	)
	
	
	
	
	addRollout rl_Materials MtlbManager
	
-- 	CreateDialog rl_Materials   width:400 height:800