function smoothByUVShells=
(
	clearListener();
	if (getCommandPanelTaskMode() != #modify)then(--make sure we are in the modify panel section
		setCommandPanelTaskMode #modify;
	)
	if (selection.count == 1)then(--at least an object selected
		local obj = selection[1]; 
		local uv = modPanel.getCurrentObject();
		
		if (classof(uv) != Unwrap_UVW)then(
			modPanel.addModToSelection (Unwrap_UVW ()) ui:on;
			uv = modPanel.getCurrentObject();
		)
		
		uv.unwrap.edit();
		uv.unwrap.edit();
		uv.unwrap2.setTVSubObjectMode(3);
 
		local totalFaces = uv.unwrap.numberPolygons();
		
		local faceElemArray = #();
		for f=1 to totalFaces do (
			faceElemArray[ f ] = 0;
		)
		local elem = #();
		--with redraw off;
		for f=1 to totalFaces do (
			if faceElemArray[ f ] == 0 then (
				uv.unwrap2.selectFaces  #{ f };
				uv.unwrap2.selectElement();
				local elemFaces = uv.unwrap2.getSelectedFaces() as array;
				
				append elem (uv.unwrap2.getSelectedFaces());
				for i in elemFaces do (
					faceElemArray[ i ] = elem.count; -- Mark these vertices with their element number in vertElemArray.
				)
			)
		)
		
		print("num shells: "+elem.count as string+"t"+totalFaces as string);
		
		modPanel.addModToSelection (Edit_Poly ()) ui:on;
		obj.modifiers[#Edit_Poly].autoSmoothThreshold = 180	
		for e in elem do(
			obj.modifiers[#Edit_Poly].SetSelection #Face e;	
			obj.modifiers[#Edit_Poly].ButtonOp #Autosmooth	
		)	
	)
)

try (

selName = $.name as string 

print selName

str = selName

sgsdk_Reset()
sgsdk_SetLoginInfo "user" "user"			
sgsdk_SetSettingsPath "Main_Proxy_Pipeline.preset"
-- sgsdk_SetGenerateMaterial true
sgsdk_SetBatchMode true
sgsdk_ProcessSelectedGeometries()


redrawViews()

a = "Simplygon_Proxy_LOD001"
b = (getNodeByName a)
select b

--SET SMOOTHING OF PROXY
smoothByUVShells()

--Set High Res and Low Res Objects
selObj = (getNodeByName str)
HighRes= selObj

select b
LowRes = b

-- Add Projection Modifier to one
modPanel.addModToSelection (Projection name:"HLOD_Bake") ui:on
addPModObjects LowRes false true objList:#(HighRes)

LowRes.name = (HighRes.name + "_HLOD") as string


-- Add Diffuse Map:-----------------------------------------------------

difmap = BakeToTexture.addMap LowRes #DiffuseMap
difmap.filename = HighRes.name + "_clr"
difmap.setImageSize 1024 1024
difmap.fileType = "png"

difmap.projectionMethod = 1
difmap.edgePadding  = 64


-- Add Occlusion Map:-----------------------------------------------------

spcmap = BakeToTexture.addMap LowRes #SpecularMap
spcmap.filename = HighRes.name + "_rgh"
spcmap.setImageSize 1024 1024
spcmap.fileType = "png"

spcmap.projectionMethod = 1
spcmap.edgePadding  = 64


-- Add Normal Map:-----------------------------------------------------
normalmap =	BakeToTexture.addMap LowRes #NormalMap

normalmap.filename = HighRes.name + "_nml"
normalmap.setImageSize 1024 1024
normalmap.fileType = "png"

normalmap.projectionMethod = 1
normalmap.edgePadding  = 64

-------------------------------------------------------------------------

BakeToTexture.showDialog()

BakeToTexture.SetOutputTo LowRes #CreateNewMaterial material:(Physical_Material())	
BakeToTexture.outputPath = pathConfig.getCurrentProjectFolder() + "\\sceneassets\\images"

-- start bake process, without a callback:
--BakeToTexture.bake()
	
) 
catch()



	


-- fn onMapBaked successfulBake MapFileString = 
-- (
-- 	 if successfulBake and doesFileExist(MapFileString) then
-- 	 (
-- 		print MapFileString
-- 		BakeToTexture.openOutputLocation()
-- 		return true
-- 	 ) else return false
-- )
-- BakeSuccess = BakeToTexture.bake onMapBakedCallback:onMapBaked