
obj = selection 
 
b = Skylight pos:[0,0,0]
b.castShadows =true
	
select obj 


LinExp = Linear_Exposure_Control()
SceneExposureControl.exposureControl = LinExp
LinExp.active = true

SceneRadiosity.showPanel() 
sceneRadiosity.radiosity = Radiosity()

sceneRadiosity.radiosity.radProcessInRenderOnly = false 
sceneRadiosity.radiosity.radInitialQuality = 95
 

sceneRadiosity.radiosity.radFiltering = 2


-- global Subdivision settings
sceneRadiosity.radiosity.meshingEnabled = true
sceneRadiosity.radiosity.useAdaptiveMeshing = true 
sceneRadiosity.radiosity.includeSkylight = true

sceneRadiosity.radiosity.initialMeshSize = 10.0
sceneRadiosity.radiosity.contrastThreshold = 100.0

sceneRadiosity.radiosity.Start () 

