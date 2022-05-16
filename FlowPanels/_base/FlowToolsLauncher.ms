macroScript FlowToolsLauncher
category:"Flow Panels"
toolTip:"Open Tools Launcher"
Icon:#("Patches",1)
buttonText:"Flow Panels"
(
		
	--link to script here 
	sysFolder = sysInfo.windowsdir
	subS = substituteString sysFolder "WINDOWS" ("Users\\" + sysInfo.username as string)
	
	if (doesDirectoryExist (subS + "\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowToolsLauncher_Set.ms") ) then
	(
		sysFolder = (subS + "\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowToolsLauncher_Set.ms")
	)
	else
	(
		sysFolder = (subS + "\\OneDrive\\Documents\\GitHub\\_Toolset\\FlowPanels\\_base\\FlowToolsLauncher_Set.ms")
	)
	
	filein sysFolder
		
)