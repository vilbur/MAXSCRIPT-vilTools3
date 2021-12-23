/*------------------------------------------------------------------------------

	ASSETS PATH

------------------------------------------------------------------------------*/
/**  
 */
macroscript	_unreal_asset_path_label
category:	"_Unreal"
buttontext:	"Materials path"
toolTip:	"Create Export Node"
icon:	"type:label|across:1|offset:[-146,0]"
--icon:	"type:label|across:1"
(

)

/**  
 */
macroscript	_unreal_asset_path
category:	"_Unreal"
buttontext:	"[Materials Dir]"
--toolTip:	"Create Export Node"
icon:	"type:BrowsePath|across:1"
--icon:	"type:BrowsePath|across:1|initialDir:c:\\Users\\%USERNAME%\\Documents\\Unreal Projects"
(
	for _node in (NodeList_v()).getSelectedNodes() do
		setUserProp _node "materials-dir" EventFired.val

	macros.run "_Unreal" "_unreal_load_materials"
)

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
	_rollout = VilTools.Tools.ROLLOUT_UNREAL

	asset_dir = execute ("@"+ "\""+_rollout.BROWSEPATH_Materials_Dir.text +"\"")

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