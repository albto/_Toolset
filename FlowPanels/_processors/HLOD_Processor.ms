
try (

selName = $.name as string 

print selName

str = selName

sgsdk_Reset()

-- execute Simplygon with the given pipeline (settings-file)
sgsdk_RunPipelineOnSelection (toolFolder + "\FlowPanels\_processors\Basic_HLOD_Pipieline.json")
-- clear all pipelines
sgsdk_ClearPipelines()

redrawViews()

a = "ProcessedMeshNode"
b = (getNodeByName a)
select b

b.name = (selName + "_HLOD")
	
) 
catch()

