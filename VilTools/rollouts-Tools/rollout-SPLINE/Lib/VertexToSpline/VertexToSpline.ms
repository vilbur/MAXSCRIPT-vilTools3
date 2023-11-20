clearListener(); print("Cleared in:\n"+getSourceFileName())

delete shapes

global vertex_to_spline_rollout

try destroyDialog vertex_to_spline_rollout catch()

rollout vertex_to_spline_rollout "Line Per Vertex" width:140
(
	fn geometryFilter obj = superClassOf obj == GeometryClass

	spinner spnLength "Length: " range:[0, 10000, 10]

	spinner spnSegments "Segments: " range:[1, 100, 1] type:#integer

	edittext edtName "Name: " text:"Guides"


	pickbutton pickMesh "Pick Mesh Target" filter:geometryFilter

	checkbox chkVertSel "Use Vert. Selection" checked:true


	on pickMesh picked obj do undo "Lines from Vertices" on
	(
		local _shape      	= SplineShape name:edtName.text pos:obj.pos
		local vertext_count	= getNumVerts obj.mesh
		local vertext_sel  	= getVertSelection obj.mesh

		fn makeLine obj _shape ind =
		(
			addNewSpline _shape

			splines_count = _shape.numSplines

			pos = (getVert obj.mesh ind) * obj.transform

			addKnot _shape splines_count #corner #line pos

			--normal = (getNormal obj.mesh ind) * obj.transform - obj.pos

			--pos += spnLength.value * normalize( normal )

			pos.z = 0
			format "pos:	% \n" pos

			addKnot _shape splines_count #corner #line pos
		)

		if chkVertSel.checked and ( vertext_sel as Array ).count != 0 then
			for i in vertext_sel do
				makeLine obj _shape i

		else
			for i = 1 to vertext_count do
				makeLine obj _shape i

		updateShape _shape

		if spnSegments.value > 1 do for i = 1 to _shape.numSplines do
		(
			subdivideSegment _shape i 1 ( spnSegments.value - 1 )

			for j = 1 to numKnots _shape i do
				setKnotType _shape i j #smooth
		)


		CompleteRedraw()
	)
)

CreateDialog vertex_to_spline_rollout
