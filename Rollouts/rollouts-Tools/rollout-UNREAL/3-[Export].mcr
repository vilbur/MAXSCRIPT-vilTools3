filein( getFilenamePath(getSourceFileName()) + "/Lib/NodeList/NodeList.ms" )


/*------------------------------------------------------------------------------

	NODES GROUPBOX

------------------------------------------------------------------------------*/
--
--/**  GROUPBOX
-- */
--macroscript	_unreal_export_group
--category:	"_Unreal"
----buttontext:	"SetupGroup"
----toolTip:	"Create Export Node"
----icon:	"control:Groupbox|across:2"
--buttontext:	"Nodes"
--icon:	"control:Groupbox|id:test_groupbox_x|across:2"
--(
--)

/**  CREATE EXPORT NODE
 */
macroscript	_unreal_export_node_create
category:	"_Unreal"
buttontext:	"Create"
toolTip:	"Create Export Node\n\nNode name is asset name\n\nUser props of node caontain export dir and materials dir\n\nGroups are attached into objects if their name IS NOT UPPERCASE"
--icon:	"Groupbox:Nodes"
icon:	"across:5|width:64"
(
	ExportNode 	= ExportNode_v()

	ExportNode.create()
)

/**  LINK TO NODE
 */
macroscript	_unreal_export_node_link_selection
category:	"_Unreal"
buttontext:	"Link"
toolTip:	"Link selected objects to selected nod"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(
	_nodes =  ((NodeList_v(unreal.nodes)).getSelectedNodes())

	if( _nodes.count > 0 ) then
		for obj in selection do obj.parent = _nodes[1]

)


/**  LOAD
 */
macroscript	_unreal_export_node_load
category:	"_Unreal"
buttontext:	"Load"
toolTip:	"Load nodes to list"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(
	--select ((NodeList_v(unreal.nodes)).getSelectedNodes())

	(NodeList_v(unreal.nodes)).loadNodes()
	--ExportNode 	= ExportNode_v()

	--ExportNode.create()
)


/**
 */
macroscript	_unreal_preexport
category:	"_Unreal"
buttontext:	"Pre Export"
toolTip:	"Save Eported nodes as separated max files in export folder"
--icon:	""
(
	clearListener()

	selected_nodes =  ((NodeList_v(unreal.nodes)).getSelectedNodes())

	format "selected_nodes	= % \n" selected_nodes

	if( selected_nodes.count > 0 ) then
		with redraw off
			(ExporterDatasmith_v export_nodes:selected_nodes).export pre_export:true
	else
		messageBox "Export node is not selected" title:"Export node error"


	redrawViews()
)




/*------------------------------------------------------------------------------
	PRE-EXPORT TEST
--------------------------------------------------------------------------------*/


/**
 */
macroscript	_unreal_export_test
category:	"_Unreal"
buttontext:	"Test"
toolTip:	"Export selected nodes to files"
--icon:	"Groupbox:Nodes|height:64"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.BROWSEPATH_Export_Dir.text +"\"")
	clearListener()

	filein( @"c:\scripts\vilTools3\Rollouts\rollouts-Unreal-Engine\rollout-UNREAL\Lib\ExporterDatasmith\ExportChecker\ExportChecker.ms" ) -- DEV

	selected_nodes =  ((NodeList_v(unreal.nodes)).getSelectedNodes())

	format "selected_nodes	= % \n" selected_nodes

	if( selected_nodes.count > 0 ) then
		(ExportChecker_v export_nodes:selected_nodes).test()
	else
		messageBox "Export node is not selected" title:"Export node error"

)


/*==============================================================================

		NODELIST

================================================================================*/

/**  NODE LIST
 */
macroscript	_unreal_export_nodes_list
category:	"_Unreal"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2"
(
	selected_nodes =  ((NodeList_v(unreal.nodes)).getSelectedNodes())

	/** Fillpaths
	 */
	function fillpaths _control prop_name =
	(
		--format "\n"; print ".fillpaths()"
		paths = for _node in selected_nodes where ( export_dir = getUserProp _node prop_name) != undefined collect export_dir
		--format "paths[1]	= % \n" paths[1]
		if( paths[1] != undefined ) then
			_control.text = paths[1]

		else	if( ( export_dir = _control.text ) != "" ) then
			for _node in selected_nodes do setUserProp _node prop_name  export_dir
	)

	fillpaths EventFired.Roll.export_Dir	"export-dir"
	fillpaths EventFired.Roll.materials_Dir	"materials-dir"

	macros.run "_Unreal" "_unreal_load_materials"

	select selected_nodes
)


/*------ NODELIST DOUBLE CLICK ------*/

macroscript	_unreal_export_nodes_list_doubleclick
category:	"_Unreal"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2"
(
	--messageBox "Doubleclick" title:"Title"  beep:false
	--format "EventFired	= % \n" EventFired
	selected_nodes =  ((NodeList_v(unreal.nodes)).getSelectedNodes())

	select ((ExporterDatasmith_v export_nodes:selected_nodes).selectChildNodes())

)


/*------ NODELIST RIGHT CLICK ------*/
macroscript	_unreal_export_nodes_list_righclick
category:	"_Unreal"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2"
(
	messageBox "Rightclick" title:"Title"  beep:false
)



/*==============================================================================

		EXPORT BUTTON

================================================================================*/

macroscript	_unreal_export
category:	"_Unreal"
buttontext:	"Export"
toolTip:	"Export selected nodes to files"
icon:	"height:64|across:2|offset:[0,16]"
--icon:	"Groupbox:Nodes|height:64"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.BROWSEPATH_Export_Dir.text +"\"")
	clearListener()

	selected_nodes =  ((NodeList_v(unreal.nodes)).getSelectedNodes())

	format "selected_nodes	= % \n" selected_nodes

	if( selected_nodes.count > 0 ) then
		with redraw off
			(ExporterDatasmith_v export_nodes:selected_nodes).export()
	else
		messageBox "Export node is not selected" title:"Export node error"


	redrawViews()
)


/**  #righclick
 */
macroscript	_unreal_export_open_dir
category:	"_Unreal"
buttontext:	"Export"
toolTip:	"Open export folder"
--icon:	"Groupbox:Nodes|height:64"
(
	export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	DosCommand ("explorer \""+export_dir+"\"")

)
