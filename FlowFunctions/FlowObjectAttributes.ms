-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------


macroScript IBGUnityAttributesDelete
category:"FlowAttributes"
toolTip:"Delete Unity Attributes"
(
		
-- 	m = EmptyModifier()
-- 	m.name = "Unity Attributes"	
-- 		
-- 		
-- 	for i in selection as array do 
-- 	(
-- 		--filter modifier
-- 		mdf = i.modifiers[#Unity_Attributes]
-- 		
-- 		--Removes Attributes Modifier
-- 		custAttributes.delete i UnityAttributes baseObject:true --add the attribute in the first modifier
-- 			
-- 		--checks to remove active attributes before being applied to object	
-- 		if( (classOf mdf) == (classof m)) then
-- 		(
-- 			index = modPanel.getModifierIndex i mdf
-- 			
-- 			try (deleteModifier i (index) ) catch()
-- 		)
-- 		else
-- 		(
-- 			continue
-- 		)
-- 			
-- 	)
		
	for o in selection as Array do 
	(
			
		--set settings	
		fps = #()
		
		--record settings	
		setUserPropBuffer o ""
		--setUserProp o "Unity Attributes" ""  
		--setUserPropVal o "Unity Attributes" fps 
		--deleteUserProp o "Unity Attributes" 
		
	)
	
)

macroScript IBGUnityAttributesClear
category:"FlowAttributes"
toolTip:"Clear Unity Attributes"
(
		
	m = EmptyModifier()
	m.name = "Unity Attributes"	
		
	for i in selection as array do 
	(
		--filter modifier
		mdf = i.modifiers[#Unity_Attributes]
		
		--Removes Attributes Modifier
		custAttributes.delete i UnityAttributes baseObject:true --add the attribute in the first modifier
			
		--checks to remove active attributes before being applied to object	
		if( (classOf mdf) == (classof m)) then
		(
			index = modPanel.getModifierIndex i mdf
			
			try (deleteModifier i (index) ) catch()
		)
		else
		(
			continue
		)
			
	)
	
)

macroScript IBGUnityAttributesHelper
category:"FlowAttributes"
toolTip:"Unity Attributes Helper"
(
	global FlowAttEditor 	
	
	--link to script here 
	sysFolder = sysInfo.windowsdir
	subS = substituteString sysFolder "WINDOWS" ("Users\\" + sysInfo.username as string)
	
	if (doesDirectoryExist (subS + "\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms") ) then
	(
		sysFolder = (subS + "\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms")
	)
	else
	(
		sysFolder = (subS + "\\OneDrive\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowObjectAttributesEditor.ms")
	)
	
	filein sysFolder
	
)








