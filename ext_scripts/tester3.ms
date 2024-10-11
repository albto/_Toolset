rollout rolTest "Test"
(
    local p2PosTop = [10,10]
    local p2PosBottom = [10,40]
 
    button btButton_1 "Push Me!" width:60 height:30 pos:p2PosTop
 
    on btButton_1 pressed do
    (
        if (btButton_1.pos == p2PosTop) then
            btButton_1.pos = p2PosBottom
        else if (btButton_1.pos == p2PosBottom) then
            btButton_1.pos = p2PosTop
    )
)
 
createDialog rolTest 80 80 100 100 style:#(#style_toolwindow, #style_sysmenu, #style_resizing)


for i = 1 to pathConfig.getProjectSubDirectoryCount() do
(
format "%: %\n" i (pathConfig.getProjectSubDirectory i)
)

pathConfig.SetDir #export ".\export"




pathConfig.getProjectSubDirectory 3

pathConfig.merge


pathConfig.doProjectSetupSteps()




 btn_lod_ava
 btn_lod_met 
 chk_asObj
	
 ddl_refs
 lbl_space 
 lbl_space2  
lbl_space3 
 btn_rmv_ref 
 btn_upd_ref 
