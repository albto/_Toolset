plugin simpleObject WeaveMesh 
	name:"Weave Mesh" 
	category:"Examples"
	classID:#(0x603e68e4, 0x434e6001)
--	author:"Vojtech Cada"
(
	fn isEven nr = bit.and 1L nr == 0	
	fn isOdd nr = NOT isEven nr
	fn getAlternateFn nr = if isEven nr then isEven else isOdd

	fn getCirclePoints pos count radius axis1 axis2 =
	(
		local step = 360d0 / count

		for i = 1 to count collect
			pos + axis1 * radius * sin (i * step) + axis2 * radius * cos (i * step)
	)

	fn buildQuadStrip length radius segCount sideCount tm flip &vertCount &vertList &faceList = 
	(
		local segLength = length / segCount

		for seg = 1 to segCount + 1 do
		(
			local pos = if isEven seg then tm.pos + tm.row1 * (flip *= -1) * radius else tm.pos
			join vertList (getCirclePoints (pos + (seg-1) * segLength * tm.row3) sideCount radius tm.row1 tm.row2)

			for pt = 1 to sideCount do
			(
				vertCount += 1

				if seg > 1 do if pt == 1 then
				(
					append faceList [vertCount, vertCount + sideCount - 1, vertCount - 1]
					append faceList [vertCount - 1, vertCount - sideCount, vertCount]
				)
				else
				(
					append faceList [vertCount, vertCount - 1, vertCount - sideCount - 1]
					append faceList [vertCount - sideCount - 1, vertCount - sideCount, vertCount]
				)
			)
		)
	)

	parameters main rollout:params
	(
		width type:#worldUnits ui:spnWidth default:1
		length type:#worldUnits ui:spnLength default:1
		height type:#worldUnits ui:spnHeight default:1
		horizontalCount type:#integer ui:spnHorizontalCount default:10
		verticalCount type:#integer ui:spnVerticalCount default:10
		sideCount type:#integer ui:spnSideCount default:4
	)

	rollout params "Weave Mesh Parameters"
	(
		spinner spnWidth "Width: " range:[0,1e9,1] type:#worldUnits
		spinner spnLength "Length: " range:[0,1e9,1] type:#worldUnits
		spinner spnHeight "Height: " range:[0,1e9,1] type:#worldUnits
		spinner spnHorizontalCount "Horiz. Count: " range:[1,1e9,1] type:#integer
		spinner spnVerticalCount "Vertical Count: " range:[1,1e9,1] type:#integer
		spinner spnSideCount "Sides: " range:[3,1e9,3] type:#integer
	)

	on buildMesh do
	(
		local vertCount = 0
		local vertList =#()
		local faceList = #()

		local horizontalStep = width / horizontalCount
		local horizontalPos = (horizontalStep - width) / 2 - horizontalStep

		local verticalStep = length / verticalCount
		local verticalPos = (verticalStep - length) / 2 - verticalStep

		for h = 1 to horizontalCount do
			buildQuadStrip length (height / 2) (2 * verticalCount) sideCount \
				(matrix3 z_axis -x_axis y_axis [horizontalPos += horizontalStep, -length / 2, 0]) (if isEven h then 1 else -1) &vertCount &vertList &faceList

		for v = 1 to verticalCount do
			buildQuadStrip width (height / 2) (2 * horizontalCount) sideCount \
				(matrix3 z_axis y_axis x_axis [-width / 2, verticalPos += verticalStep, 0]) (if isOdd v then 1 else -1) &vertCount &vertList &faceList

		setMesh mesh vertices:vertList faces:faceList
		for face in mesh.faces do setEdgeVis mesh face.index 3 false
	)

	tool create numPoints:3
	(
		on mousePoint click do
			if click == 1 do nodeTM.translation = gridPoint

		on mouseMove click do case click of
		(
			2: (width = 2 * abs gridDist.x; length = 2 * abs gridDist.y)
			3: height = gridDist.z
		)
	)
)