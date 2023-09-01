
/** KILL CALLBACKS ON START
 *
 */

--setModelingMaterialKill() -- kill for case of restart of UI


/**
 */
macroscript	material_id_by_object
category:	"_Material"
buttonText:	"Mat ID By Object"
tooltip:	"Set different material ID for each object"
(
	--EditPoly = Epoly_v()
	_selection = for o in geometry collect o


	for i=1 to _selection.count do
	(
		select _selection[i]
		(Epoly_v()).setMatIdToObject i
	)

	select _selection

	CompleteRedraw()
)


/**  Create multimaterial where each material ID has different color
 */
macroscript	material_remove
category:	"_Material"
buttonText:	"Remove"
tooltip:	"Remove material from selection"
icon:	"MENU:true"
(

	selection.material = undefined
)
