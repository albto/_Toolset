
increment = -.1

--grid align Objects 
for i in selection do 
(
	print ("value = "+ (((floor (1.0*i.pos.x/increment)*increment) as float*10)/10) as string )
	
	print ("pos = " + ((i.pos.x*10)/10) as string )
	
	if (((floor (1.0*i.pos.x/increment)*increment) as float*10)/10) == ((i.pos.x*10)/10) then
	(
		print "all aligned"
	)
	else(
		i.pos = [(floor (1.0*i.pos.x/increment+increment)*increment) as float, i.pos.y, i.pos.z]
	)
)






-- increment = .1




-- grid align Objects 
for i in selection do 
(
	print ("value = "+ (((floor (1.0*i.pos.x/increment+increment)*increment) as float*10)/10) as string )
	
	print ("pos = " + ((i.pos.x*10)/10) as string )
	
	if (((floor (1.0*i.pos.x/increment+increment)*increment) as float*10)/10) == ((i.pos.x*10)/10) then
	(
		print "all aligned"
	)
	else(
		i.pos = [(floor (1.0*i.pos.x/increment+increment)*increment) as float, (floor (1.0*i.pos.y/increment+increment)*increment) as float, (floor (1.0*i.pos.z/increment+increment)*increment) as float]
	)
)


--visualize open dialogs 
list = UIAccessor.GetPopupDialogs() 
openDialogs = #()
for i = 1 to list.count do 
(
	--UIAccessor.CloseDialog i
	openDialogs[i] = UIAccessor.GetWindowText list[i]
)

print openDialogs