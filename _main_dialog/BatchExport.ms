try (destroyDialog exportMe) catch()

Rollout exportMe "Batch Export"
(
	local usedotNam = sysInfo.username as string
	local fldPath
	local lastPath = ("C:\\users\\"+ usedotNam as string +"\\Desktop")
	
	edittext txt_loc 	"Directory Path:" 		labelontop:true
	label lbl_exp_prog	"Export Progress:"		align:#left
	progressbar progbar "Progress"				color:green 
	button btn_exp_loc 	"Export Location"		width: 160		height:40
	button btn_exp 		"Export Seleciton"		width: 160		height:40
	

	on btn_exp_loc pressed do 
	(
		
		
		fldPath = getSavepath caption:(" \n \n Your Desktop will be chosen, if nothing is selected.") initialDir:lastPath
		
		
		if fldPath == undefined then
		(
			
			if lastPath == undefined then
			(
				fldPath = ("C:\\users\\"+ usedotNam as string +"\\Desktop")
			)
			else
			(
				fldPath = lastPath
				txt_loc.text = fldPath as string
			)
			
		)
		else
		(
			lastPath = fldPath
			txt_loc.text = fldPath as string
		)
			
		txt_loc.text = fldPath as string
	)
	
	on btn_exp pressed do 
	(
		selgroup = selection as array
		
		if fldPath == undefined then
		(
			messagebox "Pick an Export Location, Sir."
		)
		else
		(
			if selection.count > 0 do
			(
				o = 1
				for i = o to selgroup.count do 
				(
					select selgroup[i]
					objname = $.name
					
					dirName = (fldPath + "\\" + objname)
					
					exportfile dirName #noPrompt selectedOnly: True 
					
					progBar.value = 100*i/selgroup.count
					lbl_exp_prog.text = "Export Progress: " + progBar.value as string + "%" 
					
				)	
					
			)
				
		)
		if progbar.value == 100 do
		(
			messagebox "Export Completed"
			lbl_exp_prog.text = "Export Progress:"
			progbar.value = 0
		)
		
	)	
	
)

createDialog exportMe width:200