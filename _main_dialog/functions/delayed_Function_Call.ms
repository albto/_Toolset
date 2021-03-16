function PerformDelayedTasks sender evt=
(
	-- important: don't repeat this timer event
	sender.enabled = false
	-- for sanity and cleanup
	dotnet.RemoveEventHandler sender "Elapsed" PerformDelayedTasks        

	-- put all your tasks below
	macros.run "Track View" "LaunchFCurveEditor" -- Curve Editor Toggle
	macros.run "Scene Explorer" "SELayerExplorer" -- Scene Explorer Toggle

	actionMan.executeAction 135018554 "32771" -- Particle View Toggle
	actionMan.executeAction 0 "50048" -- Tools: Material Editor Toggle
	actionMan.executeAction 0 "60010" -- Render: Render SetUp Toggle
	actionMan.executeAction 0 "40029" -- Render: Environment Dialog Toggle                 
)

delayTimer= dotnetobject "Windows.Forms.Timer"
delayTimer.Interval=100

dotnet.AddEventHandler delayTimer "Tick" PerformDelayedTasks

delayTimer.enabled = true

