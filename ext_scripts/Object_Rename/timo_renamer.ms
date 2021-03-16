/********************************************************
:Author:	Timothy Halim
:Site:		dottimo.tumblr.com
:Email:	timothy.halim@live.com
:Date:		15 Feb 2016
:Update:	5 Mar 2016
:notes:	Original idea by Rob Swinburn http://www.scriptspot.com/3ds-max/scripts/object-rename-0
********************************************************/
-- Modify at your own risk
-- Add credits if published again
-- Enjoy!

RenamerVersion ="1.0"

try destroydialog renamer catch()
try destroydialog renamer_help catch()
rollout renamer_help "Help" width:100
(
	label Help "----- Help -----"
	button btn_ObjName "$ - Objectname" width:90 align:#center tooltip:"Insert Current Object name"
	button btn_MatName "@ - Materialname" width:90 align:#center tooltip:"Insert Current Material name"
	button btn_Number "# - Number" width:90 align:#center tooltip:"Insert Number to Name"
	button btn_close "Close" width:90 align:#center tooltip:"Close Help"
	
	on btn_objname pressed do renamer.edt_name.text = renamer.edt_name.text+"$"
	on btn_MatName pressed do renamer.edt_name.text = renamer.edt_name.text+"@"
	on btn_Number pressed do 
	(
		renamer.edt_name.text = renamer.edt_name.text+"#"
		renamer.spn_numstart.enabled = true
		renamer.spn_digit.enabled = true
	)
	on btn_close pressed do destroydialog renamer_help
)
rollout renamer "Renamer"
(
	groupbox grp_rename "Renamer" pos:[5,5] width:(renamer.width as float -10)
	label lbl_rename "Rename"
	dropdownlist ddl_rename "" width:100 items:#("Object", "Material")
	button btn_help "?" border:off tooltip:"Help"
	button btn_name "Name" width:50 border:off tooltip:"Clear name field"
	Edittext edt_name fieldwidth:160
	Spinner spn_numstart "Start" range:[0,10000,1] type:#integer fieldwidth:40 tooltip:"Start from"
	Spinner spn_digit "Suffix" range:[2,10,3] type:#integer fieldwidth:40 tooltip:"Suffix Length"
	button btn_rename "Rename" width:210 tooltip:"Rename selected Object"
	
	groupbox grp_findreplace "Find and Replace" width:(renamer.width as float -10) 
	button btn_find "Find" width:50 border:off tooltip:"Clear find text field"
	Edittext edt_find fieldwidth:160 
	button btn_with "Replace" width:50 border:off tooltip:"Clear replace text field"
	Edittext edt_with fieldwidth:160
	button btn_replace "Replace" width:210 tooltip:"Execute Find and Replace on Selection"
	
	groupbox grp_remove "Remove Character" width:(renamer.width as float -10)
	button btn_rmStart "Remove From Begining" width:150 tooltip:"Remove characters from begining"
	spinner spn_start "" range:[0,1000,0] type:#integer fieldwidth:40 tooltip:"Start Character"
	button btn_rmEnd "Remove From End" width:150 tooltip:"Remove characters from End"
	spinner spn_end "" range:[0,1000,0] type:#integer fieldwidth:40 tooltip:"End Character"
	
	HyperLink hl_email "Mail" across:3 align:#center offset:[0,0] color:(color 200 200 200) hovercolor:(color 255 255 255) visitedcolor:(color 200 200 200) address:"mailto://timothy.halim@live.com"
	HyperLink hl_web "Website" align:#center offset:[0,0] color:(color 200 200 200) hovercolor:(color 255 255 255) visitedcolor:(color 200 200 200) address:"http://dottimo.tumblr.com"
	HyperLink hl_donate "Donate" align:#center offset:[0,0] color:(color 200 200 200) hovercolor:(color 255 255 255) visitedcolor:(color 200 200 200) address:"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=NS2NFUHX7NCUQ&lc=ID&item_name=Timothy%20Halim&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted"
	
	local RnDest
	local oname
	
	function fn_init =
	(
		lbl_rename.pos = [grp_rename.pos.x+10,grp_rename.pos.y+17]
		ddl_rename.pos = [lbl_rename.pos.x+45,lbl_rename.pos.y-3]
		btn_help.pos = [renamer.width-30,grp_rename.pos.y +13]
		btn_name.pos = [grp_rename.pos.x+5,lbl_rename.pos.y +20] 
		edt_name.pos = [btn_name.pos.x+50,btn_name.pos.y+2]
		spn_numstart.pos = [btn_name.pos.x+115,btn_name.pos.y+25]
		spn_digit.pos = [spn_numstart.pos.x+83,btn_name.pos.y+25]
		btn_rename.pos =[grp_rename.pos.x+5,btn_name.pos.y+45]
		grp_rename.height = (btn_rename.pos.y+25)
		
		grp_findreplace.pos = [grp_rename.pos.x,grp_rename.pos.y+grp_rename.height]
		btn_find.pos = [grp_findreplace.pos.x+5, grp_findreplace.pos.y+15]
		edt_find.pos = [btn_find.pos.x+50,btn_find.pos.y+2]
		btn_with.pos = [btn_find.pos.x,btn_find.pos.y+25]
		edt_with.pos = [btn_find.pos.x+50,btn_find.pos.y+27]
		btn_replace.pos = [grp_findreplace.pos.x+5,btn_with.pos.y+25]
		grp_findreplace.height = (btn_replace.pos.y+25-grp_rename.height)
		
		grp_remove.pos = [grp_findreplace.pos.x,grp_findreplace.pos.y+grp_findreplace.height]
		btn_rmStart.pos = [grp_remove.pos.x+5, grp_remove.pos.y+15]
		spn_start.pos = [btn_rmStart.pos.x+195, btn_rmStart.pos.y+3]
		btn_rmEnd.pos = [btn_rmStart.pos.x, btn_rmStart.pos.y+25]
		spn_end.pos = [spn_start.pos.x, spn_start.pos.y+25]
		grp_remove.height = (btn_rmEnd.pos.y+30- grp_findreplace.pos.y-grp_findreplace.height)
		renamer.height = grp_rename.height + grp_findreplace.height + grp_remove.height +20
		
		hl_email.pos = [hl_email.pos.x, (renamer.height-14)]
		hl_web.pos = [hl_web.pos.x, (renamer.height-14)]
		hl_donate.pos = [hl_donate.pos.x, (renamer.height-14)]
	)
	function fn_checkstate =
	(
		if findString edt_name.text "#" != undefined then 
		(
			spn_numstart.enabled = true
			spn_digit.enabled = true
		)
		else 
		(
			spn_numstart.enabled = false
			spn_digit.enabled = false
		)
		if edt_find.text != "" then btn_replace.enabled = true else btn_replace.enabled = false
	)
	on renamer open do
	(
		fn_init()
		renamer.title = ".timo - Renamer v." +RenamerVersion
		fn_checkstate()
	)
	on renamer moved pos do
	(
		if renamer_help.isdisplayed do
		(
			renamerpos = GetDialogPos renamer
			setdialogpos renamer_help [renamerpos.x+renamer.width+10,renamerpos.y+30]
		)
	)
	on btn_help pressed do
	(
		createdialog renamer_help style:#()
		renamerpos = GetDialogPos renamer
		setdialogpos renamer_help [renamerpos.x+renamer.width+10,renamerpos.y+30]
	)
	on btn_name pressed do edt_name.text = ""
	on btn_find pressed do (edt_find.text = "";fn_checkstate	())
	on btn_with pressed do edt_with.text = ""
	on edt_name changed txt do fn_checkstate	()
	on btn_rename pressed do
	(
		if edt_name.text != "" do
		(
			undo "Rename" on
			(
				onum = spn_numstart.value
				digit = (10^(spn_digit.value-1)) as string
				obj = selection as array
				for i=1 to obj.count do 
				(
					oname= edt_name.text
					for j=1 to oname.count do
					(
						findtext = "#"
						if spn_digit.value > 1 do 
						(	
							n = (i+spn_numstart.value-1)
							if i < 10 do n = ("0" + n as string)
							if i >= 10 do n = n as string
							
							replacetext = ((substring (digit as string) 2 (digit.count-2))+ n)
							if replacetext.count > digit.count do replacetext = substring replacetext (replacetext.count-(digit.count-1)) (replacetext.count)
						)
						num = findString oname findtext
						if num != undefined do oname = replace oname num findtext.count replacetext
						
						findtext = "$"
						num = findString oname findtext
						if num != undefined do oname = replace oname num findtext.count obj[i].name
						
						findtext = "@"
						num = findString oname findtext
						if num != undefined  and obj[i].material != undefined  then oname = replace oname num findtext.count obj[i].material.name
						else if num != undefined do oname = replace oname num findtext.count "No Material"
					)
					if ddl_rename.selection == 1 do obj[i].name = oname
					if ddl_rename.selection == 2 and obj[i].material != undefined do obj[i].material.name = oname
				)
			)
		)
	)
	on edt_find changed txt do fn_checkstate	()
	on btn_replace pressed do
	(
		if edt_find.text != "" do
		(
			undo "Rename" on
			(
				obj = selection as array
				for i=1 to obj.count do 
				(
					findtext = edt_find.text
					if ddl_rename.selection == 1 do
					(
						num = findString obj[i].name findtext
						if num != undefined do obj[i].name = replace obj[i].name num findtext.count edt_with.text
					)
					if ddl_rename.selection == 2 and obj[i].material != undefined do
					(
						num = findString obj[i].material.name findtext
						if num != undefined do obj[i].material.name = replace obj[i].material.name num findtext.count edt_with.text
					)
				)
			)
		)
	)
	on btn_rmStart pressed do
	(
		undo "Rename" on
		(
			obj = selection as array
			for i=1 to obj.count do 
			(
				if ddl_rename.selection == 1 do obj[i].name = substring obj[i].name (spn_start.value+1) (obj[i].name.count)
				if ddl_rename.selection == 2 and obj[i].material != undefined do obj[i].material.name = substring  obj[i].material.name (spn_start.value+1) (obj[i].material.name.count)
			)
		)
	)
	on btn_rmEnd Pressed do
	(
		undo "Rename" on
		(
			obj = selection as array
			for i=1 to obj.count do 
			(
				if ddl_rename.selection == 1 do obj[i].name = substring obj[i].name (1) (obj[i].name.count-spn_end.value)
				if ddl_rename.selection == 2 and obj[i].material != undefined do obj[i].material.name = substring obj[i].material.name (1) (obj[i].material.name.count-spn_end.value)
			)
		)
	)
	on renamer close do
	(
		try destroydialog renamer_help catch()
	)
)
createdialog renamer width:230