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
macroscript	_print_create_print_volume
category:	"_Export"
buttontext:	"Print Volume"
toolTip:	"Create\Delete dummy object of 3D printer volume"
icon:	"across:2"
--icon:	"Groupbox:Nodes|height:64"
(
	--format "EventFired	= % \n" EventFired
	dummy_name = "print_volume_dummy"

	if (dummy_object = getNodeByName dummy_name) == undefined then
	(
		print_volume_size = case units.SystemType of
		(
			#Millimeters:	[ 120, 192, 250 ]
			#Centimeters:	[ 12, 19.2, 25 ]
			#Meters:	[ 0.12, 0.192, 0.250 ]
		)

		if (export_size = ROLLOUT_export.SPIN_export_size.value) != 1 then
			print_volume_size = print_volume_size / export_size

		dummy_object = Box name:dummy_name length:print_volume_size[1] width:print_volume_size[2] height:print_volume_size[3] xray:true

		(LayerManager.getLayerFromName( "0")).addNode dummy_object

	)
	else
		delete dummy_object

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
