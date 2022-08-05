filein( getFilenamePath(getSourceFileName()) + "/../rollout-MATERIALS/Lib/Material/Material.ms" )
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
	
		materials = _Material.getMaterialsOfObjects(for o in selection where superclassof o == GeometryClass collect o)

		textures = _Material.getDiffuseTextures(materials)
		--enumerateFiles $
		format "textures	= % \n" textures
		----try (
		--	texture_path = selection[1].material.base_color_map.filename
		--	
		--	psd_path = getFilenamePath(texture_path) + getFilenameFile(texture_path) + ".psd"
		--	
		--	format "psd_path	= % \n" psd_path
		--	photoshop_path = materials.photoshop_path.text
		--	--format "texture_path	= % \n" texture_path
		--	--format "photoshop_path	= % \n" photoshop_path
		--	--DOSCommand ("start \"" +	photoshop_exe + "\"  /open \"" + m + "\"")	
		--	--DOSCommand ("start \"" +	photoshop_exe + "\"")	
		--	ShellLaunch photoshop_path psd_path
		----)
		----catch()
	)
)

