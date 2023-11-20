filein( getFilenamePath(getSourceFileName()) + "/Lib/PlatformGenerator/PlatformGenerator.ms" )	-- "./Lib/PlatformGenerator/PlatformGenerator.ms"

/**
 */
macroscript	_print_platform_generator_units_multiplier
category:	"_3D-Print"
buttontext:	"Units Multiplier"
--tooltip:	"Platform Generator"
icon:	"across:3|Control:radiobuttons|items:#('Cylinder', 'Box')|unselect:false|tooltip:Compensate print export size"
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
/**
 */
macroscript	_print_platform_generator
category:	"_3D-Print"
buttontext:	"Platform Generator"
tooltip:	"Platform Generator"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Platforms" on
		(
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\PLATFORMS.mcr"


			PlatformGenerator = PlatformGenerator_v export_size:ROLLOUT_export.SPIN_export_size.value

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