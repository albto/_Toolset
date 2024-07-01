
try (DestroyDialog roll_Color) catch()


colorDict = Dictionary #(#Character, color 125 89 23) #(#Decal, color 6 61 135) #(#Interiors, color 135 59 8) #(#Lights, color 28 149 177) #(#Props, color 176 26 26) #(#Structures, color 225 88 199) #(#Terrain, color 148 177 27) #(#Vehicles, color 8 8 136)#(#VertexAnims, color 85 28 177)#(#Weapons, color 227 153 153)                      



rollout roll_Color "Global Color Viewer"
(
	colorPicker clr_cha_color "Character -" 		color:(colorDict[#Character] as color)	modal:true	
	colorPicker clr_dec_color "Decal        -"		color:colorDict[#Decal]	modal:true	

		
)



CreateDialog	roll_Color  	width:200 height:600