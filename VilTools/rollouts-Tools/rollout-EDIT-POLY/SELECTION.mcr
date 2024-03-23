filein( getFilenamePath(getSourceFileName()) + "/Lib/passVertexSelectionToEditablePoly.ms" )	--"./Lib/passVertexSelectionToEditablePoly.ms"

/**
  *
  */
macroscript	epoly_selection_select_single_vert_of_edges
category:	"_Epoly-Selection"
buttonText:	"Filter 1 edge vert"
toolTip:	"Get only signge vertex per edge"
icon:	"MENU:false"
(

	on execute do
	undo "Filter 1 edge vert" on
	(
		obj = selection[1]

		edge_sel = polyop.getEdgeSelection obj

		verts = for edge_id in edge_sel as Array collect (( polyop.getVertsUsingEdge obj #{edge_id} ) as Array )[1]


		obj.EditablePoly.SetSelection #Vertex (verts as BitArray )

		subObjectLevel = 1

	)

)

/**
  *
  */
macroscript	epoly_select_lowest_point
category:	"_Epoly-Selection"
buttonText:	"Get lowest vert"
toolTip:	"Select lowest on axis Z vertex of selected vertices"
icon:	"MENU:true"
(

	on execute do
	undo "Filter 1 edge vert" on
	(
		obj = selection[1]

		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active


		verts_positions = meshop.getVerts obj.mesh vertex_sel node:obj
		--format "verts_positions as Array: %\n" (verts_positions as Array)
		z_positions = for pos in verts_positions collect pos.z
		--format "z_positions: %\n" z_positions
		z_pos_min = amin z_positions
		--format "z_pos_min: %\n" z_pos_min
		index	= findItem z_positions (amin z_positions)
		--format "index: %\n" index

		lowest_vert = #{( vertex_sel as Array )[index]}
		--format "lowest_vert: %\n" lowest_vert
		--verts = for edge_id in edge_sel as Array collect (( polyop.getVertsUsingEdge obj #{edge_id} ) as Array )[1]
		if classOf ( _mod = modPanel.getCurrentObject() ) == Edit_Poly then
		(
			_mod.SetSelection #Vertex #{}
			_mod.Select #Vertex (lowest_vert )

		)

		if classOf _mod  == Editable_Poly then
			_mod.SetSelection #Vertex ( lowest_vert )

		subObjectLevel = 1

	)

)

/**
  *
  */
macroscript	epoly_select_lowest_points_in_grid
category:	"_Epoly-Selection"
buttonText:	"Get lowest grid"
toolTip:	"Select lowest verts in suqaures of xy"
icon:	"MENU:true"
(
	on execute do
	undo "Get lowest grid" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\SELECTION.mcr"

		fn round p3 dp =
		(
			local tempArr = #(p3.x,p3.y,p3.z)
			local mult = 10.00^(dp as float)
			local rp3Arr = for c in tempArr collect ((floor ((c * mult)+0.5)) / mult)
			point3 rp3Arr[1] rp3Arr[2] rp3Arr[3]
		)
	--round [111.1589,12.856,85.5896] 3

		--
		--delete objects
		--obj = Plane width:60 length:30 pos:[ 50, 20, 50 ] widthsegs:10 lengthsegs:10 isSelected:on
		--
		--modPanel.addModToSelection (Noisemodifier scale:2 strength:[0,0,10] ) ui:on
		--
		----rotate obj ( angleaxis 180 [1,0,0])
		--
		--macros.run "Modifier Stack" "Convert_to_Poly"

		obj = selection[1]

		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		verts_count	= getNumVerts obj.mesh
		verts_all	= #{1..(verts_count)}

		verts_positions = meshop.getVerts obj.mesh verts_all node:obj
		--format "verts_positions as Array: %\n" (verts_positions as Array)

		/* ROUND POSTIONS TO TENS - [111.1589,12.856,85.5896] >>> [110,10,90] */
		pos_round = for pos in verts_positions collect round pos 0

		x_positions = for pos in pos_round collect pos.x
		y_positions = for pos in pos_round collect pos.y
		z_positions = for pos in pos_round collect pos.z

		--format "amin x_positions: %\n" (amin x_positions)
		--format "amax x_positions: %\n" (amax x_positions)

		x_size = (amax x_positions) - (amin x_positions)
		y_size = (amax y_positions) - (amin y_positions)

		--x_size /= 10
		--y_size /= 10

		points_grid = #()

		resolution_grid = 5

		for x = (amin x_positions) to (amax x_positions) by resolution_grid do
			for y = (amin y_positions) to (amax y_positions) by resolution_grid do
			(
				--format "\n--------------------\n"
				--format "x: %\n" x
				--format "y: %\n" y

				points_in_square = for p = 1 to pos_round.count \
					where pos_round[p].x >= x \
					and pos_round[p].x < x + resolution_grid \
					and pos_round[p].y >= y \
					and pos_round[p].y < y + resolution_grid \
				collect p

			if points_in_square.count > 0 then
				append points_grid points_in_square
		 )

		lowest_verts = #{}

		for points_in_square in points_grid do
		(
			--format "points_in_square: %\n" points_in_square

			verts_positions = meshop.getVerts obj.mesh (points_in_square as BitArray )  node:obj

			z_positions = for pos in verts_positions collect pos.z

			z_pos_min = amin z_positions

			index	= findItem z_positions (amin z_positions)

			--lowest_vert = #{( vertex_sel as Array )[index]}
			lowest_vert = ( points_in_square as Array )[index]

			lowest_verts[lowest_vert] = true

		)
			--format "points_in_square: %\n" points_in_square

		subObjectLevel = 1

		if classOf ( _mod = modPanel.getCurrentObject() ) == Edit_Poly then
		(
			_mod.SetSelection #Vertex #{}
			_mod.Select #Vertex lowest_verts

		)

		else if classOf _mod  == Editable_Poly then
			_mod.SetSelection #Vertex lowest_verts



	)
)

/**
  *
  */
macroscript	epoly_selection_pass_vert_selection_to_editable_poly
category:	"_Epoly-Selection"
buttonText:	"Pass Vert Sel"
toolTip:	"Pass vetex selection from modifiers to EditablePoly baseobject.\n\nIMPORTANT: Verts are selected in baseobject by position in modifier.\n\nWorks with polyop types of modifiers like:\n    Edit Poly|Poly Select"
icon:	"MENU:true"
(
	on execute do
	undo "Pass Vert Sel" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\SELECTION.mcr"

		verts_baseobjects = passVertexSelectionToEditablePoly()

		if not verts_baseobjects.isEmpty then
		(
			obj = selection[1]

			modPanel.setCurrentObject obj.baseObject

			subObjectLevel = 1

			$.EditablePoly.SetSelection #Vertex (verts_baseobjects as BitArray )


			redrawViews()
		)
	)
)

--global SAVE_LOAD_SELECTION

--/**
--  *
--  */
--macroscript	epoly_selection_save_load
--category:	"_Epoly-Selection"
--buttonText:	"Save\Load Selection"
--toolTip:	"SAVE current node selection.\n\nLOAD if nothing selected"
--icon:	"MENU:false"
--(
--	on execute do
--	(
--		clearListener(); print("Cleared in:\n"+getSourceFileName())
--		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\SELECTION.mcr"
--
--		if selection.count == 0 and SAVE_LOAD_SELECTION != undefined then
--				select (for obj in SAVE_LOAD_SELECTION where isValidNode obj collect obj )
--
--		else
--			SAVE_LOAD_SELECTION	= for obj in selection collect obj
--
--	)
--)
