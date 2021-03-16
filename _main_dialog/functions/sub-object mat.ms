try(closeRolloutFloater rof)catch()
 
rollout a "Multi/Sub-Object Presets" width:350 height:496
(
	button btn_1 "Create" pos:[124,26] width:60 height:16
	label lbl1 "Standard" pos:[8,26] width:112 height:16
	spinner stdnum_mtl "Standard Sub Mtl count" pos:[20,47] width:164 height:16 range:[2,100,10] type:#integer fieldwidth:40
	button btn_2 "Create" pos:[124,66] width:60 height:16
	label lbl2 "Vray" pos:[8,66] width:112 height:16
	spinner vraynum_mtl "Vray Sub Mtl count" pos:[42,87] width:142 height:16 range:[2,100,10] type:#integer fieldwidth:40
	editText basename "Material Base Name: " pos:[6,4] width:178 height:16 text:"myMaterial"
 
	on btn_1 pressed do
	(
		mat = multimaterial()
		mat.count = stdnum_mtl.value
 
		for i=1 to mat.count do
			mat[i] = standardmaterial name:(basename.text + i as String) diffusecolor:(random black white)
 
		meditmaterials[activeMeditSlot] = mat
	)--end on
	on btn_2 pressed do
	(
		mat = multimaterial()
		mat.count = vraynum_mtl.value
 
		for i=1 to mat.count do
			mat[i] = Vraymtl name:(basename.text + i as String) diffuse:(random black white)
 
		meditmaterials[activeMeditSlot] = mat
	)--end on
)--end ro
 
rollout b "About" width:200 height:200
(
label lbl1 "Multi/Sub-Object Presets v0.5" pos:[55,8] width:112 height:16
label lbl2 "Created by Andy Butler" pos:[30,24] width:160 height:16
HyperLink homepage "SB_Tools" pos:[70,56] width:65 height:15 address:"http://www.scriptspot.com/users/script-butler/" color:(color 255 255 255) hovercolor:(color 255 0 0) visitedcolor:(color 255 153 51)
)--end ro
 
rof=newrolloutfloater "Multi/Sub-Object Presets v0.5" 226 256 
 
addRollout a rof rolledUp:false
addRollout b rof rolledUp:false