/*------------------------------------------------------------------------------

	ASSETS PATH

------------------------------------------------------------------------------*/
/**  
 */
macroscript	_unreal_asset_path_label
category:	"_Unreal"
buttontext:	"Materials path"
toolTip:	"Create Export Node"
icon:	"control:label|across:1|offset:[-146,0]"
--icon:	"control:label|across:1"
(

)

/**  
 */
macroscript	_unreal_asset_path
category:	"_Unreal"
buttontext:	"[Materials Dir]"
--toolTip:	"Create Export Node"
icon:	"control:BrowsePath|ini:false|across:1"
--icon:	"control:BrowsePath|across:1|initialDir:c:\\Users\\%USERNAME%\\Documents\\Unreal Projects"
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
	filein (@"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\Rollouts\rollouts-Unreal-Engine\rollout-UNREAL\2-Materials.mcr")
	
	asset_dir = execute ("@"+ "\""+unreal.Materials_dir.text +"\"")
	format "asset_dir	= % \n" asset_dir
	files = getFiles (asset_dir+"\*.uasset")
	format "files	= % \n" files
	file_names = for file in files collect toLower (getFilenameFile(filenameFromPath file))
	format "file_names	= % \n" file_names
	unreal.Assign_Materials.items = file_names
	
)

/**  
 *	
 */
macroscript	_unreal_materials
category:	"_Unreal"
buttontext:	"Assign Materials"
toolTip:	"Assign material from asset folder"
icon:	"control:Dropdownlist|width:256"
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




