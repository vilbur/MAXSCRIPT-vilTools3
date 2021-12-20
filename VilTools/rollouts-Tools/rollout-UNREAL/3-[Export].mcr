--filein( getFilenamePath(getSourceFileName()) + "/Lib/NodeList/NodeList.ms" )	-- "./Lib/NodeList/NodeList.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNode/ExportNode.ms" )	-- "./Lib/ExportNode/ExportNode.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterFbx/ExporterFbx.ms" )



/*------------------------------------------------------------------------------
	GROUPBOX NODES
------------------------------------------------------------------------------*/

/**  
 */
macroscript	_unreal_export_group
category:	"_Unreal"
--buttontext:	"SetupGroup"
--toolTip:	"Create Export Node"
--icon:	"type:Groupbox|across:2"
buttontext:	"Nodes"
icon:	"type:Groupbox|id:test_groupbox_x|across:2"
(
)
/**  
 */
macroscript	_unreal_export_node_load
category:	"_Unreal"
buttontext:	"Load"
toolTip:	"Load nodes to list"
icon:	"Groupbox:Nodes"
--icon:	"type:checkbutton"
(
	--select ((NodeList_v()).getSelectedNodes())

	(NodeList_v()).loadNodes()
	--ExportNode 	= ExportNode_v()

	--ExportNode.create()
)

/**  
 */
macroscript	_unreal_export_node_create
category:	"_Unreal"
buttontext:	"Create"
toolTip:	"Create Export Node\nNode name is Unreal`s project name\nNode text is asset name"
icon:	"Groupbox:Nodes"
(
	ExportNode 	= ExportNode_v()

	ExportNode.create()
)

/**  
 */
macroscript	_unreal_export
category:	"_Unreal"
buttontext:	"Export"
toolTip:	"Export Fbx file"
icon:	"Groupbox:Nodes|height:64"
(
	--Exporter = ExporterFbx_v export_dir:(ROLLOUTS_GLOBAL.get "ROLLOUT_unreal").BrowsePath_Export_Path.text

	--Exporter.loadPreset()

	--Exporter.epxort ((NodeList_v()).getSelectedNodes())
)

/*------------------------------------------------------------------------------
	NODELIST
--------------------------------------------------------------------------------*/

/**  NODE LIST
 */
macroscript	_unreal_export_nodes_list
category:	"_Unreal"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"type:multilistbox|across:2"
(
	select ((NodeList_v()).getSelectedNodes())
)

