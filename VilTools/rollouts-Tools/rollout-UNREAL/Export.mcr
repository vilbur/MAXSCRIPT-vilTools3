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
 *	
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
 *	https://docs.unrealengine.com/4.27/en-US/WorkingWithContent/Importing/Datasmith/SoftwareInteropGuides/3dsMax/MAXScriptInterface/
 */
macroscript	_unreal_export
category:	"_Unreal"
buttontext:	"Export"
toolTip:	"Export Fbx file"
--icon:	"#(path, index)"
(
	Exporter = ExporterFbx_v()
	
	Exporter.selectNodeChildren()
	
	--export_node	= getNodeByName "export-node"
	--
	--select export_node
	--
	--selectmore $.children
	--
	--deselect export_node
	--
	--actionMan.executeAction 0 "40143"  -- Groups: Group Close
	--
	----DatasmithExport.IncludeTarget	= #VisibleObjects               -- or #SelectedObjects
	--DatasmithExport.IncludeTarget	= #SelectedObjects               -- or #SelectedObjects
	----DatasmithExport.AnimatedTransforms	= #ActiveTimeSegment       -- or #CurrentFrame
	--DatasmithExport.AnimatedTransforms	= #CurrentFrame       -- or #CurrentFrame
	----DatasmithExport.Export	"c:\Users\vilbur\Documents\Unreal Projects\Car_Studio\Content\Maserati\Maserati.udatasmith" true    -- set your own path and filename
	--DatasmithExport.Export	(GetDir #export + "\Maserati\Maserati.udatasmith" ) true 
)

/**  
 *	
 */
macroscript	_unreal_export_nodes_list
category:	"_Unreal"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"type:multilistbox|columns:14"
(	
	NodeList 	= NodeList_v()

	selected_items = NodeList.getSelectedItems()
	nodes_in_scene = NodeList._getNodesInScene()

	select (for _node in nodes_in_scene where findItem selected_items _node.name > 0 collect _node) 

)




















