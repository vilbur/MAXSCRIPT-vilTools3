filein( getFilenamePath(getSourceFileName()) + "/Lib/Material/Material.ms" )

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
	_Material = Material_v()
	
	selection.material = _Material.getIdMaterial()
)

/**  
 */
macroscript	material_assign_modeling
category:	"_Material"  
buttonText:	"Modeling"
tooltip:	"Shade material for modeling"
icon:	"type:checkbutton"
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
