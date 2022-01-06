----------------------------------------------------------
----------------------------------------------------------

sel = selection[1]

--Send to Simplygon
sgsdk_Reset()

-- execute Simplygon with the given pipeline (settings-file)
sgsdk_RunPipelineOnSelection (toolFolder + "\FlowPanels\_processors\Basic_Prop_LOD_Pipeline.json")

-- clear all pipelines
sgsdk_ClearPipelines()

--Refresh Viewport
redrawViews()

----------------------------------------------------------
--Create Point
macros.run FlowMaker makePoint

--Select LOD0
select sel

obj = "hlpr_point_001"
parent = (getNodeByName obj)

--Parent -- Original Object --
parent.parent = sel.parent
sel.parent = parent 

----------------------------------------------------------
try 
(
--Rename LODs
LOD1 = sel.name + "_001"
selLOD1 = (getNodeByName LOD1)
selLOD1.name = sel.name + "_LOD1"

LOD2 = sel.name + "_002"
selLOD2 = (getNodeByName LOD2)
selLOD2.name = sel.name + "_LOD2"

LOD3 = sel.name + "_003"
selLOD3 = (getNodeByName LOD3)
selLOD3.name = sel.name + "_LOD3"

--Parent LODs to L
selLOD1.parent = parent
selLOD2.parent = parent
selLOD3.parent = parent
	

----------------------------------------------------------

--Name Original Object to LOD0
sel.name = (sel.name + "_LOD0")

)
catch(print "unable to name LOD meshes")


----------------------------------------------------------
----------------------------------------------------------
