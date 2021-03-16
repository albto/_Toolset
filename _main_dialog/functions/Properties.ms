	group "Display Properties" 
	( 
	checkbox hde "Hide" 
	checkbox frz "Freeze" 
	checkbox disbox "Display as Box" 
	checkbox edgonly "Edges Only" 
	checkbox vertix "Vertex Ticks" 
	checkbox trajec "Trajectory" 
	checkbox sthrough "See-Through" 
	checkbox igtense "Ignore Extense" 
	checkbox sfreeze "Show Frozen in Gray" 
	button selname "Select By Name" pos: [50,205] 
	) 
	on selname pressed do 
	(
		hitByNameDlg() 
		if selection.count > 0 then
		(
			hde.checked = current_obj.isHidden
			frz .checked = current_obj.isFrozen
			disbox.checked = current_obj.boxMode
		)
		on hde changed state do if current_obj != undefined then current_obj.isHidden = state
on frz changed state do if current_obj != undefined then current_obj.isFrozen = state
on disbox changed state do if current_obj != undefined then current_obj.boxMode = state
	)
	
	on frz changed state do 
	(
		showclass $
	)