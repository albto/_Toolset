-- ////////////////////////////////////////////////////////////////////////////////

-- GLOBAL -- STRINGS

-- ////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------

	global  FlowAtts 	 = "FlowAttributes"
	
	global  LoadUnityOBS 	 = "LoadUnitySettings"
	
------------------------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////////////////

-- FUNCTIONS -- LIBRARY -- Attributes 

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
macroScript LoadUnitySettings
category:"FlowAttributes"
toolTip:"Load Presets"
(
	Undo on
	if classof selection != Editable_Poly and selection.count >= 2 then 
	(
		converttopoly selection
	)
	else 
		return false
	
	for i = 1 to selection.count do
	(
		selcount = selection.count
		for i = selcount to 2 by -2 do
		(
			if (classof selection[i] != Editable_Poly or Edit_Poly)then 
			(
				continue
			)
			else
				polyop.attach selection[i] selection[i-1]
		)
		update selection[1]	
	)
	
)
------------------------------------------------------------------------------------


