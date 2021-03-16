rollout test "Test Timer"
(
	local tickCnt = 0
	timer clock "testClock" interval:10 active:false--tick once a second
	label test "1"
	checkbutton btn_startClock "Start clock"

	on clock tick do
	(
		tickCnt += 1
		case tickCnt of
		(
			10: (print "Tick 10 times")
			100: (print "Tick 100 times")
		)
		valUp = (test.text as integer)+1
		test.text = valUp as string
	)

	on btn_startClock changed state do
	(
		Undo on
		if state == on then
		(	
			clock.active = true
		)
		if state == off then
		(
			clock.active = false
		)
	)

)
createDialog test