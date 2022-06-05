struct flowCore
(
	public
		
	xmlDoc = dotNetObject "system.xml.xmlDocument",
		
	fn Constructor = 
	(
		
		return xmlDoc	
	),
	
	function LoadXml = 
	(
		--load XML
		xmlDoc.load @"D:\Projects\Project3D\Assets\Resources\Layers\UnityLayers.xml"
					
		--PLACE THIS IN THE STARTUP FOLDER
		if xmlDoc != undefined then
		(
			print ("Xml " + xmlDoc.name + " - Loaded")
		)
		
		
	),

	Initialize = Constructor()
	
)
