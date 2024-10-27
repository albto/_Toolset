try(destroydialog dRol) catch()

Global rolA, rolB, rolC, rolD


rollout dRol "Baking Manager" 
(
	
	------------------------------------------------------------
	local IsNewBakeMaterial = false 
	
	local maps = #("File Only", "Base Color Map", "Metalness Map", "Roughness Map", "AO Map", "Normal Map", "Emission Map", "Opacity Map", "Displacement Map")

	local newMaterial = Material
	local lastExpFldr =  pathConfig.getCurrentProjectFolder() + "\\sceneassets\\images"   
	local bakePath
	local AutoUV = false
	
	local difmap
	local spcmap
	local normalmap
	
	local albSuf = "_ALB"
	local nmlSuf = "_NML"
	local mskSuf = "_MSK"	
	
	local clrFilename = ""
	local rghFilename = ""
	local nmlFilename = ""

	local modelsExportPath = ""
	
	local Lowpoly
	local Highpoly
	
	local rdyForBake = false
	local defaultSubstancePainterPath = @"H:\\Program Files\\Adobe Substance 3D Painter"
		------------------------------------------------------------
	-- Create New Bake Material -- { Creates material for lowpoly in bake process }  
	fn CreateNewBakeMaterial material = 
	(
				
		local nameStr = ""
			
		if selection.count != 0 then
		( 
			nameStr = "mat_" + selection[1].name as string
		)
		else
		(
			nameStr = uniquename + "mat_example_"
		)

		--create new material
		material = PBRMetalRough name:nameStr

		return material


	)

	------------------------------------------------------------
	-- Create New Bitmaps -- { Create bitmaps for lowpoly bake process } 	
	fn MakeBitmaps clrmapName rghmapName nmlmapName type clrBool rghBool nmlBool= 
	(
		
		if clrmapName != undefined then
		( 
			--set directory
			folder = bakePath
				
			--create maps if checks--------------------------------------------
			if clrBool then
			(
				file = ((folder) + "//" + (clrmapName + "." + type))
				
				if doesfileexist file then
				(
					clrFilename = ((folder) + "//" + (clrmapName + "." + type))
				)
				else	
				(
					clrFilename = ((folder) + "//" + (clrmapName + "." + type))
					--clrfile = createFile clrFilename

					render outputfile:clrfilename outputsize:[4,4]
					
					tifio.setType #color16 
					tifio.setAlpha #false
					tifio.setCompression #none
				)

			)
			--------------------------------------------------------------------
			if rghBool then
			(
				file = ((folder)+ "//" + (rghmapName + "." + type))

				if doesfileexist file then
				(
					rghFilename = ((folder)+ "//" + (rghmapName + "." + type))
				)
				else
				(
					rghFilename = ((folder)+ "//" + (rghmapName + "." + type))
	 				--rghfile = createFile rghFilename				
					
					render outputfile:rghFilename outputsize:[4,4]

					tifio.setType #color16 
					tifio.setAlpha #false
					tifio.setCompression #none
				)

			)
			--------------------------------------------------------------------
			if nmlBool then
			(
				file = ((folder) + "//" + (nmlmapName + "." + type)) 

				if doesfileexist file then
				(
					nmlFilename = ((folder) + "//" + (nmlmapName + "." + type))
				)
				else
				(
					nmlFilename = ((folder) + "//" + (nmlmapName + "." + type)) 
					--nmlfile = createFile nmlFilename				

					render outputfile:nmlFilename outputsize:[4,4]

					tifio.setType #color16 
					tifio.setAlpha #false
					tifio.setCompression #none
				)

			)
			--------------------------------------------------------------------
		)			
	)
		
	------------------------------------------------------------
	-- Set Material in SME -- { Set The Material in editor and to lowpoly } 
	fn SetMaterialInSME materialInput = 
	(
			
		wasOpen = SME.isOpen()
			
		----------------------------------------------------------------------------------------
		--Create nodes
		----------------------------------------------------------------------------------------
			
		albNode = osl_UberBitmap2b 		filename:clrFilename
		mskNode = osl_UberBitmap2b 		filename:rghFilename
		nmlNode = osl_UberBitmap2b 		filename:nmlFilename
			
		albNode.name 		= albSuf
		mskNode.name  		= mskSuf
		nmlNode.name  		= nmlSuf
			
		----------------------------------------------------------------------------------------	
		--apply maps to slots 
		----------------------------------------------------------------------------------------
		--albedo map // RGB = Color | Alpha = Coat Mask / Opacity 
		rgb_output = MultiOutputChannelTexmapToTexmap sourceMap:albNode
		rgb_output.outputChannelIndex = 1 -- 5 is the index of the alpha output of the OSLMap
		--| A = Opacity
		alp_output = MultiOutputChannelTexmapToTexmap sourceMap:albNode
		alp_output.outputChannelIndex = 5 -- 5 is the index of the alpha output of the OSLMap
			
		--normal map // RG = Normal R & G 
		--| R
		nr_output = MultiOutputChannelTexmapToTexmap sourceMap:nmlNode
		nr_output.outputChannelIndex = 2 
		--| G
		ng_output = MultiOutputChannelTexmapToTexmap sourceMap:nmlNode
		ng_output.outputChannelIndex = 3 
		--| B - created 
		bChan = osl_SetFloat()
		bChan.name = "_NML - B"
		bChan.In = 1.0
		nb_output = MultiOutputChannelTexmapToTexmap sourceMap:bChan
		nb_output.outputChannelIndex = 1
		----------------------------------------------------------------------------------------	
		--Normal Map Combine 
		combNod = osl_ColorJuggler()
		combNod.name = "Normal Map Conversion"
		--r and G channels 
		combNod.Ri_map = nr_output
		combNod.Gi_map = ng_output
		--b channel 
		combNod.Bi_map = nb_output
			
		nml_output = MultiOutputChannelTexmapToTexmap sourceMap:combNod
		nml_output.outputChannelIndex = 1 
		----------------------------------------------------------------------------------------
		--| B = AO 
		ao_output = MultiOutputChannelTexmapToTexmap sourceMap:nmlNode
		ao_output.outputChannelIndex = 4 
		--| A = Roughness
		rg_output = MultiOutputChannelTexmapToTexmap sourceMap:nmlNode
		rg_output.outputChannelIndex = 5
		----------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------
			
		--mask map // RGBA | R = Displacement | G = Tint Mask | B = Emission / Detail Mask | A = Metalness
		----------------------------------------------------------------------------------------
		--| R
		dsp_output = MultiOutputChannelTexmapToTexmap sourceMap:mskNode
		dsp_output.outputChannelIndex = 2
		----------------------------------------------------------------------------------------
		--| B
		ems_output = MultiOutputChannelTexmapToTexmap sourceMap:mskNode
		ems_output.outputChannelIndex = 3
		----------------------------------------------------------------------------------------
		--| A 
		mtl_output = MultiOutputChannelTexmapToTexmap sourceMap:mskNode
		mtl_output.outputChannelIndex = 5
			
		----------------------------------------------------------------------------------------
		--map slots 
		----------------------------------------------------------------------------------------
			
		materialInput.base_color_map 		= rgb_output
		materialInput.metalness_map 		= mtl_output
		materialInput.roughness_map 		= rg_output
		materialInput.ao_map 				= ao_output
		materialInput.normalmap 			= nml_output
		materialInput.emission_map 			= ems_output
		materialInput.opacity_map 			= alp_output
		materialInput.displacement_map 		= dsp_output
			
		----------------------------------------------------------------------------------------
			
		--open dialog 
		if wasOpen then
		(
			
		)
		else
		(
			SME.Open()
		)	
			
		--create viewport
		if (sme.GetView (sme.GetViewByName "BakeSetup")) == undefined then
		(
			smeView = sme.createView "BakeSetup"
		)
		else
		(				
			--set sme viewport
			smeView = (sme.GetView (sme.GetViewByName "BakeSetup"))
			
			
			--reset view 
			smeView.SelectAll()
			smeView.DeleteSelection()
				
			--create material 
			smeView.CreateNode materialInput [0,0]
			smeView.CreateNode combNod	[1,2]
			smeView.CreateNode bChan	[2,4]
				
			smeView.SetFocus()
				
		)

-- 		if wasOpen then
-- 		(
-- 			sme.Close()
-- 			sme.Open()
-- 		)
-- 		else
-- 		(
-- 			sme.Close()
-- 		)

			
	)

	------------------------------------------------------------
	-- Smooth Grps by UV SHELLS -- { UV Shells to Smooth Groups } 	
	fn smoothByUVShells =
	(
		clearListener();
		if (getCommandPanelTaskMode() != #modify)then
		(--make sure we are in the modify panel section
			setCommandPanelTaskMode #modify;
		)
		if (selection.count == 1)then(--at least an object selected
			local obj = selection[1]; 
			local uv = modPanel.getCurrentObject();
			
			if (classof(uv) != Unwrap_UVW)then(
				modPanel.addModToSelection (Unwrap_UVW ()) ui:on;
				uv = modPanel.getCurrentObject();
			)
			
			uv.unwrap.edit();
			uv.unwrap.edit();
			uv.unwrap2.setTVSubObjectMode(3);
		
			local totalFaces = uv.unwrap.numberPolygons();
			
			local faceElemArray = #();
			for f=1 to totalFaces do (
				faceElemArray[ f ] = 0;
			)
			local elem = #();
			--with redraw off;
			for f=1 to totalFaces do (
				if faceElemArray[ f ] == 0 then (
					uv.unwrap2.selectFaces  #{ f };
					uv.unwrap2.selectElement();
					local elemFaces = uv.unwrap2.getSelectedFaces() as array;
					
					append elem (uv.unwrap2.getSelectedFaces());
					for i in elemFaces do (
						faceElemArray[ i ] = elem.count; -- Mark these vertices with their element number in vertElemArray.
					)
				)
			)
			
			print("num shells: "+elem.count as string+"t"+totalFaces as string);
			
			modPanel.addModToSelection (Edit_Poly ()) ui:on;
			obj.modifiers[#Edit_Poly].autoSmoothThreshold = 180	
			for e in elem do(
				obj.modifiers[#Edit_Poly].SetSelection #Face e;	
				obj.modifiers[#Edit_Poly].ButtonOp #Autosmooth	
			)	
		)
	)
		
	timer globalTime "" interval:500 
	
    subRollout subRolls "" width:(dRol.width as float -20) height:1080 pos:[10,5]
		
	fn switchRolls openedRoll =
        for roll in dRol.rolls where roll != openedRoll do roll.open = false
		
    rollout rolA "Selection Panel" 
    (			
			
		Group "Baker Setup:"
		(
			pickbutton pck_high "Pick Highpoly"								width:110	height:20	across:2
			pickbutton pck_low	"Pick Lowpoly"								width:110	height:20
			Button btn_autoSet "Find w/ Attributes"									width:115	height:25	align:#center	across:2
			button btn_clear "Clear"										width:115	height:25	
			--checkbox chk_high	"Highpoly Exists"							tooltip:"Highpoly Object must be named '_High'"	across:2
			--checkbox chk_low 	"Lowpoly Exists"							tooltip:"Lowpoly Object must be named '_Low'"
		)
		
		----------------------------------------------------------------------------------		
		
		on btn_clear pressed do 
		(
			Highpoly = undefined
			Lowpoly  = undefined
			
			dRol.rolB.edt_high.text = ""
			dRol.rolB.edt_low.text = ""
		)
		
		on btn_autoSet pressed do 
		(
			--Find and set highpoly  
			Highpoly = undefined 
			Lowpoly = undefined
				
			objHighName = ""
					
			for i in geometry do 
			(
				
				bakingParams = #()
				
				
				if (getUserPropVal i "Baking Attributes" asString:true) != undefined then 
				(
					--load Selection's Unity Attributes 
					bakingParams = execute (getUserPropVal i "Baking Attributes" asString:true)	
						
					--changed setting
					if bakingParams[1] == "Highpoly Mesh" then 
					(
						objHighName = i.name
						
						
						--set high
						findHigh = (getNodeByName objHighName)
						Highpoly = findHigh
						if Highpoly != undefined then 
						(
							if (matchpattern Highpoly.name pattern:"*_HP*") then
							(
								
							)
							else(
								Highpoly.name = (Highpoly.name+"_HP" as string)
							)
						)	
							
						if Highpoly != undefined then 
						(
							pck_high.object = Highpoly
							dRol.rolB.edt_high.text = Highpoly.name as string
						)
					)
				)
			)					
				
			--if chk_low.checked then
			(
					
				objLowName = ""
					
				for i in geometry do 
				(
					
					bakingParams = #()
					
					if (getUserPropVal i "Baking Attributes" asString:true) != undefined then 
					(
						--load Selection's Unity Attributes 
						bakingParams = execute (getUserPropVal i "Baking Attributes" asString:true)	
							
						--changed setting
						if bakingParams[1] == "Lowpoly Mesh" then 
						(
							objLowName = i.name
								
							--set low
							findLow = getNodeByName objLowName
							Lowpoly = findLow
							if Lowpoly != undefined then 
							(
								if (matchpattern Lowpoly.name pattern:"*_LP*") then
								(
									
								)
								else(
									Lowpoly.name = (Lowpoly.name+"_LP" as string)
								)
							)
								
							if Lowpoly != undefined then 
							(
								pck_low.object = Lowpoly
								dRol.rolB.edt_low.text = Lowpoly.name as string
							)
						)
					)
				)	
			)
		)			
			
		on chk_autoUV changed state do 
		(
			AutoUV = state
		)
		
		on pck_high picked obj do
		(
			if obj != undefined then
			(	
				Highpoly = obj
				print Highpoly.name as string
				dRol.rolB.edt_high.text = Highpoly.name as string
				
			)
			else
			(
				dRol.rolB.edt_high.text = "None"
			)
			
		)
			
		on pck_Low picked obj do 
		(
			if obj != undefined then
			(	
				Lowpoly = obj
				print Lowpoly.name as string
				dRol.rolB.edt_low.text = Lowpoly.name as string
				
			)
			else
			(
				dRol.rolB.edt_low.text = "None"
			)
		)
		
		
		on rolA rolledUp open do if open do switchRolls rolA
    )
		
	rollout rolB "References" 
	(		
		
		Group "Object Reference:"
		(
			checkbox chk_lp_clu "-  LP object cluster"							across:2
			checkbox chk_hp_clu "-  HP object cluster"
			edittext edt_low 	"LP Mesh:"								width: 240	height:20	--across:2
			edittext edt_high 	"Hp Mesh:"								width: 240	height:20	
			
			
		)
		
		Group "Reference Controls:"
		(
			button btn_updHig	"Update Highpoly"						width:120	height:30	align:#center	across:2
			button btn_updLow	"Update Lowpoly"						width:120	height:30	align:#center
			button btn_selHig	"Select Highpoly"						width:120	height:20	align:#center	across:2
			button btn_selLow	"Select Lowpoly"						width:120	height:20	align:#center
		)

		Group "Output Location"
		(
				
			edittext edt_outpath ""										height:20 width:190 test:" ... "	align:#left		across:2
			button btn_setPth "Output"									height:20 align:#right
				
		)

		on btn_genLow pressed do 
		(
			if Highpoly != undefined then
			(
				--select object reference 
				select Highpoly

				--create copy 
				genLowObj = copy Highpoly

				--name copy
				genLowObj.name = "_Low"

				--Set as Lowpoly object 
				Lowpoly = genLowObj 
				edt_low.text = Lowpoly.name as string 

				--select object 
				select genLowObj

				--set Pro-Optimizer
				

			)
		)

			
		on btn_setPth pressed do 
		(

			--set bakepath location
			bakePath = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:lastExpFldr
			
			if bakePath == undefined then
			(
				bakePath = (GetDir #image)
			)
				
			--set outpath to bakepath 
			edt_outpath.text = bakePath
				
		)

		
		on btn_updLow pressed do 
		(
			if Lowpoly != undefined then 
			(
				-----------------------------------------------------------
					
				dRol.rolE.ExportLowpolyMesh quick:true
					
				-----------------------------------------------------------
			)
				
			
		)
		
		on btn_updHig pressed do 
		(
			if Highpoly != undefined then 
			(
				-----------------------------------------------------------
					
				dRol.rolE.ExportHighpolyMesh quick:true 
					
				-----------------------------------------------------------
			)
				
		)
		
		on btn_selLow pressed do 
		(
			-----------------------------------------------------------
				
			try 
			(
				if dRol.rolB.chk_lp_clu.checked then 
				(
					clearSelection()
					selArr = #()					
					
					for i in geometry do 
					(
						if (getUserPropVal i "Baking Attributes" asString:true) != undefined then 
						(
							--load Selection's Unity Attributes 
							bakingParams = execute (getUserPropVal i "Baking Attributes" asString:true)	
								
							--changed setting
							if bakingParams[1] == "Lowpoly Mesh" then 
							(
								selectmore i 
							)
						)
					)
						
					--selArr = selection as array
					select selArr
				)
				else(
					select Lowpoly 
				)
					
			) 
			catch (print "ERROR: NO Lowpoly Referenced")
				
			-----------------------------------------------------------
				
		)
		
		on btn_selHig pressed do 
		(
			-----------------------------------------------------------
				
			try 
			(
				if dRol.rolB.chk_hp_clu.checked then 
				(
					clearSelection()
					selArr = #()					
					
					for i in geometry do 
					(
						if (getUserPropVal i "Baking Attributes" asString:true) != undefined then 
						(
							--load Selection's Unity Attributes 
							bakingParams = execute (getUserPropVal i "Baking Attributes" asString:true)	
								
							--changed setting
							if bakingParams[1] == "Highpoly Mesh" then 
							(
								selectmore i 
							)
						)
					)
						
					--selArr = selection as array
					select selArr
				)
				else(
					select Highpoly 
				)
					
			) 
			catch (print "ERROR: NO Lowpoly Referenced")
				
			-----------------------------------------------------------
			
		)		
		
		

	)
		
    rollout rolC "Maps Settings" 
	(
		Group "UVs Options:"
		(
			checkbox chk_autoUV "Auto-Unwrap Lowpoly"	
		)
			
		Group "Bake Maps Settings:"
		(
			checkbutton chk_clr "Base Color"							checked:true		across:3
			checkbutton chk_nml "Normal Map"							checked:true	
			checkbutton chk_rgh	"Roughness"								checked:true
				
			checkbox 	chk_cAct "Active"								checked:true		across:3
			checkbox 	chk_nAct "Active"								checked:true
			checkbox 	chk_rAct "Active"								checked:true
				
		)	
		
		Group "Image Overrides:"
		(				
			dropdownList ddl_imgSiz "Image Size"						items:#("512", "1024", "2048", "4096", "8192")					selection:2					across:3
			dropdownList ddl_imgTyp "Type"								items:#("TGA", "BMP", "JPG", "AVI", "RLA", "RPF", "TIF", "EPS", "HDR", "DDS" , "MOV", "EXR", "CIN", "PNG", "RGB")	selection:7
			dropdownList ddl_imgPad "Padding"							items:#("2", "4", "6", "8", "16", "32", "64", "128")	selection:7
		)
			
	)
		
    rollout rolD "Bake Settings" 
    (
		Group "Projection Settings:"
		(				
				
			dropdownList ddl_prjMth "Method:"							items:#("Cage", "Ray Tracing", "UV Match")
		)


		Group "Bake Options:"		
		(
			Button 	btn_sBake "Setup Bake"								width: 75	height:25 	across:3
			Button 	btn_sMaps "Open SME"								width: 75	height:25
			Checkbutton btn_open "Open Dialog"							width: 75	height:25
			Button btn_bake "Bake"										width: 235	height:40
		)
			
			
		on btn_open changed state do 
		(
			if state then
			(
				BakeToTexture.showDialog()
			)
			else
			(
				BakeToTexture.hideDialog()
			)
				
		)
				
		on btn_bake pressed do 
		(
			if btn_sBake.enabled then
			(
				BakeToTexture.Bake()
			)
		)
		
		on btn_sBake pressed do 
		(
			if (Lowpoly != undefined and Highpoly != undefined) then 
			(
				--mark selection
				sel = selection[1]
				
				--check if it wants to generate lowpoly  ---- TO DO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				--# BEGIN CODE HERE #----
				--
				
				-- CODE ----- CODE
				
				--
				--# END CODE HERE #----
					
					
				--Auto-UV map Object Check
				if AutoUV then
				(
						
					max modify mode 
					newMod = Unwrap_UVW()
						
					addModifier sel newMod
						
					sel.modifiers[1].setMapCHannel 1
					sel.modifiers[1].setApplyToWholeObject true
					sel.modifiers[1].flattenMapNoParams()
					sel.modifiers[1].pack 2 0.003 true true true 
						
				)
					
					
				--reset maps
				BakeToTexture.deleteAllMaps()
					
				--check for duplicate
				try deleteModifier  sel ( sel.modifiers[#Bake_Setup]) catch()
					
				--create modifier
				Proj = Projection()
				Proj.name = "Bake Setup"
				addModifier Lowpoly Proj
				
				--add objects to list
				addPModObjects Lowpoly false true objList:#(Highpoly)				

				--projection modifier settings
				Proj.displayCage = true
				Proj.displayCageShaded = true				
 				Proj.pushPercent = 0.05
				
				Proj.autowrapCage()
				

				------------------------------------------------------------------------				
					
				local size
				local no = 0	
				local noDifMap = false
				local noNmlMap = false
				local noRghMap = false
					
				-- Add Diffuse Map:-----------------------------------------------------
					
				size = execute dRol.rolC.ddl_imgSiz.items[dRol.rolC.ddl_imgSiz.selection]
					
				if rolC.chk_clr.state then 
				(
					difmap = BakeToTexture.addMap Lowpoly #DiffuseMap
					difmap.filename = (Lowpoly.name + albSuf as string)
					difmap.setImageSize size size
					difmap.fileType = dRol.rolC.ddl_imgTyp.items[dRol.rolC.ddl_imgTyp.selection]
						
					difmap.projectionMethod = (ddl_prjMth.selection-1) 
					difmap.edgePadding  = execute dRol.rolC.ddl_imgPad.items[dRol.rolC.ddl_imgPad.selection]
					
				)
				else
				(
					noDifMap = true
					no += 1
				)
					
				-- Add Occlusion Map:-----------------------------------------------------
					
				if rolC.chk_rgh.state then 
				(
					spcmap = BakeToTexture.addMap Lowpoly #SpecularMap
					spcmap.filename = (Lowpoly.name + mskSuf as string)
					spcmap.setImageSize size size
					spcmap.fileType = dRol.rolC.ddl_imgTyp.items[dRol.rolC.ddl_imgTyp.selection]
						
					spcmap.projectionMethod = (ddl_prjMth.selection-1) 
					spcmap.edgePadding  = execute dRol.rolC.ddl_imgPad.items[dRol.rolC.ddl_imgPad.selection]
				)	
				else
				(
					noRghMap = true
					no += 1
				)
					
				-- Add Normal Map:-----------------------------------------------------
				
				if rolC.chk_nml.state then 
				(				
					normalmap =	BakeToTexture.addMap Lowpoly #NormalMap
					normalmap.filename = (Lowpoly.name + nmlSuf as string)
					normalmap.setImageSize size size
					normalmap.fileType = dRol.rolC.ddl_imgTyp.items[dRol.rolC.ddl_imgTyp.selection]
					
						
					normalmap.projectionMethod = (ddl_prjMth.selection-1) 
					normalmap.projectionMaxRayDistance = 2.0  
					normalmap.edgePadding  = execute dRol.rolC.ddl_imgPad.items[dRol.rolC.ddl_imgPad.selection]
					
					
				)				
				else
				(
					noNmlMap = true
					no += 1
				)
					
					
				-------------------------------------------------------------------------
					
				if no == 3 then
				(
					print "no maps chosen"
				)
				else
				(
					---------------------------------------------
					local dif_str = undefined
					local rgh_str = undefined
					local nml_str = undefined
					---------------------------------------------
					if noDifMap then
					(
						dif_str = ""
					)
					else
					(
						dif_str = difmap.filename
					)
					---------------------------------------------
					if noRghMap then
					(
						rgh_str = ""
					)
					else
					(
						rgh_str = spcmap.filename
					)
					---------------------------------------------
					if noNmlMap then
					(
						nml_str = ""
					)
					else
					(
						nml_str = normalmap.filename
					)
					---------------------------------------------
					
					--Create texture maps in outpath folder-------------------------------
					--fn        param           param           param           	param---------------------------------						param					param					param
					MakeBitmaps dif_str 		rgh_str			nml_str 			dRol.rolC.ddl_imgTyp.items[dRol.rolC.ddl_imgTyp.selection]	dRol.rolC.chk_clr.state	dRol.rolC.chk_rgh.state	dRol.rolC.chk_nml.state
						
						
					--create new material for bake 
					newMaterial = CreateNewBakeMaterial newMaterial
						
						
					--apply material to selection
					Lowpoly.material = newMaterial
						
						
					--set output maps 
					if IsNewBakeMaterial then
					(
						--send to material slots
						clrmap.setTargetMapSlot 	"Base Color Map"
						normalmap.setTargetMapSlot  "Normal Map"
						rghmap.setTargetMapSlot 	"Roughness Map"
					)
					else
					(
						BakeToTexture.SetOutputTo Lowpoly #OriginalMaterial material:(newMaterial)	
							
						--send to material slots
						if noDifMap then
						(
							
						)
						else
						(
							difmap.setTargetMapSlot 	maps[1]
						)
						if noNmlMap then
						(
							
						)
						else
						(
							normalmap.setTargetMapSlot  maps[1]
						)
						if noRghMap then
						(
							
						)
						else
						(
							spcmap.setTargetMapSlot 	maps[1]
						)
					
						
					)
						
					--set materials and create nodes in SME
					SetMaterialInSME newMaterial
						
				)	
					
				--set outputpath location 8
				BakeToTexture.outputPath = bakePath
					
				-- start bake process, without a callback:
				--BakeToTexture.bake()
					
				--Select Assets
				select Lowpoly
				
				--set ready for bake
				rdyForBake = true
					
			)
		)
			
		on btn_sMaps pressed do 
		(
			--Open Slate Material Editor
			SME.close()
			sme.Open()
		)
					
    )
	
	--TO DO: 
		--Surface Map Bake Setup

	rollout rolE "Substance Settings"
	(
		
		
		local lowFbxPath = ""
		local higFbxPath = ""
		
		local texturesExportPath = ""
		local modelsExportPath = ""
		
		local selArr = #()
		
--------------------------------------------------------------------------
			
		Group "Substance Painter: "
		(
		
			--GUI
			bitmap 		bitmapBannerUi 						width:240 	height:52 		fileName:bitmapBannerFile align:#center gamma:1.0
			edittext 	edt_spp_path "" 					width:200 	offset:[35,0,0]				text:defaultSubstancePainterPath tooltip:"Substance Painter application folder path." fieldWidth:160 align:#center	across:2
			button 		btn_spp_path "Sync" 					width:45   	offset:[40,0,0]				--pos:[310,77,0] initialDir:defaultSubstancePainterPath 
				
		)
			
		Group "Spp Settings: "
		(
			edittext 	edittextUseSpp 		"" 							width:180		across:2	text:defaultSppPath tooltip:"Path to an existing Substance Painter document. Will be used as source for the custom spp creation." --fieldWidth:140
			button 		btnSppPath 				"Set .spp"  				width:60 	offset:[35,0,0]
				
		)
			
		Group "Project Settings: "
		(
				
			checkbutton chk_create_folder				"Create Folder" 					checked:true		across:3 	tooltip:"Will create a dedicated folder in the specified export path"			
			checkbutton chk_exprt_map 					"Export Map" 						checked:false 					tooltip:"Export with Normal map detected in the material"
			checkbutton replaceExistingSpProject 		"Replace SPP" 						checked:false 					tooltip:"A new .spp file will be created (previous version of the document will be removed.)"
			checkbutton displayExporterDialog 				"Quick Export" 					checked:false 		across:2	tooltip:"Display 3dsMax FBX export dialog, enable it to modify export settings"
			checkbutton checkboxKillSubstancePainter 		"Close Project" 				checked:true 					tooltip:"Automatically close/relaunch Substance Painter to get file updates. Save SP current document before use!"
				
			button BtnSendToSubstancePainter 			"Send to Substance Painter" 										tooltip:"Export current selection as FBX and create SP document." width: 200 height: 40 --pos:[80,302,0]
				
		)
			
			
		fn SetSubstanceExportPath = 
		(
			--try 
			(
				--edittextFileName.text = Lowpoly.name 
							
				--getExportPath = getSavePath ()
				
				str = (maxFilePath as string)
				
				
				str = substituteString str "_max\\" ""
				
				str2 = str 
				str2 = substituteString str2 "models" "textures"
				
				texturesExportPath = (str2 + "_painter\\") as string
				print texturesExportPath
					
				modelsExportPath =  (str + "_painter\\") as string     -- getExportPath as string
				print modelsExportPath
				
				
				--create texture mps and texture sets 
				
				
				
				if (doesFileExist modelsExportPath) then (
					--edittextFbxExportPath.text = modelsExportPath
				)
				else( messageBox "Not in the Correct Directory"
				)
				
			)
			--catch( print "Not in the Correct Directory" )
			
		)
		
		
		fn getObjects objectToExport=
		(
			-- Get selected objects
			objectsFromSelection = #()
			for obj in (selection as array) do (
				append objectsFromSelection obj
			)
			
			names = for i=1 to objectsFromSelection.count collect (objectsFromSelection[i].name)
			sort names
			
			objectsFromSelectionAlphabeticalOrder = #()
			
			-- Sort objects based on name
			for n=1 to names.count do(
				for s=1 to objectsFromSelection.count do (
					if (names[n] == objectsFromSelection[s].name) do (
						append objectsFromSelectionAlphabeticalOrder objectsFromSelection[s]
					)
				)
			)
			
			global objectToExport = objectsFromSelectionAlphabeticalOrder
		)
		
		
		fn copyNormal sourceObject completeExportPath =
		(
			materialsList = #()
			materialType = ""
			
			try(
				-- Check if the object use several materials
				if sourceObject.material.materialList != undefined do (
					materialType = "notClassic"
					for m = 1 to sourceObject.material.count do (
						append materialsList sourceObject.material[m]
					)
				)
			)
			catch (
				materialType = "classic"
				append materialsList sourceObject.material
			)
			
			-- Get Normal map(s) from listed material(s)
			for mat = 1 to materialsList.count do (
				try (
					materialName = materialsList[mat].name as string
				)
				catch()
				
				-- As Substance Painter automatically remove "#" characters in texture sets name we check if we have one
				try (
					if findString (materialName) "#" != undefined do (
						materialName = substituteString materialName "#" "_"
					)
				)
				catch ()
				
				if materialType == "classic" then (
					try (
						normalToCopy = sourceObject.material.bumpMap.normal_map.filename
						normalCopied = completeExportPath+"\\"+materialName+"_normal_base.png"
					)
					catch (
						print ("No normal to copy in " + materialsList[mat] as string)
					)
				)
				else if materialType == "notClassic" do (
					try (
						normalToCopy = sourceObject.material[mat].bumpMap.normal_map.filename
						normalCopied = completeExportPath+"\\"+materialName+"_normal_base.png"
					)
					catch (
						print ("No normal to copy in " + materialsList[mat] as string)
					)
				)
					
				if (normalToCopy != undefined) do (
					-- If the Normal already exist we remove it
					if doesFileExist normalCopied  == true do (
						try (
							deleteFile normalCopied
						)
						catch (
							print ("Can't remove existing Normal : " + normalCopied)
						)
					)
					if (copyFile normalToCopy normalCopied) do(
						append copiedNormalMaps normalCopied
					)
				)
			)
		)

		
		fn GetCurrentLowpolyCluster = 
		(
			
			
			selArr = #()
			
			for i in geometry do 
			(
				if (getUserPropVal i "Baking Attributes" asString:true) != undefined then 
				(
					--load Selection's Unity Attributes 
					bakingParams = execute (getUserPropVal i "Baking Attributes" asString:true)	
						
					--changed setting
					if bakingParams[1] == "Lowpoly Mesh" then 
					(
						selectmore i 
					)
				)
			)
				
			selArr = selection as array
			select selArr
		)
		
		
		
		fn ExportLowpolyMesh quick:false = 
		(
			local LowpolyCluster = #()
			
			if dRol.rolB.chk_lp_clu.checked then 
			(
				--
				GetCurrentLowpolyCluster()
					
				if quick == unsupplied then 
				(
					exportFile lowFbxPath selectedOnly:true
				)
				else
				(
					FbxExporterSetParam "Triangulate" true 
					FbxExporterSetParam "UpAxis" "Z"
					FbxExporterSetParam "SmoothingGroups" true
					FbxExporterSetParam "TangentSpaceExport" true
					FbxExporterSetParam "GeomAsBone" false
					FbxExporterSetParam "Animation" false
					
					exportFile lowFbxPath #noprompt selectedOnly:true
				)
				
			)
			else
			(			
				select Lowpoly	
					
				if quick == unsupplied then 
				(
					exportFile lowFbxPath selectedOnly:true
				)
				else
				(
					FbxExporterSetParam "Triangulate" true 
					FbxExporterSetParam "UpAxis" "Z"
					FbxExporterSetParam "SmoothingGroups" true
					FbxExporterSetParam "TangentSpaceExport" true
					FbxExporterSetParam "GeomAsBone" false
					FbxExporterSetParam "Animation" false
					
					exportFile lowFbxPath #noprompt selectedOnly:true
					
				)
				
				
				
			)
			

		)
		
		fn ExportHighpolyMesh quick:false = 
		(
			select Highpoly 
			
			FbxExporterSetParam "Triangulate" false 
			FbxExporterSetParam "UpAxis" "Z"
			FbxExporterSetParam "SmoothingGroups" true
			FbxExporterSetParam "TangentSpaceExport" false	
			FbxExporterSetParam "GeomAsBone" false
			FbxExporterSetParam "Animation" false
				
			
			
				
			if quick == unsupplied then 
			(
				exportFile higFbxPath selectedOnly:true
			)
			else(exportFile higFbxPath #noprompt selectedOnly:true)
			
			
		)
		
		
		
		
		-- Get Substance Painter path from button if input is valid
		on btn_spp_path pressed do 
		(
			getSubstancePainterPath = getSavePath ()
			SubstancePainterPath = getSubstancePainterPath as string
			if (doesFileExist SubstancePainterPath) do (
				edt_spp_path.text = SubstancePainterPath
			)
		)
		
		-- Get export path from button if input is valid
		on btnExportPath pressed do 
		(
			SetSubstanceExportPath()
		)
		
		on btnSppPath pressed do 
		(
			SppPath = getOpenFileName \ 
			caption:"Open a .spp File:" \ 
			types:"Spp files (*.spp)" \
			if (SppPath != undefined) then 
			(
				-- Check file extension to see if it is a .spp
				SppPathExtension = substring SppPath (SppPath.count-3) 4
				if SppPathExtension == ".spp" then (
					edittextUseSpp.text = SppPath
				)
				else (
					messageBox "Please select a .spp file"
					edittextUseSpp.text = ""
				)
			)
			else
			(
				edittextUseSpp.text = ""
			)
		)
			
		on BtnSendToSubstancePainter pressed do
		(
			if (Lowpoly == undefined or Highpoly == undefined ) then 
			(
				return false
			)
			
			--select lowpoly object 
			select Lowpoly 
			
			--set export path
			SetSubstanceExportPath()
						
			-- Check if something is selected
			if $ !=undefined then (
				spVersion = ""
				-- Check if the user specified a path for SP1 or SP2
				if (doesFileExist (edt_spp_path.text+"\\Adobe Substance 3D Painter.exe")) then (
					print "Substance Painter 1 detected"
					substancePainterFullPath = "\""+edt_spp_path.text as string+"\\Adobe Substance 3D Painter.exe\""
					spVersion = 1
				)
				else if (doesFileExist (edt_spp_path.text+"\\Adobe Substance 3D Painter.exe")) then (
					print "Substance Painter 2 detected"
					substancePainterFullPath = "\""+edt_spp_path.text as string+"\\Adobe Substance 3D Painter.exe\""
					spVersion = 2
				)
				else (
					messageBox "Substance Painter executable cannot be detected in specified path"
				)
				
				-- Check if specified SP path is valid
				if (doesFileExist (execute(substancePainterFullPath))) then (
					if not (doesFileExist modelsExportPath) do (
						try (
							makedir modelsExportPath
						)
						catch(
							print "Cannot create dir at specified FBX export path"
						)
					)
					
					if (doesFileExist modelsExportPath) then 
					(
						getObjects(objectToExport)
						select objectToExport
						print "Object(s) to export: "
						for i = 1 to objectToExport.count do (
							print objectToExport[i].name
						)
						
						-- Use the fileName set by the user if available
						if (Lowpoly.name != "" or Lowpoly.name != undefined) then (
							lpfileName = Lowpoly.name
							
							--if dRol.rolA.chk_high.checked then
							(
								--create highpoly path
								hpFileName = Highpoly.name
							)
							
						)
						else(
						-- Use the first object name as filename
							lpfileName = ((objectToExport[1]).name)
						)
						
						-- Set the export path based on folder creation option
						if (chk_create_folder.state == true) then 
						(							
								
							--rename spp file  
							sppFileName = substituteString lpfileName "_LP" ""
								
							completeExportPath = (modelsExportPath+"\\"+sppFileName) 
							completeTexturesExportPath = (texturesExportPath + "\\" + sppFileName)
								
							--create lowpoly folder
							makedir (completeExportPath+"\\low\\") 	
								
							--if dRol.rolA.chk_high.checked then
							(
								--create highpoly folder
								makedir (completeExportPath+"\\high\\") 
								
							)
							--create texture folder
							makedir (completeTexturesExportPath+"\\maps\\") 
							
						)
						else (
							completeExportPath = modelsExportPath
						)
							
						lowFbxPath = completeExportPath+"\\low\\"+lpfileName+".FBX"
							
						--if dRol.rolA.chk_high.checked then
						(
							--create highpoly folder
							higFbxPath = completeExportPath+"\\high\\"+hpFileName+".FBX"							
						)
							
						substancePainterProjectPath = completeTexturesExportPath+"\\"+sppFileName+"_Texturing"+".spp"
						
						srcPath = ""
						copyFile (defaultSubstancePainterPath+"\\resources\\samples\\MeetMat.spp")  substancePainterProjectPath
												
						
						--sppFile = createfile substancePainterProjectPath					
						
						
						
						-- No "hot reload" possible, here is the workaround: kill SP if option is enabled to allow quick preview for the user
						if (checkboxKillSubstancePainter.state == true) and spVersion == 1 then (
							DOSCOMMAND("taskkill /f /im \"Adobe Substance 3D Painter.exe\"")
						)				
						--Delete Substance painter project if it already exists (to replace it) based on the option
						if (replaceExistingSpProject.state == true) and (doesFileExist substancePainterProjectPath) do (
							try (
								-- Delay necessary to be sure the file is not "read only" anymore due to Substance Painter
								sleep 3
								deleteFile substancePainterProjectPath
							)
							catch (
								messageBox "Impossible to remove existing Substance Painter document."
							)
						)
						
						-- Check if the user specified a custom spp file
						if (doesFileExist edittextUseSpp.text) and edittextUseSpp.text != "" then (
							extension = substring edittextUseSpp.text (edittextUseSpp.text.count-3)  4
							if (extension == ".spp") then (
								if (copyFile edittextUseSpp.text (completeExportPath+"\\"+sppFileName+"_Texturing"+".spp")) then (
									print "Spp file successfully copied!"
								)
								else (
									messageBox ("Impossible to copy existing .spp file (can be related to administrator rights)."+
													"\nBe sure to enable \"Replace existing Substance Painter document\" if needed.\n\n"+
													"An empty Substance Painter document (or the already existing one) will be used instead."
									)
								)
							)
							else (
								messageBox "Please specify a path to a valid .spp file.\nAn empty Substance Painter document will be used instead."
							)
						)
						else if edittextUseSpp.text != "" do (
							messageBox "Spp file path is invalid.\nAn empty Substance Painter document will be used instead."
						)
						
						-- Create export folder if it doesn't exsist
						if doesFileExist completeExportPath  == false do (
							makedir completeExportPath
						)
						
						-- Exports the object as fbx with default settings. Display dialog depending on the option settings
						if (displayExporterDialog.checked == true or firstExport== true) then (
							
							--send lowpoly to painter folder
							ExportLowpolyMesh()
								
							--send lowpoly to painter folder
							ExportHighpolyMesh()
								
								
						)
						else(
								
							--send lowpoly to painter folder
							ExportLowpolyMesh quick:true
								
							--send lowpoly to painter folder
							ExportHighpolyMesh quick:true
								
						)
						
						-- Store the user path
						global userExportPath = modelsExportPath
						
						if doesFileExist lowFbxPath == true do (
							local firstExport = false
							print ("Export path: "+completeExportPath)
							
							-- Export the normal maps used in objects' materials is option is enabled
							if (chk_exprt_map.state  == true) do (
								copiedNormalMaps = #()
								for i = 1 to objectToExport.count do (
									copyNormal objectToExport[i] completeExportPath
								)
							)
							
							-- Store the user path
							global userSubstancePainterPath = edt_spp_path.text
							
							-- Base command
							substancePainterCmd = " \""+substancePainterProjectPath+"\""+" --export-path "+"\""+completeExportPath+"\""+" --mesh "+" \""+lowFbxPath+"\""
							
							-- Add normal map inputs to the command if available
							if (chk_exprt_map.state  == true and copiedNormalMaps != #()) do(
								for nrm = 1 to copiedNormalMaps.count do(
									substancePainterCmd += (" --mesh-map \""+copiedNormalMaps[nrm]+"\" ")
								)
							)
							
							print substancePainterCmd
							
							ShellLaunch substancePainterFullPath 	(substancePainterCmd)
						)
					)
				)
				else(
					messageBox "Please enter a valid path for Substance Painter"
				)
			)
			else(
				messageBox "Please select an object"
			)
		)
		
	)


	
	on globalTime tick do 
	(
		
		
		if bakePath != undefined and Lowpoly != undefined and Highpoly != undefined then
		(
			dRol.rolD.btn_sBake.enabled = on

		)
		else
		(
			dRol.rolD.btn_sBake.enabled = off
			rdyForBake = false
		)

		if rdyForBake then
		(
			dRol.rolD.btn_bake.enabled = on
		)
		else
		(
			dRol.rolD.btn_bake.enabled = off
		)




	)
	
	
	------------------------------------------------------------
	
    local rolls = #(rolA, rolB, rolE, rolC, rolD)

	------------------------------------------------------------	
    on dRol open do
        for roll in rolls do addSubRollout subRolls roll --rolledUp:true

	------------------------------------------------------------
)
createdialog dRol  width:300 height:710 





