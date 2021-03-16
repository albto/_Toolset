struct jsTool
(
	unInst = undefined,
	
	fn ui = 	
	(
		rollout uiR "UI rollout"
		(
			
		)
		
		CreateDialog uiR
		unInst = uiR
	),
	
	fn run =
	(
		if unInst ==undefined then
		(
			ui()
		)
		else(
			DestroyDialog unInst
			unInst=undefined
		)
	)
	
)

jsTool = jsTool()

jsTool.run()