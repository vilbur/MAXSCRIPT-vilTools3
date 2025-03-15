filein( getFilenamePath(getSourceFileName()) + "/Lib/NodeList/NodeList.ms" )	-- "./Lib/NodeList/NodeList.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNode/ExportNode.ms" )	-- "./Lib/ExportNode/ExportNode.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/selectExportNodeInListCallback/selectExportNodeInListCallback.ms" )	-- "./Lib/selectExportNodeInListCallback/selectExportNodeInListCallback.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterSetup/ExporterSetup.ms" )	-- "./Lib/ExporterSetup/ExporterSetup.ms"
/*==============================================================================

	NODES CONTROL

================================================================================*/
global NODE_GROUP_NAME_ROLLOUT
--global ROLLOUT_export
--global ROLLOUT_3d_print

/**  CREATE EXPORT NODE


  TODO:
	Groups are attached into objects if their name IS NOT UPPERCASE

 */
macroscript	_export_node_create
category:	"_Export"
buttontext:	"Create"
toolTip:	"Create Export Node\n\nNode name is exported filename\n\nSlected objects will be linked to new node"
icon:	"across:3|width:64|height:48|pos:[ 184, 24 ]"
--icon:	"across:5|width:64|height:48"
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
toolTip:	"LINK TO NODE:\n(link selected obgjects to selcted node)"
icon:	"pos:[ 250, 24 ]"
(

	/** Get selection without members of closed group
	 */
	function getSelectionWithouGroupMembers =
	(
		mapped function getAllChildren node &children = (if isValidNode node and isKindOf children Array do join children node.children)

		children = #()

		groups_closed = for o in ( _selection = selection as Array ) where isGroupHead o and isOpenGroupHead o == false and findItem _selection o.parent == 0 collect o

		getAllChildren groups_closed &children

		for o in selection where findItem children o == 0 collect o --return
	)


	on execute do
		undo "Link to node" on
		(
			_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())

			if( _nodes.count > 0 ) then
			(
				objects_to_link = getSelectionWithouGroupMembers()

				for obj in objects_to_link do obj.parent = _nodes[1]

				object_names = ""

				for obj in objects_to_link do object_names += "\n" + obj.name

				if objects_to_link.count < 200 then
					messageBox ("OBJECTS: "+object_names+"\n\nNODE:\n" + _nodes[1].name ) title:"LINK TO NODE"  beep:false
				else
					messageBox ( objects_to_link.count as string + " OBJECTS HAS BEEN LINKED TO NODE:\n" + _nodes[1].name ) title:"LINK TO NODE"  beep:false
			)
		)
)

--/**  LINK TO GROUP
-- */
--macroscript	_export_node_link_to_group
--category:	"_Export"
--buttontext:	"Link"
--toolTip:	"LINK TO GROUP\n( Link nodes to selected group )"
--icon:	"pos:[ 246, 24 ]"
--(
--	undo "Link to group" on
--	(
--		_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())
--
--		all_groups = makeUniqueArray( for obj in shapes where classOf obj == Export_Node and obj.parent != undefined and isGroupHead obj.parent collect  obj.parent)
--
--		group_names_in_selection = for index in ROLLOUT_export.ML_node_groups.selection as Array collect ROLLOUT_export.ML_node_groups.items[index]
--
--		selected_groups = for _group in all_groups where findItem group_names_in_selection _group.name > 0 collect _group
--
--		format "_NODES	= % \n" _nodes
--		--if( _nodes.count > 0 ) then
--			--for obj in selection do obj.parent = _nodes[1]
--		format "selected_groups	= % \n" selected_groups
--
--		if _nodes.count > 0 and selected_groups.count > 0 then
--		(
--
--			for _node in _nodes do
--				_node.parent = selected_groups[1]
--
--			node_names = ""
--
--			for _node in _nodes do node_names += "\n" + _node.name
--
--			messageBox ("NODES: "+node_names+"\n\nGROUP:\n" + selected_groups[1].name ) title:"GROUP NODES"  beep:false
--		)
--	)
--)




/**  LOAD
 */
macroscript	_export_node_load
category:	"_Export"
buttontext:	"Load"
toolTip:	"Load nodes to list"
icon:	"pos:[ 316, 24 ]"

(
	--format "eventFired	= % \n" eventFired

	(NodeList_v(ROLLOUT_export.ML_nodes)).loadNodes()

	selectExportNodeInListCallbactAdd()
)


/**  GROUP NODES
 */
macroscript	_export_group_nodes
category:	"_Export"
buttontext:	"Group"
toolTip:	"Group selected nodes"
icon:	"pos:[ 184, 72]"
(
	_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())

	--if( _nodes.count > 0 ) then
		--for obj in selection do obj.parent = _nodes[1]
	--isGroupHead

	/** Ask name dialog
	 */
	function _createNodeDialog =
	(
		try(destroyDialog NODE_GROUP_NAME_ROLLOUT) catch()

		rollout NODE_GROUP_NAME_ROLLOUT "Set export node name"
		(
			dotNetControl TextBox "TextBox"

			on NODE_GROUP_NAME_ROLLOUT open do
			(
				TextBox.Text	= toUpper _nodes[1].name
				TextBox.BackColor	= ( dotNetClass "System.Drawing.Color").FromArgb 180 180 180
			)

			on TextBox KeyUp s e do
			(
				if e.KeyCode == e.KeyCode.Enter then
				(
					format "GROUP NAME	= % \n" TextBox.Text
					_group = group _nodes name:TextBox.Text select:true

					_nodes[1].layer.addnode _group

					destroyDialog NODE_GROUP_NAME_ROLLOUT
				)
				else if e.KeyCode == e.KeyCode.Escape then
					destroyDialog NODE_GROUP_NAME_ROLLOUT
			)
		)

		CreateDialog NODE_GROUP_NAME_ROLLOUT width:256 height:40

		setFocus NODE_GROUP_NAME_ROLLOUT.TextBox
	)


	if _nodes.count > 0 then
		_createNodeDialog()

)
/**  Unify
 */
macroscript	_export_node_unify
category:	"_Export"
buttontext:	"Unify"
toolTip:	"Set size and path of selected export nodes\n\n1st selected node is source object"
icon:	"pos:[ 250, 72]"
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





/*==============================================================================


		NODELIST


================================================================================*/



/**  NODE LIST
 */
macroscript	_export_nodes_list
category:	"_Export"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2|event:#selectionEnd|height:19|width:160|offset:[ 0, -120]"
--icon:	"control:multilistbox|across:2|height:20|width:160|offset:[ 0, -96]"
--icon:	"control:multilistbox|across:2"
--icon:	"control:multilistbox|across:2|items:#('1','2')" -- DEV
(
	----clearListener(); print("Cleared in:\n"+getSourceFileName())
	--filein @"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-EXPORT\1-[Export-Nodes].mcr"
	--print "SELECTED"
	--format "eventFired	= % \n" eventFired

	selectExportNodeInListCallbackRemove()

	clearSelection()

	selected_nodes = ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())

	format "\n-----------\nARRAY:selected_nodes:\n";  for selected_node in selected_nodes do format "selected_node:	%\n" selected_node.name

	/* OPEN PARENT GROUPS OF SELECTEDS NODES */
	for selected_node in selected_nodes where selected_node.parent != undefined and isGroupHead selected_node.parent do setGroupOpen selected_node.parent true

	select selected_nodes

	selectExportNodeInListCallbactAdd()

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


/*
	NODELIST DOUBLE CLICK

*/
macroscript	_export_isolate_node_objects
category:	"_Export"
buttontext:	"Nodes"
toolTip:	"Isolate node children\n\nCtrl+LMB: Select node children."
icon:	"control:multilistbox|across:2|event:#doubleClicked"
(
	--clearListener(); print("Cleared in:\n"+getSourceFileName())
	--format "EventFired	= % \n" EventFired

	--print "DOUBLECLICKED"
	--format "eventFired	= % \n" eventFired

	LayersManager 	= LayersManager_v()

	all_children	= #()
	default_Layer	= LayerManager.getLayerFromName "0"

	selectExportNodeInListCallbackRemove()

	selected_nodes = for obj in selection where classOf obj == Export_Node collect obj

	/* OPEN PARENT GROUPS OF SELECTEDS NODES */
	for selected_node in selected_nodes where selected_node.parent != undefined and isGroupHead selected_node.parent do setGroupOpen selected_node.parent true

	/* GET ALL CHILDREN OF NODES */
	for selected_node in selected_nodes do all_children += (selected_node.getAllChildren())
	--format "\n-----------\nARRAY:selected_nodes:\n";  for selected_node in selected_nodes do format "selected_node:	%\n" selected_node.name

	nodes_and_objects = all_children + selected_nodes + (LayersManager.getObjectsInLayers(default_Layer))

	layers_of_objects = LayersManager.getLayersByObjects( nodes_and_objects  )

	--format "\n-----------\nARRAY:layers_of_objects:\n";  for layer in layers_of_objects do format "layer:	%\n" layer.name

	/* SHOW LAYERS OF NODES CHILDREN */
	LayersManager.setVisibility (layers_of_objects) (true)

	/* UNHIDE DEFAULT LAYER - Printer Dummy for 3d print is there */
	--LayersManager.setVisibility(default_Layer)(true)

	/* SHOW OBLY OBJECTS OF NODES */
	for obj in nodes_and_objects do
		obj.isHidden = false


	clearSelection()

	max tool zoomextents all


	/* ISOLATE NODES AND OBJECTS IF NEEDED */
	IsolateSelection.ExitIsolateSelectionMode()

	not_hidden_other_objects = for obj in objects where obj.isHidden == false and findItem nodes_and_objects obj == 0 collect obj

	if not_hidden_other_objects.count > 0 then
	(
		select ( nodes_and_objects )

		IsolateSelection.EnterIsolateSelectionMode()
	)

	select selected_nodes

	/* ENABLE CALLBACK */
	selectExportNodeInListCallbactAdd()

)

/**  SELECT GROUPS OF NODES
 */
macroscript	_export_nodes_groups_list_select
category:	"_Export"
buttontext:	"Node Groups"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2|event:#selectionEnd|height:9|width:160|offset:[ 0, 8 ]"
--icon:	"control:multilistbox|across:2|items:#('1','2')" -- DEV
(
	--clearListener()
	--format "eventFired	= % \n" eventFired
	--format "eventFired.Control.items	= % \n" eventFired.Control.items
	--format "eventFired.Control.selection	= % \n" (eventFired.Control.selection as array )

	selected_groups = #()

	all_groups = makeUniqueArray( for obj in shapes where classOf obj == Export_Node and obj.parent != undefined and isGroupHead obj.parent collect  obj.parent)

	group_names_in_selection = for index in eventFired.Control.selection as Array collect eventFired.Control.items[index]

	selected_groups = for _group in all_groups where findItem group_names_in_selection _group.name > 0 collect _group

	select selected_groups
)


/**  NODE GROUPS LIST
 */
macroscript	_export_nodes_groups_list_isolate
category:	"_Export"
buttontext:	"Node Groups"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|event:#doubleClicked"
(
	selected_groups = #()

	all_groups = makeUniqueArray( for obj in shapes where classOf obj == Export_Node and obj.parent != undefined and isGroupHead obj.parent collect  obj.parent)

	group_names_in_selection = for index in eventFired.Control.selection as Array collect eventFired.Control.items[index]

	for _group in all_groups where findItem group_names_in_selection _group.name > 0 do
	(
		selectmore _group

		selectmore _group.children

		append selected_groups _group
	)

	macros.run "_Export" "_export_isolate_node_objects"

	--select selected_groups
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
