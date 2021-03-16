try(destroydialog dRol) catch()

Global rolA, rolB, rolC, rolD


rollout dRol "Bake To Texture Config" 
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
	
	local clrFilename = ""
	local rghFilename = ""
	local nmlFilename = ""

	local Lowpoly
	local Highpoly
	
	local rdyForBake = false
	
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
	fn SetMaterialInSME mtl = 
	(
		
		wasOpen = SME.isOpen()
		
		--Create nodes
		clrNode = Bitmaptexture 	filename:clrFilename
		--aoNode	= BitmapTexture() --filename:clrFilename
		rghNode = BitmapTexture 	filename:rghFilename
		nmlNode = BitmapTexture 	filename:nmlFilename
			
		--apply maps to slots 
		--mtl.ao_map = aoNode
		mtl.base_color_map = clrNode
		mtl.roughness_map = rghNode
		mtl.normalmap = nmlNode
		
		--open dialog 
		if wasOpen then
		(
			
		)
		else
		(
			SME.Open()
		)	
			
		--create viewport
		if ((sme.GetViewByName "Lowpoly Materials") == undefined) then
		(
			matView = sme.createView "Lowpoly Materials"
		)
		
		--set sme viewport
		smeView = (sme.GetView (sme.GetViewByName "Lowpoly Materials"))
				
		--reset view 
		smeView.SelectAll()
		smeView.DeleteSelection()
			
		--create material 
		smeView.CreateNode mtl [0,0]
		smeView.SetFocus()

		if wasOpen then
		(
			sme.Close()
			sme.Open()
		)
		else
		(
			sme.Close()
		)

			
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
	
    subRollout subRolls "" width:(dRol.width as float -20) height:880 pos:[10,5]
		
	fn switchRolls openedRoll =
        for roll in dRol.rolls where roll != openedRoll do roll.open = false
		
    rollout rolA "Selection Panel" 
    (			
			
		Group "Baker Setup:"
		(
			pickbutton pck_high "Pick Highpoly"								width:110	height:20	across:2
			pickbutton pck_low	"Pick Lowpoly"								width:110	height:20
			Button chk_autoSet "Auto-Setup"									width:230	height:25	align:#center
			checkbox chk_high	"Highpoly Exists"							tooltip:"Highpoly Object must be named '_High'"	across:2
			checkbox chk_low 	"Lowpoly Exists"							tooltip:"Lowpoly Object must be named '_Low'"
		)
		
				----------------------------------------------------------------------------------		
		on chk_autoSet pressed do 
		(
			if chk_high.checked then 
			(
				--find high object
				high = "_High"
				findHigh = (getNodeByName high)
				try select findHigh catch()
				
				--set high
				Highpoly = findHigh
				pck_high.object = Highpoly
				dRol.rolB.edt_high.text = Highpoly.name as string
					
			)					
				
			if chk_low.checked then
			(
				--find low object
				low = "_Low"
				findLow = (getNodeByName low) 
				try select findLow catch()
				
				--set low
				Lowpoly = findLow
				pck_low.object = Lowpoly
				dRol.rolB.edt_low.text = Lowpoly.name as string
				
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
		
		Group "Object Setup:"
		(
			edittext edt_high 	"High:"										width: 100	height:20	across:2
			edittext edt_low 	"Low:"										width: 100	height:20
		)
		
		Group "Object Generation:"
		(
			button btn_genLow	"Generate Lowpoly"						width:180	height:30	align:#center
			
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
					difmap.filename = Lowpoly.name + "_clr"
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
					spcmap.filename = Lowpoly.name + "_rgh"
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
					normalmap.filename = Lowpoly.name + "_nml"
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
	
    local rolls = #(rolA, rolB, rolC, rolD)

	------------------------------------------------------------	
    on dRol open do
        for roll in rolls do addSubRollout subRolls roll --rolledUp:true

	------------------------------------------------------------
)
createdialog dRol  width:300 height:810 





