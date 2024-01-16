

/*------------------------------------------------------------------------------



--------------------------------------------------------------------------------*/
macroscript	_print_select_by_plane
category:	"_3D-Print"
buttontext:	"Select By Plane"
tooltip:	"Use print plane to select verts by layer of current selected object"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Platforms" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-EDIT LAYERS.mcr"

			if $PRINT_DUMMY_VOLUME == undefined then
				(PrinterVolume_v( ROLLOUT_export.SPIN_export_size.value ) ( ROLLOUT_print_3d.SPIN_layer_height.value )).createVolume(#RECTANGLE)

			objects_to_slice	= for obj in selection where superClassOf obj == GeometryClass collect obj

			for obj in objects_to_slice where obj.modifiers[#SELECT_BY_PRINT_PLANE] != undefined do
				deleteModifier obj obj.modifiers[#SELECT_BY_PRINT_PLANE]

			format "$PRINT_DUMMY_VOLUME:	% \n" $PRINT_DUMMY_VOLUME

			vol_select_mod = Vol__Select name:"SELECT BY PRINT PLANE" level:1 volume:3 --node:$PRINT_DUMMY_VOLUME  -- adding node on modifier init causes error

			select objects_to_slice

			modPanel.addModToSelection vol_select_mod

			vol_select_mod.node = $PRINT_DUMMY_VOLUME -- adding node on modifier init causes error
		)
)





/**
  *
  */
macroscript	_print_select_by_plane_delete
category:	"_3D-Print"
buttontext:	"Select By Plane"
tooltip:	"Delete  modifier from objects"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Platforms" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-EDIT LAYERS.mcr"

			for obj in geometry where obj.modifiers[#SELECT_BY_PRINT_PLANE] != undefined do
				deleteModifier obj obj.modifiers[#SELECT_BY_PRINT_PLANE]

		)
)
