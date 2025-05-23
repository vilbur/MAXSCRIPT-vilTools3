filein( getFilenamePath(getSourceFileName()) + "/../rollout-MATERIALS/Lib/Material/Material.ms" )

/** Show or hide diffuse textures onselection or all materials
 */
function showOrHideDiffuseTexturesOnselectionOrAllMaterials state =
(
	--format "\n"; print ".showOrHideDiffuseTexturesOnselectionOrAllMaterials()"
	_Material 	= Material_v()

	materials = if selection.count > 0 then _Material.getMaterialsOfObjects( selection as Array ) else sceneMaterials

	_Material.showTexturesInViewPort(materials)(#diffuseMap)(state)
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
toolTip:	"Hide diffuse map in viewport\n\nWORKS ON ALL MATERIALS IF NOTHING IS SELECTED"
--icon:	"Across:1"
(
	showOrHideDiffuseTexturesOnselectionOrAllMaterials(false)
)

/**
 */
macroscript	_texture_open_psd_in_photoshop
category:	"_Texture"
buttontext:	"Open in PS"
toolTip:	"Open current texture in Photoshop\n*.psd file will be opened if exist"
--icon:	"Across:1"
(
	/* TODO: MOVE THIS TO CLASS */

	on execute do
	(
		_Material 	= Material_v()

		materials = _Material.getMaterialsOfObjects( selection as Array )

		_bitmaps = _Material.getBitmaps(materials)
		---format "_bitmaps	= % \n" _bitmaps

		for _bitmap in _bitmaps where _bitmap != undefined and _bitmap.filename != undefined do
		(
			---format "_bitmap	= % \n" _bitmap
			if not  matchPattern _bitmap.filename pattern:@"*.psd" then  -- IF PATH IS NOT PSD FILE
			(
				dir	= getFilenamePath(_bitmap.filename)
				filename	= getFilenameFile(_bitmap.filename)
				---format "filename	= % \n" filename
				psd_path = dir + filename + ".psd" -- if psd version of filename exists E.G.: foo-FileName.tga >>> foo-FileName.psd

				if not doesFileExist psd_path then -- remove suffix  E.G.: foo-FileName-DIFF.tga >>> foo-FileName.psd
				(
					psd_path	= dir
					filename_split	= (filterString (filename) (texture.Separator.text))

					for i = 1 to filename_split.count - 1 do
						psd_path += filename_split[i] + texture.Separator.text

					psd_path = (substring psd_path 1 (psd_path.count - 1)) + ".psd"
				)
			)

			Photoshop_exe = ROLLOUT_options.BP_Photoshop_exe.text

			file_path = if psd_path != undefined and doesFileExist (psd_path) then psd_path else _bitmap.filename
			
			file_path = substituteString file_path "/" "\\"
			Photoshop_exe = substituteString Photoshop_exe "/" "\\"

			---format "file_path	= % \n" file_path
			DOSCommand ("start \"\" \"" +	Photoshop_exe + "\" /open \"" +	file_path +	"\"" )
		)
	)
)

/**
 */
macroscript	_texture_import_file_from_cliboard
category:	"_Texture"
buttontext:	"From Cliboard"
toolTip:	"Import texture path from clipboard as diffuse map"
--icon:	"Across:1"
(
	--print "_texture_import_file_from_cliboard"

	undo "Import texture from clipboard" on
	(

		_Material 	= Material_v()

		file_formats = #(".jpg",".tga",".bmp",".psd",".png")
		--Sel = for o in selection   where superclassof o == GeometryClass collect o

		--file_path = @"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-MATERIALS\_Test\material-test-texture-A.tga"


		if selection.count > 0 then
			if( clipboard_text = getclipboardText() ) != undefined and doesFileExist (clipboard_text) and findItem file_formats ( toLower(getFilenameType(clipboard_text))) then
			(
				filename	= getFilenameFile(clipboard_text)
				--format "filename	= % \n" filename
				if( mat = selection[1].material ) == undefined then
				(
					mat = Standardmaterial name:filename diffuse:(color 128 128 128)

					for o in selection do o.material = mat
				)

				_Material.setTextureFile mat clipboard_text #diffuseMap
			)

	)
)


/**
 */
macroscript	_texture_set_map_channels
category:	"_Texture"
buttontext:	"Channels"
toolTip:	"Change UV channels of textures used in material of seleted obejects"
icon:	"control:spinner|range:[1,99,1]|type:#integer|across:5|align:#left"
(

	on execute do
	(
		--format "EventFired	= % \n" EventFired
		_Material 	= Material_v()

		materials = _Material.getMaterialsOfObjects( selection as Array )

		for mat in materials where (slots = _Material.getMapSlots(mat)).count > 0 do
			for slot_name in slots where ( map_slot = getProperty mat slot_name ) != undefined do
				map_slot.coords.mapChannel = EventFired.val

	)
)


/**
 */
macroscript	_texture_suffix_separator
category:	"_Texture"
buttontext:	"Separator"
toolTip:	"Separator of texture type\n\nE.G:\n	'foomap-DIFF.tga'\nor\n	'foomap_DIFF.tga'"
icon:	"control:edittext|across:5|offset:[16,0]"
(

)
