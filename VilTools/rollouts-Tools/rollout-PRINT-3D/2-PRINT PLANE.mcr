filein( getFilenamePath(getSourceFileName()) + "/../rollout-EXPORT/rollouts-ExportTo/rollout-3D-PRINT/Lib/PrinterVolume/PrinterVolume.ms" )	-- "./../rollout-EXPORT/rollouts-ExportTo/rollout-3D-PRINT/Lib/PrinterVolume/PrinterVolume.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/setSlicePlaneModifier.ms" )	-- "./Lib/setSlicePlaneModifier.ms"
/*------------------------------------------------------------------------------

	EDIT PRINT PLANE

--------------------------------------------------------------------------------*/

/** Set print elevation
  *
  */
function setPrintPlaneElevation layer_index incremental:false =
(
	format "\n"; print "PRINTER DUMMY.mcr.setPrintElevation()"

	format "layer_index:	% \n" layer_index

	--volume_height	= (PrinterVolume_v(ROLLOUT_export.SPIN_export_size.value)).printer_size.z
	layer_height	= ROLLOUT_print_3d.SPIN_layer_height.value
	layer_current	= ROLLOUT_print_3d.SLIDER_set_elevation.value
	--layers_count	= volume_height / layer_height

	format "layer_current:	% \n" layer_current

	if incremental then
		layer_index = layer_current + layer_index

	--format "volume_height:	% \n" volume_height
	--format "layer_height:	% \n" layer_height
	--format "layers_count:	% \n" layers_count
	--
	--if layer_index < 0 or layer_index > layers_count then
	--	layer_index = 	if layer_index < 0  then 0 else layers_count
	--
	--
	--if $SELECT_PLANE_HELPER == undefined then
	--	(PrinterVolume_v( ROLLOUT_export.SPIN_export_size.value ) ( ROLLOUT_print_3d.SPIN_layer_height.value )).createVolume(#RECTANGLE)
	--
	--
	--$SELECT_PLANE_HELPER.pos.z = layer_index * layer_height
	--
	--
	--ROLLOUT_print_3d.SPIN_current_layer.value	= layer_index
	--ROLLOUT_print_3d.SLIDER_set_elevation.value	= layer_index

	cap_slice_plane = ROLLOUT_print_3d.CBX_cap_slice.state

	if ROLLOUT_print_3d.CBX_slice_top.state then
		setSlicePlaneModifier (#TOP) (#TRUE) (layer_index) (cap_slice_plane)

	if ROLLOUT_print_3d.CBX_slice_bottom.state then
		setSlicePlaneModifier (#BOTTOM) (#TRUE) (layer_index - 1) (cap_slice_plane)



	/* UPDATE UI */
	ROLLOUT_print_3d.SPIN_current_layer.value	= layer_index
	ROLLOUT_print_3d.SLIDER_set_elevation.value	= layer_index

)


/*------------------------------------------------------------------------------

	 BUTTONS

--------------------------------------------------------------------------------*/

/** ELEVATION +\-
 */
macroscript	_print_plane_set_elevation_plus
category:	"_3D-Print"
buttontext:	"+\-"
toolTip:	"Shift plane UP"
icon:	"across:4|id:#BTN_print_plane_pos_increment|#height:32|width:64|align:#left|offset:[ -4, 0 ]"
(

	--format "EventFired	= % \n" EventFired
	--clearListener(); print("Cleared in:\n"+getSourceFileName())
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PRINTER DUMMY.mcr"

	val = if keyboard.controlPressed then 10 else 1

	setPrintPlaneElevation val incremental:true
)


/** ELEVATION +\- RIGHTCLICK
 */
macroscript	_print_plane_set_elevation_minus
category:	"_3D-Print"
buttontext:	"+\-"
toolTip:	"Shift plane DOWN\n\nCTRL: value is 10"
icon:	"across:4|id:#BTN_print_plane_pos_increment|#height:32|width:32|align:#left|offset:[ -4, 0 ]"
(

	--format "EventFired	= % \n" EventFired
	--clearListener(); print("Cleared in:\n"+getSourceFileName())
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PRINTER DUMMY.mcr"

	val = if keyboard.controlPressed then -10 else -1

	setPrintPlaneElevation val incremental:true
)


/** NORMAL BUTTON
 */
macroscript	_print_plane_set_normal
category:	"_3D-Print"
buttontext:	"Normal"
toolTip:	"Create\Unhide Plane\n\nToggle Normal if plane exists\n\nCTRL:	2-Sided\n\nSHIFT:	Xray\n\nALT:	Toggle Grey\Green"
icon:	"across:4|id:#BTN_print_plane_nomal|#height:32|width:42|align:#left|offset:[ -16, 0 ]"
(

	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PRINTER DUMMY.mcr"

	if $SELECT_PLANE_HELPER == undefined then
		(PrinterVolume_v(ROLLOUT_export.SPIN_export_size.value)).createVolume(#RECTANGLE)

	if not $SELECT_PLANE_HELPER.isHidden then
	(

		_plane = $SELECT_PLANE_HELPER

		normal_modifier = _plane.modifiers[#Normal]

		if not normal_modifier.enabled then
			normal_modifier.enabled = true

		if keyboard.controlPressed or keyboard.altPressed or keyboard.shiftPressed then
		(
			normal_modifier.enabled = true

			if keyboard.controlPressed then
				_plane.backfacecull = not ( _plane.backfacecull )

			if keyboard.shiftPressed then
				_plane.xray = not ( _plane.xray )

			if keyboard.altPressed then
				_plane.showFrozenInGray = not ( _plane.showFrozenInGray )


		)
		else
			normal_modifier.flip = not ( normal_modifier.flip )

	)
	else
	(
		$SELECT_PLANE_HELPER.layer.on = true
		$SELECT_PLANE_HELPER.isHidden = false
	)


)

/**
 */
macroscript	_print_plane_set_normal_rightclick
category:	"_3D-Print"
buttontext:	"Normal"
toolTip:	"Toggle Normnal"
icon:	"across:4|id:#BTN_print_plane_nomal"
(

	if $SELECT_PLANE_HELPER != undefined then
		$PRINT_DUMMY_VOLUME.modifiers[#Normal].enabled = not $PRINT_DUMMY_VOLUME.modifiers[#Normal].enabled
)


/*------------------------------------------------------------------------------

	SPINNERS

--------------------------------------------------------------------------------*/
/**
 */
macroscript	_print_plane_current_layer
category:	"_3D-Print"
buttontext:	"Current"
tooltip:	"Set Current Layer"
icon:	"across:4|control:spinner|id:#SPIN_current_layer|type:#integer|range:[ 0, 5000, 0 ]|fieldwidth:32|offset:[ -32, 8 ]|align:#left"
(
	--format "EventFired:	% \n" EventFired

	--ROLLOUT_print_3d.SLIDER_set_elevation.value = EventFired.val

	--macros.run "_3D-Print" "_print_plane_set_elevation"
	setPrintPlaneElevation (EventFired.val)
)

/**
 */
macroscript	_print_layer_height
category:	"_3D-Print"
buttontext:	"Layer Height"
tooltip:	"Height of printed layer in mm"
icon:	"across:4|control:spinner|fieldwidth:32|range:[ 0.03, 0.1, 0.05 ]|scale:0.01|offset:[ -16, 8 ]"
(
	format "EventFired:	% \n" EventFired
)





/*------------------------------------------------------------------------------

	SLIDER

--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript	_print_plane_set_elevation
category:	"_3D-Print"
buttontext:	"Set Elevation"
toolTip:	"Set Printer Plane Elevation"
icon:	"across:1|control:slider|orient:#horizontal|range:[ 0, 5000, 0 ]|ticks:5000|type:#integer"
(
	--clearListener(); print("Cleared in:\n"+getSourceFileName())
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\2-PRINT PLANE.mcr"

	--format "EventFired:	% \n" EventFired

	setPrintPlaneElevation (EventFired.val)


	--clearListener(); print("Cleared in:\n"+getSourceFileName())
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-EXPORT\rollouts-ExportTo\rollout-3D-PRINT\Lib\PrinterVolume\PrinterVolume.ms"
	--
	--(PrinterVolume_v(ROLLOUT_export.SPIN_export_size.value)).createVolume(#RECTANGLE)
)

/**
  *
  */
macroscript	_print_plane_set_elevation_rightclick
category:	"_3D-Print"
buttontext:	"Set Elevation"
toolTip:	"Reset plane to 0 on z Axis.\n\nDOUBLE RIGHTCLICK:Delete Plane"
--icon:	"control:slider|orient:#horizontal|across:1|range:[ 0, 5000, 0 ]|ticks:5000|type:#integer"
icon:	"control:slider"
(
	--clearListener(); print("Cleared in:\n"+getSourceFileName())
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\2-PRINT PLANE.mcr"

	/* SET LAYER 0 */
	if $SELECT_PLANE_HELPER != undefined and $SELECT_PLANE_HELPER.pos.z > 0 then
		setPrintPlaneElevation 0

	/* DELTE PLANE */
	else if $SELECT_PLANE_HELPER != undefined then
		delete $SELECT_PLANE_HELPER
)


/*------------------------------------------------------------------------------
	PRINTER DUMMY
--------------------------------------------------------------------------------*/

--/**
--  *
--  */
--macroscript	_print_dummy_create_plane
--category:	"_3D-Print"
--buttontext:	"Create Dummy"
--toolTip:	"Create\Delete dummy palne of 3D printer plane"
--icon:	"height:64|across:2"
--(
--
--	--format "EventFired	= % \n" EventFired
--	clearListener(); print("Cleared in:\n"+getSourceFileName())
--	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PRINTER DUMMY.mcr"
--
--	(PrinterVolume_v(ROLLOUT_export.SPIN_export_size.value)).createVolume(#RECTANGLE)
--)
--
--
--
--/**
--  *
--  */
--macroscript	_print_dummy_create_volume
--category:	"_3D-Print"
--buttontext:	"Create Dummy"
--toolTip:	"Create\Delete dummy of 3D printer volume"
----icon:	"across:3"
--(
--	--format "EventFired	= % \n" EventFired
--	(PrinterVolume_v(ROLLOUT_export.SPIN_export_size.value)).createVolume(#box)
--)
