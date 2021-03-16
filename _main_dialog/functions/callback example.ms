global ExposeUserDefined
callbacks.removeScripts id:#Rollout_Update

rollout ExposeUserDefined "Expose User Defined Attributes"
(
	edittext userDef "User Defined:" text:"I want to change this dynamically" height:200 fieldWidth:200 labelOnTop:true
		
	fn updateList =	
	(
		if selection.count == 1 then
		(
			userDef.enabled = true
			userDef.text = getUserPropBuffer $
		)
		else
		(
			userDef.text = if selection.count > 1 then "<multiple selected>" else "<none selected>"
			userDef.enabled = false
		)
	)	
		
	on ExposeUserDefined open do
	(	
		callbacks.addScript #selectionSetChanged "ExposeUserDefined.updateList()" id:#Rollout_Update
		updateList()
	)
		
	on ExposeUserDefined close do
	(
		callbacks.removeScripts id:#Rollout_Update
	)
		
	on userDef entered txt do
	(
		if selection.count == 1 do 
		setUserPropBuffer $ (replace_LF_with_CRLF userDef.text) --fixed as DenisT suggested
	)
		
)

try(closeRolloutFloater theNewFloater )catch()
theNewFloater = newRolloutFloater "EUD" 300 220
addRollout ExposeUserDefined theNewFloater