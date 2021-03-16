
	if selection.count != 0 do
	(
		for o in selection do
		(
			objName = o.name
			if (objLayer = LayerManager.getLayerFromName objName) == undefined then
			(
				objLayer = Layermanager.newLayerFromName objName
	 			objLayer.addNode o
			)
			else
			(
				objLayer.addNode o
			)
		)
	)