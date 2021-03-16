fn fnConcaveShape = 
(
	ln = line render_displayRenderMesh:false render_renderable:false
	splIdx = addNewSpline ln;
		addKnot ln splIdx #bezierCorner #curve [-4.86351,1.25001,0.391907] [-4.43112,2.80138,1.68292] [-3.89569,0.897181,-0.163292]
		addKnot ln splIdx #bezierCorner #curve [-1.44333,0.569744,-1.21952] [-2.41114,0.922575,-0.664337] [-0.732294,1.38391,-0.497459]
		addKnot ln splIdx #bezierCorner #curve [2.36214,2.08489,0.247749] [1.65111,1.27074,-0.474312] [1.87823,3.69774,1.10903]
		addKnot ln splIdx #bezier #curve [-0.974522,1.65948,2.87065] [0.602815,1.88357,2.72718] [-2.55186,1.43539,3.01411];
	close ln splIdx
	updateShape ln
	convertToSplineShape ln
	ln.wireColor = (color 140 88 225)
	ln.name = uniqueName "Shape001"
	select ln
	return ln
)
fnConcaveShape()