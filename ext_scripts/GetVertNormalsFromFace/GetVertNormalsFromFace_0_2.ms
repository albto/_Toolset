
/*
--------------------------------------------------------------------------------

Author: Enrico Gullotti
Website: http://www.illusioncatalyst.com
Website: http://www.aliquaforma.com

Name: GetVertNormalsFromFaces
Category: Normal Tools
Version: 0.2 - 2010.08.21

Requirements: 3ds Max 9+


GetVertNormalsFromFaces works on Editable Poly Objects and sets
the face selection perimeter vertex normals to the direction
of their face holder. It supports Smoothing Groups.

To use it, select faces whose vertex normals are to be realigned
and run the script.


Thanks to Rasmus Deguchi for the original idea,
to Benoit Stordeur and Eric Chadwick for suggestions and ideas,

--------------------------------------------------------------------------------
*/

macroScript GetVertNormalsFromFaces
category:"Normal Tools"
buttonText:"Get Vert Normals from Faces"
tooltip:"Get Vert Normals from Faces"
(

	function getVertNormalsFromFaces =
	(
		if (getCommandPanelTaskMode() != #modify) do
			setCommandPanelTaskMode #modify

		if (Filters.Is_EditPoly()) do
		(
			local theNode = selection[1]
			local theEditObj = modPanel.getCurrentObject()
			local theEditNorm = undefined

			local iModIndex = theNode.modifiers.count

			if ((classOf theEditObj) == Editable_Poly) then
			(
				theEditNorm = theNode.modifiers[theNode.modifiers.count]

				local baFaceSelection = polyOp.getFaceSelection theEditObj
			)

			if (not baFaceSelection.isEmpty) do
			(
				if ((classOf theEditNorm) == UndefinedClass) then
				(
					theEditNorm = Edit_Normals()
					addModifier theNode theEditNorm
				)
				else if ((classOf theEditNorm) != Edit_Normals) then
				(
					theEditNorm = Edit_Normals()
					addModifier theNode theEditNorm before:iModIndex
				)

				if (theEditNorm != undefined) do
				(
					local baVertsFromFaceSelection = polyOp.getVertsUsingFace theEditObj baFaceSelection

					local ap3FaceNormals = for iFace = 1 to (polyOp.getNumFaces theEditObj) collect
						( if (baFaceSelection[iFace]) then ( polyOp.getFaceNormal theEditObj iFace ) else ( 0.0 ) )

					modPanel.setCurrentObject theEditNorm

					local abaFaceVertNormals = #()

					for iFace = 1 to (polyOp.getNumFaces theEditObj) do
					(
						local baFaceVertNormals = #{}

						if (baFaceSelection[iFace]) do
							theEditNorm.convertFaceSelection #{iFace} baFaceVertNormals node:theNode

						append abaFaceVertNormals baFaceVertNormals
					)

					local baAllVertNormals = #{}
					theEditNorm.convertFaceSelection baFaceSelection baAllVertNormals node:theNode

					for iVert in baVertsFromFaceSelection do
					(
						local baVertNormals = #{}
						theEditNorm.convertVertexSelection #{iVert} baVertNormals node:theNode

						baVertNormals *= baAllVertNormals

						local baProxiFaces = (polyOp.getFacesUsingVert theEditObj iVert) * baFaceSelection

						if (baVertNormals.numberSet == 1) then
						(
							local p3AvgFaceNormal = Point3 0.0 0.0 0.0

							for iFace in baProxiFaces do
								p3AvgFaceNormal += ap3FaceNormals[iFace]

							p3AvgFaceNormal /= baProxiFaces.numberSet

							local iNormal = (baVertNormals as Array)[1]
							theEditNorm.setNormal iNormal p3AvgFaceNormal node:theNode
						)
						else
						(
							for iNormal in baVertNormals do
							(
								local p3AvgFaceNormal = Point3 0.0 0.0 0.0

								for iFace in baProxiFaces do
									if (abaFaceVertNormals[iFace][iNormal]) do
										p3AvgFaceNormal += ap3FaceNormals[iFace]

								p3AvgFaceNormal = normalize p3AvgFaceNormal

								theEditNorm.setNormal iNormal p3AvgFaceNormal node:theNode
							)
						)
					)

					theEditNorm.makeExplicit selection:baAllVertNormals node:theNode

					maxOps.collapseNodeTo theNode theNode.modifiers.count true
					modPanel.setCurrentObject theNode.baseObject

					subObjectLevel = 4
				)
			)
		)
	)

	on execute do
	(
		undo "Get Vert Normals From Faces" on
		(
			getVertNormalsFromFaces()
		)
	)

)