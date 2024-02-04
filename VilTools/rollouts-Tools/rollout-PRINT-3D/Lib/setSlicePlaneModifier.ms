/** Set slice plane modifier
  *
  * @param int|float layer_index_or_z_pos position where slice plane is elevated
  *		1) FLOAT:	z pozition in world units
  *		2) INTEGER:	index of print layer
  *
  */
function setSlicePlaneModifier mode state layer_index_or_z_pos cap_state =
(
	--format "\n"; print ("setSlicePlaneModifier.ms.setSlicePlaneModifier( #"+mode as string +" )")

	slice_mod = PRINT_SLICE_MODIFIERS[#SLICE_PLANE_TOP]

	z_pos = if classOf layer_index_or_z_pos == integer then getPlaneZpozition (layer_index_or_z_pos) else layer_index_or_z_pos

	pos01 = [ 0,	0,	z_pos ]
	pos02 = [ 10,	0,	z_pos ]
	pos03 = [ 0,	10,	z_pos ]

	local vect1 = normalize (pos02 - pos01)
	local vect2 = normalize (pos03 - pos02)
	local vect3 = normalize (cross vect2 vect1)

	vect2 = cross vect3 vect1


	slice_matrix = ( Matrix3 vect1 vect2 vect3 ((pos01 + pos02 + pos03) / 3) )

	slice_mod.slice_plane.transform = slice_matrix

	/* SET CAP STATE */
	slice_mod.cap = cap_state
)
