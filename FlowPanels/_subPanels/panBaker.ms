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
	
	local clrFilename = ""
	local rghFilename = ""
	local nmlFilename = ""

	local ExportPath = ""
	
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
	
    subRollout subRolls "" width:(dRol.width as float -20) height:1280 pos:[10,5]
		
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
				high = "*_High*"
				arr = #()
					
				nameArr = (for i in geometry collect i.name)
								
				for val in nameArr where MatchPattern val pattern:high do 
				(				
					
					findHigh = (getNodeByName val)
				)					
					
				--try select findHigh catch()
				print ("highpoly mesh = " + findHigh as string)
				
				--set high
				Highpoly = findHigh
				pck_high.object = Highpoly
				dRol.rolB.edt_high.text = Highpoly.name as string
					
			)					
				
			if chk_low.checked then
			(
				--find low object
				low = "*_Low"
				arr = #()
					
				nameArr = (for i in geometry collect i.name)
					
				objName = ""
				
				for val in nameArr where MatchPattern val pattern:low do 
				(				
					print val 
					objName = val 
					findLow = (getNodeByName val)
				)					
					
				findLow = getNodeByName objName
				--try select findHigh catch()
				print ("lowpoly mesh = " + findLow as string)
				--try select findLow catch()
				
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
			edittext edt_low 	"LP Mesh:"									width: 240	height:20	--across:2
			edittext edt_high 	"Hp Mesh:"									width: 240	height:20	
			
		)
		
		Group "Object Generation:"
		(
			button btn_genLow	"Generate Lowpoly"						width:120	height:30	align:#center	across:2
			button btn_updLow	"Update Lowpoly"						width:120	height:30	align:#center
			
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
					
				select Lowpoly
					
				FbxExporterSetParam "Triangulate" true 
				FbxExporterSetParam "UpAxis" "Z"
				FbxExporterSetParam "SmoothingGroups" true
				FbxExporterSetParam "TangentSpaceExport" true
				FbxExporterSetParam "GeomAsBone" false
				FbxExporterSetParam "Animation" false
					
				exportFile dRol.rolE.lowFbxPath #noprompt selectedOnly:true
					
				-----------------------------------------------------------
-- 					
-- 				select Highpoly 
-- 					
-- 				FbxExporterSetParam "Triangulate" false 
-- 				FbxExporterSetParam "UpAxis" "Z"
-- 				FbxExporterSetParam "SmoothingGroups" true
-- 				FbxExporterSetParam "TangentSpaceExport" false	
-- 				FbxExporterSetParam "GeomAsBone" false
-- 				FbxExporterSetParam "Animation" false
-- 					
-- 				exportFile higFbxPath #noprompt selectedOnly:true
					
					
				-----------------------------------------------------------
			)
				
			
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

	rollout rolE "Substance Settings"
	(
		
		
		local lowFbxPath = ""
		local higFbxPath = ""
		
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
				
			edittext 	edittextFileName 		"Exported file name:" 			labelontop:true tooltip:"Allow to use a custom name for the exported file. If none is specified, it will use the first object in alphabetic order." text:"" 
				
			button 		btnExportPath 			"Export path:"  					width:200 --pos:[310,102,0]
			edittext 	edittextFbxExportPath 	"" 									width:200 text:defaultExportPath 					tooltip:"Path where the meshes are exported/Substance documents are created." fieldWidth:160 align:#center
				
		)
			
		Group "Project Settings: "
		(
				
			checkbutton chk_create_folder				"Create Folder" 					checked:true		across:3 	tooltip:"Will create a dedicated folder in the specified export path"			
			checkbutton chk_exprt_map 					"Export Map" 						checked:false 					tooltip:"Export with Normal map detected in the material"
			checkbutton replaceExistingSpProject 		"Replace SPP" 						checked:false 					tooltip:"A new .spp file will be created (previous version of the document will be removed.)"
			checkbox displayExporterDialog 				"Quick Export" 						checked:false 					tooltip:"Display 3dsMax FBX export dialog, enable it to modify export settings"
			checkbox checkboxKillSubstancePainter 		"Close Open Painter Projects" 		checked:true 					tooltip:"Automatically close/relaunch Substance Painter to get file updates. Save SP current document before use!"
				
			button BtnSendToSubstancePainter 			"Send to Substance Painter" 										tooltip:"Export current selection as FBX and create SP document." width: 200 height: 40 --pos:[80,302,0]
				
		)
			
			
		fn SetSubstanceExportPath = 
		(
			try 
			(
				edittextFileName.text = Lowpoly.name 
							
				--getExportPath = getSavePath ()
				
				str = (maxFilePath as string)
				
				str = substituteString str "_max\\_art\\" ""
					
				ExportPath =  (str + "_painter\\") as string     -- getExportPath as string
				print ExportPath
				
				if (doesFileExist ExportPath) then (
					edittextFbxExportPath.text = ExportPath
				)
				else( messageBox "Not in the Correct Directory"
				)
				
			)
			catch( print "Not in the Correct Directory" )
			
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
					if not (doesFileExist ExportPath) do (
						try (
							makedir ExportPath
						)
						catch(
							print "Cannot create dir at specified FBX export path"
						)
					)
					
					if (doesFileExist ExportPath) then (
						getObjects(objectToExport)
						select objectToExport
						print "Object(s) to export: "
						for i = 1 to objectToExport.count do (
							print objectToExport[i].name
						)
						
						-- Use the fileName set by the user if available
						if (Lowpoly.name != "" or Lowpoly.name != undefined) then (
							lpfileName = Lowpoly.name
							hpFileName = Highpoly.name
						)
						else(
						-- Use the first object name as filename
							lpfileName = ((objectToExport[1]).name)
						)
						
						-- Set the export path based on folder creation option
						if (chk_create_folder.state == true) then 
						(							
							completeExportPath = (ExportPath+"\\"+lpfileName) 
								
							makedir (completeExportPath+"\\low\\") 
							makedir (completeExportPath+"\\high\\") 
							makedir (completeExportPath+"\\maps\\") 
						)
						else (
							completeExportPath = ExportPath
						)
						
						lowFbxPath = completeExportPath+"\\low\\"+lpfileName+".FBX"
						higFbxPath = completeExportPath+"\\high\\"+hpFileName+".FBX"
						substancePainterProjectPath = completeExportPath+"\\"+lpfileName+".spp"
						
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
								if (copyFile edittextUseSpp.text (completeExportPath+"\\"+fileName+".spp")) then (
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
							
							
							select Lowpoly
							
							FbxExporterSetParam "Triangulate" true 
							FbxExporterSetParam "UpAxis" "Z"
							FbxExporterSetParam "SmoothingGroups" true
							FbxExporterSetParam "TangentSpaceExport" true
							FbxExporterSetParam "GeomAsBone" false
							FbxExporterSetParam "Animation" false
								
							exportFile lowFbxPath  selectedOnly:true
								
							
							select Highpoly 
							
							FbxExporterSetParam "Triangulate" false 
							FbxExporterSetParam "UpAxis" "Z"
							FbxExporterSetParam "SmoothingGroups" true
							FbxExporterSetParam "TangentSpaceExport" false	
							FbxExporterSetParam "GeomAsBone" false
							FbxExporterSetParam "Animation" false
								
							exportFile higFbxPath  selectedOnly:true
								
						)
						else(
							
							
							select Lowpoly
							
							FbxExporterSetParam "Triangulate" true 
							FbxExporterSetParam "UpAxis" "Z"
							FbxExporterSetParam "SmoothingGroups" true
							FbxExporterSetParam "TangentSpaceExport" true
							FbxExporterSetParam "GeomAsBone" false
							FbxExporterSetParam "Animation" false
								
							exportFile lowFbxPath #noprompt selectedOnly:true
								
							
							select Highpoly 
							
							FbxExporterSetParam "Triangulate" false 
							FbxExporterSetParam "UpAxis" "Z"
							FbxExporterSetParam "SmoothingGroups" true
							FbxExporterSetParam "TangentSpaceExport" false	
							FbxExporterSetParam "GeomAsBone" false
							FbxExporterSetParam "Animation" false
								
							exportFile higFbxPath #noprompt selectedOnly:true
							
							
						)
						
						-- Store the user path
						global userExportPath = ExportPath
						
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
	
    local rolls = #(rolA, rolB, rolE) --, rolC, rolD)

	------------------------------------------------------------	
    on dRol open do
        for roll in rolls do addSubRollout subRolls roll --rolledUp:true

	------------------------------------------------------------
)
createdialog dRol  width:300 height:810 





