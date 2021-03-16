(
global reNman
global objinSel
 
try (destroyDialog reNman) catch()	
rollout reNman "Rename Tools" width:156 height:46
(
	editText edt_InText "" pos:[0,3] width:151 height:19 enabled:false
	button btn_ren "Rename Object" pos:[4,25] width:150 height:19 enabled:false
 
	fn objInSel=
	(
		if selection.count ==1 then
		(
			edt_InText.enabled =true
			btn_ren.enabled =true
			edt_InText.text=$.name
		)
		else if selection.count>=2 then
		(
			edt_InText.text=""
			edt_InText.enabled =true
			btn_ren.enabled =true	
			edt_InText.text=selection[1].name
		)
		else if selection.count==0 do
		(
			edt_InText.enabled =false
			btn_ren.enabled=false
			edt_InText.text=""
		)
	)
 
	on btn_ren pressed do 
	(
		undo "rename my object" on
		(
			for i in selection where selection.count!=0 do
			(
				i.name = uniquename (edt_InText.text+" ")
			)
		)
	)
 
	on reNman close do
	(
		callbacks.removeScripts #selectionSetChanged id:#ObjNameCall
	)
 
	on reNman open do
	(
		callbacks.addScript #selectionSetChanged "renman.objInSel()" id:#ObjNameCall
	)
 
)
createDialog reNman
 
)