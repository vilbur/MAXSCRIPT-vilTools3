
/** Set print elevation
  *
  */
function getPlaneZpozition layer_index =
(
	--format "\n"; print "PRINTER DUMMY.mcr.setPrintElevation()"


	volume_height	= (PrinterVolume_v(ROLLOUT_export.SPIN_export_size.value)).printer_size.z
	layer_height	= ROLLOUT_print_3d.SPIN_layer_height.value
	layer_current	= DIALOG_elevation_slider.SLIDER_elevation.value
	layers_count	= volume_height / layer_height

	--if incremental then
		--layer_index = layer_current + layer_index

	--format "volume_height:	% \n" volume_height
	--format "layer_height:	% \n" layer_height
	--format "layers_count:	% \n" layers_count

	if layer_index < 0 or layer_index > layers_count then
		layer_index = 	if layer_index < 0  then 0 else layers_count


	--if $SELECT_PLANE_HELPER == undefined then
		--(PrinterVolume_v( ROLLOUT_export.SPIN_export_size.value ) ( ROLLOUT_print_3d.SPIN_layer_height.value )).createVolume(#RECTANGLE)

	--$SELECT_PLANE_HELPER.pos.z = layer_index * layer_height



	layer_index * layer_height --return z poz

)

/** Set slice plane modifier
  *
  */
function setSlicePlaneModifier mode state layer_index cap_state =
(
	format "\n"; print "setSlicePlaneModifier.ms.setSlicePlaneModifier()"
	--format "state:	% \n" state
	--format "mode:	% \n" mode

	if selection.count == 0 then
		return false

	z_pos = getPlaneZpozition (layer_index)

	--format "z_pos:	% \n" z_pos

	mod_name = "SLICE PLANE " + toUpper (mode as string )

	objects_to_slice	= for obj in selection where superClassOf obj == GeometryClass collect obj

	obj = selection[1]

	if ( _poly_select = obj.modifiers[ #SELECT_SLICE ] ) != undefined then
		_poly_select.enabled = false

	slice_mod = if ( _modifier = obj.modifiers[ mod_name as name ] ) != undefined then
		_modifier
	else
		 SliceModifier name:mod_name cap:cap_state Faces___Polygons_Toggle:1 Slice_Type:(if mode == #TOP then 3 else 2)

	/* SLICE MODIFIER SETUP */

	select objects_to_slice

	modPanel.addModToSelection slice_mod



	/* SET SLICE PLANE POSITION */
	pos01 = [ selection.center.x,	selection.center.y,	z_pos ]
	pos02 = [ selection.center.x+10,	selection.center.y,	z_pos ]
	pos03 = [ selection.center.x,	selection.center.y+10,	z_pos ]

	local vect1 = normalize (pos02 - pos01)
	local vect2 = normalize (pos03 - pos02)
	local vect3 = normalize (cross vect2 vect1)

	vect2 = cross vect3 vect1


	objTM = obj.objectTransform

	max modify mode

	if ( modTM = getModContextTM obj slice_mod ) != undefined then
	(
		--modTM = getModContextTM obj slice_mod
	   tempMatrix = ((matrix3 vect1 vect2 vect3 ((pos01 + pos02 + pos03) / 3) )) * modTM * (inverse objTM)

	   slice_mod.slice_plane.transform = tempMatrix


	)


	(

		if ( _poly_select = obj.modifiers[ #SELECT_SLICE ] ) != undefined then
		(
			_poly_select.enabled = true


			subobjectLevel = 1
		)
	)
	   redrawViews()


)















