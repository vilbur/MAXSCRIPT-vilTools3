filein( getFilenamePath(getSourceFileName()) + "/Lib/PlatformGenerator/PlatformGenerator.ms" )	-- "./Lib/PlatformGenerator/PlatformGenerator.ms"

/**
 */
macroscript	_print_platform_generator_units_multiplier
category:	"_3D-Print"
buttontext:	"Units Multiplier"
--tooltip:	"Platform Generator"
icon:	"across:2|Control:radiobuttons|items:#('10x', '100x')|tooltip:Compensate print export size"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-3D-PRINT\vilTools3.mcr"
	on execute do
		format "EventFired:	% \n" EventFired
		--undo "Generate Platforms" on
		--(
		--	platforms = #()
		--
		--	_selection = for obj in selection where superClassOf obj == GeometryClass collect obj
		--
		--	for obj in _selection where superClassOf obj == GeometryClass do
		--		join platforms ( (PlatformGenerator_v( obj )).generate() )
		--
		--	select platforms
		--)
)

/**
 */
macroscript	_print_platform_generator
category:	"_3D-Print"
buttontext:	"Platform Generator"
tooltip:	"Platform Generator"
icon:	"across:2|height:16|width:48"
(
	on execute do
		undo "Generate Platforms" on
		(
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PLATFORMS.mcr"

			units_multiplier = case ROLLOUT_print_3d.RB_units_multiplier.state  of
			(
				0: 1
				1: 10
				2: 100
			)

			format "test:	% \n" test

			platforms = #()

			_selection = for obj in selection where superClassOf obj == GeometryClass collect obj

			for obj in _selection where superClassOf obj == GeometryClass do
				join platforms ( (PlatformGenerator_v( obj )( units_multiplier )).generate() )

			select platforms
		)
)