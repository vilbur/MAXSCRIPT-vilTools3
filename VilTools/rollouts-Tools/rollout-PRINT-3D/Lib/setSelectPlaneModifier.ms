


/** setSelectPlaneModifier
  *
  */
function setSelectPlaneModifier layer_index  =
(
	--format "\n"; print "setSelectPlaneModifier.ms.setSelectPlaneModifier()"
	--format "layer_index	= % \n" layer_index
	--format "layer_height	= % \n" ROLLOUT_print_3d.SPIN_layer_height.value
	--format "classOf SPIN_export_size	= % \n" (classOf ROLLOUT_export.SPIN_export_size.value)
	--format "classOf layer_height	= % \n" (classOf ROLLOUT_print_3d.SPIN_layer_height.value)

	objects_to_slice	= for obj in selection where superClassOf obj == GeometryClass collect obj

	if objects_to_slice.count == 0 then
		return false


	/* CREATE PRINT PLANE OBJECT HELPER - used as node for Volume Select modifier */
	if $PRINT_DUMMY_VOLUME == undefined then
		printerVolumeAdd(#RECTANGLE)


	if $PRINT_DUMMY_VOLUME.modifiers[#LAYER_HEIGHT] == undefined then
		addModifier $PRINT_DUMMY_VOLUME (Shell name:"LAYER HEIGHT" innerAmount: ROLLOUT_print_3d.SPIN_layer_height.value)


	/* CREATE NEW Volume Select modifier */
	vol_select_mod = Vol__Select name:"SELECT BY PRINT LAYER" level:1 volume:3 --node:$PRINT_DUMMY_VOLUME  -- ADDING NODE ON MODIFIER INIT CAUSES ERROR


	/* ADD MODIFIER WHERE IS NOT ALREADY */
	objs_without_mod = for obj in objects_to_slice where obj.modifiers[#SELECT_BY_PRINT_LAYER] == undefined collect obj

	if objs_without_mod.count > 0 then
		addModifier objs_without_mod vol_select_mod


	/* SET PALNE AS SELECT BY OBJECT */
	--for obj in objects_to_slice where obj.modifiers[#SELECT_BY_PRINT_LAYER] != undefined do
	for obj in objects_to_slice where obj.modifiers[#SELECT_BY_PRINT_LAYER].node != $PRINT_DUMMY_VOLUME do
		obj.modifiers[#SELECT_BY_PRINT_LAYER].node = $PRINT_DUMMY_VOLUME -- adding node on modifier init causes error


	/* SET Z POSITION OF PRINT PLANE */
	$PRINT_DUMMY_VOLUME.pos.z = getPlaneZpozition(layer_index)
)