	rollout lockUnlock "lockUnlock" width:84 height:63
	(
		label lbl1 "Links info :" pos:[2,2] width:80 height:15
		button btn1 "Lock All !!?" pos:[2,19] width:80 height:20
		button btn2 "Unlock" pos:[2,41] width:80 height:20
		on btn1 pressed  do
			setTransformLockFlags selection #all
		on btn2 pressed  do
			setTransformLockFlags selection #none
	)
	createDialog lockUnlock style:#(#style_titlebar, #style_toolwindow, #style_sysmenu)