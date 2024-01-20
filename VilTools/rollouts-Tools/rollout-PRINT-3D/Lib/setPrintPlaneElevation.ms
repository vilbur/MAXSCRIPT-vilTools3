/** Set print elevation
  *
  */
function setPrintPlaneElevation layer_index incremental:false =
(
	format "\n"; print "PRINTER DUMMY.mcr.setPrintElevation()"

	format "layer_index:	% \n" layer_index

	--function showLayerHud layer_index =
	--(
	--	HUD = Hud_v()
	--
	--	HUD.defaults color:white width:48 height:24 -- Set Defaults to row and column
	--
	--	/* DEFINE ROW */
	--	Row_1 = HUD.row ( layer_index )
	--
	--	--Row_1.Column "Column 2" width:96
	--	--Row_1.Column "Column 3" color:yellow
	--	--
	--	--/* OTHER ROWS */
	--	--HUD.row ( "Row 2" ) color:red height:64
	--	--HUD.row ( "Row 3" ) color:red height:-32
	--
	--	/* ADD TO HUD DATA */
	--	HUD_DATA[#QUICK_ADD] = HUD
	--)

	/** Toggle hud callback
	  */
	function toggleLayerHudCallback hud_name data: =
	(
		--format "\n"; print "HUD.mcr.toggleHudCallbeack()"

		if data != unsupplied then
		(
			print ("HudCallback ON: #"+ hud_name as string )


			unregisterRedrawViewsCallback viewportHudCallback

			--HUD = Hud_v pos:#( #RIGHT,	#CENTER )
			HUD = Hud_v pos:#( #CENTER,	#CENTER )

			HUD.defaults color:white width:48 height:24 -- Set Defaults to row and column

			HUD_DATA[hud_name] = data


			registerRedrawViewsCallback viewportHudCallback
		)
		else
		(
			RemoveDictValue HUD_DATA hud_name

			--print ("HudCallback OFF: #"+ hud_name as string )

			if HUD_DATA.count == 0 then
			(
				unregisterRedrawViewsCallback viewportHudCallback

				--print "HudCallback DISABLE"
			)
		)
	)



	volume_height	= (PrinterVolume_v(ROLLOUT_export.SPIN_export_size.value)).printer_size.z
	layer_height	= ROLLOUT_print_3d.SPIN_layer_height.value
	layer_current	= DIALOG_elevation_slider.SLIDER_elevation.value
	layers_count	= volume_height / layer_height

	format "layer_current:	% \n" layer_current

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

)