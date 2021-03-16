try DestroyDialog SSets Catch()
	
Rollout SSets "Selection Sets List"
(
	local SelArr =#()
	local selected = false
	
	group "Sets List:"
	(
	
		DropDownlist dd_sets "Selection Sets" items:#() 
	)
	
	Group "Set Creation:"
	(
		Edittext edt_Set "Set Name:"							labelontop: true
		Button btn_add "Create Set from Selection"				width:140
		Button btn_apn "Append Current to Set"					width:140
		Button btn_rmv "Remove Item From Set"					width:140
		Button btn_dlt "Delete Selection Set"					width:140
-- 		Timer deltaTimer "" Interval: 100 active:false
	)
	--------------------------------------------------------------------------------------------------------------------------------------------
	--Refresh list 
	fn GenerateList = 
	(
		if selectionSets.count >= 1 do 
		(
			
			for i = 1 to selectionSets.count do 
			(
				SelArr[i] = GetNamedSelSetName i as string
				
				dd_sets.items = SelArr					
			)
			
		)
	)
		
	--------------------------------------------------------------------------------------------------------------------------------------------	TICK
		
-- 	on deltaTimer tick do 
-- 	( 
-- 		
-- 	)
	--------------------------------------------------------------------------------------------------------------------------------------------	CREATE SET
	on btn_add pressed do
	(
		sel = selection as array
		
		selectionSets[edt_Set.text as string] = sel
		GenerateList()
		
		edt_Set.text = ""
		dd_sets.selection = dd_sets.items.count
	)
	--------------------------------------------------------------------------------------------------------------------------------------------	APPEND TO SET
	on btn_apn pressed do 
	(
		sel = Selection as array
		
		if selectionSets.count >= 1 then 
		(						
			if sel.count >= 1 then
			(
				for i = 1 to 1 do 
				(
					
					selSet = selectionSets[GetNamedSelSetName dd_sets.selection] 
					
					selectMore selSet
					
					sel += selSet
					
					selectionSets[GetNamedSelSetName dd_sets.selection] = sel
					
					print (GetNamedSelSetName dd_sets.selection)
					
					--Refresh list
					GenerateList()					
					
				)
			)
		)		
	)
	--------------------------------------------------------------------------------------------------------------------------------------------	REMOVE FROM SELECTION SET	
		
	on btn_rmv pressed do
	(
		sel = selection as array
		objsToDel = #()
		if selectionSets.count >= 1 then 
		(					
			if sel.count >= 1 then
			(
				arr =#()
				selCur = sel	
					
					
				selSet = selectionSets[GetNamedSelSetName dd_sets.selection] 
					
				for i = 1 to selCur.count do 
				(
						
					objsToDel = for i in selCur collect i
						
					select selSet
					deselect objsToDel	
						
					arr = selection as array
				)
					
				selectionSets[GetNamedSelSetName dd_sets.selection] = arr
					
				
			)
				
			--Refresh list
			GenerateList()		
				
			deselect $*
		)

	)	
	--------------------------------------------------------------------------------------------------------------------------------------------	DELETE SELECTION SET	
		
	on btn_dlt pressed do 
	(
			
		SelArrNew = #()
		
		--Gets selection
		nss = selectionSets[GetNamedSelSetName dd_sets.selection]
		deleteItem selectionSets nss
		dd_sets.selection = dd_sets.items.count-1
		
		for i = 1 to selectionSets.count do 
		(
			SelArrNew[i] = GetNamedSelSetName i as string
			
			dd_sets.items = SelArrNew
		)
		
	)
	--------------------------------------------------------------------------------------------------------------------------------------------	SELECT SET				
	on dd_sets selected i do
	(
		if selectionSets.count >= 1 do 
		(
			select selectionSets[i]	i
		)
	)
	--------------------------------------------------------------------------------------------------------------------------------------------	REFRESH LIST				
	on dd_sets rightClick do 
	(	
		if selectionSets.count >= 1 do 
		(
			--Refresh list
			GenerateList()
			
		)

	)
		
	--------------------------------------------------------------------------------------------------------------------------------------------			
		
	
	on SSets open do 
	(
		--Refresh list
		GenerateList()
		
	)
	
	
	
)


CreateDialog SSets  width:200