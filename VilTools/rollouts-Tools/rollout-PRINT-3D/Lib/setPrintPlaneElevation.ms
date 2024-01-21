
/** Data callback
  *
  */
function toggleLayerHudCallback =
(
	--format "\n"; print "ViewportHudTest.ms.toggleLayerHudCallback()"
	HUD_DATA[#CALLBACK_DATA].Rows[1].Columns[1].text = ((timestamp() / 1000) as string )
)



/** Set print elevation
  *
  */
function setPrintPlaneElevation layer_index incremental:false =
(
	--format "\n"; print "PRINTER DUMMY.mcr.setPrintElevation()"

	--format "layer_index:	% \n" layer_index

	function showLayerHud layer_index =
	(
		--format "\n"; print "PRINTER DUMMY.mcr.showLayerHud()"
		unregisterRedrawViewsCallback viewportHudCallback

		HUD = Hud_v pos:#( #RIGHT,	#CENTER ) offset:[ 64, 0 ]

		HUD.row ( layer_index as string )

		HUD_DATA[#SLICE_LAYER_CURRENT] = HUD

		registerRedrawViewsCallback viewportHudCallback

	)


	volume_height	= (PrinterVolume_v(ROLLOUT_export.SPIN_export_size.value)).printer_size.z
	layer_height	= ROLLOUT_print_3d.SPIN_layer_height.value
	layer_current	= DIALOG_elevation_slider.SLIDER_elevation.value
	layers_count	= volume_height / layer_height

	--format "layer_current:	% \n" layer_current

	if incremental then
		layer_index = layer_current + layer_index

	--if layer_index < 0 or layer_index > layers_count then
		--layer_index = 	if layer_index < 0  then 0 else layers_count


	------if $SELECT_PLANE_HELPER == undefined then
	------	(PrinterVolume_v( ROLLOUT_export.SPIN_export_size.value ) ( ROLLOUT_print_3d.SPIN_layer_height.value )).createVolume(#RECTANGLE)
	------
	------
	------$SELECT_PLANE_HELPER.pos.z = layer_index * layer_height


	cap_slice_plane = ROLLOUT_print_3d.CBX_cap_slice.state



	if ROLLOUT_print_3d.CBX_slice_top.state then
		setSlicePlaneModifier (#TOP) (#TRUE) (layer_index) (cap_slice_plane)

	if ROLLOUT_print_3d.CBX_slice_bottom.state then
		setSlicePlaneModifier (#BOTTOM) (#TRUE) (layer_index - 1) (cap_slice_plane)



	/* UPDATE UI */
	ROLLOUT_print_3d.SPIN_current_layer.value	= layer_index
	DIALOG_elevation_slider.SPIN_layer_current.value	= layer_index
	DIALOG_elevation_slider.SLIDER_elevation.value	= layer_index

	--toggleLayerHudCallback #SLICE_ELEVATION data:"layer_index"

	showLayerHud(layer_index)

)