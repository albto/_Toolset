


---------------------------------------------------------------------------------------------------------------// Banner 	
		
	---------------------------------------------------------------------------------------------------------------// Selection


		group "Selection Type:" 	
		(
			button btn_selname "Name Select" 	width:80 height: 20 	across:2 	align:#center
			button btn_selsim "Select Similar" 	width:80 height: 20 				align:#center
			button btn_selclr "Select By Color" width:80 height: 20 	across:2	align:#center
			button btn_selset "Selection Sets" 	width:80 height: 20 				align:#center
		)
			

		group "Organize Layers:"
		(
			CheckButton chk_autLay "Auto-Organize Layers" 				width:180 height: 30	checked:true
			Button btn_openCtrl "Open Layer Controller"					width:180 height: 30
		)
		
		Group "Custom Layers:"
		(
			Button btn_setLay "Create Layer from Selection" 			width:180 height: 30
			checkbox multiLay "Unique Layer per Object"				width:180 height: 30	align:#center
		)
			
	---------------------------------------------------------------------------------------------------------------// Current Selection Function
		
		--auto Layer Scene
		on chk_autLay changed state do
		(
				
			if state then
			(
				
				--Remove any existing callbacks with this ID.
				callbacks.removeScripts id:#MXSHelp
				--Add a new callback script which will call --callbacks.notificationParam() before selected nodes are deleted --and thus will print the deleted objects to the Listener:
				callbacks.addScript #nodeCreated " AutoLayer()" id:#MXSHelp			
				
				AutoLayer()
			)
			else
			(
				UnSubscribe()
			)
				
		)
			
		--Open layer controller dialog
		on btn_openCtrl pressed do 
		(
			
			filein "FlowPanels//_subPanels//panObjMan.ms"
			
		)
			
		--create layer from selection 
		on btn_setLay pressed do 
		(
			if multiLay.checked then 
			(
				selGroup = selection as array
				
				for i in selGroup do
				(	
					lay = LayerManager.NewLayer()
						
					lay.addnode i
					lay.setname (i.name as string)
				)
			)
			else 
			(
				lay = LayerManager.NewLayer()
						
				selGroup2 = selection as array
						
				for i in selGroup2 do
				(	
					lay.addnode i
						
				)
						
				sel = selGroup2[1]
					
				lay.setname (sel.name as string)
			)					
		)
		
		
		
		
		
		on btn_selset pressed do
		(
			macros.run "Edit" "namedbtn_selsets"
		)
		
		
		on btn_selclr pressed do
		(
			max select by color
		)
			
		on btn_selsim pressed do
		(
			actionMan.executeAction 0 "40099" 
		)
			
		On btn_selname pressed do 
		(
			hitByNameDlg()
		)
			
			
	---------------------------------------------------------------------------------------------------------------// Clean Up Controls
		
		Group "Clean-Up:"
		(
			button selNQ "Sel. NGons" 		width:80 	height: 20	across:2 	align:#center
			button selOF "Sel. Open" 		width:80 	height: 20				align:#center
-- 			button selMCU "Mesh CleanUp" 	width:160 	height: 30				align:#center
		)


		On selNQ pressed do 
		(
			for i in selection do 
			(
				NQmod = edit_poly()
				NQMod.name = "CLEAN-UP: N-Gons"
				addModifier $ NQMod
				subobjectLevel = 4
				macros.run "PolyTools" "NonQuad"
			)
		)

		On selOF pressed do 
		(
			for i in selection do 
			(
				OFmod = edit_poly()
				OFMod.name = "CLEAN-UP: Open Faces"
				addModifier $ OFMod
				subobjectLevel = 3
				macros.run "PolyTools" "OpenSelect"
			)
		)
		
		On selMCU pressed do
		(
			macros.run "rapidTools" "rapidMeshCleanUp"
		)	
			
		-------------------------------------------------------------------------------------------------------------------------------------
		--OPEN // CLOSED
		-------------------------------------------------------------------------------------------------------------------------------------
			
		on panOrganize rolledUp open do 
		(
			if use_AutoCollapse == true do 
			(
				if open do switchRolls panOrganize
			)
		)
			
		on panOrganize rolledUp close do 
		(
			if use_AutoCollapse == true do 
			(
				if close do switchRolls panOrganize
			)
		)