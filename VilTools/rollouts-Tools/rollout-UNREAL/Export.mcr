filein( getFilenamePath(getSourceFileName()) + "/Lib/NodeList/NodeList.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNode/ExportNode.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterFbx/ExporterFbx.ms" )

/**  
 *	
 */
macroscript	_unreal_export_path
category:	"_Unreal"
buttontext:	"Projects"
toolTip:	"Create Export Node"
icon:	"type:BrowsePath|width:256"
(

	--ExportNode 	= ExportNode_v()

	
)

/**  
 */
macroscript	_unreal_export_node_create
category:	"_Unreal"
buttontext:	"Node"
toolTip:	"Create Export Node\nNode name is Unreal`s project name\nNode text is asset name"
--icon:	"#(path, index)"
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
--icon:	"#(path, index)"
(
	Exporter = ExporterFbx_v()
	
	Exporter.loadPreset()
	
	Exporter.epxort ((NodeList_v()).getSelectedNodes())
)

/**  
 */
macroscript	_unreal_export_nodes_list
category:	"_Unreal"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"type:multilistbox|columns:14"
(
	select ((NodeList_v()).getSelectedNodes())
)