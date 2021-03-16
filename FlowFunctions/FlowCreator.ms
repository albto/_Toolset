-- ////////////////////////////////////////////////////////////////////////////////

-- GLOBAL -- STRINGS

-- ////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------
	global  FlowMaker 	 = "FlowCreator"
	

	global  makeBox 	 = "createBox"
	global  makeBoxSel 	 = "createBoxSel"
	global  makeCyl 	 = "createCyl"
	global  makeCylSel 	 = "createCylSel"
	global  makeSph 	 = "createSph"
	global  makeSphSel 	 = "createSphSel"
	global  makeTub 	 = "createTub"
	global  makeTubSel 	 = "createTubSel"
	global  makePlane 	 = "createPla"
	global  makePlaneSel = "createPlaSel"	
	global  makeCone 	 = "createCon"
	global  makeConeSel  = "createConSel"	
	global  makePyra 	 = "createPyra"
	global  makePyraSel  = "createPyraSel"	
	global  makeGeo 	 = "createGeo"
	global  makeGeoSel   = "createGeoSel"
	global  makeTor 	 = "createTor"
	global  makeTorSel   = "createTorSel"
	global  makeTex 	 = "createTex"
	global  makeTexSel   = "createTexSel"
	global  makeCont 	 = "createCont" 
	global  makeContSel	 = "createContSel" 
	global  makePoint 	 = "createPoint" 
	global  makePointSel = "createPointSel" 
	
	
------------------------------------------------------------------------------------	
-- ////////////////////////////////////////////////////////////////////////////////

-- FUNCTIONS -- LIBRARY -- modeling 

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

------------------------------------------------------------------------------------ Box
macroScript createBox
category:"FlowCreator"
toolTip:"Create Box"
(
	Undo on 
	mybox = box length:PrimScale width:PrimScale height:PrimScale isSelected: On 
	mybox.mapcoords = on		
	$.wirecolor = gray
)
------------------------------------------------------------------------------------
macroScript createBoxSel
category:"FlowCreator"
toolTip:"Create Box on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	mybox = box length:PrimScale width:PrimScale height:PrimScale isSelected: On pos:place
	mybox.mapcoords = on		
	$.wirecolor = gray
)
------------------------------------------------------------------------------------ Cylinder

macroScript createCyl
category:"FlowCreator"
toolTip:"Create Cylinder"
(
	Undo on 
	mycyl = cylinder radius:PrimScale height:(PrimScale * 3) isSelected: On
	mycyl.mapcoords = on
	mycy
	$.wirecolor = gray
)
------------------------------------------------------------------------------------
macroScript createCylSel
category:"FlowCreator"
toolTip:"Create Cylinder on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	mycyl = cylinder radius:PrimScale height:(PrimScale * 3) isSelected: On pos:place
	mycyl.mapcoords = on		
	$.wirecolor = gray
)
------------------------------------------------------------------------------------ Sphere

macroScript createSph
category:"FlowCreator"
toolTip:"Create Sphere"
(
	Undo on 
	mysphere = sphere radius:PrimScale segments:32 isSelected: On
	mysphere.mapcoords = on
	$.wirecolor = gray 
)
------------------------------------------------------------------------------------
macroScript createSphSel
category:"FlowCreator"
toolTip:"Create Sphere on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	mysphere = sphere radius:PrimScale segments:32 isSelected: On pos:place
	mysphere.mapcoords = on
	$.wirecolor = gray 
)
------------------------------------------------------------------------------------ Tube
macroScript createTub
category:"FlowCreator"
toolTip:"Create Tube"
(
	Undo on 
	mytube = tube radius1:(PrimScale - (PrimScale/2))  radius2:(PrimScale - (PrimScale/4)) height:(PrimScale * 3) isSelected: On
	mytube.mapcoords = on
	mytube
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------
macroScript createTubSel
category:"FlowCreator"
toolTip:"Create Tube on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	mytube = tube radius1:(PrimScale - (PrimScale/2))  radius2:(PrimScale - (PrimScale/4)) height:(PrimScale * 3) isSelected: On pos:place
	mytube.mapcoords = on
	mytube
	$.wirecolor = gray 
)
------------------------------------------------------------------------------------ Plane
macroScript createPla
category:"FlowCreator"
toolTip:"Create Plane"
(
	Undo on 
	myplane = plane length:PrimScale width:PrimScale isSelected: On
	myplane.mapcoords = on
	myplane
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------
macroScript createPlaSel
category:"FlowCreator"
toolTip:"Create Plane on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	myplane = plane length:PrimScale width:PrimScale isSelected: On pos:place
	myplane.mapcoords = on
	myplane
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------ Cone
macroScript createCon
category:"FlowCreator"
toolTip:"Create Cone"
(
	Undo on 
	mycone = cone radius1:(PrimScale/2) radius2:0 width:PrimScale height:PrimScale isSelected: On
	mycone.mapcoords = on
	mycone
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------
macroScript createConSel
category:"FlowCreator"
toolTip:"Create Cone on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	mycone = cone radius1:(PrimScale/2) radius2:0 width:PrimScale height:PrimScale isSelected: On pos:place
	mycone.mapcoords = on
	mycone
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------ Pyramid
macroScript createPyra
category:"FlowCreator"
toolTip:"Create Pyramid"
(
	Undo on 
	mypyra = pyramid width:PrimScale depth:PrimScale height:PrimScale isSelected: On
	mypyra.mapcoords = on
	mypyra
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------
macroScript createPyraSel
category:"FlowCreator"
toolTip:"Create Pyramid on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	mypyra = pyramid width:PrimScale depth:PrimScale height:PrimScale isSelected: On pos:place
	mypyra.mapcoords = on
	mypyra
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------ GeoSphere
macroScript createGeo
category:"FlowCreator"
toolTip:"Create GeoSphere"
(
	Undo on 
	mygeo = geosphere radius:PrimScale isSelected: On
	mygeo.mapcoords = on
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------
macroScript createGeoSel
category:"FlowCreator"
toolTip:"Create GeoSphere on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	mygeo = geosphere radius:PrimScale isSelected: On pos:place
	mygeo.mapcoords = on
	$.wirecolor = gray    
)
------------------------------------------------------------------------------------ Torus
macroScript createTor
category:"FlowCreator"
toolTip:"Create Torus"
(
	Undo on 
	mytor = torus radius1:PrimScale radius2:(PrimScale/2) isSelected: On
	mytor.mapcoords = on
	$.wirecolor = gray  
)
------------------------------------------------------------------------------------
macroScript createTorSel
category:"FlowCreator"
toolTip:"Create Torus on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	mytor = torus radius1:PrimScale radius2:(PrimScale/2) isSelected: On pos:place
	mytor.mapcoords = on
	$.wirecolor = gray     
)
------------------------------------------------------------------------------------ Text
macroScript createTex
category:"FlowCreator"
toolTip:"Create Text"
(
	Undo on 
	mytplus = TextPlus layouttype:0 Plane:0  isSelected: On
	$.width = PrimScale
	$.length = PrimScale
	$.size = PrimScale
	tplustext = "Flow Panels"
	mytplus.SetPlaintextString tplustext
	$.wirecolor = gray     
  
)
------------------------------------------------------------------------------------
macroScript createTexSel
category:"FlowCreator"
toolTip:"Create Text on Selection"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos 
	mytplus = TextPlus layouttype:0 Plane:0  isSelected: On pos:place
	$.width = PrimScale
	$.length = PrimScale
	$.size = PrimScale
	tplustext = "Flow Panels"
	mytplus.SetPlaintextString tplustext
	$.wirecolor = gray     
)

------------------------------------------------------------------------------------	
-- ////////////////////////////////////////////////////////////////////////////////

-- FUNCTIONS -- LIBRARY -- helpers 

-- ////////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------------ 

------------------------------------------------------------------------------------ Container 
macroScript createContSel
category:"FlowCreator"
toolTip:"Create Container"
(
	Undo on 
	selgroup = selection as array 
	place = selection[1].pos
	hlp_cont = 0 
	myCont = Container isSelected:on pos:Place size: PrimScale
	myCont.name = "inst_" + hlp_cont as string
	myCont.name = uniquename("inst_")	
	$.wirecolor = (color 13 229 155)
)
------------------------------------------------------------------------------------ 
macroScript createCont
category:"FlowCreator"
toolTip:"Create Container on Selection"
(
	hlp_cont = 0 
	myCont = Container isSelected:on size: PrimScale
	myCont.name = "cont_" + hlp_cont as string
	myCont.name = uniquename("cont_")	
)
------------------------------------------------------------------------------------ 
macroScript createPoint
category:"FlowCreator"
toolTip:"Create Point"
(
	hlp_point = 0 
	Point pos:[0,0,0] size:PrimScale isSelected:on	
	$.name = "hlpr_point_" 	+ hlp_point as string
	$.name = uniquename("hlpr_point_")	
)

------------------------------------------------------------------------------------ 
macroScript createPointSel
category:"FlowCreator"
toolTip:"Create Point on Selection"
(
	hlp_point = 0 
	Point pos:Place size:PrimScale isSelected:on	
	$.name = "hlpr_point_" 	+ hlp_point as string
	$.name = uniquename("hlpr_point_")	
)






