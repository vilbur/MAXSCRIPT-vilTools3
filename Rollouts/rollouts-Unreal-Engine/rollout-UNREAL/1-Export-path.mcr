filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNode/ExportNode.ms" )	 -- "./Lib/ExportNode/ExportNode.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterFbx/ExporterFbx.ms" ) -- "./Lib/ExporterFbx/ExporterFbx.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterDatasmith/ExporterDatasmith.ms" )

/*------------------------------------------------------------------------------
  
	EXPORT PATH
	
------------------------------------------------------------------------------*/



/**  
 */
macroscript	_unreal_export_dir
category:	"_Unreal"
buttontext:	"[Export Dir]"
--toolTip:	"Create Export Node"
icon:	"control:BrowsePath|ini:false|across:1"
--icon:	"control:BrowsePath|across:1|initialDir:c:\\Users\\%USERNAME%\\Documents\\Unreal Projects"
(
	--messageBox "Yupiii" title:"Title"  beep:false
	
	format "EventFired	= % \n" EventFired
		
	--for _node in (NodeList_v()).getSelectedNodes() do
	--(
	--	setUserProp _node "export-dir" EventFired.val
	--)
	
)
--/**  
-- */
--macroscript	_unreal_projects_name
--category:	"_Unreal"
--buttontext:	"Projects name"
----toolTip:	"Create Export Node"
--icon:	"control:BrowsePath|across:1"
----icon:	"control:BrowsePath|across:1|initialDir:c:\\Users\\%USERNAME%\\Documents\\Unreal Projects"
--(
--	
--)

