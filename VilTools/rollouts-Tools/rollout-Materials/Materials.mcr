filein( getFilenamePath(getSourceFileName()) + "/Material.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callback/setModelingMaterial.ms" )


/** KILL CALLBACKS ON START 
 *	
 */

setModelingMaterialKill()



/**  Create multimaterial where each material ID has different color
 */
macroscript	material_assign_idmat
category:	"_Material"  
buttonText:	"Multi ID"
tooltip:	"Create multimaterial where each material ID has different color"  
(
	Material = Material_v()
	
	selection.material = Material.getIdMaterial()
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
		setModelingMaterialKill()
)