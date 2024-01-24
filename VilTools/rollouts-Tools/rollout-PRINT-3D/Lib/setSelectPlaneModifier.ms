


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

	/** Select is not above slice modifier
	 */
	function selectIsNotFirst obj =
	(
		--format "\n"; print ".selectIsNotFirst()"
		--format "objs_without_mod	= % \n" objs_without_mod

		mod_names = #( "SELECT BY PRINT LAYER", "SLICE PLANE TOP", "SLICE PLANE BOTTOM" )

		if  obj.modifiers[#SELECT_BY_PRINT_LAYER] != undefined then
		(
			--for i = 1 to obj.modifiers.count do
				--format "mod_name	= % \n" (obj.modifiers[i].name as name)

			mods = for i = 1 to obj.modifiers.count where findItem mod_names (obj.modifiers[i].name ) > 0 collect obj.modifiers[i].name
			--format "mods	= % \n" mods
			--format "findItem mods #SELECT_BY_PRINT_LAYER	= % \n" (findItem mods "SELECT BY PRINT LAYER")

			findItem mods "SELECT BY PRINT LAYER" != 1 --return
		)
		else
			false --return
	)

	layer_height = ROLLOUT_print_3d.SPIN_layer_height.value

	_objects	= for obj in selection where superClassOf obj == GeometryClass collect obj

	if _objects.count == 0 then
		return false

	/*------------------------------------------------------------------------------
		CONFIG SELECT DUMMY OBJECT
	--------------------------------------------------------------------------------*/
	/* CREATE PRINT PLANE OBJECT HELPER - used as node for Volume Select modifier */
	if $SELECT_BY_PRINT_LAYER == undefined then
		(PrinterVolume_v dummy_name:"SELECT BY PRINT LAYER" export_size:ROLLOUT_export.SPIN_export_size.value volume_height:ROLLOUT_print_3d.SPIN_layer_height.value ).createVolume(#RECTANGLE)


	$SELECT_BY_PRINT_LAYER.wirecolor = gray


	if $SELECT_BY_PRINT_LAYER.modifiers[#LAYER_HEIGHT] == undefined then
		addModifier $SELECT_BY_PRINT_LAYER (Shell name:"LAYER HEIGHT" innerAmount:layer_height )
	else
		$SELECT_BY_PRINT_LAYER.modifiers[#LAYER_HEIGHT].innerAmount = layer_height



	/* CREATE NEW Volume Select modifier */
	vol_select_mod = Vol__Select name:"SELECT BY PRINT LAYER" level:1 volume:3 --node:$SELECT_BY_PRINT_LAYER  -- ADDING NODE ON MODIFIER INIT CAUSES ERROR

	for obj in _objects where selectIsNotFirst(obj) do
	(
		format "DELETE MODIFIER	= % \n" obj.name
		deleteModifier obj obj.modifiers[#SELECT_BY_PRINT_LAYER]
	)


	/* ADD MODIFIER WHERE IS NOT ALREADY */
	objs_without_mod = for obj in _objects where obj.modifiers[#SELECT_BY_PRINT_LAYER] == undefined collect obj
	--format "objs_without_mod	= % \n" objs_without_mod

	if objs_without_mod.count > 0 then
	(
		format "ADD MODIFIER	= % \n" objs_without_mod

		addModifier objs_without_mod vol_select_mod
	)


	/* SET PALNE AS SELECT BY OBJECT */
	--for obj in _objects where obj.modifiers[#SELECT_BY_PRINT_LAYER] != undefined do
	for obj in _objects where obj.modifiers[#SELECT_BY_PRINT_LAYER].node != $SELECT_BY_PRINT_LAYER do
	(
		print "SET NODE"

		obj.modifiers[#SELECT_BY_PRINT_LAYER].node = $SELECT_BY_PRINT_LAYER -- adding node on modifier init causes error
	)


	/* SET Z POSITION OF PRINT PLANE */
	$SELECT_BY_PRINT_LAYER.pos.z = getPlaneZpozition(layer_index)
)