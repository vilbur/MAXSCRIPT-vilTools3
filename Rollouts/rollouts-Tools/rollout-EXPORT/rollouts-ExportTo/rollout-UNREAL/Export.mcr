
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

	selected_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodes())

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


/*------------------------------------------------------------------------------

	EXPORT PATH

------------------------------------------------------------------------------*/



--/**
-- */
--macroscript	_unreal_export_dir
--category:	"_Unreal"
--buttontext:	"[Export Dir]"
----toolTip:	"Create Export Node"
--icon:	"control:BrowsePath|ini:false|across:1"
----icon:	"control:BrowsePath|across:1|initialDir:c:\\Users\\%USERNAME%\\Documents\\Unreal Projects"
--(
--	--messageBox "Yupiii" title:"Title"  beep:false
--
--	format "EventFired	= % \n" EventFired
--
--	--for _node in (NodeList_v()).getSelectedNodes() do
--	--(
--	--	setUserProp _node "export-dir" EventFired.val
--	--)
--
--)

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
