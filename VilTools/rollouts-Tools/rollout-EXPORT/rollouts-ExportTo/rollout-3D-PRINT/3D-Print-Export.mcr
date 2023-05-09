/**  #righclick
 */
macroscript	_export_print_open_in_chitubox
category:	"_Export"
buttontext:	"[Open In Program]"
toolTip:	"Open export file in chitubox after export"
icon:	"control:radiobuttons|across:2|offset:[ 0, 0 ]|items:#('Chitubox', 'LycheSlicer')|columns:1"
(
	--export_dir = execute ("@"+ "\""+EventFired.Roll.export_dir.text +"\"")

	--DosCommand ("explorer \""+export_dir+"\"")
	--format "EventFired	= % \n" EventFired

)

/**
  *
  */
macroscript	_print_create_print_plane
category:	"_Export"
buttontext:	"Print Dummy"
toolTip:	"Create\Delete dummy palne of 3D printer plane"
icon:	"across:2"
(
	--format "EventFired	= % \n" EventFired
	(PrinterVolume_v()).createVolume(#Plane)(ROLLOUT_export.SPIN_export_size.value)
)

/**
  *
  */
macroscript	_print_create_print_volume
category:	"_Export"
buttontext:	"Print Dummy"
toolTip:	"Create\Delete dummy of 3D printer volume"
icon:	"across:2"
(
	--format "EventFired	= % \n" EventFired
	(PrinterVolume_v()).createVolume(#box)(ROLLOUT_export.SPIN_export_size.value)
)



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

	(ExporterSetup_v #Print).export()
)