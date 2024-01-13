filein( getFilenamePath(getSourceFileName()) + "/Lib/PlatformGenerator/PlatformGenerator.ms" )	-- "./Lib/PlatformGenerator/PlatformGenerator.ms"

--/**
-- */
--macroscript	_print_platform_generator_units_multiplier
--category:	"_3D-Print"
--buttontext:	"Units Multiplier"
----tooltip:	"Platform Generator"
--icon:	"across:2|Control:radiobuttons|items:#('Cylinder', 'Box')|unselect:false|tooltip:Compensate print export size"
--(
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-3D-PRINT\vilTools3.mcr"
--	on execute do
--		format "EventFired:	% \n" EventFired
--		--undo "Generate Platforms" on
--		--(
--		--	platforms = #()
--		--
--		--	_selection = for obj in selection where superClassOf obj == GeometryClass collect obj
--		--
--		--	for obj in _selection where superClassOf obj == GeometryClass do
--		--		join platforms ( (PlatformGenerator_v( obj )).generate() )
--		--
--		--	select platforms
--		--)
--)

--/**
-- */
--macroscript	_print_platform_generator_bind_to_parent
--category:	"_3D-Print"
--buttontext:	"Single Object"
----tooltip:	"Platform Generator"
--icon:	"across:3|Control:checkbox|tooltip:Each platform is independent object if unchcked"
--(
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-3D-PRINT\vilTools3.mcr"
--	on execute do
--		format "EventFired:	% \n" EventFired
--		--undo "Generate Platforms" on
--		--(
--		--	platforms = #()
--		--
--		--	_selection = for obj in selection where superClassOf obj == GeometryClass collect obj
--		--
--		--	for obj in _selection where superClassOf obj == GeometryClass do
--		--		join platforms ( (PlatformGenerator_v( obj )).generate() )
--		--
--		--	select platforms
--		--)
--)
/*------------------------------------------------------------------------------

	PLATFORM OPTIONS

--------------------------------------------------------------------------------*/


/**
 */
macroscript	_print_platform_generator_bar_width
category:	"_3D-Print"
buttontext:	"Bar width"
tooltip:	"Bar width in mm of printed model.\n\nExported scale is used"
icon:	"across:2|control:spinner|range:[ 1, 99, 1.5 ]|width:64|offset:[ -8, 0]"
(
	format "EventFired:	% \n" EventFired
)

/**
 */
macroscript	_print_platform_generator_extrude_top
category:	"_3D-Print"
buttontext:	"Top Extrude"
tooltip:	"Top Extrude part in mm of printed model.\n\nExported scale is used"
icon:	"across:2|control:spinner|range:[ 0, 99, 0.25 ]|width:64"
(
	format "EventFired:	% \n" EventFired
)

/**
 */
macroscript	_print_platform_generator_base_width
category:	"_3D-Print"
buttontext:	"Base width"
tooltip:	"Width of base part"
icon:	"across:2|control:spinner|type:#integer|range:[ 0, 99, 4 ]|width:64|offset:[ -6, 0]"
(
	format "EventFired:	% \n" EventFired
)

/**
 */
macroscript	_print_platform_generator_bar_chamfer
category:	"_3D-Print"
buttontext:	"Top Chamfer Multiplier"
tooltip:	"Chamfer Multiplier of top section of support.\n\nHigher value makes lower chamfer.\n\nMAX CHAMFER = 1"
icon:	"across:2|control:spinner|type:#integer|range:[ 1, 99, 4 ]|width:64|offset:[ 64, 0]"
(
	format "EventFired:	% \n" EventFired
)


/*------------------------------------------------------------------------------

	SPLINE OPTIONS

--------------------------------------------------------------------------------*/
macroscript	_print_platform_generator_use_every_vertex
category:	"_3D-Print"
buttontext:	"Use nth vertex"
tooltip:	"Use every nth vertex of spline"
icon:	"across:2|control:spinner|type:#integer|range:[ 1, 99,1 ]|width:64"
(
	format "EventFired:	% \n" EventFired
)


/*------------------------------------------------------------------------------

	GENERATE BUTTON

--------------------------------------------------------------------------------*/
macroscript	_print_platform_generator
category:	"_3D-Print"
buttontext:	"Generate Platforms"
tooltip:	"Generate Platforms"
icon:	"across:1|height:32|width:128|offset:[0, 12]"
(
	on execute do
		undo "Generate Platforms" on
		(
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PLATFORMS.mcr"
			clearListener(); print("Cleared in:\n"+getSourceFileName())

			PlatformGenerator = PlatformGenerator_v export_size:ROLLOUT_export.SPIN_export_size.value use_every_nth_vert_of_spline:ROLLOUT_print_3d.SPIN_use_nth_vertex.value


			PlatformGenerator.Options.base_extrude	= ROLLOUT_print_3d.SPIN_base_width.value
			PlatformGenerator.Options.bar_width	= ROLLOUT_print_3d.SPIN_bar_width.value
			PlatformGenerator.Options.extrude_top	= ROLLOUT_print_3d.SPIN_top_extrude.value
			PlatformGenerator.Options.chamfer_top_divider	= ROLLOUT_print_3d.SPIN_top_chamfer_multiplier.value


			platforms = #()

			--_selection = for obj in selection where superClassOf obj == GeometryClass collect obj
			_selection = for obj in selection collect obj
			format "_selection:	% \n" _selection



			for obj in _selection do
			(
				platform = PlatformGenerator.generate(obj)

				append platforms platform
			)

			select platforms
		)
)
