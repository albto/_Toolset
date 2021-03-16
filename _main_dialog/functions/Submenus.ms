rcMenu myMenu 
(	
	submenu "Tool Settings"
	(
		menuItem myItem4 "Close Tool"
		submenu "Dock Tool"
		(
		menuItem myItem1 "Dock Right"
		menuItem myItem2 "Dock Left"
		menuItem myItem3 "Float Tool"		
		)
	)
    -- Allows the Tool to Dock Right 
	on myItem1 picked do
    (
		cui.registerDialogBar myRoll
        cui.dockDialogBar myRoll #cui_dock_right
	)
    -- Allows the Tool to Dock Left	
    on myItem2 picked do
    (
		cui.registerDialogBar myRoll
        cui.dockDialogBar myRoll #cui_dock_left
	)
    -- Allows the Tool to Float
    on myItem3 picked do
    (
        if myRoll.dialogBar then (cui.floatDialogBar myRoll)
	)
    -- Close Tool
	on myItem4 picked do
	(
	    if myRoll.dialogBar then (cui.unRegisterDialogBar myRoll)
        destroyDialog myRoll
	)
)