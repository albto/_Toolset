	
	--load unity layers xml file
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
				
	--load Max Toolset Settings xml file
	struct flowData
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
			xmlDoc.load @"C:\Users\albto\OneDrive\Documents\GitHub\_Toolset\FlowPanels\savedata\xmlDataWriter.xml"
						
			--PLACE THIS IN THE STARTUP FOLDER
			if xmlDoc != undefined then
			(
				print ("Xml " + xmlDoc.name + " - Loaded")
			)
		),
			
		Initialize = Constructor()
			
	)
	
	
	struct flowParams
	(
		public
			
		areatag = #("_Art", "_Design", "_Inst", "_Prop", "_Vehicle", "_Weapon", "_Test", ""),
		areasuf = #("no_tag","_000", "_050", "_100","_150", "_200","_250", "_300","_350", "_400","_450", "_500","_550", "_600","_650", "_700","_750", "_800","_850", "_900","_950", "_Uni"),
		arealab = #("_Art", "_Design", "_Inst", "_Prop", "_Vehicle", "_Weapon", "_Test", "null"),
		
		
		function FindByObjectAttribute objName objAttribute = 
		(
			for obj in objects do 
			(
				if getUserProp obj objName == objAttribute then 
					return obj 
			)
			undefined
		)

		
	)
	
	
	