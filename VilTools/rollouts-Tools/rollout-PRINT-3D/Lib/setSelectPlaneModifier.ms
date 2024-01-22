
/** Data callback
  *
  */
function toggleLayerHudCallback =
(
	--format "\n"; print "ViewportHudTest.ms.toggleLayerHudCallback()"
	HUD_DATA[#CALLBACK_DATA].Rows[1].Columns[1].text = ((timestamp() / 1000) as string )
)



/** setSelectPlaneModifier
  *
  */
function setSelectPlaneModifier layer_index  =
(


	if $SELECT_PLANE_HELPER == undefined then
		(PrinterVolume_v( ROLLOUT_export.SPIN_export_size.value ) ( ROLLOUT_print_3d.SPIN_layer_height.value )).createVolume(#RECTANGLE)

	$SELECT_PLANE_HELPER.pos.z = layer_index

)