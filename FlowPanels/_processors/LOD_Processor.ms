----------------------------------------------------------
----------------------------------------------------------

sel = selection[1]


--Send to Simplygon
sgsdk_Reset()
sgsdk_SetLoginInfo "user" "user"			
sgsdk_SetSettingsPath "Main_Reduction_Chain.preset"
sgsdk_SetGenerateMaterial true
sgsdk_SetBatchMode true
sgsdk_ProcessSelectedGeometries()

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
sel.parent = parent 

----------------------------------------------------------
--Rename LODs
LOD1 = sel.name + "_LOD001"
selLOD1 = (getNodeByName LOD1)
selLOD1.name = sel.name + "_LOD1"

LOD2 = sel.name + "_LOD002"
selLOD2 = (getNodeByName LOD2)
selLOD2.name = sel.name + "_LOD2"

LOD3 = sel.name + "_LOD003"
selLOD3 = (getNodeByName LOD3)
selLOD3.name = sel.name + "_LOD3"


----------------------------------------------------------
--Select all LODs
objSels = #(selLOD1, selLOD2, selLOD3)

--Parent LODs to L
objSels.parent = parent

--Name Parent Node - Original Object Name
parent.name = sel.name

--Name Original Object to LOD0
sel.name = (sel.name + "_LOD0")


----------------------------------------------------------
----------------------------------------------------------

-- a = "_LOD001"
-- b = (getNodeByName a)
-- select b