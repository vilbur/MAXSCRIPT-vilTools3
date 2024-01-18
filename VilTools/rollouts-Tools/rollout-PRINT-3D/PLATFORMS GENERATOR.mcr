filein( getFilenamePath(getSourceFileName()) + "/Lib/PlatformGenerator/PlatformGenerator.ms" )	-- "./Lib/PlatformGenerator/PlatformGenerator.ms"



/** Get platform generator instance
  *
  */
function getPlatformGeneratorInstance =
(
	--format "\n"; print "PLATFORMS GENERATOR.mcr.getPlatformGeneratorInstance()"
	PlatformGenerator = PlatformGenerator_v export_size:ROLLOUT_export.SPIN_export_size.value use_every_nth_vert_of_spline:ROLLOUT_print_3d.SPIN_use_nth_vertex.value


	PlatformGenerator.Options.base_extrude	= ROLLOUT_print_3d.SPIN_base_width.value
	PlatformGenerator.Options.extrude_top	= ROLLOUT_print_3d.SPIN_top_extrude.value

	PlatformGenerator.Options.layer_height	= ROLLOUT_print_3d.SPIN_layer_height.value
	PlatformGenerator.Options.bar_width	= ROLLOUT_print_3d.SPIN_bar_width.value
	PlatformGenerator.Options.chamfer_top_divider	= ROLLOUT_print_3d.SPIN_top_chamfer_multiplier.value
	PlatformGenerator.Options.normal_length	= ROLLOUT_print_3d.SPIN_normal_length.value

	PlatformGenerator.Options.cross_section	= ROLLOUT_print_3d.CBX_cross_section.state
	PlatformGenerator.Options.cross_section_max	= ROLLOUT_print_3d.SPIN_max_distance.value


	PlatformGenerator --return
)


/*------------------------------------------------------------------------------

	GENERATE PLATFORMS

--------------------------------------------------------------------------------*/
macroscript	_print_platform_generator
category:	"_3D-Print"
buttontext:	"Generate Platforms"
tooltip:	"Generate Platforms"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Platforms" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PLATFORMS GENERATOR.mcr"

			PlatformGenerator = getPlatformGeneratorInstance()

			platforms = #()

			--_selection = for obj in selection collect obj

			PlatformGenerator.generate( selection as Array )

			--selectmore _selection
		)
)

/*------------------------------------------------------------------------------

	GENERATE POINTS

--------------------------------------------------------------------------------*/

/** GENERATE POINTS
 */
macroscript	_print_platform_generate_points
category:	"_3D-Print"
buttontext:	"Generate Points"
tooltip:	"Generate Points From selected mesh"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Points" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PLATFORMS GENERATOR.mcr"
			--messageBox "Yupiii" title:"Title"  beep:false

			--PlatformGenerator = getPlatformGeneratorInstance()

			select ((getPlatformGeneratorInstance()).generatePointHelpers( selection ))
		)
)

/** GENERATE LINE FROM POINTS
 */
macroscript	_print_platform_generate_line_from_points
category:	"_3D-Print"
buttontext:	"Generate Points"
tooltip:	"Generate line from selected points"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Line From Points" on
		(
			_selected_points = for obj in selection where classOf obj == Point collect obj


			if _selected_points.count > 0 then
			(
				_shape = SplineShape name:( "platforms-source" ) wirecolor:_selected_points[1].wirecolor isSelected:on

				addNewSpline _shape

				for selected_point in _selected_points do
					addKnot _shape 1 #corner #line selected_point.pos
			)
		)
)

/** REBUILD PALTFORMS
 */
macroscript	_print_platform_rebuild
category:	"_3D-Print"
buttontext:	"Rebuild Platforms"
tooltip:	"Rebuild selected platforms"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Rebuild Platforms" on
		(

			PlatformGenerator = getPlatformGeneratorInstance()

			PlatformGenerator.rebuild( selection as Array )
		)
)
