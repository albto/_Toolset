fn fnConvexShape = 
(
	ln = line render_displayRenderMesh:false render_renderable:false
	splIdx = addNewSpline ln
		addKnot ln splIdx #bezierCorner #curve [-4.86351,1.25,0.391891] [-4.35209,2.73153,2.13256] [-3.89569,0.897177,-0.163307]
		addKnot ln splIdx #bezierCorner #curve [-1.44332,0.569744,-1.21953] [-2.41114,0.922573,-0.664337] [-0.732294,1.3839,-0.497459]
		addKnot ln splIdx #bezierCorner #curve [2.36214,2.08489,0.247742] [1.65111,1.27073,-0.474327] [1.87792,3.7654,1.1346]
		addKnot ln splIdx #bezier #curve [-1.32686,3.88881,3.11214] [0.250473,4.1129,2.96867] [-2.9042,3.66472,3.25561]
	close ln splIdx
	updateShape ln
	convertToSplineShape ln
	ln.wireColor = (color 140 88 225)
	ln.name = uniqueName "Shape002"
	select ln;
	return ln
)
fnConvexShape()