try (DestroyDialog tst_saveload) catch ()
rollout tst_saveload "save and load"
(
	edittext edt_name "name data:"
	button btn_save "Save xml"
	button btn_load "Load xml"
	
	on btn_save pressed do 
	(
		xmlDoc = dotNetObject "system.xml.xmlDocument"
			
		DatEle = xmlDoc.createElement "FlowDataElement"
		flwDataTest = xmlDoc.createElement (edt_name.text as string )
			
			
		xmlDoc.appendChild DatEle 
		DatEle.appendChild flwDataTest	
			
		xmlDoc.save "C:\\Users\\albto\\OneDrive\\Documents\\GitHub\\_Toolset\\FlowPanels\\savedata\\xmlDataTest.xml"
			
		showProperties xmlDoc
		showMethods xmlDoc 
			
	)
		
		
)
	
CreateDialog tst_saveload 



	