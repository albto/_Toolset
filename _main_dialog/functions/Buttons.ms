    button dockLeftBt "Dock Left"
	button dockRightBt "Dock Right"
    button floatBt "Float"
    button closeBt "Close"

    --Register the rollout as a dialogBar then dock it to the left.
    on dockLeftBt pressed do
    (
        cui.registerDialogBar myRoll
        cui.dockDialogBar myRoll #cui_dock_left
    )
    --Register the rollout as a dialogBar then dock it to the right.
	on dockRightBt pressed do
    (
        cui.registerDialogBar myRoll
        cui.dockDialogBar myRoll #cui_dock_right
    )

    --Float dialog if it is registered as a dialogBar
    on floatBt pressed do
    (
        if myRoll.dialogBar then (cui.floatDialogBar myRoll)
    )

    --Unregister dialogBar bar before trying to close it using destroyDialog.
    on closeBt pressed do
    (
        if myRoll.dialogBar then (cui.unRegisterDialogBar myRoll)
        destroyDialog myRoll
    )