/**
  *
  *	USES: "./../../Lib/ExporterSetup/ExporterSetup.ms"
  */


/**  #righclick
 */
macroscript	_export_print_open_in_label
category:	"_Export"
buttontext:	"Open In Program"
toolTip:	"Open export file in chitubox after export"
icon:	"control:label|across:2|offset:[ -32, 0 ]"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	--DosCommand ("explorer \""+export_dir+"\"")
	--format "EventFired	= % \n" EventFired

)

/**  #righclick
 */
macroscript	_export_print_open_in_program
category:	"_Export"
buttontext:	"[Open In Program]"
toolTip:	"Open export file in chitubox after export"
icon:	"control:radiobuttons|across:2|items:#('Chitubox', 'LycheSlicer')|columns:2|offset:[ -64, 0 ]"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	--DosCommand ("explorer \""+export_dir+"\"")
	--format "EventFired	= % \n" EventFired

)


/*==============================================================================

		CHECKBOXES

================================================================================*/

/**
  *
  */
macroscript	_export_fixed_position
category:	"_Export"
buttontext:	"Fix Position"
toolTip:	"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
icon:	"control:checkbox|across:1"
(
	--format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)



/**
  *
  */
macroscript	_export_open_in_final_file
category:	"_Export"
buttontext:	"Project File Open"
--toolTip:	"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
icon:	"control:checkbox|across:1"
(
	--format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)




/*==============================================================================

		BUTTONS

================================================================================*/


/*------------------------------------------------------------------------------
	EXPORT
--------------------------------------------------------------------------------*/
/**
  *
  */
macroscript	_export_print
category:	"_Export"
buttontext:	"Export"
toolTip:	"Export selected nodes to files"
icon:	"height:64|across:3"
--icon:	"Groupbox:Nodes|height:64"
(
	clearListener()

	(ExporterSetup_v(#Print)).export()
)

/*------------------------------------------------------------------------------
	PRINTER DUMMY
--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript	_export_print_create_plane
category:	"_Export"
buttontext:	"Print Dummy"
toolTip:	"Create\Delete dummy palne of 3D printer plane"
icon:	"height:64|across:3"
(
	--format "EventFired	= % \n" EventFired
	(PrinterVolume_v()).createVolume(#Rectangle)(ROLLOUT_export.SPIN_export_size.value)
)



/**
  *
  */
macroscript	_export_print_create_volume
category:	"_Export"
buttontext:	"Print Dummy"
toolTip:	"Create\Delete dummy of 3D printer volume"
--icon:	"across:3"
(
	--format "EventFired	= % \n" EventFired
	(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)

/*------------------------------------------------------------------------------
	OPEN FILE
--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript	_export_print_open_exported_files
category:	"_Export"
buttontext:	"Open Files"
toolTip:	"Open exported files of selected nodes"
icon:	"height:64|across:3"
(
	--format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#Rectangle)(ROLLOUT_export.SPIN_export_size.value)

	selected_nodes = ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())

	PrintExporter = PrintExporter_v()

	PrintExporter.params[#OPEN_IN]	= ROLLOUT_export.ExportTo.ROLLOUT_3d_print.RB_open_in_program.state
	PrintExporter.params[#SUBDIR_BY_NODE]	= ROLLOUT_export.CBX_sub_directory_by_node_name.checked


	if selected_nodes.count > 0 then
	(
		export_paths	= for selected_node in selected_nodes collect PrintExporter.getExportFilePath (selected_node)
		format "export_paths	= % \n" export_paths
		PrintExporter.openInProgram(export_paths)
	)

)
