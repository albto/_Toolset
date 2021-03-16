try destroyDialog positionSnap catch()
rollout positionSnap "Position Snap" width:125
(
	spinner spnSnapMult "Unit: " range:[0,1e6,100] fieldWidth:65 type:#worldUnits align:#left
	checkButton chbSnap "SNAP" width:100 height:25 align:#left

	fn roundNearest nr mult =
	(
		if nr < 0 do mult *= -1
		nr + mult/2 - 1 - mod (nr + mult/2 - 1) mult
	)

	mapped fn correctPos obj =
		obj.pos = [roundNearest obj.pos.x spnSnapMult.value,
				   roundNearest obj.pos.y spnSnapMult.value,
				   roundNearest obj.pos.z spnSnapMult.value]

	fn redefineTransformHandlers sel =
	(
		deleteAllChangeHandlers id:#autoSnapTransform
		when transform sel changes id:#autoSnapTransform obj do correctPos obj
	)

	fn initCallbacks =
	(
		callbacks.removeScripts id:#autoSnapTransform
		callbacks.addScript #selectionSetChanged "positionSnap.redefineTransformHandlers selection" id:#autoSnapTransform
		redefineTransformHandlers selection
	)

	fn removeHandlersAndCallbacks =
	(
		 callbacks.removeScripts id:#autoSnapTransform
		 deleteAllChangeHandlers id:#autoSnapTransform
	)

	on positionSnap open do
		removeHandlersAndCallbacks()

	on chbSnap changed state do
		if state then initCallbacks()
		else removeHandlersAndCallbacks()

	on positionSnap close do
		removeHandlersAndCallbacks()
)
createDialog positionSnap