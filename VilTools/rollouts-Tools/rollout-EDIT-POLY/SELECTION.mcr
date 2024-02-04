filein( getFilenamePath(getSourceFileName()) + "/Lib/passVertexSelectionToEditablePoly.ms" )	--"./Lib/passVertexSelectionToEditablePoly.ms"

/**
  *
  */
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

/**
  *
  */
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

		verts_baseobjects = passVertexSelectionToEditablePoly()

		if not verts_baseobjects.isEmpty then
		(
			modPanel.setCurrentObject obj.baseObject

			subObjectLevel = 1

			$.EditablePoly.SetSelection #Vertex (verts_baseobjects as BitArray )


			redrawViews()
		)
	)
)

global SAVE_LOAD_SELECTION

/**
  *
  */
macroscript	epoly_selection_save_load
category:	"_Epoly-Selection"
buttonText:	"Save\Load Selection"
toolTip:	"SAVE current node selection.\n\nLOAD if nothing selected"
icon:	"MENU:false"
(
	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\SELECTION.mcr"

		if selection.count == 0 and SAVE_LOAD_SELECTION != undefined then
				select (for obj in SAVE_LOAD_SELECTION where isValidNode obj collect obj )

		else
			SAVE_LOAD_SELECTION	= for obj in selection collect obj

	)
)












