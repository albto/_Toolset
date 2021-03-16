global MyPath
if MyPath == undefined do 
(
	MyPath = ""
)


rollout TestDialog "Dialog"
(
	
	label labelExportFolder "Export folder" pos:[10,10] 
	edittext folderPathTxt "" text:MyPath pos: [10,30] width:140
	button btnBrowse "..." pos: [160,30]
	button btnLoad "Load Path" 
	
	--Saves Path
	fn setFOKINPATH =
	(
		if MyPath != undefined do
		(
			local maxINI = getMAXIniFile()
			setINISetting  maxINI "EliasScriptSettings" "ExportDirectory" MyPath
		)
	)
	--Loads Path
	fn getFOKINPATH =
	(
		local maxINI = getMAXIniFile()
		MyPath = getINISetting  maxINI "EliasScriptSettings" "ExportDirectory"
		folderPathTxt.text = MyPath 
	)

	on btnBrowse pressed do 
	(
		MyPath = getSavePath caption:"Choose export directory"
		if (MyPath != undefined) do 
		(
			folderPathTxt.text = MyPath 
		)
		-- setINISetting  MaxINI "EliasScriptSettings" "ExportDirectory" "test" -- !!ERROR HERE!!
		setFOKINPATH()
	)
	
	on btnLoad pressed do 
	(
		getFOKINPATH()
	)
)
createdialog TestDialog width: 200 height: 200