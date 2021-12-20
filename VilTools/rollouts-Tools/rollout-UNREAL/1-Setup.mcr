--filein( getFilenamePath(getSourceFileName()) + "/Lib/NodeList/NodeList.ms" )	-- "./Lib/NodeList/NodeList.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNode/ExportNode.ms" )	-- "./Lib/ExportNode/ExportNode.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterFbx/ExporterFbx.ms" )

/*------------------------------------------------------------------------------
	EXPORT PATH
------------------------------------------------------------------------------*/
/**  
 */
macroscript	_unreal_export_path_label
category:	"_Unreal"
buttontext:	"Unreal projects"
toolTip:	"Create Export Node"
icon:	"type:label|across:1|offset:[-134,0]"
--icon:	"type:label|across:1"
(

)

/**  
 */
macroscript	_unreal_export_path
category:	"_Unreal"
buttontext:	"[Export Dir]"
--toolTip:	"Create Export Node"
icon:	"type:BrowsePath|across:1"
--icon:	"type:BrowsePath|across:1|initialDir:c:\\Users\\%USERNAME%\\Documents\\Unreal Projects"
(

)


/*------------------------------------------------------------------------------
	ASSETS PATH
------------------------------------------------------------------------------*/
/**  
 */
macroscript	_unreal_asset_path_label
category:	"_Unreal"
buttontext:	"Asset path"
toolTip:	"Create Export Node"
icon:	"type:label|across:1|offset:[-146,0]"
--icon:	"type:label|across:1"
(

)


/**  
 */
macroscript	_unreal_asset_path
category:	"_Unreal"
buttontext:	"[Assets Dir]"
--toolTip:	"Create Export Node"
icon:	"type:BrowsePath|across:1"
--icon:	"type:BrowsePath|across:1|initialDir:c:\\Users\\%USERNAME%\\Documents\\Unreal Projects"
(

)


--
--/**  
-- */
--macroscript	_unreal_export_path
--category:	"_Unreal"
--buttontext:	"Project name"
--icon:	"type:EditText"
--(
--
--)