filein( getFilenamePath(getSourceFileName()) + "/Lib/MaterialId/MaterialId.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callback/setModelingMaterial.ms" )


/** KILL CALLBACKS ON START
 *
 */

--setModelingMaterialKill() -- kill for case of restart of UI



/**  Create multimaterial where each material ID has different color
 */
macroscript	material_assign_idmat
category:	"_Material"
buttonText:	"Multi ID"
tooltip:	"Create multimaterial where each material ID has different color"
(
	_Material = MaterialId_v()

	selection.material = _Material.getIdMaterial()
)

/**
 */
macroscript	material_by_object
category:	"_Material"
buttonText:	"Mat By Object"
tooltip:	"Set different material ID for each object"
(
	--EditPoly = Epoly_v()
	_selection = for o in geometry collect o
	print ( "_selection=" + _selection.count as string )

	for i=1 to _selection.count do
	(
		select _selection[i]
		(Epoly_v()).setMatIdToObject i
	)

	select _selection

	CompleteRedraw()
)

/**
 */
macroscript	material_assign_modeling
category:	"_Material"
buttonText:	"Modeling"
tooltip:	"Shade material for modeling"
icon:	"control:checkbutton"
(
	global MODELING_MATERIAL_STORE = #( )

	if( EventFired.value == true ) then
	(
		setSelectionLastKill()

		setModelingMaterialCallback()

		setSelectionLastCallback()
	)
	else
	(
		_selection = selection

		deselect selection

		setModelingMaterialKill()

		select _selection
	)
)


/**  Create multimaterial where each material ID has different color
 */
macroscript	material_remove
category:	"_Material"
buttonText:	"Remove"
tooltip:	"Remove material from selection"
(

	selection.material = undefined
)
