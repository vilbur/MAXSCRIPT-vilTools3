--filein( getFilenamePath(getSourceFileName()) + "/../rollout-EDIT-POLY/Lib/passVertexSelectionToEditablePoly.ms" )	--"./../rollout-EDIT-POLY/Lib/passVertexSelectionToEditablePoly.ms"

/**
  *
  */
macroscript	epoly_selection_select_single_vert_of_edges
category:	"_Epoly-Selection"
buttonText:	"Filter 1 vert per edge"
toolTip:	"Get only signge vertex per edge"
icon:	"MENU:false|across:3"
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
macroscript	epoly_selection_pass_vert_selection_to_editable_poly
category:	"_Epoly-Selection"
buttonText:	"PASS Vert Sel"
toolTip:	"Pass vetex selection from modifiers to EditablePoly baseobject.\n\nIMPORTANT: Verts are selected in baseobject by position in modifier.\n\nWorks with polyop types of modifiers like:\n    Edit Poly|Poly Select"
icon:	"MENU:true"
(
	on execute do
	undo "Pass Vert Sel" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\SELECTION.mcr"

		verts_baseobjects = passVertexSelectionToEditablePoly()

		if not verts_baseobjects.isEmpty then
		(
			obj = selection[1]

			modPanel.setCurrentObject obj.baseObject

			subObjectLevel = 1

			obj.EditablePoly.SetSelection #Vertex (verts_baseobjects as BitArray )


			redrawViews()
		)
	)
)

/** 
  *
  */
macroscript	epoly_selection_copy_by_pos
category:	"_Epoly-Selection"
buttonText:	"Copy by POSITION"
toolTip:	"Select verts on object based on local position of source object verts.\nWorks for Editable Poly and Edit Poly. SOURCE OBJ == selection[1]\nTAREGET OBJ == selection[2]\n\n USECASE:\n Select verts in case of vertex order of two object is differrent."
icon:	"MENU:true|ACROSS:1|width:128"
(
	/* 
	   Function to set sub-object selection on first Edit_Poly modifier if found, 
	   otherwise fallback to Editable_Poly base object.
	   Works for different sub-object types: #Vertex, #Edge, #Border, #Face, #Element
	   
	   
	   E.G.:
		selectSubObjectOnEditableOrEditPoly selection[1]	#VERTEX #{1..4}
	   
	*/
	function selectSubObjectOnEditableOrEditPoly obj subobj_type bitset =
	(
		epoly_mod = undefined
		
		/* Search modifiers for first Edit_Poly */
		for m in obj.modifiers while epoly_mod == undefined where classof m == Edit_Poly do
			epoly_mod = m
		format "EPOLY_MOD: %\n" epoly_mod
		
		subobjectLevel = 1

		/* Edit_Poly  */ 	
		if epoly_mod != undefined then
		(
			epoly_mod.SetSelection subobj_type #{}
			
			epoly_mod.Select subobj_type bitset
		)
		/* Editable_Poly  */ 	
		else
		(
			if ( superclassof obj.baseObject == GeometryClass and classof obj.baseObject == Editable_Poly) then
				obj.EditablePoly.SetSelection subobj_type bitset
		)
		
		final_mod = if epoly_mod != undefined then epoly_mod else obj.baseObject
		
		setSelectionLevel final_mod subobj_type
	
		modPanel.setCurrentObject final_mod
		
	)
	/* 
	Select verts on target object by using directly bitarray of verts from source object
	Works for Editable Poly and Edit Poly
	*/
	function copyVertSelectionByPosition source target round_to_decimal_places:3 =
	(
		fn round p3 dp =
		(
			local tempArr = #(p3.x,p3.y,p3.z)
			local mult = 10.00^(dp as float)
			local rp3Arr = for c in tempArr collect ((floor ((c * mult)+0.5)) / mult)
			point3 rp3Arr[1] rp3Arr[2] rp3Arr[3]
		)
		
	
		--if ( (classof source == Editable_Poly or classof source == Edit_Poly or classof source == Editable_Mesh ) and \
			 --(classof target == Editable_Poly or classof target == Edit_Poly or classof target == Editable_Mesh ) ) then
		(
			--vertex_sel = polyop.getVertSelection source
			vertex_sel	= getVertSelection source.mesh
			
			--verts_pos = in coordsys world meshop.getVerts obj.mesh vertex_sel node:obj
			--verts_pos = meshop.getVerts source.mesh vertex_sel node:source
			verts_pos = in coordsys source meshop.getVerts source.mesh vertex_sel node:source
			--format "VERTS_POS: %\n" verts_pos
			src_positions = for vert_pos in verts_pos collect round vert_pos round_to_decimal_places
			
			
			--src_positions = for i in vertex_sel where vertex_sel[i] collect
				--round ( polyop.getVert source i ) round_to_decimal_places
			
			--format "SRC_POSITIONS: %\n" src_positions
			--format "TARAGET COUNT: %\n" (getNumVerts target.mesh)

			tar_sel = #{}
			verts_all = #{1..(getNumVerts target.mesh )}
			
			--target_positions = meshop.getVerts target.mesh verts_all node:target
			target_positions = in coordsys target meshop.getVerts target.mesh verts_all node:target
			
			format "TARGET_POSITIONS: %\n" target_positions

			target_positions = for vert_pos in target_positions collect round vert_pos round_to_decimal_places
			format "TARGET_POSITIONS: %\n" target_positions
			--for target_position in target_positions do
			for i = 1 to target_positions.count do 
				if ( findItem src_positions target_positions[i]) > 0 then
				(
					format "target_position: %\n" target_positions[i]
					tar_sel[i] = true
				)
			

			for i = 1 to ( getNumVerts target.mesh ) do
			(
				--vert_pos = round (polyop.getVert target i) round_to_decimal_places
				vert_pos = round ( polyop.getVert target i ) round_to_decimal_places

				--format "vert_pos: % index: %\n" vert_pos ( findItem src_positions vert_pos) 
				
				if ( findItem src_positions vert_pos) > 0 then
				(
					
					--format "vert_pos: %\n" vert_pos
					tar_sel[i] = true
				)
			)

			format "TARGET_SEL: %\n" tar_sel
			--polyop.setVertSelection target tar_sel
			select target
			
			selectSubObjectOnEditableOrEditPoly target	#VERTEX tar_sel
			
			
			--subObjectLevel = 1
			
			
		)
	)

	
	on execute do
		copyVertSelectionByPosition selection[1] selection[2] round_to_decimal_places:3

)


--global SAVE_LOAD_SELECTION

--/**
--  *
--  */
--macroscript	epoly_selection_save_load
--category:	"_Epoly-Selection"
--buttonText:	"Save\Load Selection"
--toolTip:	"SAVE current node selection.\n\nLOAD if nothing selected"
--icon:	"MENU:false|across:3"
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
