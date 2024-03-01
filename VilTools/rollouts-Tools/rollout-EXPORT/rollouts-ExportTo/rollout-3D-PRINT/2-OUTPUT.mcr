/**  Export format
  *
 */
macroscript	_export_print_open_in_program
category:	"_Export"
buttontext:	"Export format"
toolTip:	"Open export file in chitubox after export"
icon:	"control:radiobuttons|across:2|items:#('obj', 'stl')|columns:2|offset:[ -16, 0 ]"
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
icon:	"control:radiobuttons|across:2|items:#('Chitubox', 'LycheSlicer')|columns:2|offset:[ -48, 0 ]"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	--DosCommand ("explorer \""+export_dir+"\"")
	format "EventFired	= % \n" EventFired

	/* SET EXPORT FORMAT TO STL IF LycheSlicer is used (LycheSlicer import holes in *.obj files ) */
	if EventFired.val == 2 then
		ROLLOUT_export.ExportTo.ROLLOUT_3d_print.RB_export_format.state = 2
)
