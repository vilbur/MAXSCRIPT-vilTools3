filein( getFilenamePath(getSourceFileName()) + "/Lib/NodeList/NodeList.ms" )	-- "./Lib/NodeList/NodeList.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNode/ExportNode.ms" )	-- "./Lib/ExportNode/ExportNode.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNodeCallbacks/ExportNodeCallback.ms" )	-- "./Lib/ExportNodeCallbacks/ExportNodeCallback.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterSetup/ExporterSetup.ms" )	-- "./Lib/Exporter/Exporter.ms"

/*==============================================================================

	NODES CONTROL

================================================================================*/

/**  CREATE EXPORT NODE


  TODO:
	Groups are attached into objects if their name IS NOT UPPERCASE

 */
macroscript	_export_node_create
category:	"_Export"
buttontext:	"Create"
toolTip:	"Create Export Node\n\nNode name is exported filename\n\nSlected objects will be linked to new node"
icon:	"across:1|width:64|height:48|offset:[ -128, 16]"
(
	--format "eventFired.control	= % \n" eventFired.control
	--format "eventFired	= % \n" eventFired
	undo "Create Export Node" on
	(
		ExportNode 	= ExportNode_v()

		ExportNode.create()

	)
)

/**  LINK TO NODE
 */
macroscript	_export_node_link_selection
category:	"_Export"
buttontext:	"Link"
toolTip:	"Link selected objects to selected nod"
icon:	"offset:[ -128, 0]"
(
	_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())

	if( _nodes.count > 0 ) then
		for obj in selection do obj.parent = _nodes[1]
)


/**  LOAD
 */
macroscript	_export_node_load
category:	"_Export"
buttontext:	"Load"
toolTip:	"Load nodes to list"
icon:	"offset:[ -128, 0]"
(
	--select ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())

	(NodeList_v(ROLLOUT_export.ML_nodes)).loadNodes()
	--ExportNode 	= ExportNode_v()

	--ExportNode.create()
)

/**  Unify
 */
macroscript	_export_node_unify
category:	"_Export"
buttontext:	"Unify"
toolTip:	"Set size and path of selected export nodes\n\n1st selected node is source object"
icon:	"offset:[ -128, 0]"
(
	_nodes = ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())

	if( _nodes.count >= 2 and queryBox "Set size and export path to selected nodes by first selected node ?" title:"Unify node settings" ) then	--ExportNode 	= ExportNode_v()
	(

		master_node = _nodes[1]
		other_nodes = deleteItem _nodes 1
		--format "master_node	= % \n" master_node
		--format "other_nodes	= % \n" other_nodes
		for _node in other_nodes do
		(
			_node.size	= master_node.size
			_node.export_dir	= master_node.export_dir

		)

	)
)

--
--/**
-- */
--macroscript	_export_preexport
--category:	"_Export"
--buttontext:	"Pre Export"
--toolTip:	"Save Eported nodes as separated max files in export folder"
----icon:	"Groupbox:Nodes Control"
--(
--	clearListener()
--
--	selected_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())
--
--	format "selected_nodes	= % \n" selected_nodes
--
--	if( selected_nodes.count > 0 ) then
--		with redraw off
--			(ExporterDatasmith_v export_nodes:selected_nodes).export pre_export:true
--	else
--		messageBox "Export node is not selected" title:"Export node error"
--
--
--	redrawViews()
--)
--



--/*------------------------------------------------------------------------------
--	PRE-EXPORT TEST
----------------------------------------------------------------------------------*/
--
--
--/**
-- */
--macroscript	_export_test
--category:	"_Export"
--buttontext:	"Test"
--toolTip:	"Export selected nodes to files"
--icon:	"height:64"
--(
--	--export_dir = execute ("@"+ "\""+EventFired.Roll.BROWSEPATH_Export_Dir.text +"\"")
--	clearListener()
--
--	filein( @"c:\scripts\vilTools3\Rollouts\rollouts-Unreal-Engine\rollout-UNREAL\Lib\ExporterDatasmith\ExportChecker\ExportChecker.ms" ) -- DEV
--
--	selected_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())
--
--	format "selected_nodes	= % \n" selected_nodes
--
--	if( selected_nodes.count > 0 ) then
--		(ExportChecker_v export_nodes:selected_nodes).test()
--	else
--		messageBox "Export node is not selected" title:"Export node error"
--
--)

/*==============================================================================

		NODELIST

================================================================================*/

/**  NODE LIST
 */
macroscript	_export_nodes_list
category:	"_Export"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2|event:#selectionEnd|height:20|width:256|offset:[ 96, -224]"
--icon:	"control:multilistbox|across:2"
--icon:	"control:multilistbox|across:2|items:#('1','2')" -- DEV
(
	--format "eventFired	= % \n" eventFired

	selected_nodes =  (NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList()

	clearSelection()

	--selectExportNodeInListCallbackRemove()

	select (selected_nodes)

	--selectExportNodeInListCallbactAdd()


	/*------------------------------------------------------------------------------
		DEPRECATED FOR UNREAL
	--------------------------------------------------------------------------------*/
	--/** Fillpaths
	-- */
	--function fillpaths _control prop_name =
	--(
	--	--format "\n"; print ".fillpaths()"
	--	paths = for _node in selected_nodes where ( export_dir = getUserProp _node prop_name) != undefined collect export_dir
	--	--format "paths[1]	= % \n" paths[1]
	--	if( paths[1] != undefined ) then
	--		_control.text = paths[1]
	--
	--	else	if( ( export_dir = _control.text ) != "" ) then
	--		for _node in selected_nodes do setUserProp _node prop_name  export_dir
	--)
	--
	--fillpaths EventFired.Roll.export_Dir	"export-dir"
	--fillpaths EventFired.Roll.materials_Dir	"materials-dir"
	--
	--macros.run "_Export" "_load_materials"
	--
	--select selected_nodes
)


/*------ NODELIST DOUBLE CLICK ------*/

macroscript	_export_nodes_list_doubleclick
category:	"_Export"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2"
(
	--messageBox "Doubleclick" title:"Title"  beep:false
	--format "EventFired	= % \n" EventFired

	NodeList 	= NodeList_v(ROLLOUT_export.ML_nodes)

	selected_nodes = NodeList.getSelectedNodesInList()

	selectExportNodeInListCallbackRemove()

	selectmore (NodeList.getAllChildren( selected_nodes  ))

	selectExportNodeInListCallbactAdd()

)