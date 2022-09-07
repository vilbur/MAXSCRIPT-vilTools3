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


/**  Set material of 1st selected object to all objects in selection
 */
macroscript	material_by_1st_object
category:	"_Material"  
buttonText:	"By 1st object"
tooltip:	"Set material of 1st selected object to all objects in selection"  
(
	_selection = for o in selection where superClassOf o == GeometryClass collect o
	
	if _selection.count <= 1 then
		return false
	
	source_object = _selection[1]
	
	target_objects = deleteItem _selection 1
	
	for obj in target_objects do
		obj.material = source_object.material
)




