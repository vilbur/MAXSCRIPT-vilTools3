filein( getFilenamePath(getSourceFileName()) + "/../rollout-MATERIALS/Lib/Material/Material.ms" )

/** Show or hide diffuse textures onselection or all materials
 */
function showOrHideDiffuseTexturesOnselectionOrAllMaterials state =
(
	--format "\n"; print ".showOrHideDiffuseTexturesOnselectionOrAllMaterials()"
	_Material 	= Material_v()

	materials = if selection.count > 0 then _Material.getMaterialsOfObjects( selection as Array ) else sceneMaterials

	_Material.showTexturesInViewPort(materials)(state)
)

/**  
 */
macroscript	_texture_diffuse_map_show_viewport
category:	"_Texture"
buttontext:	"Show\Hide"
toolTip:	"Show diffuse map in viewport"
--icon:	"Across:1"
(
	showOrHideDiffuseTexturesOnselectionOrAllMaterials(true)
)

/**  
 */
macroscript	_texture_diffuse_map_hide_viewport
category:	"_Texture"
buttontext:	"Show\Hide"
toolTip:	"Hide diffuse map in viewport"
--icon:	"Across:1"
(
	showOrHideDiffuseTexturesOnselectionOrAllMaterials(false)
)

/**  
 */
macroscript	_texture_open_psd_in_photoshop
category:	"_Texture"
buttontext:	"Open PSD"
toolTip:	"Open PSd of current texture in Photoshop"
--icon:	"Across:1"
(
	on execute do
	(
		clearListener()
		_Material 	= Material_v()
	
		materials = _Material.getMaterialsOfObjects( selection as Array )

		textures = _Material.getDiffuseTextures(materials)
		format "textures	= % \n" textures
		
		for texture in textures do
		(
			
			psd_path = replace texture (texture.count-2) 3 "psd"
			
			if (getFiles psd_path).count != 0 then
				DOSCommand ("start \"\" \"" +	ROLLOUT_options.Photoshop_exe.text + "\" \"" +	psd_path +	"\"" )
		)
	)
)


