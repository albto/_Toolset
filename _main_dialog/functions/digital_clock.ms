Rollout DigiClock "DigiClock"
(
	local tsec = 0
	
	timer SecTme "Tme" interval:1000 
	label l_time "00 : 00 : 00" align:#center

	On SecTme tick do
	(
		tsec += 1
		
		local h = tsec/3600
		local sh = if h < 10 then "0"+h as string
					else h as string
		local m = (mod (tsec/60) 60) as integer
		local sm = if m < 10 then "0"+m as string
					else m as string
		local s = (mod tsec 60) as integer
		local ss = if s < 10 then "0"+s as string
					else s as string

		l_time.text = sh+" : "+sm+" : "+ss
	)
)
createDialog DigiClock width:90 height:26