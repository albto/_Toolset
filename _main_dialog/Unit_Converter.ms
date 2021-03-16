try destroyDialog ucu catch()

rollout ucu "Unit Conversion Panel"
(
	edittext edt_cnv1 "Unit Amount:"	labelontop:true --across:2
	dropdownlist dpl_cnv1 "Unit"		items:#("CM","Meters", "Inches") width:65		across:2
	dropdownlist dpl_cnv2 "Converion"	items:#("CM","Meters", "Inches") width:65
	edittext edt_cnv2 "Result:"			labelontop:true readOnly:true
	button btn_cnv "Convert Unit"
	
	on btn_cnv pressed do 
	(
		--------------------------------------------------------------------------------------------------------------------------
		-- Centimeters to Centimeters
		if dpl_cnv1.selection == 1 and dpl_cnv2.selection == 1 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = amt as string + " cm" 
			
		)
		-- Centimeters to Meters
		if dpl_cnv1.selection == 1 and dpl_cnv2.selection == 2 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = (amt * 0.01) as string + " m" 
			
		)
		-- Centimeters to Inches
		if dpl_cnv1.selection == 1 and dpl_cnv2.selection == 3 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = (amt * 0.393701) as string + " inches" 
			
		)
		--------------------------------------------------------------------------------------------------------------------------
		-- Meters to Centimeters
		if dpl_cnv1.selection == 2 and dpl_cnv2.selection == 1 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = (amt * 100) as string + " cm" 
			
		)
		-- Meters to Meters
		if dpl_cnv1.selection == 2 and dpl_cnv2.selection == 2 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = amt as string + " m" 
			
		)
		-- Meters to Inches
		if dpl_cnv1.selection == 2 and dpl_cnv2.selection == 3 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = (amt * 39.3701) as string + " inches" 
			
		)
		--------------------------------------------------------------------------------------------------------------------------
		-- Inches to Centimeters
		if dpl_cnv1.selection == 3 and dpl_cnv2.selection == 1 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = ((amt * 2.54) as string + " cm" )
			
		)
		-- Inches to Meters
		if dpl_cnv1.selection == 3 and dpl_cnv2.selection == 2 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = (amt * 0.0254) as string + " m" 
			
		)
		-- Inches to Inches
		if dpl_cnv1.selection == 3 and dpl_cnv2.selection == 3 do 
		(
			amt = edt_cnv1.text as float 
			
			edt_cnv2.text = amt as string + " inches" 
			
		)
		--------------------------------------------------------------------------------------------------------------------------
	)

)	

createDialog ucu