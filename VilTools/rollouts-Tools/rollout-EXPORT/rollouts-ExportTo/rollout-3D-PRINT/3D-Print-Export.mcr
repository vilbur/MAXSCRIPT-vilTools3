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


/*------------------------------------------------------------------------------

	CHECKBOXES

--------------------------------------------------------------------------------*/


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
buttontext:	"Open In Final File"
--toolTip:	"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
icon:	"control:checkbox|across:1"
(
	--format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)


/*------------------------------------------------------------------------------

	BUTTONS

--------------------------------------------------------------------------------*/




/**
  *
  */
macroscript	_export_print
category:	"_Export"
buttontext:	"Export"
toolTip:	"Export selected nodes to files"
icon:	"height:64|across:2"
--icon:	"Groupbox:Nodes|height:64"
(
	clearListener()

	(ExporterSetup_v(#Print)).export()
)

/**
  *
  */
macroscript	_export_print_create_plane
category:	"_Export"
buttontext:	"Print Dummy"
toolTip:	"Create\Delete dummy palne of 3D printer plane"
icon:	"height:64|across:2"
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
--icon:	"across:2"
(
	--format "EventFired	= % \n" EventFired
	(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)
