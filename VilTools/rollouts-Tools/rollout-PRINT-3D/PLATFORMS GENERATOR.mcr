filein( getFilenamePath(getSourceFileName()) + "/Lib/PlatformGenerator/PlatformGenerator.ms" )	-- "./Lib/PlatformGenerator/PlatformGenerator.ms"


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

			PlatformGenerator = PlatformGenerator_v export_size:ROLLOUT_export.SPIN_export_size.value use_every_nth_vert_of_spline:ROLLOUT_print_3d.SPIN_use_nth_vertex.value


			PlatformGenerator.Options.base_extrude	= ROLLOUT_print_3d.SPIN_base_width.value
			PlatformGenerator.Options.bar_width	= ROLLOUT_print_3d.SPIN_bar_width.value
			PlatformGenerator.Options.extrude_top	= ROLLOUT_print_3d.SPIN_top_extrude.value
			PlatformGenerator.Options.chamfer_top_divider	= ROLLOUT_print_3d.SPIN_top_chamfer_multiplier.value


			platforms = #()

			_selection = for obj in selection collect obj

			PlatformGenerator.generate( _selection as Array )

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

			PlatformGenerator = PlatformGenerator_v source_obj: selection[1]

			verts_selected = PlatformGenerator.getVertexPositions()
			format "\n-----------\nARRAY:verts_selected:\n";  for vert in verts_selected do format "vert:	%\n" vert
			points_created = #()

			for vert_pos in verts_selected do
				append points_created ( Point pos:vert_pos size:1 wirecolor:green )

			select points_created

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
