try (DestroyDialog edt) catch()

rollout edt "scene file properties editor"
(
	
	edittext edt_title "Title"  
	--edittext edt_subj "Subject"
	--edittext edt_auth "Author"
	--edittext edt_mana "Manager"
	edittext edt_comp "Company"
	dropdownList ddl_Cat "Category" 	items:#("Props", "Structures", "Prefabs", "Vehicles", "Characters", "Tilesets", "Weapons")
 
	button btn_setProps "Set Scene Properties"
	
	on btn_setProps pressed do 
	(
			
		-- Add some properties
		fileProperties.addProperty #summary "Title" 	edt_title.text
		fileProperties.addProperty #summary "Subject" 	"Game Assets"
		fileProperties.addProperty #summary "Author" 	sysInfo.username as string --edt_subj.text
			
		fileProperties.addProperty #contents "Manager" 	"Flow Tools"
		fileProperties.addProperty #contents "Company" 	edt_comp.text
		fileProperties.addProperty #contents "Category" ddl_Cat.items[ddl_Cat.selection] as string
			
		fileProperties.addProperty #custom "TileSet Size" 4
		fileProperties.addProperty #custom "FloatVal" 1.234
		fileProperties.addProperty #custom "IsPrefabScene" true
		fileProperties.addProperty #custom "Created On" "05/11/2001" #date
		--
		-- Perform a scene hold to update the Contents set.
		max hold
			
		-- Get all properties
		pages = #( #summary, #contents, #custom)
		for pg in pages do
		(
		format "--- % ---\n" (pg as string)
		for i=1 to (fileProperties.getNumProperties pg) do
		(
		local pname = (fileProperties.getPropertyName pg i)
		local pval = (fileProperties.getPropertyValue pg i)
		format "\t% : " pname
		if (pname =="Headers") then
		(
		format "\n"
		for hdr in pval do
		(
		format "\t\t%\n" hdr
		local docs = fileProperties.getItems hdr
		if docs != undefined then
		for d in docs do format "\t\t\t%\n"d
		)
		)
		else format " %\n" pval
		)
		)
		
	)
)	 
 
 CreateDialog edt  width:200 height:400
 
 
 
 
 
