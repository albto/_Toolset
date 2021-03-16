global d 

if d == undefined then 
(	
	d = Dictionary()
)

try destroyDialog boxes catch()
try destroyDialog wndw catch()
try destroyDialog test catch()

Rollout test "Dictionary Tests"
(
	label  lbl_name "Dictionary Test"		
	button btn_test "Create New Entry" 		width:160	height:40
	button print_test "Print Dictionary" 	width:160	height:40
	button btn_clear "Clear List"	 		width:160	height:40
		
	edittext key_Value "key value:"
		
	dropdownlist lst_box "Dictionary:" items:d.keys
		
	button btn_edt "Edit Entry"	 		width:170	height:20
		
	edittext val_ofKey "value of selected item:" labelontop: true
		
------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	on btn_test pressed do 
	(
		try destroyDialog boxes catch()
		
		rollout boxes "New Entry Dialog"
		(
			label lbl_entry "Please do not Delete '#' "
			edittext itm_name "Name:" text:"#"
			button pressme "create"  		width:120	height:40
				
			----------------------------------------------------------------------------------
				
			on pressme pressed do 
			(
				--substitutes spaces for underscore
				s1 = itm_name.text
				s2 = " "
				s3 = "_"
				ss = substitutestring s1 s2 s3
					
				--adds Key value
				PutDictValue d (execute ss) (key_Value.text)  putOnlyIfNew:true
					
				--refresh list
				lst_box.items = d.keys
					
				destroyDialog boxes
			)
				
			----------------------------------------------------------------------------------
				
			on itm_name entered i do 
			(
				--substitutes spaces for underscore
				s1 = itm_name.text
				s2 = " "
				s3 = "_"
				ss = substitutestring s1 s2 s3
					
				--adds Key value
				PutDictValue d (execute ss) (key_Value.text) putOnlyIfNew:true
					
				--refresh list
				lst_box.items = d.keys
					
				destroyDialog boxes
			)
			
		)
			
		createDialog boxes
	)
		
------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	on btn_edt pressed do 
	(
		
		if (d.count > 0) do 
		(
			
			global ster = ("#" + lst_box.selected as string)
			global ster2 = GetDictValue d (execute ster)
				
				
			try destroyDialog wndw catch()
			rollout wndw "Edit Entry"
			(
				edittext valNam "Entry Name:" text:ster readOnly: true
				edittext chngVal "Current Value:" 		width:380 	height:60	labelontop: true text:ster2 fieldwidth:380
				button accpt "Accept"					width:160	height:40	across:2
				button dlt_Entry "Delete Entry"  		width:160	height:40
					
				----------------------------------------------------------------------------------
					
				on accpt pressed do
				(
					--edits key value
					SetDictValue d (execute ster) (chngVal.text as string)
						
					--refresh list
					lst_box.items = d.keys
						
					--clear and destroy dialog
					val_ofKey.text = chngVal.text
					destroyDialog wndw
				)
					
				----------------------------------------------------------------------------------
					
				on dlt_Entry pressed do 
				(
					RemoveDictValue d (execute ster)
					
					lst_box.items = d.keys
					lst_box.selection = (d.count - (d.count-1))
					destroyDialog wndw
				)
					
				----------------------------------------------------------------------------------				
					
			)			
			
			--valNam.text = ster
			
			createDialog wndw width:400
		)
	)
		
------------------------------------------------------------------------------------------------------------------------------------------------------------		
		
	on lst_box rightClick do 
	(
		if (d.count > 0) do 
		(
			global ster = ("#" + lst_box.selected as string)
			global ster2 = GetDictValue d (execute ster)
				
				
			try destroyDialog wndw catch()
			rollout wndw "Edit Entry"
			(
				edittext valNam "Entry Name:" 			text:ster readOnly: true
				edittext chngVal "Current Value:" 		width:380 	height:60	labelontop: true text:ster2 fieldwidth:380
				button accpt "Accept"					width:160	height:40	across:2
				button dlt_Entry "Delete Entry"  		width:160	height:40
					
				----------------------------------------------------------------------------------
					
				on accpt pressed do
				(
					SetDictValue d (execute ster) (chngVal.text as string)
						
					lst_box.items = d.keys
						
					val_ofKey.text = chngVal.text
					destroyDialog wndw
				)
					
				----------------------------------------------------------------------------------
					
				on dlt_Entry pressed do 
				(
					RemoveDictValue d (execute ster)
					
					lst_box.items = d.keys
					lst_box.selection = (d.count - (d.count-1))
					destroyDialog wndw
				)
					
				----------------------------------------------------------------------------------				
					
			)			
			
			--valNam.text = ster
			
			createDialog wndw width:400
		)
	)
		
------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	on lst_box selected val do 
	(
			
		str = ("#" + lst_box.selected as string)
			
			
		str2 = GetDictValue d (execute str)
			
			
		print (str + ": value = " + GetDictValue d (execute str))
		print ("key name is "+str)
		print (str2)
		val_ofKey.text = str2
	)
		
------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	on btn_clear pressed do 
	(
		free d
		lst_box.items = d.keys
		val_ofKey.text = ""
	)
		
------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	on print_test pressed do 
	(
		GetDictKeys d
		print (d)
	)
		
)
createdialog test  width: 200 height:300
