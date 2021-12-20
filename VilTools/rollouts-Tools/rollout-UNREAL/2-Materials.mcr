filein( getFilenamePath(getSourceFileName()) + "/Lib/NodeList/NodeList.ms" )	 -- "./Lib/NodeList/NodeList.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNode/ExportNode.ms" )	 -- "./Lib/ExportNode/ExportNode.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterFbx/ExporterFbx.ms" ) -- "/Lib/ExporterFbx/ExporterFbx.ms"

/**  
 *	
 */
macroscript	_unreal_load_materials
category:	"_Unreal"
buttontext:	"Load Mats"
toolTip:	"Load materials"
icon:	""
(
	--format "EventFired	= % \n" EventFired
	_rollout = EventFired.Roll

	asset_dir = execute ("@"+ "\""+_rollout.BROWSEPATH_Assets_Dir.text +"\"")

	files = getFiles (asset_dir+"\*.uasset")

	file_names = for file in files collect getFilenameFile(filenameFromPath file)

	_rollout.DROPDOWNLIST_Assign_Materials.items = file_names
)

/**  
 *	
 */
macroscript	_unreal_materials
category:	"_Unreal"
buttontext:	"Assign Materials"
toolTip:	"Assign material from asset folder"
icon:	"type:Dropdownlist|width:256"
(
	if( selection.count == 0 ) then
		return false

	dropdown = EventFired.Control

	materials = dropdown.items
	selected  = dropdown.selection

	mat_in_scene	= for mat in sceneMaterials where mat.name == materials[selected] collect mat
	--format "mat_in_scene	= % \n" mat_in_scene

	$.material = if( mat_in_scene.count > 0 ) then mat_in_scene[1] else standardMaterial name:materials[selected] diffuse:(color ( random 64 128) ( random 64 128) ( random 64 128))
)