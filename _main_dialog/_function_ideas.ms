-- try(destroyDialog testR)catch()
-- rollout testR "Test" width:300
-- (
-- 	dotNetControl tabs "system.windows.forms.tabControl" width:(testR.width-30) height:25 
-- 	subRollout subRoll "Sub" width:(testR.width-30) height:200 offset:[0,-5]
-- 	fn initTabs tab labels:#() =
-- 	(
-- 		tab.tabPages.clear()
-- 		tab.sizeMode=tab.sizeMode.fixed
-- 		tab.itemSize=dotnetObject "System.Drawing.Size" ((tab.width/labels.count)-2) 25
-- 		for x in labels do tab.tabPages.add x
-- 	)
-- 	on testR open do
-- 	(
--  		initTabs tabs labels:#("Main", "Settings", "User")
-- 	)
-- )
-- createDialog testR    
-- cui.registerDialogBar testR style:#(#cui_floatable, #cui_handles, #cui_dock_vert, #cui_max_sized)	


-- rollout MyRollout "Yo" 
--  (
--  	label lbl_test "Haha"
--  )
--  MyFloater = newRolloutFloater "YoYo" 450 467 400 400
--  addRollout MyRollout MyFloater
--  
--  cui.RegisterDialogBar MyFloater style:#(#cui_dock_all, #cui_floatable, #cui_handles)

-- try(destroydialog dRolH) catch() 
-- rollout dRolH "Dialog" height:200 width:200 
-- (
-- dropdownlist rolList "Rollouts: " items:#("Rollout A", "Rollout B", "Rollout C") width:175 offset:[0,0]
-- checkbox lbA "A" pos:[14,50] visible:off
-- checkbox lbB "B" pos:[14,50] visible:off 
-- checkbox lbC "C" pos:[14,50] visible:off
--  
-- local rolls = #(#(lbA), #(lbB), #(lbC))
-- on rolList selected sel do
-- (
-- for k=1 to rolls.count do for c in rolls[k] do c.visible = (k == sel) 
-- )
-- )
-- createDialog dRolH pos:[740, 200]

rollout Test_Rollout "Untitled" width:162 height:300
(
	label label1 "Hello, world"
	spinner spinner2 "Spinner" offset:[0,200]
	
	on Test_Rollout resized size do
	(
		print(size)
		
		spinner2.fieldWidth = size.x
		
		print "Resized..."
	)
)

-- Resize notification does not trigger
rof = newRolloutFloater "Untitled" 162 300 lockHeight:false lockWidth:false autoLayoutOnResize:true
addRollout Test_Rollout rof



if classOf ::roMain == RolloutClass do DestroyDialog ::roMain

rollout roSubRollA "Group A"
(
	label lblA "Label A" pos:[20,5]
	spinner spnA "Spinner A:" range:[0,100,10] pos:[20,23]
)
 
rollout roSubRollB "Group B"
(
	label lblB "Label B" pos:[20,5]
	button btnB "BBBBBB" pos:[20,33]
	spinner spnB "Spinner B:" range:[0,300,30] pos:[20,63]
)
 
rollout roMain "Clevar SubRoll"
(
	checkButton chbShowA "Show A" checked:on across:2
	checkButton chbShowB "Show B" checked:off
 
	subRollout roSubA "" height:160 width:140 pos:[10,30]
	subRollout roSubB "" height:160 width:140 pos:[10,roSubA.height/2]
 
	on roMain open do 
	(
		AddSubRollout roMain.roSubA roSubRollA
		AddSubRollout roMain.roSubB roSubRollB
	)
 
	on chbShowA changed state do 
	(
		--chbShowB.state = not state
		roMain.roSubA.visible = state
		--roMain.roSubB.visible = not state
	)
 
	on chbShowB changed state do 
	(
		--chbShowA.state = not state
		--roMain.roSubA.visible = not state
		roMain.roSubB.visible = state
	)
)
createDialog roMain 160 200

