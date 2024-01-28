
macroscript	epoly_selection_select_single_vert_of_edges
category:	"_Epoly-Selection"
buttonText:	"Edge to Vert"
toolTip:	"Convert edge selection\n\nQUICK SCRIPT, TESTED ONLY ON EDITABLE POLY"
icon:	"MENU:false"
(

	on execute do
	undo "Explode By Element" on
	(
		obj = selection[1]

		edge_sel = polyop.getEdgeSelection obj

		verts = for edge_id in edge_sel as Array collect (( polyop.getVertsUsingEdge obj #{edge_id} ) as Array )[1]


		obj.EditablePoly.SetSelection #Vertex (verts as BitArray )

		subobjectLevel = 1

	)

)


macroscript	epoly_selection_pass_vert_selection_to_editable_poly
category:	"_Epoly-Selection"
buttonText:	"Pass Vert Sel"
toolTip:	"Pass vetex selection from modifiers to EditablePoly baseobject.\n\nIMPORTANT: Verts are selected in baseobject by position in modifier.\n\nWorks with polyop types of modifiers like:\n    Edit Poly|Poly Select"
icon:	"MENU:false"
(
	on execute do
	undo "Pass Vert Sel" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\SELECTION.mcr"

		obj = selection[1]

		vertex_sel = (getVertSelection obj.mesh) as Array

		verts_all	= #{1..( getNumVerts obj.mesh)} as Array
		verts_all_base	= #{1..( polyop.getNumVerts obj.baseobject)} as Array

		verts_sel_pos = #()

		verts_baseobjects = #()

		verts_pos_baseobjects = polyop.getVerts obj.baseobject verts_all_base node:obj

		if vertex_sel.count > 0 then
		(
			verts_sel_pos  = polyop.getVerts obj vertex_sel node:obj

			for vert_pos in verts_sel_pos where (index = findItem verts_pos_baseobjects (vert_pos)) > 0 do
				append verts_baseobjects index

			if verts_baseobjects.count > 0 then
			(

				if not keyboard.controlPressed then
				(
					modPanel.setCurrentObject obj.baseObject

					subObjectLevel = 1

					obj.EditablePoly.SetSelection #Vertex (verts_baseobjects as BitArray )
				)
				else
					polyop.setVertColor obj 0 (verts_baseobjects as BitArray ) orange

			)

			redrawViews()
		)
	)
)


--polyop.setVertColor _obj 0 vertex_selection vertex_color