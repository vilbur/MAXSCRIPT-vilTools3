filein( getFilenamePath(getSourceFileName()) + "/Material.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callback/setModelingMaterial.ms" )


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
	
	--setModelingMaterialCallback()
	setModelingMaterialKill()
	
	--mat = StandardMaterial glossiness:0 specularLevel:0
	--
	--mat.diffuse = color 169 191 203
	--	
	--mat.name	= "Modeling"
	--
	--selection.material = mat
	
	
	
	
	
)
