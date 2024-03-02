/*------------------------------------------------------------------------------

	RADIOBUTTONS

--------------------------------------------------------------------------------*/

/**  Export format
  *
 */
macroscript	_export_print_open_in_program
category:	"_Export"
buttontext:	"Export format"
toolTip:	"Open export file in chitubox after export"
icon:	"control:radiobuttons|across:2|items:#('obj', 'stl')|columns:2|offset:[ -4, 0 ]"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	--DosCommand ("explorer \""+export_dir+"\"")
	--format "EventFired	= % \n" EventFired
)

/**  #righclick
  * IMPORTANT: SORT ORDER OF ITEMS MUST BE SAME AS IN PrintExporter_v.open_in_programs
 */
macroscript	_export_print_open_in_program
category:	"_Export"
buttontext:	"Open In Program"
toolTip:	"Open export file in chitubox after export"
icon:	"control:radiobuttons|across:2|items:#('Chitubox', 'LycheSlicer')|columns:2|offset:[ -32, 0 ]"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	--DosCommand ("explorer \""+export_dir+"\"")
	format "EventFired	= % \n" EventFired

	/* SET EXPORT FORMAT TO STL IF LycheSlicer is used (LycheSlicer import holes in *.obj files ) */
	if EventFired.val == 2 then
		ROLLOUT_export.ExportTo.ROLLOUT_3d_print.RB_export_format.state = 2
)

/*------------------------------------------------------------------------------

	CHECKBOXEX

--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript	_export_open_in_final_file
category:	"_Export"
buttontext:	"Project File Open"
--toolTip:	"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
icon:	"control:checkbox|across:2|offset:[ 12, 2 ]"
(
	--format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)

/**
  *
  */
macroscript	_export_open_in_close_instances
category:	"_Export"
buttontext:	"Single Instance"
toolTip:	"Close other instances of open in program"
icon:	"control:checkbox|across:2|offset:[ 0, 2 ]"
(
	format "EventFired	= % \n" EventFired

	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)
