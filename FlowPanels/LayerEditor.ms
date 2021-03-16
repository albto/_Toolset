
try DestroyDialog lyrEdt Catch()

Rollout lyrEdt "Layer Editor"
(
	local all_layers = #()
	local lyrs = #()
	local objArr = #()
	
	
	label lbl_lyr_amnt "Number of Layers: "
	label lbl_act_lyr  "Active Layer:"
	dropdownlist lst_layers "Active Layer:"
	listbox lst_layer_nodes "Nodes"   		
	button btn_Empty_Layer "Clean Empty Layers"			width:120	height:30
	button btn_Cur_Obj_Lyr "Select Obj Layer"			width:120	height:30
	button btn_Add_Act_Lyr "Add to Active Layer"		width:120	height:30
	button btn_ref_Layer "Refresh Layers"			width:120	height:30
		
	timer lbl_tim interval:100
		
	--------------------------------------------------------------------------------------------------------------------------------------------------
		
	--Generate Layers - FUNCTION
	fn genFileLayers = 
	(		
		for i = 0 to layerManager.count-1 do
		(
			ilayer = layerManager.getLayer i
			layerName = ilayer.name
			layer = ILayerManager.getLayerObject i
			layerNodes = refs.dependents layer
			
			--format "Layer: %; nodes: %\n" layerName layerNodes
			
			if layerName == "0" then 
			(
				layerName = "Default Layer"
			)
			
			append lyrs layerName
				
		)
			
		--add layers to listbox
		lst_layers.items = lyrs
			
		free lyrs
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------------------
		
	on lst_layers selected itm do 
	(
		
		
		lyr = LayerManager.getLayer (itm-1)
		lyr.current = true
			
		lyr.nodes &objArr
		--lst_layers_nodes.items = lyr.nodes &objArr

		lst_layer_nodes.items = for i in objArr collect i.name as string
		
	)
		
	on lst_Layer_nodes selected itm do 
	(
		select (getNodeByName (objArr[itm].name as string))
		
		--print (objArr[itm].name)
		
	)
	
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
		
	--Clean-Up empty layers
	on btn_Empty_Layer pressed do 
	(
		_defaultlayer = layerManager.getLayer 0
		_defaultlayer.current = true
			
		try
		(	
			_total_layers = layerManager.count - 1
			_layercount = #()
			_layercount = for i = 1 to _total_layers collect i
			_revlayers = #()
			for i in _layercount.count to 1 by -1 do append _revlayers _layercount[i]
				
			for j in _revlayers do
			(
				_getlayer = layerManager.getlayer j
				LayerManager.deleteLayerByName _getlayer.name
			)		
				
			--refresh list
			genFileLayers()
				
		)
		catch()
			
	)	
	--------------------------------------------------------------------------------------------------------------------------------------------------
		
	--refresh list --temp fix
	on btn_ref_Layer pressed do 
	(		
		--refresh list
		genFileLayers()
	)	
		
	--------------------------------------------------------------------------------------------------------------------------------------------------
		
	--Add Selection to Active Layer
	on btn_Add_Act_Lyr pressed do 
	(
		
		_cur_Layer = LayerManager.current 
		
		undo on
		for i in selection as array do 
		(
			_cur_Layer.addnode i
		)
		
	)
	--------------------------------------------------------------------------------------------------------------------------------------------------	
		
	--Make Current Layer Active
	on btn_Cur_Obj_Lyr pressed do 
	(
		sel = selection[1]
		
		lyr = LayerManager.getLayerFromName sel.layer.name
		
		lyr.current = true
		
		
	)
	--------------------------------------------------------------------------------------------------------------------------------------------------
		
	--Timer Ticker
	on lbl_tim tick do 
	(
		
-- 		callbacks.removeScripts id:#testCallback
-- 		callbacks.addScript #filePreOpenProcess "genFileLayers()" id:#testCallback
		
		--find layer
		ly = LayerManager.current
		curLyr = ly.name
			
			
		-- all_layers= for i in LayerManager.getlayer i 
		lbl_lyr_amnt.text = ("Number of Layers: " + layerManager.count as string)
			
		--current active layer - update
		if curLyr == "0" then 
		(
			lbl_act_lyr.text = "Active Layer: " + "Default Layer"
		)
		else
		(
			lbl_act_lyr.text = "Active Layer: " + curLyr as string
		)
	)
	--------------------------------------------------------------------------------------------------------------------------------------------------
		
	--ON OPEN DO 
	on lyrEdt open do 
	(
		
		--refresh and generate layers in list
		genFileLayers()
		
	)
		
		
	--------------------------------------------------------------------------------------------------------------------------------------------------
	

	
	
)

createDialog lyrEdt width:200