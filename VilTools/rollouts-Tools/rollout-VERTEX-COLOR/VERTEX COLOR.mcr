
/**
  *
  */
macroscript	epoly_vertex_color_set_to_baseobject
category:	"_Epoly-Vertex-Color"
buttonText:	"SET Color"
toolTip:	"Set vertex color to selected vertex.\n\nVertex can be selected in modifiers like:\nEdit Poly|Poly Select\n\nLMB: Green\nCTRL:#RED"
icon:	"MENU:true|tooltip:\n\n----------------------\n\nFIX IF NOT WORK PROPERLY:\\n1) Try clean mesh, weld verts and close borders"
(

	on execute do

	if selection.count > 0 then undo "Set Vertex Color" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VERTEX-COLOR\VERTEX COLOR.mcr"


		--_mod = modPanel.getCurrentObject()f
		--format "_mod	= % \n" _mod
		--format "_mod == Editable_Poly	= % \n" (_mod == Editable_Poly)

		--format "VERTS_BASEOBJECTS	= % \n" verts_baseobjects

		--verts_count	= getNumVerts obj.mesh
		--verts_count_VC	= getNumCPVVerts obj.mesh
		obj = selection[1]

		if not polyop.getMapSupport obj 0 then
			polyop.setMapSupport obj 0 true


		verts_count	= polyop.getNumVerts obj.baseObject

		verts_count_VC	= polyop.getNumMapVerts obj.baseObject 0


		if verts_count == verts_count_VC then
		(

				--setNumCPVVerts obj.baseObject.mesh (verts_count) true -- WORKS BUT IT RESET VERTEX COLORS
				--setNumCPVVerts obj.baseObject.mesh (verts_count)		 -- SEEM TO WORKING, RESULT IS



			--format "verts_count_VC	= % \n" (getNumCPVVerts obj.baseObject.mesh)

			--if verts_count == verts_count_VC then
			--(
			verts_baseobjects = passVertexSelectionToEditablePoly()

			format "VERTS_BASEOBJECTS	= % \n" verts_baseobjects
			--if not verts_baseobjects.isEmpty then
			--(
			--
			--	/* SELECT VERTEX IN BASEOBJECT MANNUALY - Direct assigment without swithching to */
			--	if classof _mod != Editable_Poly then
			--		modPanel.setCurrentObject(obj.baseobject)
			--
			--	obj.EditablePoly.SetSelection #Vertex verts_baseobjects
			--
			--	subObjectLevel = 1
			--
			--	polyop.setVertColor obj 0 verts_baseobjects (if keyboard.controlPressed then red else green )
			--
			--	obj.EditablePoly.SetSelection #Vertex #{}
			--
			--	subObjectLevel = 0
			--
			--	if _mod != ( modPanel.getCurrentObject()) then
			--		 modPanel.setCurrentObject(_mod)
			--)


			/* CODE BELLOW OFTEN ASSIGN COLORS TO MANY OTHER VERTS */

			if not verts_baseobjects.isEmpty then
				polyop.setVertColor obj.baseobject 0 (verts_baseobjects) (if keyboard.controlPressed then red else green )

			$.showVertexColors	= true
			$.vertexColorsShaded	= true

			redrawViews()


		)
		else
		(
			format "getNumVerts	= % \n" verts_count
			format "getNumMapVerts	= % \n" verts_count_VC

			addModifier obj (UVW_Mapping_Clear mapID:0) before:obj.modifiers.count

			messageBox "VERTEX COUNT AND COUNT OF COLORED VERTS IS NOT EQUAL\n\nPLEASE RESET UV CHANNEL.\n\nModifier has been added" title:"ERROR"
		)

		--)
		--else if queryBox "RESET OF VERTEX COLORS IS NEEDED.\n\nCONTINUE ?" title:"RESET VERTEX COLORS"  beep:true then
		--(
		--	polyop.defaultMapFaces obj.baseobject 0
		--
		--	messageBox "RESET VERTEX COLORS FINISHED" title:"SUCCESS"
		--)
	)
)


/**
  *
  */
macroscript	epoly_vertex_color_select_by
category:	"_Epoly-Vertex-Color"
buttonText:	"SELECT Color"
icon:	"across:4|MENU:true|tooltip:Select all verts with same vertex color as selected verts.\n\nSELECT ALLCOLORED VERTS IF NT ANY VERTEX SELECTED"
(
	on execute do if ( obj = selection[1] ) != undefined then
		undo "Select Vertex Color" on
		(
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VERTEX-COLOR\VERTEX COLOR.mcr"

			verts_all	= #{1..(getNumVerts obj.mesh)}
			vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active

			--all_colored_verts	= #{}
			new_selection	= #{}

			MeshVertexGetter 	= MeshVertexGetter_v(obj)

			colored_verts = MeshVertexGetter.getColoredVerts quiet:true
			format "COLORED_VERTS	= % \n" colored_verts
			format "classOF colored_verts	= % \n" (classOF colored_verts)

			white_verts = if ( verts = colored_verts[white as string] ) != undefined then verts else #{}

			if not vertex_sel.isEmpty then
				for clr in colored_verts.keys do new_selection += colored_verts[clr]

			else
				new_selection = verts_all - white_verts -- get all colored verts

			if classOf (_mod = modPanel.getCurrentObject() ) == Edit_Poly then
			(
				_mod.SetSelection #Vertex #{}

				_mod.Select #Vertex new_selection
			)
			else
				if classOf _mod == Editable_Poly then
					_mod.SetSelection #Vertex new_selection

			subObjectLevel = 1

		)
)


/**
  *
  */
macroscript	epoly_vertex_color_hide_by_color
category:	"_Epoly-Vertex-Color"
buttonText:	"HIDE By Color"
toolTip:	"Hide verts by vertex color of selected verts.White color is used, if nothing selected.\n\nCTRL: ISOLATE MODE (Show all verts of selected colors ).\n\nQUICK SCRIPT, TESTED ONLY ON EDITABLE POLY"
icon:	"across:4|MENU:true"
(
	on execute do
	undo "Hide Colored Verts" on
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VERTEX-COLOR\VERTEX COLOR.mcr"

		obj 	= selection[1]
		new_sel	= #{}
		verts_by_colors	= Dictionary #string

		if (colored_verts_num = polyop.getNumMapVerts obj.baseObject 0  ) > 0 then
		(
			verts_to_get = getVertSelection obj.mesh

 			while not verts_to_get.isEmpty do
 			(
				first_vert = (verts_to_get as Array )[1]

				vert_color = getvertcolor obj.mesh  first_vert

				verts_by_color = meshop.getVertsByColor obj.mesh  (vert_color) 0.001 0.001 0.001 --return TRESHOLD FLOAT MUST NOT BE 0.0 - it causeses error in whie loop in this._setVertexColors()

				verts_by_colors[ vert_color as string ] = verts_by_color

				verts_to_get = verts_to_get - verts_by_color
			)

			/* GET COLROS OF SELECTED VERTS */
			if verts_to_get.count > 0 then
				for key in verts_by_colors.keys do
					new_sel += verts_by_colors[key]

			else
				new_sel = meshop.getVertsByColor obj.mesh white 0.001 0.001 0.001

			format "NEW_SEL	= % \n" new_sel
			if keyboard.controlPressed then
			(
				/* ISOLATE ONLY VERTS OF GIVEN COLOR */
				polyop.unHideAllVerts obj

				polyop.setHiddenVerts obj  (#{1..(getNumVerts obj.mesh)} - new_sel)
			)
			else /* ONLY HIDE VERTS OF GIVEN COLOR */
				polyop.setHiddenVerts obj new_sel

			subObjectLevel = 1
		)
		else
			messageBox ("There is not any vertex color on object:\n\n"+obj.name) title:"NO VERTEX COLOR"
	)
)


/**
  *
  */
macroscript	epoly_vertex_color_reset
category:	"_Epoly-Vertex-Color"
buttonText:	"RESET Color"
toolTip:	"Hide verts by vertex color of selected verts.White color is used, if nothing selected.\n\nCTRL: ISOLATE MODE (Show all verts of selected colors ).\n\nQUICK SCRIPT, TESTED ONLY ON EDITABLE POLY"
icon:	"across:4|MENU:true"
(
	on execute do
	undo "Reset Vertex Color" on
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VERTEX-COLOR\VERTEX COLOR.mcr"

		obj = selection[1]

		--if getNumCPVVerts obj.mesh > 0 then
		if polyop.getNumMapVerts obj.baseObject 0 > 0 then
		(
			--vertex_sel = getVertSelection obj.mesh

			verts = passVertexSelectionToEditablePoly()

			if verts.isEmpty then
				verts = #ALL


			--/* GET SELECTED OR ALL VERTS */
			--verts = if vertex_sel.isEmpty then
			--(
			--	all_verts =  #{1..(getNumVerts obj.mesh)}
			--	white_verts = meshop.getVertsByColor obj.mesh white 0.001 0.001 0.001
			--
			--	all_verts - white_verts
			--)
			--else
			--	vertex_sel


			polyop.setVertColor  obj.baseobject 0 verts white

			--print ("VERTEX COLOR OF "+ (if vertex_sel.isEmpty then "ALL"else "SELECTED") +" SET TO WHITE")

		)
		else
			messageBox ("There is not any vertex color on object:\n\n"+obj.name) title:"NO VERTEX COLOR"
	)
)

/**
  *
  */
macroscript	epoly_vertex_color_property_toggle
category:	"_Epoly-Vertex-Color"
buttonText:	"SHOW-Colors"
toolTip:	"Toggle show\hide"
icon:	"across:4|MENU:true"
(
	on execute do
	undo "Show Vertex Colors" on
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VERTEX-COLOR\VERTEX COLOR.mcr"

		if selection.count > 0 then
		(
			$.showVertexColors = not selection[1].showVertexColors
			$.vertexColorsShaded = on
			$.vertexColorType = 0
		)
	)
)
