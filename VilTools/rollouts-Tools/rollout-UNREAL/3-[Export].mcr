/*------------------------------------------------------------------------------
  
	NODES GROUPBOX
	
------------------------------------------------------------------------------*/

/**  GROUPBOX
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

/**  LOAD
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

/**  CREATE NODE
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

/**  EXPORT
 */
macroscript	_unreal_export
category:	"_Unreal"
buttontext:	"Export"
toolTip:	"Export Fbx file"
icon:	"Groupbox:Nodes|height:64"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.BROWSEPATH_Export_Dir.text +"\"")
	selected_nodes =  ((NodeList_v()).getSelectedNodes())
	
	if( selected_nodes.count == 0 ) then
		return false
		
	holdMaxFile() 

		
	--export_paths = for _node in selected_nodes where ( export_dir = getUserProp _node "export-dir") != undefined collect export_dir
	
	try
	(
		for _node in selected_nodes where ( export_dir = getUserProp _node "export-dir") != undefined do 
		(
			Exporter = ExporterFbx_v export_dir:export_dir
			
			Exporter.loadPreset()
			
			Exporter.epxort (_node)	
		)
		
		
	)
	catch(
		messageBox "Export Failed" title:"Title"  beep:false
		
	)
	
	fetchMaxFile quiet:true

	--format "export_paths	= % \n" export_paths
	--format "export_dir	= % \n" export_dir
)

/**  EXPORT #righclick 
 */
macroscript	_unreal_export_open_dir
category:	"_Unreal"
buttontext:	"Export"
toolTip:	"Open export folder"
--icon:	"Groupbox:Nodes|height:64"
(
	export_dir = execute ("@"+ "\""+EventFired.Roll.BROWSEPATH_Export_Dir.text +"\"")
	
	DosCommand ("explorer \""+export_dir+"\"")

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
	selected_nodes =  ((NodeList_v()).getSelectedNodes())
	
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
	
	fillpaths EventFired.Roll.BROWSEPATH_Export_Dir	"export-dir"
	fillpaths EventFired.Roll.BROWSEPATH_Materials_Dir	"materials-dir"
	
	macros.run "_Unreal" "_unreal_load_materials"
	
	select selected_nodes
)

















