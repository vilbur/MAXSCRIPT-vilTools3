
/**
  *
  */
macroscript	epoly_vertex_color_set_to_baseobject
category:	"_Epoly-Vertex-Color"
buttonText:	"Set Vertex Color"
toolTip:	"Set vertex color to selected vertex.\n\nVertex can be selected in modifiers like:\nEdit Poly|Poly Select"
icon:	"MENU:true"
(
	on execute do
	undo "Set Vertex Color" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\VERTEX COLOR.mcr"

		obj = selection[1]

		verts_baseobjects = passVertexSelectionToEditablePoly()

		if not verts_baseobjects.isEmpty then
			polyop.setVertColor obj 0 (verts_baseobjects as BitArray ) orange

		$.showVertexColors	= true
		$.vertexColorsShaded	= true

		redrawViews()
	)
)

/**
  *
  */
macroscript	epoly_vertex_color_select_by
category:	"_Epoly-Vertex-Color"
buttonText:	"Select Vertex Color"
toolTip:	"Select Vertex Color"
icon:	"across:4|MENU:true"
(
	on execute do
	undo "Select Vertex Color" on
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\VERTEX COLOR.mcr"

		verts_by_colors = #{}

		for obj in selection where superClassOf obj == GeometryClass do
		(
			if getNumCPVVerts obj.mesh > 0 then
			(
				vertex_sel = getVertSelection obj.mesh

				vert_color = getvertcolor obj.mesh (vertex_sel as Array )[1]

				verts_white = meshop.getVertsByColor obj.mesh vert_color 0.001 0.001 0.001 --return TRESHOLD FLOAT MUST NOT BE 0.0 - it causeses error in whie loop in this._getVertexColors()

				verts_by_colors += verts_white
			)
		)

		if not verts_by_colors.isEmpty then
		(
			if classOf (_mod = modPanel.getCurrentObject() ) == Edit_Poly then
			(
				_mod.SetSelection #Vertex #{}

				_mod.Select #Vertex verts_by_colors
			)

			if classOf _mod == Editable_Poly then
				_mod.SetSelection #Vertex verts_by_colors
		)
	)
)


/**
  *
  */
macroscript	epoly_vertex_color_hide_by_color
category:	"_Epoly-Vertex-Color"
buttonText:	"Hide By Color"
toolTip:	"Hide verts by vertex color of selected verts.White color is used, if nothing selected.\n\nCTRL: ISOLATE MODE (Show all verts of selected colors ).\n\nQUICK SCRIPT, TESTED ONLY ON EDITABLE POLY"
icon:	"across:4|MENU:true"
(
	on execute do
	undo "Hide Colored Verts" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\VERTEX COLOR.mcr"

		obj = selection[1]

		if getNumCPVVerts obj.mesh > 0 then
		(
			vertex_colors	= #()
			verts_by_colors	= #{}

			vertex_sel = (getVertSelection obj.mesh) as Array

			/* GET COLROS OF SELECTED VERTS */
			if vertex_sel.count == 0 then
				vertex_colors = #(white)
			else
				/* USE WHITE COLOR IF NOTHING SELECTED */
				for i = 1 to vertex_sel.count do
					appendIfUnique vertex_colors (getvertcolor obj.mesh vertex_sel[i] )

			--format "vertex_colors	= % \n" vertex_colors

			/* GET VERTS USED BY COLORS */
			for clr in vertex_colors do
				verts_by_colors += meshop.getVertsByColor obj.mesh clr 0.001 0.001 0.001


			if keyboard.controlPressed then
			(
				polyop.unHideAllVerts obj


				polyop.setHiddenVerts obj  (#{1..(getNumVerts obj.mesh)} - verts_by_colors)
			)
			else
				polyop.setHiddenVerts obj verts_by_colors

			subObjectLevel = 1
		)
		else
			messageBox ("There is not any vertex color on object:\n\n"+obj.name) title:"NO VERTEX COLOR"
	)
)

