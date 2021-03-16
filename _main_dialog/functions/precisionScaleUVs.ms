



try(destroyDialog ::dlgScaleSelectedUV)catch()
trsDialogIniFile = getDir #plugcfg + "/trsDialogs.ini"

fn doScaleUVs = ()

pivotArray = #([0,1,0], [1,1,0], [0.5,0.5,0], [1,1,0], [1,0,0])
rollout dlgScaleSelectedUV "Scale Selected UVs" width:350
(
	radiobuttons rdbPivot "Scale From:"\
		columns:3\
		align:#left\
		labels:#("", "", "", "", "")\
		offsets:#([0,0], [5,0], [-40,18],[0,20], [5,20])\
		across:4\
		default:1

	spinner spnU "U:" offset:[70, 0] range:[-10.0,10.00,1] fieldwidth:40
	checkbox cbxUniform offset:[80, 5] width:10 checked:true
	spinner spnV "V:" range:[-10.0,10.00,1] fieldwidth:40

	label spacer "" height:1

	group "Override Pivot"
	(
		checkbox cbxCustom "Custom Pivot" across:2
		checkbox cbxCenter "Center to Shell" align:#right
		spinner spnPivotU "U:" range:[0.0,1000,0] align:#center fieldwidth:40 enabled:false across:3
		spinner spnPivotV "V:" range:[0.0,1000,0] align:#center fieldwidth:40 enabled:false
		spinner spnPivotW "W:" range:[0.0,1000,0] align:#center fieldwidth:40 enabled:false
	)

	button btnScale "Scale" width:140

	on dlgScaleSelectedUV close do
	(
		setIniSetting trsDialogIniFile "dlgScaleSelectedUV" "Position" ((GetDialogPos dlgScaleSelectedUV) as string)
		setIniSetting trsDialogIniFile "dlgScaleSelectedUV" "Size" ((GetDialogSize dlgScaleSelectedUV) as string)
	)

	on cbxCenter changed state do
	(
		rdbPivot.enabled = (not state)
		if cbxCustom.checked == true then
		(
			cbxCustom.checked = false
			spnPivotU.enabled = false
			spnPivotV.enabled = false
			spnPivotW.enabled = false
		)
	)

	on cbxCustom changed state do
	(
		rdbPivot.enabled = (not state)
		spnPivotU.enabled = state
		spnPivotV.enabled = state
		spnPivotW.enabled = state
	)

	on spnU changed value do
	(
		if cbxUniform.checked == true then spnV.value = value
	)

	on spnV changed value do
	(
		if cbxUniform.checked == true then spnU.value = value
	)

	on btnScale pressed do
	(
		doScaleUVs()
	)
	subrollout presets "Scale Presets"
)

DialogSize = execute (getIniSetting trsDialogIniFile "dlgScaleSelectedUV" "Size")
DialogPos = execute (getIniSetting trsDialogIniFile "dlgScaleSelectedUV" "Position")

if DialogPos == OK and DialogSize == OK then
	createdialog dlgScaleSelectedUV
else if DialogPos == OK then
	createdialog dlgScaleSelectedUV pos:DialogPos
else if DialogSize == OK then
	createdialog dlgScaleSelectedUV size:DialogSize
else
	createdialog dlgScaleSelectedUV pos:DialogPos size:DialogSize


rci = rolloutCreator "quickScale" "Quick Scale"
rci.begin()
for i = 10 to 50 by 10 do
(
	local btnName = ("button_" + (i as string)) as name
	if (mod i 50) == 10 then rci.addControl #button btnName ("+ " + (i as string) + "%") paramStr:"width:50 across:5"
	else rci.addControl #button btnName ("+ " + (i as string) + "%") paramStr:"width:50"
	rci.addHandler btnName #pressed filter:on codeStr:("doScaleUVs uScale:" + ((1.0 + (i / 100.0)) as string) + " vScale:" + ((1.0 + (i / 100.0)) as string))
)
for i = -10 to -50 by -10 do
(
	local btnName = ("button_neg" + ((abs i) as string)) as name
	if (mod i -50) == -10 then rci.addControl #button btnName ("- " + ((abs i) as string) + "%") paramStr:"width:50 across:5"
	else rci.addControl #button btnName ("- " + ((abs i) as string) + "%") paramStr:"width:50"
	rci.addHandler btnName #pressed filter:on codeStr:("doScaleUVs uScale:" + ((1.0 + (i / 100.0)) as string) + " vScale:" + ((1.0 + (i / 100.0)) as string))
)

fn doScaleUVs uScale:0 vScale:0 =
(
	if uScale == 0 then uScale = dlgScaleSelectedUV.spnU.value
	if vScale == 0 then vScale = dlgScaleSelectedUV.spnV.value
	if dlgScaleSelectedUV.cbxCustom.checked then
	(
		pivotPoint = [dlgScaleSelectedUV.spnPivotU.value, dlgScaleSelectedUV.spnPivotV.value, dlgScaleSelectedUV.spnPivotW.value]
	)
	else
	(
		pivotPoint = pivotArray[dlgScaleSelectedUV.rdbPivot.state]
	)
	for obj in $ do
	(
		if dlgScaleSelectedUV.cbxCenter.checked then pivotPoint = obj.modifiers[#unwrap_uvw].getSelCenter()
		obj.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY uScale vScale (pivotPoint as Point3)
		exit
	)
)

addSubRollout dlgScaleSelectedUV.presets (rci.end())
dlgScaleSelectedUV.height += 80
dlgScaleSelectedUV.presets.height = 90

